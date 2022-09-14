package com.ra.demo.influxdb;

import com.influxdb.client.write.Point;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.apache.plc4x.java.api.messages.PlcReadResponse;
import org.apache.plc4x.java.api.types.PlcResponseCode;
import org.quartz.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.concurrent.ExecutionException;

@PersistJobDataAfterExecution
@DisallowConcurrentExecution
public class InfluxDBJob implements Job {
    private static Logger log = LoggerFactory.getLogger(InfluxDBJob.class);
	private static String INFLUX_WRITE = "influx";
	private static String CIP_DRIVER = "driver";
	private static String IS_SYNC = "sync";

	private  WriteWrapper writeApi;
	public InfluxDBJob() {}

    public void execute(JobExecutionContext context) {
		long starttime = System.currentTimeMillis();
		long readtime = 0;
		JobKey jobKey = context.getJobDetail().getKey();
		try {
			JobDataMap dataMap = context.getJobDetail().getJobDataMap();
			HashSet<PlcReadRequest> requestSet = (HashSet<PlcReadRequest>) dataMap.get(CIP_DRIVER);
			writeApi = (WriteWrapper) dataMap.get(INFLUX_WRITE);
			boolean sync = (boolean) dataMap.get(IS_SYNC);
			if (sync) {
				ArrayList<Point> points = new ArrayList<>();
				for (PlcReadRequest r : requestSet) {
					log.trace("Synchronous request data {}",r.getFieldNames());
					PlcReadResponse syncResponse = r.execute().get();
					Map<String, Object> field = new HashMap<String, Object>();
					for (String fieldName : syncResponse.getFieldNames()) {
						if (syncResponse.getResponseCode(fieldName) == PlcResponseCode.OK) {
							int counter = syncResponse.getNumberOfValues(fieldName);
							for (int i = 0; i < counter; i++) {
								field.put(writeApi.getInfluxFields(fieldName, i), syncResponse.getObject(fieldName, i));
							}
							points.add(writeApi.createPoint(fieldName, field));
						}
						// Something went wrong, to output an error message instead.
						else {
							log.error("Error[{}]: {}", fieldName, syncResponse.getResponseCode(fieldName).name());
						}
					}
				}
				readtime = System.currentTimeMillis();
				//writeApi.writePoints(points);
			}
			long endtime = System.currentTimeMillis();
			log.info("InfluxDBJob says: " + jobKey + " executing at " + new Date() + "ReadDuration is {} ms,writeDuration is {} ms",
					(endtime - starttime),(endtime - readtime));
		}
		catch (InterruptedException e) {
				log.error(e.getMessage());
			}
		catch (ExecutionException e) {
				log.error(e.getMessage());
			}
		catch (Exception e) {
			log.error(e.getMessage());
		}
    }
}


