library(dplyr)
library(stringr)
library(lubridate)
library(wordcloud)
library(ggplot2)
library(readr)

data <- read_csv("fake_tweets.csv") 

corpus <- paste(data$text, collapse = " ")

clean_tokenize <- function(text) {
  tokens <- unlist(strsplit(text, "\\s+"))
  return(tolower(tokens)) #make lowercase
}

words <- clean_tokenize(corpus)
total_words <- length(words)
unique_words <- length(unique(words))
word_freq <- table(words)
word_freq_sorted <- sort(word_freq, decreasing = TRUE)
characters <- unlist(strsplit(tolower(corpus), ""))
characters <- characters[characters != " "]  
char_freq <- table(characters)
char_freq_sorted <- sort(char_freq, decreasing = TRUE)

top_words <- head(word_freq_sorted, 20)
stop_words <- c("a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "aren't", "as", "at", "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", "can't", "cannot", "could", "couldn't", "did", "didn't", "do", "does", "doesn't", "doing", "don't", "down", "during", "each", "few", "for", "from", "further", "had", "hadn't", "has", "hasn't", "have", "haven't", "having", "he", "he'd", "he'll", "he's", "her", "here", "here's", "hers", "herself", "him", "himself", "his", "how", "how's", "i", "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "isn't", "it", "it's", "its", "itself", "let's", "me", "more", "most", "mustn't", "my", "myself", "no", "nor", "not", "of", "off", "on", "once", "only", "or", "other", "ought", "our", "ours", "ourselves", "out", "over", "own", "same", "she", "she'd", "she'll", "she's", "should", "shouldn't", "so", "some", "such", "than", "that", "that's", "the", "their", "theirs", "them", "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", "under", "until", "up", "very", "was", "wasn't", "we", "we'd", "we'll", "we're", "we've", "were", "weren't", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why", "why's", "with", "won't", "would", "wouldn't", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves")
identified_stop_words <- word_freq[names(word_freq) %in% stop_words]
top_stop <- head(sort(identified_stop_words, decreasing = TRUE), 10)

print(paste("Total Word Count:", total_words))
print(paste("Vocabulary Size:", unique_words))

print("Word Frequency (Sorted):")
  #print(head(word_freq_sorted, 10)) 
print(word_freq_sorted)

print("Character Frequency (Sorted):")
  #print(head(char_freq_sorted, 10)) 
print(char_freq_sorted)

print("Top 20 Most Frequent Words:")
print(top_words)
print("Top 10 Most Frequent Stop Words:")
print(top_stop)

#wordlcoud
png("wordcloud.png", width = 500, height = 500)
wordcloud(names(top_words), freq = as.numeric(top_words), scale = c(3, 0.5), min.freq = 1)
dev.off()
print("Word cloud saved as 'wordcloud.png'")

#bar
png("barchart.png", width = 500, height = 500)
ggplot(monthly_posts, aes(x = month, y = post_count)) +
  geom_bar(stat = "identity", fill = "pink") +
  theme_minimal() +
  labs(title = "Total Number of Posts Per Month", x = "Month", y = "Number of Posts") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()
print("Bar chart saved as 'barchart.png'")



#symbol freq
symbols <- unlist(str_extract_all(corpus, "[^a-zA-Z0-9\\s]"))
if (length(symbols) > 0) {
  symbol_freq <- table(symbols)
  symbol_data <- data.frame(symbol = names(symbol_freq), freq = as.numeric(symbol_freq))
  
  #pie 
  png("piechart.png", width = 500, height = 500)
  
  print(ggplot(symbol_data, aes(x = "", y = freq, fill = symbol)) +
          geom_bar(stat = "identity", width = 1) +
          coord_polar("y", start = 0) +
          theme_void() +
          labs(title = "Distribution of Symbols in the Corpus"))
  
  dev.off()
  print("Pie chart saved as 'piechart.png'")
} else {
  print("No symbols found.")
}



