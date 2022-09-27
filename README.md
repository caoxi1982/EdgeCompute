# Edge Compute
<h1 align="center">
  <br>
   <img src="./EdgeReadmeImage.png" alt="Edge Compute Logo" title="Edge Compute Logo" width="60%" height="30%"/>
  <br>
</h1>
<h3 align="center">工业边缘计算示例</h3>
<h4 align="center">本示例抽取AB PLC中标签的数据，存储，并已看板的形式展现
</h4>


边缘计算是相对于集中式的数据中心，或是云端服务器的概念，它更接近于PLC或是现场OT层的数据。利用各种工业现场的通讯协议能够更直接
的提供高密度的数据采样，进而提供实时性更高，更准确的反馈给到现场设备。目前这个实例中我们主要呈现前一部分的内容：借助于开源的InfluxDB和Grafana
进行高密度的数据采集及其呈现。第二部分的内容目前更多的以专机的形式出现：比如罗克韦尔的集成CIP的震动检测单元。这里不做讨论。

本示例提供了基于docker 的一键启动，当然也可以按需求将各个部分分别安装


* [Ethernet/IP驱动](#Ethernet/IP驱动)
* [Docker镜像制作](#Docker镜像制作)
* [OPC_UA驱动](#OPC_UA驱动)
* [Connect实时数据库](#Connect实时数据库)
* [Grafana看板展示](#Grafana看板展示)
* [Docker编排](#Docker编排)

## Ethernet/IP驱动
这里的Ethernet/IP驱动专指数据标签的读取写入部分的协议，而不是ODVA组织定义的Ethernet/IP驱动（详见[ODVA官网](https://www.odva.org/technology-standards/document-library/)）
在这个例子中我们采用了[Apache PLC4X](https://plc4x.apache.org/users/gettingstarted.html)的EIP驱动当然你也可以
采用其他的一些驱动
这例子中使用JSON文件来配置需要读取的PLC地址，标签名字，已经将要写入的InfluxDB的数据库的URL等信息.

示例文件./docker/Connection.json

```shell
{ "url": "http://localhost:8086",
  "org": "ra",
  "token": "U0pdAvYrUbJMPvnD8YZjkm9d8KCVHpeBEe1_LiVlQImsr98ERFRrYKge1hsZVeht_VfEAixTkgsAi6B85lax-Q==",
  "bucket": "test",
  "debug": false,
  "plcs":
  [{"connection": "eip://192.168.1.31?backplane=1",
      "measurement": "L3100ERMS2",
      "interval": 1000,
      "plcTags":
      [{  "name": "a_sin[0]",
          "length": 2,
          "datatype": "REAL",
          "influxFields": ["test1","test2"],
          "influxTags": { "location": "PayOff", "parameter": "Speed" } }]  }]
}
```
- 第一级属性中url,org,token,bucket均对应InfluxDB v2中数据组织形式的概念；
- 第一级属性中plcs为数组可建立多个PLC4X中EIP驱动的PLC连接；
- 属性plcs中每个EIP连接均需要指定他的目标PLC（connection），在InfluxDB中存储的表（Measurement），数据采样的间隔（interval）
已经需要被采集的PLC中标签名字
- 第二级中属性plcTags为数组，可包含同一个PLC中，同一个采样频率的标签组
- 第三级中属性含义name:
  - PLC中的标签名（可以为数组)
  - length如果是数组则为数组的长度
  - datatype 该PLC标签的数据类型，目前PLC4X支持BOOL，DWORD，SINT，INT，DINT，LINT，REAL
  - influxFields 该PLC标签在InfluxDB的对应Measurement中的名字，可为数组中不同的元素添加不同的名字
  例如test1，test2 分别是a_sin[0],a_sin[1]在数据库中的名字
  - influxTags 该PLC标签在InfluxDB的对应Measurement中索引Tag的键值对，这里不能为每个数组中的元素分配不同的索引

<span style="color:#F75D59">*influxFields属性可以对数组中不同的元素分配不同的名字，同时在PLC程序中增加MOV指令将需要采集的数据整理到同一个数组中
可以有效的提供EIP驱动的采集效率（即采样间隔）。在PLC4X中数组的目前最大长度为50。*</span>

<span style="color:#F75D59">*L8x 最大为2000 package/秒*</span>

<span style="color:#F75D59">*L7x 最大为400 package/秒*</span>

## Docker镜像制作
进入docker文件夹，运行下面的命令可以产生Ethernet/IP驱动的docker镜像文件
```shell
docker build -t mycip:0.0.1 .
```
或者去docker hub下载
```shell
docker push coabbb/ra
```

## OPC_UA驱动

示例中同时提供了采用telegraf的OPC UA驱动来进行数据采集的配置文件；

需要配置的部分为
- [agent]
- [[outputs.influxdb_v2]]
- [[inputs.opcua]]
- [[inputs.opcua.group]]
详情可参考[Telegraf的帮助](https://github.com/influxdata/telegraf)

## Connect实时数据库

本示例中将InfluxDB v2作为时间序列数据的存储工具，通过对Ethernet/IP驱动的JSON配置文件的设置，Telegraf中OutPut
插件的设置来写入数据，同时在Grafana中配置InfluxDB v2的数据源来做数据呈现

## Grafana看板展示

本示例中使用Grafana作为数据呈现的工具，并使用[Provision](https://grafana.com/docs/grafana/latest/administration/provisioning/)预制了数据源和一些看板。
在这里我们除了需要按手册配置InfluxDB的数据连接，还需要连接Rockwell FactoryTalk Alarm And Event的数据库，并导入相关的ISA18.2
报表的MS SQL存储过程，具体SQL请联系Rockwell技术支持

```shell
datasources:
  - name: MSSQL
    type: mssql
    uid: my_mssql
    url: 192.168.248.40:1433
    database: AlarmEvent
    user: sa
    jsonData:
      maxOpenConns: 0 # Grafana v5.4+
      maxIdleConns: 2 # Grafana v5.4+
      connMaxLifetime: 14400 # Grafana v5.4+
    secureJsonData:
      password: '123'
```
- uid是这个数据源在grafana实例中的编码，将被看板中的所有SQL查询语句所引用
- url为FactoryTalk Alarm And Event的服务器IP地址或域名<span style="color:red">*注意开通TCP访问及响应端口（默认1433）*</span>
- FactoryTalk Alarm And Event service 的数据库连接参数需要提供给属性database，user，password

## Docker编排

本示例可以支持Docker Composer的一键启动
但是docker使用了windows环境中的docker desktop，如果是Linux下的docker环境需要根据实际情况更改一些绑定目路的地址
具体已在[docker-composer.yml](./docker/docker-compose.yml)中标注

使用Ethernet/IP驱动执行：
```shell
docker compose up cip
```

使用OPC UA驱动执行：
```shell
docker compose up opcua
```
同时启动：
```shell
docker compose up
```




