package com.ra.demo.influxdb;

import com.ra.demo.config.Config;
import com.ra.demo.config.Plc;
import org.apache.plc4x.java.api.PlcConnection;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.quartz.*;
import org.quartz.impl.matchers.KeyMatcher;
import org.quartz.listeners.JobListenerSupport;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.util.Map;
import java.util.Set;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;
import static org.quartz.TriggerBuilder.newTrigger;

public class CIPConnectJobListener extends JobListenerSupport {
    private static final Logger log = LoggerFactory.getLogger(CIPConnectJobListener.class);
    private JobListener influxDBJoblistener;
    private static final String INFLUX_WRITE= "influx";
    private static final String CONFIG = "config";
    private static final String CIP_DRIVER = "driver";
    private static final String CIP_REQUEST= "request";

    public CIPConnectJobListener(JobListener influxDBJoblistener) {
        this.influxDBJoblistener = influxDBJoblistener;
    }

    @Override
    public String getName() {
        return "CIPConnectJobListener";
    }

    @Override
    public void jobWasExecuted(JobExecutionContext context, JobExecutionException jobException) {
        log.info("Cip Connect job was Executed Completed");
        Config cfg = (Config) context.getJobDetail().getJobDataMap().get(CONFIG);
        Map<String, WriteWrapper> writeApiMap = (Map<String, WriteWrapper>) context.getJobDetail().getJobDataMap().get(INFLUX_WRITE);
        Map<String, PlcConnection> plcConnectionMap = (Map<String, PlcConnection>) context.getJobDetail().getJobDataMap().get(CIP_DRIVER);
        Map<String, Set<PlcReadRequest>> plcReadRequestMap = (Map<String, Set<PlcReadRequest>>) context.getJobDetail().getJobDataMap().get(CIP_REQUEST);
        try {
            if (jobException != null) {
                Scheduler scheduler = context.getScheduler();
                scheduler.clear();
                scheduler.standby();
            }else {
                int identity = 0;
                for (Plc plc : cfg.getPlcs()) {
                    String measure = plc.getMeasurement();
                    int interval = plc.getInterval();
                    JobDetail job = newJob(InfluxDBJob.class).withIdentity("readAndwrite" + measure + identity, "J_main").build();
                    job.getJobDataMap().put(INFLUX_WRITE, writeApiMap.get(measure));
                    job.getJobDataMap().put(CONFIG, cfg);
                    job.getJobDataMap().put(CIP_DRIVER, plcConnectionMap.get(measure));
                    job.getJobDataMap().put(CIP_REQUEST, plcReadRequestMap.get(measure));
                    SimpleTrigger trigger = newTrigger().withIdentity("readAndwrite" + measure + identity, "T_main").startNow()
                            .withSchedule(simpleSchedule().withIntervalInMilliseconds(interval).repeatForever()).build();
                    //start the job of influxDB to read data from PLC and write to influx
                    context.getScheduler().getListenerManager().addJobListener(influxDBJoblistener, KeyMatcher.keyEquals(job.getKey()));
                    Date ft = context.getScheduler().scheduleJob(job, trigger);
                    log.info(job.getKey() + " will run at: " + ft + " and repeat: forever times, every "
                            + trigger.getRepeatInterval() + " ms");
                    log.info("Cip Connect job was Executed Completed ,InfluxDB Job was scheduled");
                    identity++;
                }
            }
        } catch (SchedulerException e) {
            log.error("Cip Connect job was Executed Completed ,but InfluxDB Job not to be scheduled");
            throw new RuntimeException(e);
        }
    }
}