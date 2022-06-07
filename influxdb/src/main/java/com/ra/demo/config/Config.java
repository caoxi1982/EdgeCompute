package com.ra.demo.config;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Config {
    private String url = "http://influxdb:8086";
    private String token = "8sgEtjNP0pki9SAx3H5K-wXu804VDz5csGNeXaJXAKulColIJip1aVT_2O-UpUbyjkES-n3nbzszwrpjI-lkAA==";
    private String org = "ra";
    private String bucket = "docker";
    private String connection;
    private PlcTag[] plcTags;

    public Config(String url,String token,String org,String bucket,String connection,PlcTag[] plcTags) {
        this.url = url;
        this.token = token;
        this.org = org;
        this.bucket = bucket;
        this.connection = connection;
        this.plcTags = plcTags;
    }

    public String getConnection() {
        return connection;
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

    public List<PlcTag> getTags() {
        return Arrays.asList(plcTags);
    }

    public List<String> getTagString() {
        ArrayList<String> result = new ArrayList<String>();
        for (PlcTag t : getTags()) {
            result.add(connection + t.toString());
        }
        return result;
    }

    @Override
    public String toString() {
        return "Config [connection=" + connection + "\n, url=" + this.url
                +  "\n, org=" + this.org
                + "\n, bucket=" + this.bucket
                + "\n, token=" + this.token
                + "\n, tags=" + Arrays.toString(plcTags) + "]";
    }
}
