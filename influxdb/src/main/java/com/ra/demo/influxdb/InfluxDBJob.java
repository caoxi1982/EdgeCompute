package com.ra.demo.influxdb;

import com.influxdb.client.WriteApiBlocking;
import com.influxdb.client.domain.WritePrecision;
import com.influxdb.client.write.Point;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.apache.plc4x.java.api.messages.PlcReadResponse;
import org.apache.plc4x.java.api.types.PlcResponseCode;
import org.quartz.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Instant;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@PersistJobDataAfterExecution
@DisallowConcurrentExecution
public class InfluxDBJob implements Job {
    private static Logger log = LoggerFactory.getLogger(InfluxDBJob.class);
	private static String ORG = "influx_org";
	private static String BUCKET = "influx_bucket";

	private static String INFLUX_HANDLE = "influx";
	private static String DRIVER = "driver";

    public InfluxDBJob() {}

    public void execute(JobExecutionContext context) {
		long starttime = System.currentTimeMillis();
		JobKey jobKey = context.getJobDetail().getKey();
		try {
			JobDataMap datas = context.getJobDetail().getJobDataMap();
			PlcReadRequest readRequest = (PlcReadRequest) datas.get(DRIVER);
			WriteApiBlocking writeApi = (WriteApiBlocking) datas.get(INFLUX_HANDLE);
			String org = (String) datas.get(ORG);
			String bucket = (String) datas.get(BUCKET);
			WriteResponse(writeApi,readRequest,org,bucket);
			long endtime = System.currentTimeMillis();
			log.info("InfluxDBJob says: " + jobKey + " executing at " + new Date() + "Duration is {} ms",
				(endtime - starttime));
		} catch (Exception e) {
			log.error(e.getMessage());
		}
    }

    private void writePoint(WriteApiBlocking writeApi,String measurement,String org,String bucket,Map<String, String> tags, Map<String, Object> field) {
		Point point = Point.measurement(measurement).addTags(tags).addFields(field).time(Instant.now(),
			WritePrecision.MS);
		writeApi.writePoint(bucket, org, point);
    }

    private void writePoint(WriteApiBlocking writeApi,String measurement,String org,String bucket,String tagName, String tagValue, String fieldName, float fieldValue) {
		Point point = Point.measurement(measurement).addTag(tagName, tagValue).addField(fieldName, fieldValue)
			.time(Instant.now(), WritePrecision.MS);
		writeApi.writePoint(bucket, org, point);
    }

    private void WriteResponse(WriteApiBlocking writeApi,PlcReadRequest request,String org,String bucket) {
		//////////////////////////////////////////////////////////
		// Read synchronously ...
		// NOTICE: the ".get()" immediately lets this thread pause until
		// the response is processed and available.
		log.info("Synchronous request ...");
		PlcReadResponse syncResponse;
		try {
			syncResponse = request.execute().get();
			for (String fieldName : syncResponse.getFieldNames()) {
				if (syncResponse.getResponseCode(fieldName) == PlcResponseCode.OK) {
					writePoint(writeApi,"SimpleTest",org,bucket, "plc", "controller", fieldName, syncResponse.getFloat(fieldName));
					log.info("InfluxDBJob says: executing at " + new Date()	+ "write to influxdb measurement={},tag={},field={},value={}",
						"plc4x", "controller", fieldName, syncResponse.getFloat(fieldName));
				}
				// Something went wrong, to output an error message instead.
				else {
					log.error("Error[{}]: {}", fieldName, syncResponse.getResponseCode(fieldName).name());
				}
			}
		} catch (InterruptedException e) {
			log.error(e.getMessage());
		} catch (ExecutionException e) {
			log.error(e.getMessage());
		}
    }
}
