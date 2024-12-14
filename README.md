# Twitter Sentiment Analysis Using Spark and R

## Abstract
This project aims to analyze Twitter sentiment data using Apache Spark for data processing and R for visualization. The goal is to understand public sentiment on various entities by analyzing tweets and generating insightful visualizations.

## Table of Contents
- Abstract
- Project Structure
- Environment Setup
- Running the Project
- File Descriptions
- Output Descriptions
- Purpose
- License

## Project Structure
```
TwitterSentimentAnalysis/
├── data/
│   ├── tweets.csv
│   └── outputs/
├── src/
│   └── main/
│       └── java/
│           └── com/
│               └── example/
│                   └── TwitterSentimentAnalysis.java
├── R/
│   └── visualization.R
├── resources/
│   └── log4j.properties
├── pom.xml
└── README.md
```

## Environment Setup

### Prerequisites
- **Java 8 or higher**
- **Apache Maven**
- **Apache Hadoop**
- **Apache Spark**
- **R and RStudio**
- **Required R packages:** `ggplot2`, `dplyr`, `wordcloud`, `RColorBrewer`, `gridExtra`, `grid`, `png`

### Installing Hadoop and Spark
1. **Install Hadoop:**
    - Follow the official [Hadoop installation guide](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html).

2. **Install Spark:**
    - Follow the official [Spark installation guide](https://spark.apache.org/docs/latest/index.html).

### Cloning the Repository
```sh
git clone https://github.com/yourusername/TwitterSentimentAnalysis.git
cd TwitterSentimentAnalysis
```

## Running the Project

### Step 1: Run the Java Code
1. Open IntelliJ IDEA.
2. Open the cloned repository as a Maven project.
3. Run the `TwitterSentimentAnalysis` class located in 

TwitterSentimentAnalysis.java

.

### Step 2: Run the R Script
```sh
Rscript R/visualization.R
```

## File Descriptions

### 

tweets.csv


- **Description:** Contains the tweet data without headers.
- **Columns:**
  - `TweetID`: Unique identifier for each tweet.
  - `Entity`: The subject or entity being discussed in the tweet.
  - `Sentiment`: The sentiment expressed in the tweet (e.g., Positive, Negative, Neutral).
  - `TweetContent`: The actual text content of the tweet.

### 

TwitterSentimentAnalysis.java


- **Description:** Main Java file for data processing using Apache Spark.
- **Key Functions:**
  - **Data Loading and Cleaning:** Loads tweets from `tweets.csv`, removes duplicates.
  - **Sentiment Analysis:** Calculates the percentage of each sentiment.
  - **Entity Analysis:** Identifies the top entities by tweet count.
  - **Additional Insights:** Calculates average tweet length by sentiment, top words in positive and negative tweets, sentiment distribution by entity, and sentiment distribution for top entities.
  - **Output:** Saves the results to CSV files in the 

outputs

 directory.

### 

visualization.R


- **Description:** R script for generating visualizations from the CSV files.
- **Key Functions:**
  - **Visualization:** Generates plots and word clouds from the CSV files.
  - **PDF Report:** Creates a PDF report with all the plots and tables, each on a separate page, displaying only the top 10 rows of each table with captions.

### 

log4j.properties


- **Description:** Configuration file for logging levels for Spark and Hadoop.

### 

pom.xml


- **Description:** Maven configuration file for managing project dependencies.

## Output Descriptions

### Java Output
The Java code processes the tweet data and generates the following CSV files in the 

outputs

 directory:
- **`sentiment_percentage`**: Contains the percentage of each sentiment.
- **`top_entities`**: Contains the top entities by tweet count.
- **`avg_tweet_length_by_sentiment`**: Contains the average tweet length by sentiment.
- **`top_positive_words`**: Contains the top positive words.
- **`top_negative_words`**: Contains the top negative words.
- **`sentiment_by_entity`**: Contains the sentiment distribution by entity.
- **`sentiment_for_top_entities`**: Contains the sentiment distribution for top entities.

### R Output
The R script generates the following visualizations and saves them in the 

outputs

 directory:
- **`sentiment_percentage_distribution.png`**: Pie chart of sentiment percentage distribution.
- **`top_entities.png`**: Bar chart of the top entities by tweet count.
- **`avg_tweet_length_by_sentiment.png`**: Bar chart of the average tweet length by sentiment.
- **`top_positive_words.png`**: Bar chart of the top positive words.
- **`top_negative_words.png`**: Bar chart of the top negative words.
- **`sentiment_by_entity.png`**: Bar chart of the sentiment distribution by entity.
- **`sentiment_for_top_entities.png`**: Bar chart of the sentiment distribution for top entities.
- **`positive_wordcloud.png`**: Word cloud of positive words.
- **`negative_wordcloud.png`**: Word cloud of negative words.
- **`visualization.pdf`**: PDF report containing all the plots and tables, each on a separate page, displaying only the top 10 rows of each table with captions.

## Purpose
The purpose of this project is to provide insights into public sentiment on various entities using Twitter data. This can be useful for businesses, politicians, and organizations to make informed decisions based on public opinion.

## License
This project is licensed under the MIT License. See the `LICENSE` file for more details.