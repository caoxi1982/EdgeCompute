package com.ra.demo.influxdb;

import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.InfluxDBClientFactory;
import com.influxdb.client.WriteApi;
import com.influxdb.client.WriteOptions;
import com.ra.demo.config.Config;
import com.ra.demo.config.Plc;
import com.ra.demo.config.PlcTag;
import org.apache.plc4x.java.PlcDriverManager;
import org.apache.plc4x.java.api.PlcConnection;
import org.apache.plc4x.java.api.exceptions.PlcConnectionException;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.jetbrains.annotations.NotNull;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;
import static org.quartz.TriggerBuilder.newTrigger;

/**
 * This Example will demonstrate all of the basics of scheduling capabilities of
 * Quartz using Simple Triggers.
 * 
 * @author Bill Kratzer
 */
public class Trigger {
	private Map<String,WriteApi> writeApiMap = new HashMap<>();
	private Map<String,PlcConnection> plcConnectionMap = new HashMap<>();
	private Map<String, Set<PlcReadRequest>> plcReadRequestMap = new HashMap<>();
	private Map<String,Plc> plcConfigMap = new HashMap<>();
	private static final String PLC_TAG_CONFIG = "tagConfig";
    private static final String INFLUX_WRITE_API= "influx";
    private static final String CIP_DRIVER = "driver";
    private static final Logger log = LoggerFactory.getLogger(Trigger.class);
	private boolean exit = true;
    public void run(Config cfg){
		clearAllMap();
		initialInfluxdb(cfg);
		initialCIPDriver(cfg);
		try {
			log.info("------- Initializing -------------------");
			// First we must get a reference to a scheduler
			SchedulerFactory sf = new StdSchedulerFactory();
			Scheduler sched = sf.getScheduler();
			log.info("------- Initialization Complete --------");
			log.info("------- Scheduling Jobs ----------------");
			// Create and schedule jobs ,they can not be execute before call start()
			for(Plc plc : cfg.getPlcs()){
				String measure = plc.getMeasurement();
				int interval = plc.getInterval();
				String jobName = "InfluxDB_" + measure + String.valueOf(interval);
				Date startTime = DateBuilder.nextGivenSecondDate(null, 15);
				JobDetail job = newJob(InfluxDBJob.class).withIdentity(jobName, measure).build();
				job.getJobDataMap().put(PLC_TAG_CONFIG, plcConfigMap.get(measure));
				job.getJobDataMap().put(INFLUX_WRITE_API, writeApiMap.get(measure));
				job.getJobDataMap().put(CIP_DRIVER, plcReadRequestMap.get(measure));
				SimpleTrigger trigger = newTrigger().withIdentity(jobName, measure).startAt(startTime)
						.withSchedule(simpleSchedule().withIntervalInMilliseconds(interval).repeatForever()).build();
				Date ft = sched.scheduleJob(job, trigger);
				log.info(job.getKey() + " will run at: " + ft + " and repeat: forever times, every "
						+ trigger.getRepeatInterval() + " ms");
			};
			log.info("------- Starting Scheduler ----------------");
			// All the jobs have been added to the scheduler, but none of the jobs
			// will run until the scheduler has been started
			sched.start();
			log.info("------- Started Scheduler -----------------");
			Scanner sc = new Scanner(System.in);
			while(exit){
				int temp = sc.nextInt();
				if (temp == 100) {
					exit = false;
				}
				log.debug("Type = {}",temp);
			}
			sc.close();
			log.info("------- Shutting Down ---------------------");
			sched.shutdown(true);
			log.info("------- Shutdown Complete -----------------");
			// display some stats about the schedule that just ran
			SchedulerMetaData metaData = sched.getMetaData();
			log.info("Executed " + metaData.getNumberOfJobsExecuted() + " jobs.");
			log.info("------- EIP drivers Shutdowning  -----------------");
			writeApiMap.values().forEach(writeApi -> writeApi.close());
			plcConnectionMap.values().forEach(plcConnection -> {
				try {
					plcConnection.close();
				} catch (Exception e) {
					log.error(e.getMessage());
				}
			});
		}
//		catch (InterruptedException e) {
//		}
		catch (SchedulerException e){
			log.error(e.getMessage());
			clearAllMap();
		}
		catch(Exception e){
			log.error(e.getMessage());
			clearAllMap();
		}
		clearAllMap();
		System.exit(0);
    }

	private void initialInfluxdb(Config cfg){
		InfluxDBClient client = InfluxDBClientFactory.create(cfg.getURL(), cfg.getToken().toCharArray(),cfg.getORG(),cfg.getBucket());
		cfg.getPlcs().forEach((plc) ->{
			WriteApi writeApi = client.makeWriteApi(WriteOptions.builder().batchSize(2000).flushInterval(10000).jitterInterval(3000).bufferLimit(100000).build());
			writeApiMap.put(plc.getMeasurement(),writeApi);
			plcConfigMap.put(plc.getMeasurement(),plc);
		});
	}
	private void initialCIPDriver(@NotNull Config cfg){
		// --connection-string eip://192.168.1.11?backplane=1 --field-addresses %aa
		cfg.getPlcs().forEach((plc) -> {
			try {
				PlcConnection plcConnection = new PlcDriverManager().getConnection(plc.getConnection());
				// Check if this connection support reading of data.
				if (!plcConnection.getMetadata().canRead()) {
					log.error("This connection doesn't support reading.");
					return;
				}
				// Create a new read request:
				Set<PlcReadRequest> readRequestSet = new HashSet<PlcReadRequest>();
				// The different is Array be parsed as one Item or an Array of Items
				for (Map.Entry<String,PlcTag> entry : plc.getPlcTags().entrySet()) {
					PlcReadRequest.Builder builder = plcConnection.readRequestBuilder();
					builder.addItem(entry.getKey(), entry.getValue().getItemName());
					readRequestSet.add(builder.build());
				}
				plcConnectionMap.put(plc.getMeasurement(), plcConnection);
				plcReadRequestMap.put(plc.getMeasurement(), readRequestSet);
			}catch (PlcConnectionException e) {
				//
			}
		});
	}
	private void clearAllMap(){
		writeApiMap.clear();
		plcConnectionMap.clear();
		plcReadRequestMap.clear();
		plcConfigMap.clear();
	}
}
