package com.ra.demo.influxdb;

import java.time.Instant;
import java.util.Date;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ExecutionException;

import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.apache.plc4x.java.api.messages.PlcReadResponse;
import org.apache.plc4x.java.api.types.PlcResponseCode;
import org.quartz.DisallowConcurrentExecution;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobKey;
import org.quartz.PersistJobDataAfterExecution;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.InfluxDBClientFactory;
import com.influxdb.client.WriteApiBlocking;
import com.influxdb.client.domain.WritePrecision;
import com.influxdb.client.write.Point;

@PersistJobDataAfterExecution
@DisallowConcurrentExecution
public class InfluxDBJob implements Job {
    private static Logger _log = LoggerFactory.getLogger(InfluxDBJob.class);
    private static String TOKEN = "8sgEtjNP0pki9SAx3H5K-wXu804VDz5csGNeXaJXAKulColIJip1aVT_2O-UpUbyjkES-n3nbzszwrpjI-lkAA==";
    private static String ORG = "ra";
    private static String WRITE_DATA = "data";
    private static String DRIVER = "driver";
    private static String BUCKET = "opcua";
    private static InfluxDBClient client = InfluxDBClientFactory.create("http://influxdb:8086", TOKEN.toCharArray());
    private static WriteApiBlocking writeApi = client.getWriteApiBlocking();

    public InfluxDBJob() {

    }

    public void execute(JobExecutionContext context) {
	long starttime = System.currentTimeMillis();
	JobKey jobKey = context.getJobDetail().getKey();
	try {
	    JobDataMap datas = context.getJobDetail().getJobDataMap();
	    Random data = (Random) datas.get(WRITE_DATA);
	    PlcReadRequest readRequest = (PlcReadRequest) datas.get(DRIVER);
	    int i = data.nextInt(100);
	    writePoint("plc4x", "plc", "random", "sim", i);
	    _log.info(
		    "InfluxDBJob says: " + jobKey + " executing at " + new Date()
			    + "write to influxdb measurement={},tag={},field={},value={}",
		    "plc4x", "plc=random", "sim", i);
	    printResponse(readRequest);
	    long endtime = System.currentTimeMillis();
	    _log.info("InfluxDBJob says: " + jobKey + " executing at " + new Date() + "Duration is {} ms",
		    (endtime - starttime));
	} catch (Exception e) {
	    client.close();
	}
    }

    private void writePoint(String measurement, Map<String, String> tags, Map<String, Object> field) {
	Point point = Point.measurement(measurement).addTags(tags).addFields(field).time(Instant.now(),
		WritePrecision.MS);
	writeApi.writePoint(BUCKET, ORG, point);
    }

    private void writePoint(String measurement, String tagName, String tagValue, String fieldName, float fieldValue) {
	Point point = Point.measurement(measurement).addTag(tagName, tagValue).addField(fieldName, fieldValue)
		.time(Instant.now(), WritePrecision.MS);
	WriteApiBlocking writeApi = client.getWriteApiBlocking();
	writeApi.writePoint(BUCKET, ORG, point);
    }

    private void printResponse(PlcReadRequest request) {
	//////////////////////////////////////////////////////////
	// Read synchronously ...
	// NOTICE: the ".get()" immediately lets this thread pause until
	// the response is processed and available.
	_log.info("Synchronous request ...");
	PlcReadResponse syncResponse;
	try {
	    syncResponse = request.execute().get();
	    for (String fieldName : syncResponse.getFieldNames()) {
		if (syncResponse.getResponseCode(fieldName) == PlcResponseCode.OK) {
		    writePoint("plc4x", "plc", "controller", fieldName, (Float) syncResponse.getObject(fieldName));
		    _log.info(
			    "InfluxDBJob says: executing at " + new Date()
				    + "write to influxdb measurement={},tag={},field={},value={}",
			    "plc4x", "controller", fieldName, (Float) syncResponse.getObject(fieldName));

		}
		// Something went wrong, to output an error message instead.
		else {
		    _log.error("Error[{}]: {}", fieldName, syncResponse.getResponseCode(fieldName).name());
		}
	    }
	} catch (InterruptedException e) {
	    e.printStackTrace();
	} catch (ExecutionException e) {
	    e.printStackTrace();
	}
    }
}
