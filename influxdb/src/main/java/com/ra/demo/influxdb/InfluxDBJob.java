package com.ra.demo.influxdb;

import com.influxdb.client.WriteApi;
import com.influxdb.client.domain.WritePrecision;
import com.influxdb.client.write.Point;
import com.ra.demo.config.Plc;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.apache.plc4x.java.api.messages.PlcReadResponse;
import org.apache.plc4x.java.api.types.PlcResponseCode;
import org.quartz.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Instant;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@PersistJobDataAfterExecution
@DisallowConcurrentExecution
public class InfluxDBJob implements Job {
    private static Logger log = LoggerFactory.getLogger(InfluxDBJob.class);
	private static String INFLUX_WRITE_API = "influx";
	private static String PLC_TAG_CONFIG = "tagConfig";
	private static String CIP_DRIVER = "driver";

    public InfluxDBJob() {}

    public void execute(JobExecutionContext context) {
		long starttime = System.currentTimeMillis();
		JobKey jobKey = context.getJobDetail().getKey();
		try {
			JobDataMap dataMap = context.getJobDetail().getJobDataMap();
			HashSet<PlcReadRequest> requestSet = (HashSet<PlcReadRequest>) dataMap.get(CIP_DRIVER);
			WriteApi writeApi = (WriteApi) dataMap.get(INFLUX_WRITE_API);
			Plc plcConfig = (Plc) dataMap.get(PLC_TAG_CONFIG);
			WriteResponse(writeApi,requestSet,plcConfig);
			long endtime = System.currentTimeMillis();
			log.info("InfluxDBJob says: " + jobKey + " executing at " + new Date() + "Duration is {} ms",
				(endtime - starttime));
		} catch (Exception e) {
			log.error(e.getMessage());
		}
    }

    private void writePoint(WriteApi writeApi,String measurement,Map<String, String> tags, Map<String, Object> field) {
		Point point = Point.measurement(measurement).addTags(tags).addFields(field).time(Instant.now(),
			WritePrecision.MS);
		writeApi.writePoint(point);
    }

    private void writePoint(WriteApi writeApi,String measurement,String tagName, String tagValue, String fieldName, float fieldValue) {
		Point point = Point.measurement(measurement).addTag(tagName, tagValue).addField(fieldName, fieldValue)
			.time(Instant.now(), WritePrecision.MS);
		writeApi.writePoint(point);
    }

    private void WriteResponse(WriteApi writeApi,HashSet<PlcReadRequest> requestSet,Plc plcCfg) {
		//////////////////////////////////////////////////////////
		// Read synchronously ...
		// NOTICE: the ".get()" immediately lets this thread pause until
		// the response is processed and available.
		log.debug("Synchronous request data ,then write to influxdb");
		try {
			for(PlcReadRequest r : requestSet) {
				PlcReadResponse syncResponse = r.execute().get();
				Map<String, Object> field = new HashMap<String, Object>();
				for (String fieldName : syncResponse.getFieldNames()) {
					if (syncResponse.getResponseCode(fieldName) == PlcResponseCode.OK) {
						field.put(fieldName, syncResponse.getFloat(fieldName));
						writePoint(writeApi, plcCfg.getMeasurement(), plcCfg.getPlcTag(fieldName).getInfluxTags(), field);
						log.trace("write to influxdb measurement={},tag={},field={},value={}",
								plcCfg.getMeasurement(), plcCfg.getPlcTag(fieldName).getInfluxTags(), fieldName, syncResponse.getFloat(fieldName));
					}
					// Something went wrong, to output an error message instead.
					else {
						log.error("Error[{}]: {}", fieldName, syncResponse.getResponseCode(fieldName).name());
					}
				}
			}
		} catch (InterruptedException e) {
			log.error(e.getMessage());
		} catch (ExecutionException e) {
			log.error(e.getMessage());
		}
    }
}
