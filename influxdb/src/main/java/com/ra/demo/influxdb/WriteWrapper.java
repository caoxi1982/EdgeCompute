package com.ra.demo.influxdb;

import com.influxdb.client.WriteApi;
import com.influxdb.client.domain.WritePrecision;
import com.influxdb.client.write.Point;
import com.ra.demo.config.Plc;
import org.apache.plc4x.java.api.messages.PlcReadRequest;
import org.apache.plc4x.java.api.messages.PlcReadResponse;
import org.apache.plc4x.java.api.types.PlcResponseCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

public class WriteWrapper {
    private  Logger log = LoggerFactory.getLogger(WriteWrapper.class);
    private Plc plcCfg;
    private WriteApi api;
    public WriteWrapper(Plc plcCfg,WriteApi api) {
        this.plcCfg = plcCfg;
        this.api = api;
    }

    public Point createPoint(String fieldName,Map<String, Object> field) {
        Point point = Point.measurement(getMeasurement())
                .addTags(getInfluxTags(fieldName)).addFields(field).time(Instant.now(),
                        WritePrecision.MS);
        log.trace("Create the point meansurement:{},Tags:{},Fields:{}",getMeasurement(),getInfluxTags(fieldName),field);
        api.writePoint(point);
        return point;
    }

    public void writePoints(List<Point> points) {
        api.writePoints(points);
    }
    /*
     * never be used here, still have some problem
     */
    public void writePointAsync(HashSet<PlcReadRequest> requestSet) {
        CompletableFuture<Void> allDone = CompletableFuture.runAsync(() ->{
            ArrayList<Point> points = new ArrayList<>();
            for (PlcReadRequest r : requestSet) {
                PlcReadResponse syncResponse = null;
                try {
                    syncResponse = r.execute().get();
                } catch (InterruptedException e) {
                    log.error(e.getMessage());
                } catch (ExecutionException e) {
                    log.error(e.getMessage());
                }
                Map<String, Object> field = new HashMap<String, Object>();
                for (String fieldName : syncResponse.getFieldNames()) {
                    if (syncResponse.getResponseCode(fieldName) == PlcResponseCode.OK) {
                        int counter = syncResponse.getNumberOfValues(fieldName);
                        for (int i = 0; i < counter; i++) {
                            field.put(getInfluxFields(fieldName,i), syncResponse.getObject(fieldName, i));
                        }
                        points.add(Point.measurement(getMeasurement()).addTags(getInfluxTags(fieldName))
                                .addFields(field).time(Instant.now(), WritePrecision.MS));
                        //api.writePoints(points);
                        log.trace("AAAAAsync write to influxdb measurement={},tag={},field={}",
                                getMeasurement(), getInfluxTags(fieldName), field);
                    }
                    // Something went wrong, to output an error message instead.
                    else {
                        log.error("Error[{}]: {}", fieldName, syncResponse.getResponseCode(fieldName).name());
                    }
                }
            }
            api.writePoints(points);
        });//.orTimeout(2000, TimeUnit.MILLISECONDS);
    }

    private String getMeasurement(){
        return plcCfg.getMeasurement();
    }
    private Map<String,String> getInfluxTags(String fieldName){
       return plcCfg.getPlcTag(fieldName).getInfluxTags();
    }

    public String getInfluxFields(String fieldName,int index){
        return plcCfg.getPlcTag(fieldName).getInfluxFields(index);
    }

    public void close(){
        api.close();
    }
}
