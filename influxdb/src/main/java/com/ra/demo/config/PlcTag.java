package com.ra.demo.config;

import org.apache.plc4x.java.eip.readwrite.types.CIPDataTypeCode;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PlcTag {
    private static final String REGEX ="\\[(\\d+)\\]";
    private String name;
    private int length;
    private String datatype;
    private List<String> influxFields;

    private Map<String,String> influxTags = new HashMap<String,String>();

    public PlcTag(String name, int length, List<String> influxFields, String datatype, Map<String,String> influxTags) {
        this.name = name;
        this.length = length;
        this.datatype = datatype;
        this.influxFields = influxFields;
        this.influxTags = influxTags;
    }
    public String getName() {
        return name;
    }
    public String getItemName() {
        return "%" + name + validDataType(datatype)+ ":" + length;}

    public String getItemName(boolean debug) {
        if (debug) {
            return "%" + name + validDataType(datatype) + ":1";
        } else {
            return getItemName();
        }
    }
    public String getInfluxFields(int index) {
        if (index < length) {
            return influxFields.get(index);
        } else {
            return "impossible";
        }
    }
    public void setInfluxFields() {
        ArrayList<String> fields = new ArrayList<String>();
        if (influxFields == null){
            for(int i = 0 ;i <length;i++){
                fields.add(changeArrayIndex(getName(),i));
            }
            influxFields = fields;
        }else {
            int size = influxFields.size();
            if ( size < length){
                for(int i = size ;i <length;i++){
                    influxFields.add(changeArrayIndex(getName(),i));
                }
            }
        }
    }
    public int getLength() {
	    return length;
    }
    public Map<String, String> getInfluxTags() {
        return influxTags;
    }
    List<PlcTag> flat(){
        ArrayList<PlcTag> newPlcTags = new ArrayList<PlcTag>();
        for(int i = 0;i < length;i++) {
            newPlcTags.add(new PlcTag(changeArrayIndex(name,i),1,Arrays.asList(getInfluxFields(i)),datatype,influxTags));
        }
        return newPlcTags;
    }
    private String changeArrayIndex(String tagName,int index){
        Pattern p = Pattern.compile(REGEX);
        Matcher m = p.matcher(tagName); // 获取 matcher 对象
        if (m.find( )) {
            // group 1 will be the original index
            int replace = Integer.parseInt(m.group(1)) + index;
            StringBuffer str = new StringBuffer();
            m.appendReplacement(str,"[" + String.valueOf(replace) + "]");
            return m.appendTail(str).toString();
        } else {
            return tagName;
        }
    }

    private String validDataType(String datatype){
        if (CIPDataTypeCode.valueOf(datatype) != null){
            return ":" + datatype;
        }
        return "";
    }

    @Override
    public String toString() {
        return "\n" + this.getItemName() + ",influxTags = " + influxTags.toString();
    }
}
