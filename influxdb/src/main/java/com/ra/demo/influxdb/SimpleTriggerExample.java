package com.ra.demo.influxdb;

import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.InfluxDBClientFactory;
import com.influxdb.client.WriteApiBlocking;
import com.ra.demo.config.Config;
import com.ra.demo.config.PlcTag;
import org.apache.plc4x.java.PlcDriverManager;
import org.apache.plc4x.java.api.PlcConnection;
import org.apache.plc4x.java.api.exceptions.PlcConnectionException;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.util.Scanner;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;
import static org.quartz.TriggerBuilder.newTrigger;

/**
 * This Example will demonstrate all of the basics of scheduling capabilities of
 * Quartz using Simple Triggers.
 * 
 * @author Bill Kratzer
 */
public class SimpleTriggerExample {

	private String url;
	private String org;
	private String bucket;
	private String token;

	private InfluxDBClient client;
	private WriteApiBlocking writeApi;
	private PlcConnection plcConnection;
	private PlcReadRequest readRequest;
	private static String ORG = "influx_org";
	private static String BUCKET = "influx_bucket";
    private static String INFLUX_HANDLE= "influx";
    private static String DRIVER = "driver";
    private static Logger log = LoggerFactory.getLogger(SimpleTriggerExample.class);
	private boolean exit = true;
    public void run(Config cfg){
		initialInfluxdb(cfg);
		initialCIPDriver(cfg);
		try {
			log.info("------- Initializing -------------------");
			// First we must get a reference to a scheduler
			SchedulerFactory sf = new StdSchedulerFactory();
			Scheduler sched = sf.getScheduler();
			log.info("------- Initialization Complete --------");
			log.info("------- Scheduling Jobs ----------------");
			// jobs can be scheduled before sched.start() has been called
			// get a "nice round" time a few seconds in the future...
			Date startTime = DateBuilder.nextGivenSecondDate(null, 15);
			JobDetail job = newJob(InfluxDBJob.class).withIdentity("jobInflux", "group1").build();
			job.getJobDataMap().put(DRIVER, readRequest);
			job.getJobDataMap().put(ORG, cfg.getORG());
			job.getJobDataMap().put(BUCKET, cfg.getBucket());
			job.getJobDataMap().put(INFLUX_HANDLE, writeApi);
			SimpleTrigger trigger = newTrigger().withIdentity("trigger1", "group1").startAt(startTime)
				.withSchedule(simpleSchedule().withIntervalInMilliseconds(2000).repeatForever()).build();
			Date ft = sched.scheduleJob(job, trigger);
			log.info(job.getKey() + " will run at: " + ft + " and repeat: forever times, every "
				+ trigger.getRepeatInterval() / 1000 + " seconds");
			log.info("------- Starting Scheduler ----------------");
			// All of the jobs have been added to the scheduler, but none of the jobs
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
			plcConnection.close();
			client.close();
		}
//		catch (InterruptedException e) {
//		}
		catch (SchedulerException e){
			log.error(e.getMessage());
		}
		catch(Exception e){
			log.error(e.getMessage());
		}
		System.exit(0);
    }

	private void initialInfluxdb(Config cfg){
		this.url = cfg.getURL();
		this.org = cfg.getORG();
		this.bucket = cfg.getBucket();
		this.token = cfg.getToken();
		this.client = InfluxDBClientFactory.create(url, token.toCharArray());
		this.writeApi = client.getWriteApiBlocking();
	}
	private void initialCIPDriver(Config cfg){
		try {
			// --connection-string eip://192.168.1.11?backplane=1 --field-addresses %aa
			plcConnection = new PlcDriverManager().getConnection(cfg.getConnection());
			// Check if this connection support reading of data.
			if (!plcConnection.getMetadata().canRead()) {
				log.error("This connection doesn't support reading.");
				return;
			}
			// Create a new read request:
			// - Give the single item requested the alias name "value"
			PlcReadRequest.Builder builder = plcConnection.readRequestBuilder();
			for (PlcTag tag:cfg.getTags()) {
				builder.addItem(tag.getName(), tag.getItemName());
			}
			readRequest = builder.build();
		}
		catch (PlcConnectionException e) {
			//
		}
	}

}
