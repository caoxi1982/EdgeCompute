package com.ra.demo.config;

import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class ReadConfig {
	private static final Logger log = LoggerFactory.getLogger(ReadConfig.class);
    public static Config read() {
		try {
			// create a reader
			Reader reader;
			Path path = Paths.get("var","lib", "Connection.json");
			if (!Files.exists(path)) {
				path = Paths.get("C:\\myGitHub\\EdgeCompute\\influxdb\\src\\main\\resources\\Connection.json");
				log.debug("{}",path);
			}
			reader = Files.newBufferedReader(path);
			Gson gson = new Gson();
			// convert JSON string to User object
			Config config = gson.fromJson(reader, Config.class);
			if (config.isDebug()){
				config.getPlcs().forEach(Plc::createDebugTags);
			}else {
				config.getPlcs().forEach(Plc::createPlcTagsMap);
			}
			// close reader
			reader.close();
			return config;
		} catch (Exception ex) {
			ex.printStackTrace();
			log.error(ex.getMessage());
			System.exit(0);
			return null;
		}
	}
}
