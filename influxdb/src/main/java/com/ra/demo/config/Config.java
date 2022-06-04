package com.ra.demo.config;

import java.util.Arrays;
import java.util.List;

public class Config {
    private String connection;
    private String[] tags;

    public Config(String connection, String[] tags) {
	super();
	this.connection = connection;
	this.tags = tags;
    }

    public String getConnection() {
	return connection;
    }

    public List<String> getTags() {
	return Arrays.asList(tags);
    }

    @Override
    public String toString() {
	return "Config [connection=" + connection + ", tags=" + Arrays.toString(tags) + "]";
    }

}
