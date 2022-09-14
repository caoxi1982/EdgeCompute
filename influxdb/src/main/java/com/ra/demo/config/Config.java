package com.ra.demo.config;

import java.util.Arrays;
import java.util.List;

public class Config {
    private final String url;
    private final String token;
    private final String org;
    private final String bucket;
    private boolean debug = false;
    private final Plc[] plcs;

    public Config(String url,String token,String org,String bucket,boolean debug,Plc[] plcs) {
        this.url = url;
        this.token = token;
        this.org = org;
        this.bucket = bucket;
        this.debug = debug;
        this.plcs = plcs;
    }
    public String getURL() {
        return url;
    }
    public String getORG() {
        return org;
    }
    public String getBucket() {
        return bucket;
    }
    public String getToken() {
        return token;
    }
    public boolean isDebug() { return debug; }
    public List<Plc> getPlcs() {
        return Arrays.asList(plcs);
    }

    @Override
    public String toString() {
        return "Config [url=" + this.url
                +  "\n, org=" + this.org
                + "\n, bucket=" + this.bucket
                + "\n, token=" + this.token
                + "\n, debug=" + this.debug
                + "\n, plcs=" + Arrays.toString(plcs) + "]";
    }
}
