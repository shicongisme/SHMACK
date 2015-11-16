package com.zuehlke.shmack.sparkjobs.wordcount;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaSparkContext;

import com.zuehlke.shmack.sparkjobs.base.SparkTestBase;

public class LocalSparkTestBase extends SparkTestBase {

    protected JavaSparkContext createSparkContext(String appName) {
        final SparkConf conf = new SparkConf().setAppName(appName).setMaster("local[*]")
                .set("spark.executor.memory", "1g");
        return new JavaSparkContext(conf);
    }

}
