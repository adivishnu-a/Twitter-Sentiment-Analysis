library(ggplot2)
library(dplyr)
library(wordcloud)
library(RColorBrewer)
library(gridExtra)
library(grid)
library(png)


# Define stop words
stop_words <- c("the", "is", "in", "and", "to", "of", "a", "for", "on", "with", "at", "by", "an", "be", "this", "that", "it", "from", "or", "as", "are", "was", "were", "but", "not", "have", "has", "had", "will", "would", "can", "could", "should", "may", "might", "must", "shall")

# Load the sentiment percentage data
sentiment_percentage <- read.csv(list.files("data/outputs/sentiment_percentage", full.names = TRUE, pattern = "*.csv"), header = TRUE)

# Plot the sentiment percentage distribution as a pie chart
pie_chart <- ggplot(sentiment_percentage, aes(x = "", y = Percentage, fill = Sentiment)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_minimal() +
  theme(axis.text.x = element_blank()) +
  labs(title = "Sentiment Percentage Distribution", x = "", y = "") +
  scale_fill_brewer(palette = "Set3")

# Save the plot with a white background
ggsave("data/outputs/sentiment_percentage_distribution.png", plot = pie_chart, bg = "white")

# Load the top entities data
top_entities <- read.csv(list.files("data/outputs/top_entities", full.names = TRUE, pattern = "*.csv"), header = TRUE)

# Plot the top entities by tweet count
top_entities_plot <- ggplot(top_entities, aes(x = reorder(Entity, -count), y = count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Top 10 Entities by Tweet Count", x = "Entity", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Save the plot with a white background
ggsave("data/outputs/top_entities.png", plot = top_entities_plot, bg = "white")

# Load the average tweet length by sentiment data
avg_tweet_length_by_sentiment <- read.csv(list.files("data/outputs/avg_tweet_length_by_sentiment", full.names = TRUE, pattern = "*.csv"), header = TRUE)

# Plot the average tweet length by sentiment
avg_tweet_length_plot <- ggplot(avg_tweet_length_by_sentiment, aes(x = Sentiment, y = AvgTweetLength)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Average Tweet Length by Sentiment", x = "Sentiment", y = "Average Tweet Length")

# Save the plot with a white background
ggsave("data/outputs/avg_tweet_length_by_sentiment.png", plot = avg_tweet_length_plot, bg = "white")

# Load the top positive words data
top_positive_words <- read.csv(list.files("data/outputs/top_positive_words", full.names = TRUE, pattern = "*.csv"), header = TRUE)

# Plot the top positive words
top_positive_words_plot <- ggplot(top_positive_words, aes(x = reorder(Word, -count), y = count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Top 10 Positive Words", x = "Word", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Save the plot with a white background
ggsave("data/outputs/top_positive_words.png", plot = top_positive_words_plot, bg = "white")

# Load the top negative words data
top_negative_words <- read.csv(list.files("data/outputs/top_negative_words", full.names = TRUE, pattern = "*.csv"), header = TRUE)

# Plot the top negative words
top_negative_words_plot <- ggplot(top_negative_words, aes(x = reorder(Word, -count), y = count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Top 10 Negative Words", x = "Word", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Save the plot with a white background
ggsave("data/outputs/top_negative_words.png", plot = top_negative_words_plot, bg = "white")

# Load the sentiment by entity data
sentiment_by_entity <- read.csv(list.files("data/outputs/sentiment_by_entity", full.names = TRUE, pattern = "*.csv"), header = TRUE)

# Plot the sentiment distribution by entity
sentiment_by_entity_plot <- ggplot(sentiment_by_entity, aes(x = Entity, y = count, fill = Sentiment)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Sentiment Distribution by Entity", x = "Entity", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Save the plot with a white background
ggsave("data/outputs/sentiment_by_entity.png", plot = sentiment_by_entity_plot, bg = "white")

# Load the sentiment for top entities data
sentiment_for_top_entities <- read.csv(list.files("data/outputs/sentiment_for_top_entities", full.names = TRUE, pattern = "*.csv"), header = TRUE)

# Plot the sentiment distribution for top entities
sentiment_for_top_entities_plot <- ggplot(sentiment_for_top_entities, aes(x = Entity, y = count, fill = Sentiment)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Sentiment Distribution for Top Entities", x = "Entity", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Save the plot with a white background
ggsave("data/outputs/sentiment_for_top_entities.png", plot = sentiment_for_top_entities_plot, bg = "white")

# Generate word clouds for positive and negative words
positive_words <- read.csv(list.files("data/outputs/top_positive_words", full.names = TRUE, pattern = "*.csv"), header = TRUE)
negative_words <- read.csv(list.files("data/outputs/top_negative_words", full.names = TRUE, pattern = "*.csv"), header = TRUE)

# Word cloud for positive words
png("data/outputs/positive_wordcloud.png", bg = "white")
wordcloud(words = positive_words$Word, freq = positive_words$count, min.freq = 1,
          max.words = 20, random.order = FALSE, rot.per = 0.35, 
          colors = brewer.pal(8, "Dark2"), scale = c(3, 0.5))
title(main = "Positive Words Word Cloud")
dev.off()

# Word cloud for negative words
png("data/outputs/negative_wordcloud.png", bg = "white")
wordcloud(words = negative_words$Word, freq = negative_words$count, min.freq = 1,
          max.words = 20, random.order = FALSE, rot.per = 0.35, 
          colors = brewer.pal(8, "Dark2"), scale = c(3, 0.5))
title(main = "Negative Words Word Cloud")
dev.off()

# Create a PDF with all the plots and tables
pdf("RPlots.pdf", width = 8, height = 10)

# Add plots to the PDF
grid.newpage()
grid.draw(rasterGrob(readPNG("data/outputs/sentiment_percentage_distribution.png")))
grid.newpage()
grid.draw(rasterGrob(readPNG("data/outputs/top_entities.png")))
grid.newpage()
grid.draw(rasterGrob(readPNG("data/outputs/avg_tweet_length_by_sentiment.png")))
grid.newpage()
grid.draw(rasterGrob(readPNG("data/outputs/top_positive_words.png")))
grid.newpage()
grid.draw(rasterGrob(readPNG("data/outputs/top_negative_words.png")))
grid.newpage()
grid.draw(rasterGrob(readPNG("data/outputs/sentiment_by_entity.png")))
grid.newpage()
grid.draw(rasterGrob(readPNG("data/outputs/sentiment_for_top_entities.png")))
grid.newpage()
grid.draw(rasterGrob(readPNG("data/outputs/positive_wordcloud.png")))
grid.newpage()
grid.draw(rasterGrob(readPNG("data/outputs/negative_wordcloud.png")))

# Add tables to the PDF (top 10 rows with captions)
grid.newpage()
grid.text("Top 10 Sentiment Percentage", gp = gpar(fontsize = 14, fontface = "bold"))
grid.newpage()
grid.table(head(sentiment_percentage, 10))

grid.newpage()
grid.text("Top 10 Entities by Tweet Count", gp = gpar(fontsize = 14, fontface = "bold"))
grid.newpage()
grid.table(head(top_entities, 10))

grid.newpage()
grid.text("Top 10 Average Tweet Length by Sentiment", gp = gpar(fontsize = 14, fontface = "bold"))
grid.newpage()
grid.table(head(avg_tweet_length_by_sentiment, 10))

grid.newpage()
grid.text("Top 10 Positive Words", gp = gpar(fontsize = 14, fontface = "bold"))
grid.newpage()
grid.table(head(top_positive_words, 10))

grid.newpage()
grid.text("Top 10 Negative Words", gp = gpar(fontsize = 14, fontface = "bold"))
grid.newpage()
grid.table(head(top_negative_words, 10))

grid.newpage()
grid.text("Top 10 Sentiment Distribution by Entity", gp = gpar(fontsize = 14, fontface = "bold"))
grid.newpage()
grid.table(head(sentiment_by_entity, 10))

grid.newpage()
grid.text("Top 10 Sentiment Distribution for Top Entities", gp = gpar(fontsize = 14, fontface = "bold"))
grid.newpage()
grid.table(head(sentiment_for_top_entities, 10))

dev.off()