package com.ra.demo.plc4x;

import com.ra.demo.config.Config;
import com.ra.demo.config.ReadConfig;
import com.ra.demo.influxdb.SimpleTriggerExample;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class App 
{
    private static Logger log = LoggerFactory.getLogger(App.class);
    public static void main( String[] args )
    {
        log.debug( "Hello World!" );
        Config cfg = ReadConfig.read();
        log.debug("{}",cfg);
        SimpleTriggerExample example = new SimpleTriggerExample();
        example.run(cfg);
    }
}
