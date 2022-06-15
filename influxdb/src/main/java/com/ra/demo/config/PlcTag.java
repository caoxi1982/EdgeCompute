package com.ra.demo.config;

import java.util.HashMap;
import java.util.Map;

public class PlcTag {
    private String name;
    private int length;
    private Map<String,String> iTags = new HashMap<String,String>();

    public PlcTag(String name, int length, Map iTags) {
        this.name = name;
        this.length = length;
        this.iTags = iTags;
    }

    public String getItemName() {return "%" + name + ":" + length;}

    public String getName() {
        return name;
    }

    public int getLength() {
	return length;
    }

    @Override
    public String toString() {
        return "\n" + this.getItemName() + ",iTags = " + iTags.toString();
    }

}
