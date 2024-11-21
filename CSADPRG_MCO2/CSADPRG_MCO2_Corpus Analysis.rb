# # Made by: BALINGIT, Andrei Luis
# # For CSADPROG MCO2
# # Corpus Analysis 

require 'csv'

def process_tweets(filename)
  tweets = []
  CSV.foreach(filename, headers: true) do |row|
    tweet = {
      tweet_id: row['tweet_id'].to_i,
      user_id: row['user_id'].to_i,
      date_created: DateTime.parse(row['date_created']),
      text: row['text'],
      language: row['language']
    }
    tweets << tweet
  end
  tweets
end

def analyze_tweets(tweets)
  all_words = []
  tweets.each do |tweet|
    all_words += tweet[:text].split
  end

  # Word count
  word_count = all_words.length

  # Vocabulary size
  vocabulary_size = all_words.uniq.length

  # Word frequency
  word_frequency = all_words.each_with_object(Hash.new(0)) do |word, counts| 
    counts[word] += 1 
  end
  sorted_word_frequency = word_frequency.sort_by do |word, count| 
    -count 
  end

  # Character frequency
  character_frequency = all_words.join.chars.each_with_object(Hash.new(0)) do |char, counts| 
    counts[char] += 1 
  end
  sorted_character_frequency = character_frequency.sort_by do |char, count| 
    -count 
  end

  # Top 20 most frequent words
  top_20_words = sorted_word_frequency.first(20)

  # Identify common stop words (you might need to refine this list)
  # stop_words = ["the", "and", "a", "of", "to", "in", "is", "it", "for", "that"]

  # TODO: only display 10 of the most frequent stop words, and not all of them
  stop_words = [
    "a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "aren't", "as", "at",
    "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", 
    "can't", "cannot", "could", "couldn't",
    "did", "didn't", "do", "does", "doesn't", "doing", "don't", "down", "during", 
    "each", 
    "few", "for", "from", "further",
    "had", "hadn't", "has", "hasn't", "have", "haven't", "having", "he", "he'd", "he'll", "he's", "her", "here", "here's", "hers",
    "herself", "him", "himself", "his", "how", "how's", "i", "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "isn't", "it",
    "it's", "its", "itself", 
    "let's", 
    "me", "more", "most", "mustn't", "my", "myself", 
    "no", "nor", "not", 
    "of", "off", "on", "once", "only", "or", "other", "ought", "our", "ours", "ourselves", "out", "over", "own", 
    "same", "she", "she'd", "she'll", "she's", "should", "shouldn't", "so", "some", "such", 
    "than", "that", "that's", "the", "their", "theirs", "them", "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", 
    "under", "until", "up", 
    "very", 
    "was", "wasn't", "we", "we'd", "we'll", "we're", "we've", "were", "weren't", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why", "why's", "with", "won't", "would", "wouldn't", 
    "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves"
  ]
  

  puts "----------------------------------------------------------------"
  puts "Word Count: #{word_count}"

  puts "----------------------------------------------------------------"
  puts "Vocabulary Size: #{vocabulary_size}"

  puts "----------------------------------------------------------------"
  puts "Word Frequency:"
  sorted_word_frequency.each { |word, count| 
    puts "#{word}: #{count}" 
  }

  puts "----------------------------------------------------------------"
  puts "Character Frequency:"
  sorted_character_frequency.each { |char, count| 
    puts "#{char}: #{count}" 
  }
  
  puts "----------------------------------------------------------------"
  puts "Top 20 Most Frequent Words:"
  top_20_words.each { |word, count| 
    puts "#{word}: #{count}" 
  }

  puts "----------------------------------------------------------------"
  puts "Potential Stop Words:"
  stop_words.each { |word| 
    puts word 
  }
end

filename = 'fake_tweets.csv'

tweets = process_tweets(filename)
analyze_tweets(tweets)


# CURRENTLY DOES NOT WORK
# require 'ruby-plot'

# # Assuming you have a hash `posts_per_month` with month as key and count as value
# posts_per_month = {
#   "January" => 100,
#   "February" => 150,
#   # ...
# }

# # Create a bar chart
# Plot.new
# Plot.bar(posts_per_month.keys, posts_per_month.values)
# Plot.xlabel("Month")
# Plot.ylabel("Number of Posts")
# Plot.title("Posts per Month")
# Plot.show