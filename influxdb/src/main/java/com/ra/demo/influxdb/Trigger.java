package com.ra.demo.influxdb;

import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.InfluxDBClientFactory;
import com.influxdb.client.WriteApi;
import com.influxdb.client.WriteOptions;
import com.ra.demo.config.Config;
import org.apache.plc4x.java.api.PlcConnection;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;
import org.quartz.impl.matchers.KeyMatcher;
import org.quartz.listeners.JobListenerSupport;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;


/**
 * This Example will demonstrate all the basics of scheduling capabilities of
 * Quartz using Simple Triggers.
 * 
 * @author Bill Kratzer
 */
public class Trigger extends JobListenerSupport {
	private Map<String,WriteWrapper> writeApiMap = new HashMap<>();
	private Map<String,PlcConnection> plcConnectionMap = new HashMap<>();
	private Map<String, Set<PlcReadRequest>> plcReadRequestMap = new HashMap<>();
    private static final String INFLUX_WRITE= "influx";
	private static final String CONFIG = "config";
    private static final String CIP_DRIVER = "driver";
    private static final String CIP_REQUEST= "request";
    private static final Logger log = LoggerFactory.getLogger(Trigger.class);
	private int repeat = 0;
	private final Scheduler scheduler;
	private final Config cfg;
	private InfluxDBClient client;

	public Trigger(Config cfg) {
		// First we must get a reference to a scheduler
		log.info("------- Initializing -------------------");
		SchedulerFactory sf = new StdSchedulerFactory();
		try {
			this.scheduler = sf.getScheduler();
		} catch (SchedulerException e) {
			log.error("------- Initialization Quartz Failure ----------------");
			throw new RuntimeException(e);
		}
		this.cfg = cfg;
	}


	public void run(){
		initialInfluxdb();
		try {
			log.info("------- Initialization CIP Connection Jobs ----------------");
			createCIPConnectJob();
			scheduler.start();
			log.info("------- Started Scheduler,Keep monitoring the Scheduler every 10 seconds -----------------");
			while(repeat < 20){
				if (scheduler.isInStandbyMode()) {
					createCIPConnectJob();
					scheduler.start();
					repeat++;
				}
				log.debug("retry {} times for timeout exception",repeat);
				Thread.sleep(10000);
			}
			log.info("------- 20 times retry to recover the CIP connect will shut Down ---------------------");
			// display some stats about the schedule that just ran
			SchedulerMetaData metaData = scheduler.getMetaData();
			log.info("Executed " + metaData.getNumberOfJobsExecuted() + " jobs.");
			close();
			System.exit(0);
		} catch (SchedulerException | InterruptedException e) {
			throw new RuntimeException(e);
		} finally {
			close();
		}
    }
	private void initialInfluxdb(){
		client = InfluxDBClientFactory.create(cfg.getURL(), cfg.getToken().toCharArray(),cfg.getORG(),cfg.getBucket());
		cfg.getPlcs().forEach((plc) ->{
			WriteApi writeApi = client.makeWriteApi(WriteOptions.builder().batchSize(2000).flushInterval(10000).jitterInterval(3000).bufferLimit(100000).build());
			writeApiMap.put(plc.getMeasurement(),new WriteWrapper(plc,writeApi));
		});
	}
	private void createCIPConnectJob(){
		Date startTime = DateBuilder.nextGivenSecondDate(null, 15);
		JobDetail cipConnectJob = newJob(CIPConnectJob.class).withIdentity("CreateCIPConnection", "J_begin").build();
		try {
			scheduler.clear();
			scheduler.getListenerManager().addJobListener(new CIPConnectJobListener(this), KeyMatcher.keyEquals(cipConnectJob.getKey()));
			cipConnectJob.getJobDataMap().put(CONFIG, cfg);
			cipConnectJob.getJobDataMap().put(INFLUX_WRITE, writeApiMap);
			cipConnectJob.getJobDataMap().put(CIP_DRIVER, null);
			cipConnectJob.getJobDataMap().put(CIP_REQUEST, null);
			SimpleTrigger cipConnectTrigger = TriggerBuilder.newTrigger().withIdentity("CreateCIPConnection", "T_begin").startAt(startTime)
					.withSchedule(simpleSchedule().withRepeatCount(0)).build();
			scheduler.scheduleJob(cipConnectJob,cipConnectTrigger);
		} catch (SchedulerException e) {
			log.error("CIPConnectJob can not be scheduled correct");
			throw new RuntimeException(e);
		}
	}

	private void closeCIPAndStandbySchedule() {
		log.info("------- Try to remove CIP Connection -----------------");
		plcConnectionMap.values().forEach(plcConnection -> {

			try {
				plcConnection.close();
			} catch (Exception e) {
				log.error("------- Remove CIP Connection Failure -----------------");
				throw new RuntimeException(e);
			}

		});
		plcConnectionMap.clear();
		plcReadRequestMap.clear();
		try {
			scheduler.clear();
			scheduler.standby();
			log.info("-------- Schedule standby Complete -----------------");
		} catch (SchedulerException e) {
			log.error("------- Schedule Shutdown with SchedulerException -----------------");
			throw new RuntimeException(e);
		}
	}
	private void close(){
		closeCIPAndStandbySchedule();
		writeApiMap.clear();
		client.close();
		try {
			scheduler.shutdown(true);
		} catch (SchedulerException e) {
			log.error("-------- Schedule shutdown Complete -----------------");
			throw new RuntimeException(e);
		}
	}

	@Override
	public String getName() {
		return "InfluxDBJobListener";
	}

	@Override
	public void jobWasExecuted(JobExecutionContext context, JobExecutionException jobException) {
		if (jobException != null){
			closeCIPAndStandbySchedule();
		}
		else {
			log.info("InfluxDBJob Was Executed Success with context :{} ",context);
		}
	}
}
