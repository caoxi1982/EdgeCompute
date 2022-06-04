package com.ra.demo.plc4x;

import com.ra.demo.config.Config;
import com.ra.demo.config.ReadConfig;
import com.ra.demo.influxdb.InfluxDBJob;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Scanner;

/**
 * Hello world!
 *
 */
public class App 
{
    private static Logger _log = LoggerFactory.getLogger(App.class);
    public static void main( String[] args )
    {
        boolean exit = true;
        System.out.println( "Hello World!" );
        Config cfg = ReadConfig.read();
        System.out.println("Config = " + cfg );
        _log.debug("Config = /n {}",cfg);
        Scanner sc = new Scanner(System.in);
        while(exit){
            int temp = sc.nextInt();
            if (temp == 100) {
                exit = false;
            }
            System.out.println("Type = " + temp );
            _log.debug("Type = {}",temp);
            _log.trace("Type = {}",temp);
        } 
        sc.close();
    }
}
