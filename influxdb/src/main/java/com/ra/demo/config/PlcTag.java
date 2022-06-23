package com.ra.demo.config;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PlcTag {
    private static final String REGEX ="\\[(\\d+)\\]";
    private String name;
    private int length;

    private Map<String,String> influxTags = new HashMap<String,String>();

    public PlcTag(String name, int length, Map influxTags) {
        this.name = name;
        this.length = length;
        this.influxTags = influxTags;
    }

    public String getItemName() {return "%" + name + ":" + length;}

    public String getItemName(boolean debug) {
        if (debug) {
            return "%" + name + ":1";
        } else {
            return getItemName();
        }
    }
    public String getName() {
        return name;
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
            newPlcTags.add(new PlcTag(changeArrayIndex(name,i),1,influxTags));
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
            return null;
        }
    }

    @Override
    public String toString() {
        return "\n" + this.getItemName() + ",influxTags = " + influxTags.toString();
    }
}
