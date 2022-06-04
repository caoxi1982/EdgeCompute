package com.ra.demo.influxdb;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;
import static org.quartz.TriggerBuilder.newTrigger;

import java.util.Date;
import java.util.Random;

import org.apache.plc4x.java.PlcDriverManager;
import org.apache.plc4x.java.api.PlcConnection;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.quartz.DateBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.SchedulerMetaData;
import org.quartz.SimpleTrigger;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This Example will demonstrate all of the basics of scheduling capabilities of
 * Quartz using Simple Triggers.
 * 
 * @author Bill Kratzer
 */
public class SimpleTriggerExample {

    private static String WRITE_DATA = "data";
    private static String DRIVER = "driver";
    private static Logger log = LoggerFactory.getLogger(SimpleTriggerExample.class);
    private Random rand = new Random(25);

    public void run() throws Exception {
	// --connection-string eip://192.168.1.11?backplane=1 --field-addresses %aa
	PlcConnection plcConnection = new PlcDriverManager().getConnection("eip://192.168.1.11?backplane=1");
	// Check if this connection support reading of data.
	if (!plcConnection.getMetadata().canRead()) {
	    log.error("This connection doesn't support reading.");
	    return;
	}
	// Create a new read request:
	// - Give the single item requested the alias name "value"
	PlcReadRequest.Builder builder = plcConnection.readRequestBuilder();
	builder.addItem("value-%a_sin[0]", "%a_sin[0]:1");
	builder.addItem("value-%a_sin[1]", "%a_sin[1]:1");
	builder.addItem("value-%a_cos[0]", "%a_cos[0]:1");
	builder.addItem("value-%a_cos[1]", "%a_cos[1]:1");
	PlcReadRequest readRequest = builder.build();
	log.info("------- Initializing -------------------");
	// First we must get a reference to a scheduler
	SchedulerFactory sf = new StdSchedulerFactory();
	Scheduler sched = sf.getScheduler();
	log.info("------- Initialization Complete --------");
	log.info("------- Scheduling Jobs ----------------");
	// jobs can be scheduled before sched.start() has been called
	// get a "nice round" time a few seconds in the future...
	Date startTime = DateBuilder.nextGivenSecondDate(null, 15);
	JobDetail job = newJob(InfluxDBJob.class).withIdentity("jobinflux", "group1").build();
	job.getJobDataMap().put(WRITE_DATA, rand);
	job.getJobDataMap().put(DRIVER, readRequest);

	SimpleTrigger trigger = newTrigger().withIdentity("trigger1", "group1").startAt(startTime)
		.withSchedule(simpleSchedule().withIntervalInMilliseconds(50).repeatForever()).build();
	Date ft = sched.scheduleJob(job, trigger);
	log.info(job.getKey() + " will run at: " + ft + " and repeat: forever times, every "
		+ trigger.getRepeatInterval() / 1000 + " seconds");
	log.info("------- Starting Scheduler ----------------");
	// All of the jobs have been added to the scheduler, but none of the jobs
	// will run until the scheduler has been started
	sched.start();
	log.info("------- Started Scheduler -----------------");
	log.info("------- Waiting five minutes... ------------");
	try {
	    // wait five minutes to show jobs
	    Thread.sleep(3000L * 1000L);
	    // executing...
	} catch (Exception e) {
	    //
	}
	log.info("------- Shutting Down ---------------------");
	sched.shutdown(true);
	log.info("------- Shutdown Complete -----------------");
	// display some stats about the schedule that just ran
	SchedulerMetaData metaData = sched.getMetaData();
	log.info("Executed " + metaData.getNumberOfJobsExecuted() + " jobs.");
	log.info("------- EIP drivers Shutdowning  -----------------");
	plcConnection.close();
	System.exit(0);
    }

    public static void main(String[] args) throws Exception {

	SimpleTriggerExample example = new SimpleTriggerExample();
	example.run();

    }

}
