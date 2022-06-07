package com.ra.demo.config;

import com.google.gson.Gson;

import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Paths;

public class ReadConfig {
    public static Config read() {
	try {
	    Gson gson = new Gson();
	    // create a reader
	    Reader reader = Files.newBufferedReader(Paths.get("var","lib","Connection.json"));
	    // convert JSON string to User object
	    Config config = gson.fromJson(reader, Config.class);
	    // close reader
	    reader.close();
	    return config;
	} catch (Exception ex) {
	    ex.printStackTrace();
	}
	return null;
    }
}
