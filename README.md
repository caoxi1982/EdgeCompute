# Edge Compute
<h1 align="center">
  <br>
   <img src="./EdgeReadmeImage.png" alt="Edge Compute Logo" title="Edge Compute Logo"/>
  <br>
</h1>
<h3 align="center">工业边缘计算示例</h3>
<h4 align="center">本示例抽取AB PLC中标签的数据，存储，并已看板的形式展现
</h4>


边缘计算是相对于集中式的数据中心，或是云端服务器的概念，它更接近于PLC或是现场OT层的数据。利用各种工业现场的通讯协议能够更直接
的提供高密度的数据采样，进而提供实时性更高，更准确的反馈给到现场设备。目前这个实例中我们主要呈现前一部分的内容：借助于开源的InfluxDB和Grafana
进行高密度的数据采集及其呈现。第二部分的内容目前更多的以专机的形式出现：比如罗克韦尔的集成CIP的震动检测单元。这里不做讨论。
***

* [Ethernet/IP驱动](#Ethernet/IP驱动)
* [Docker镜像制作](#Docker File)
* [OPC UA驱动](#OPC UA驱动)
* [Connect实时数据库](#Connect to InfluxDB v2)
* [Grafana看板展示](#Visualization)
* [Docker编排](#Docker Composer)

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

<span style="color:pink">some *blue* text</span>
## Docker File
## OPC UA驱动

Depending on the programming language, the usage will differ, therefore please go to the
[Getting Started](https://plc4x.apache.org/users/gettingstarted.html) on the PLC4X website to look up
the language of choice.

## Connect to InfluxDB v2
## Visualization
## Docker Composer

