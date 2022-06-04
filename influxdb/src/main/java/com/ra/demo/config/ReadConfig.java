package com.ra.demo.config;

import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Paths;

import com.google.gson.Gson;

public class ReadConfig {
    public static Config read() {
	try {
	    Gson gson = new Gson();
	    // create a reader
	    Reader reader = Files.newBufferedReader(Paths.get("Connection.json"));
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
