package com.ra.demo.influxdb;

import com.ra.demo.config.Config;
import com.ra.demo.config.PlcTag;
import com.ra.demo.config.Plc;
import org.apache.plc4x.java.PlcDriverManager;
import org.apache.plc4x.java.api.PlcConnection;
import org.apache.plc4x.java.api.exceptions.PlcConnectionException;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.jetbrains.annotations.NotNull;
import org.quartz.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

@PersistJobDataAfterExecution
@DisallowConcurrentExecution
public class CIPConnectJob implements Job {
    private static final Logger log = LoggerFactory.getLogger(CIPConnectJob.class);
	private static final String CONFIG = "config";
	private static final String CIP_DRIVER = "driver";
	private static final String CIP_REQUEST= "request";

	public CIPConnectJob() {}

    public void execute(JobExecutionContext context) throws JobExecutionException {
		JobDataMap dataMap = context.getJobDetail().getJobDataMap();
		initialCIPDriver(dataMap);
		log.info("------- CIP Driver Connected ---------------------");
	}

	private void initialCIPDriver(@NotNull JobDataMap dataMap) throws JobExecutionException{
		// --connection-string eip://192.168.1.11?backplane=1 --field-addresses %aa
		Map<String, Set<PlcReadRequest>> requestMap = new HashMap<>();
		Map<String,PlcConnection> connectionMap = new HashMap<>();
		Config cfg = (Config) dataMap.get(CONFIG);
		try {
			for(Plc plc : cfg.getPlcs()){
				PlcConnection plcConnection = new PlcDriverManager().getConnection(plc.getConnection());
				// Check if this connection support reading of data.
				if (!plcConnection.getMetadata().canRead()) {
					log.error("This connection doesn't support reading.");
					return;
				}
				// Create a new read request:
				Set<PlcReadRequest> readRequestSet = new HashSet<>();
				// The different is Array be parsed as one Item or an Array of Items
				for (Map.Entry<String, PlcTag> entry : plc.getPlcTags().entrySet()) {
					PlcReadRequest.Builder builder = plcConnection.readRequestBuilder();
					builder.addItem(entry.getKey(), entry.getValue().getItemName());
					readRequestSet.add(builder.build());
				}
				connectionMap.put(plc.getMeasurement(), plcConnection);
				requestMap.put(plc.getMeasurement(), readRequestSet);
			}
		}
		catch (PlcConnectionException e) {
				log.error("Can not create CIP connection");
				throw new JobExecutionException("Can not create CIP connection");
		}
		if (requestMap.isEmpty()) {
			log.error("Can not create CIP connection");
			throw new JobExecutionException("Can not create CIP connection");
		}
		dataMap.put(CIP_DRIVER,connectionMap);
		dataMap.put(CIP_REQUEST,requestMap);
	}
}


