package com.ra.demo.plc4x;

import com.ra.demo.config.Config;
import com.ra.demo.config.ReadConfig;
import com.ra.demo.influxdb.Trigger;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class App 
{
    private static Logger log = LoggerFactory.getLogger(App.class);
    public static void main( String[] args )
    {
        Config cfg = ReadConfig.read();
        log.debug("{}",cfg);
        Trigger example = new Trigger();
        example.run(cfg);
    }
}
