package com.example;

import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Encoders;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.functions;
import org.apache.spark.sql.types.DataTypes;
import org.apache.spark.sql.types.StructField;
import org.apache.spark.sql.types.StructType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Arrays;
import java.util.List;

public class TwitterSentimentAnalysis {
    private static final Logger logger = LoggerFactory.getLogger(TwitterSentimentAnalysis.class);

    public static void main(String[] args) {
        logger.info("Starting Twitter Sentiment Analysis using Spark");

        SparkSession spark = SparkSession.builder()
                .appName("Twitter Sentiment Analysis")
                .master("local[*]")
                .config("spark.driver.extraJavaOptions", "-Dlog4j.configuration=file:resources/log4j.properties")
                .getOrCreate();

        logger.info("Spark Session created");

        StructType schema = DataTypes.createStructType(new StructField[]{
                DataTypes.createStructField("TweetID", DataTypes.IntegerType, false),
                DataTypes.createStructField("Entity", DataTypes.StringType, false),
                DataTypes.createStructField("Sentiment", DataTypes.StringType, false),
                DataTypes.createStructField("TweetContent", DataTypes.StringType, false)
        });

        Dataset<Row> tweets = spark.read()
                .option("header", "false")
                .schema(schema)
                .csv("data/tweets.csv");

        logger.info("Tweets data loaded");

        // Data Cleaning: Remove duplicate tweets
        tweets = tweets.dropDuplicates("TweetContent");
        logger.info("Duplicate tweets removed");

        // Sentiment Analysis: Calculate the percentage of each sentiment
        Dataset<Row> sentimentCount = tweets.groupBy("Sentiment").count();
        long totalTweets = tweets.count();
        Dataset<Row> sentimentPercentage = sentimentCount.withColumn("Percentage",
                functions.round(functions.col("count").divide(totalTweets).multiply(100), 2));

        logger.info("Sentiment analysis completed");

        // Entity Analysis: Identify the top entities by tweet count
        Dataset<Row> topEntities = tweets.groupBy("Entity").count()
                .orderBy(functions.desc("count"))
                .limit(10);

        logger.info("Entity analysis completed");

        // Additional Insights: Average tweet length by sentiment
        Dataset<Row> tweetLength = tweets.withColumn("TweetLength", functions.length(functions.col("TweetContent")));
        Dataset<Row> avgTweetLengthBySentiment = tweetLength.groupBy("Sentiment")
                .agg(functions.avg("TweetLength").alias("AvgTweetLength"));

        logger.info("Average tweet length by sentiment calculated");

        // Define stop words
        List<String> stopWords = Arrays.asList("the", "is", "in", "and", "to", "of", "a", "for", "on", "with", "at", "by", "an", "be", "this", "that", "it", "from", "or", "as", "are", "was", "were", "but", "not", "have", "has", "had", "will", "would", "can", "could", "should", "may", "might", "must", "shall");

        // Additional Insights: Top words in positive and negative tweets
        Dataset<Row> positiveTweets = tweets.filter(functions.col("Sentiment").equalTo("Positive"));
        Dataset<Row> negativeTweets = tweets.filter(functions.col("Sentiment").equalTo("Negative"));

        Dataset<Row> positiveWords = positiveTweets.select(functions.explode(functions.split(functions.col("TweetContent"), " ")).alias("Word"))
                .filter(functions.not(functions.col("Word").isin(stopWords.toArray())))
                .groupBy("Word").count().orderBy(functions.desc("count")).limit(20);

        Dataset<Row> negativeWords = negativeTweets.select(functions.explode(functions.split(functions.col("TweetContent"), " ")).alias("Word"))
                .filter(functions.not(functions.col("Word").isin(stopWords.toArray())))
                .groupBy("Word").count().orderBy(functions.desc("count")).limit(20);

        logger.info("Top words in positive and negative tweets calculated");

        // Additional Insights: Sentiment distribution by entity
        Dataset<Row> sentimentByEntity = tweets.groupBy("Entity", "Sentiment").count();

        // Additional Insights: Sentiment distribution for top entities
        Dataset<Row> sentimentForTopEntities = tweets.filter(functions.col("Entity").isin(topEntities.select("Entity").as(Encoders.STRING()).collectAsList().toArray()))
                .groupBy("Entity", "Sentiment").count();

        logger.info("Sentiment distribution by entity and for top entities calculated");

        // Output: Save the results to CSV files
        sentimentPercentage.coalesce(1).write().option("header", "true").csv("data/outputs/sentiment_percentage");
        topEntities.coalesce(1).write().option("header", "true").csv("data/outputs/top_entities");
        avgTweetLengthBySentiment.coalesce(1).write().option("header", "true").csv("data/outputs/avg_tweet_length_by_sentiment");
        positiveWords.coalesce(1).write().option("header", "true").csv("data/outputs/top_positive_words");
        negativeWords.coalesce(1).write().option("header", "true").csv("data/outputs/top_negative_words");
        sentimentByEntity.coalesce(1).write().option("header", "true").csv("data/outputs/sentiment_by_entity");
        sentimentForTopEntities.coalesce(1).write().option("header", "true").csv("data/outputs/sentiment_for_top_entities");

        logger.info("Results saved to CSV files");

        // Show the results
        sentimentPercentage.show();
        topEntities.show();
        avgTweetLengthBySentiment.show();
        positiveWords.show();
        negativeWords.show();
        sentimentByEntity.show();
        sentimentForTopEntities.show();

        spark.stop();
        logger.info("Spark Session stopped");
    }
}