# Edge Compute
<h1 align="center">
  <br>
   <img src="./EdgeReadmeImage.png" alt="Edge Compute Logo" title="Edge Compute Logo"/>
  <br>
</h1>
<h3 align="center">工业边缘计算示例</h3>
<h4 align="center">本示例抽取AB PLC中标签的数据，存储，并已看板的形式展现
</h4>


this is a Demo of read tags from CLX or CMX ,then write to influxDB 
* [CIP驱动](#CIP Driver)
* [Docker镜像制作](#Docker File)
* [Connect实时数据库](#Connect to InfluxDB v2)
* [看板展示](#Visualization)
* [Docker编排](#Docker Composer)


***

## CIP Driver

Apache PLC4X is an effort to create a set of libraries for communicating with industrial grade programmable logic controllers (PLCs) in a uniform way.
We are planning on shipping libraries for usage in:

1. CIP
2. Go
3. C (not ready for usage)
4. Python (not ready for usage)
5. C# (.Net) (not ready for usage)

PLC4X also integrates with other Apache projects, such as:

* [Apache Calcite](https://calcite.apache.org/)
* [Apache Camel](https://camel.apache.org/)
* [Apache Kafka-Connect](https://kafka.apache.org)
* [Apache Karaf](https://karaf.apache.org/)
* [Apache NiFi](https://nifi.apache.org/)

And brings stand-alone (Java) utils like:

* OPC-UA Server: Enables you to communicate with legacy devices using PLC4X with OPC-UA.
* PLC4X Server: Enables you to communicate with a central PLC4X Server which then communicates with devices via PLC4X.

It also provides (Java) tools for usage inside an application:

* Connection Cache: New implementation of our framework for re-using and sharing PLC-connections
* Connection Pool: Old implementation of our framework for re-using and sharing PLC-connections
* OPM: Object-Plc-Mapping: Allows binding PLC fields to properties in java POJOs similar to JPA
* Scraper: Utility to do scheduled and repeated data collection.

## Docker File

Depending on the programming language, the usage will differ, therefore please go to the
[Getting Started](https://plc4x.apache.org/users/gettingstarted.html) on the PLC4X website to look up
the language of choice.

## Connect to InfluxDB v2
## Visualization
## Docker Composer

