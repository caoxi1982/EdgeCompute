package com.ra.demo.config;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Plc {

    private final String connection;
    private final int interval;

    private final String measurement;

    private final PlcTag[] plcTags;
    private List<PlcTag> plcTags_debug;
    public Plc(String connection, int interval, String measurement,PlcTag[] plcTags) {
        this.connection = connection;
        this.interval = interval;
        this.plcTags = plcTags;
        this.measurement = measurement;
    }

    public String getConnection() {
        return connection;
    }

    public int getInterval() {
        return interval;
    }
    public String getMeasurement() {
        return measurement;
    }
    public List<PlcTag> getPlcTags() {
        return Arrays.asList(plcTags);
    }
    public PlcTag getPlcTag(String name) {
        // Maybe a Map be initialed at the beginning is better
        return getPlcTags().stream().filter(plcTag -> plcTag.getName() == name).findFirst().get();
    }

    List<PlcTag> generateDebugTags(){
        List<PlcTag> tagList = getPlcTags();
        List<PlcTag> debugTagList = new ArrayList<>();
        if (tagList != null){
            for(PlcTag pt : tagList){
                if (pt.getLength() > 1) {
                    debugTagList.addAll(pt.flat());
                }else if (pt.getLength() == 1) {
                    debugTagList.add(pt);
                }
            }
        }
        plcTags_debug = debugTagList;
        return debugTagList;
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
