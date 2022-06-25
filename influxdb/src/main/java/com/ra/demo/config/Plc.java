package com.ra.demo.config;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class Plc {

    private String connection;
    private int interval;

    private String measurement;

    private PlcTag[] plcTags;
    private boolean debug = false;

    private Map<String,PlcTag> plcTagsMap,plcTagsMap_debug;
    public Plc(String connection, int interval, String measurement,PlcTag[] plcTags) {
        this.connection = connection;
        this.interval = interval;
        this.plcTags = plcTags;
        this.measurement = measurement;
        System.out.println("Gson_1");
    }
    public String getConnection() {
        return connection;
    }

    public int getInterval() {
        return interval;
    }

    public boolean isDebug() {
        return debug;
    }

    private void setDebug(boolean debug) {
        this.debug = debug;
    }

    public String getMeasurement() {
        return measurement;
    }
    public synchronized Map<String,PlcTag> getPlcTags() {
        if (debug) {
            return plcTagsMap_debug;
        }else {
            return plcTagsMap;
        }
    }
    synchronized Map<String,PlcTag> createDebugTags(){
        // Initialize the debug mode of this PLC
        setDebug(true);
        Map<String,PlcTag> tagMap = createPlcTagsMap();
        Map<String,PlcTag> debugTagMap = new HashMap<>();
        for(Map.Entry<String,PlcTag> entry : tagMap.entrySet()){
            if (entry.getValue().getLength() > 1) {
                entry.getValue().flat().forEach(t -> {
                    t.setInfluxFields();
                    debugTagMap.put(t.getName(),t);
                });
            }else if (entry.getValue().getLength() == 1) {
                entry.getValue().setInfluxFields();
                debugTagMap.put(entry.getKey(),entry.getValue());
            }
        }
        plcTagsMap_debug = debugTagMap;
        return plcTagsMap_debug;
    }
    synchronized Map<String,PlcTag> createPlcTagsMap() {
        if (plcTagsMap == null){
            plcTagsMap =  new HashMap<String,PlcTag>();
            for(PlcTag tag : Arrays.asList(plcTags)) {
                tag.setInfluxFields();
                plcTagsMap.put(tag.getName(),tag);
            }
        }
        return plcTagsMap;
    }
    public PlcTag getPlcTag(String name) {
        if (debug) {
            return plcTagsMap_debug.get(name);
        }else {
            return plcTagsMap.get(name);
        }
    }

    @Override
    public String toString() {
        return "Plc{" +
                "connection='" + connection + "'" +
                ", interval=" + interval +
                ", measurement=" + measurement +
                ", plcTags=" + Arrays.toString(plcTags) +
                '}';
    }
}
