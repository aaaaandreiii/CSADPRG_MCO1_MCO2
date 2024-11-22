###########################
# Last names:
# 	Avelino
# 	Balingit
# 	Liong
# 	Wong
#
# Language: Ruby
# Paradigms: functional, imperative, object-oriented, reflective
##########################

# For CSADPROG MCO2
# Corpus Analysis 

require 'csv'
require 'rmagick'
require 'gruff'
require 'date'


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
  symbol_counts = Hash.new(0)
  posts_per_month = Hash.new(0)

  tweets.each do |tweet|
    #extract words
    # all_words += tweet[:text].split.map { |word| word.downcase.gsub(/[^a-z0-9]/i, '') }         491 vocab words
    all_words += tweet[:text].split.map(&:downcase)                                            #  530 vocab words

    #count symbols
    tweet[:text].each_char do |char|
      unless char.match?(/[a-zA-Z0-9]/)
        symbol_counts[char] += 1
      end
    end

    # Count posts per month
    month = tweet[:date_created].strftime('%Y-%m')
    posts_per_month[month] += 1
  end

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
  

  #word count
  word_count = all_words.length
  
  #vocabulary size
  vocabulary_size = all_words.uniq.length

  # Character frequency
  character_frequency = all_words.join.chars.each_with_object(Hash.new(0)) {|char, counts| counts[char] += 1}
  sorted_character_frequency = character_frequency.sort_by {|char, count| -count}

  # Word frequency
  word_frequency = all_words.each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
  word_frequency = word_frequency.sort
  sorted_word_frequency = word_frequency.sort_by { |_, count| -count }

  # Top 20 words
  top_20_words = sorted_word_frequency.first(20)

  stop_word_frequency = word_frequency.select { |word, _| stop_words.include?(word) }
  sorted_stop_word_frequency = stop_word_frequency.sort_by { |_, count| -count }.first(10)



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
  puts "Top 10 Most Frequent Stop Words:"
  sorted_stop_word_frequency.each { |word, count| 
    puts "#{word}: #{count}" 
  }

  [top_20_words, posts_per_month, symbol_counts]
end



# data visualization methods

def create_word_cloud(top_words)
  canvas = Magick::Image.new(1000, 800) 
  canvas.background_color = 'white'
  draw = Magick::Draw.new

  max_size = 100
  min_size = 20
  max_frequency = top_words.first[1]
  min_frequency = top_words.last[1]

  top_words.each do |word, frequency|
    font_size = ((frequency - min_frequency).to_f / (max_frequency - min_frequency) * (max_size - min_size) + min_size).to_i
    x = rand(100..900)
    y = rand(100..700)
    draw.annotate(canvas, 0, 0, x, y, word) do
      draw.font_family = 'Arial'
      draw.fill = "##{rand(0x1000000).to_s(16).rjust(6, '0')}" # Random color
      draw.pointsize = font_size
    end
  end

  canvas.write('Ruby_word_cloud.png')
end

def create_bar_chart(posts_per_month)
  bar_chart = Gruff::Bar.new
  bar_chart.title = 'Posts Per Month'
  months = posts_per_month.keys.sort
  values = months.map { |month| posts_per_month[month] }

  bar_chart.labels = months.each_with_index.map { |month, index| [index, month] }.to_h
  bar_chart.data('Posts', values)
  bar_chart.write('Ruby_posts_per_month.png')
end

# def create_bar_chart(posts_per_month)
#   bar_chart = Gruff::Bar.new(width: 1000)
#   bar_chart.title = 'Posts Per Month'

#   months = posts_per_month.keys.sort
#   values = months.map { |month| posts_per_month[month] }

#   # Rotate labels by 45 degrees
#   # bar_chart.x_axis_label_rotate = 45
#   # bar_chart.font = { :angle => 45 }


#   bar_chart.labels = months.each_with_index.map { |month, index| [index, month] }.to_h
#   bar_chart.data('Posts', values)
#   bar_chart.write('Ruby_posts_per_month.png')
# end

def create_pie_chart(symbol_counts)
  pie_chart = Gruff::Pie.new
  
  pie_chart.title = 'Symbol Distribution'

  symbol_counts.each do |symbol, count|
    # Get the ASCII code of the symbol
    ascii_code = symbol.ord

    # Format the legend label with "ASCII Code ####"
    legend_label = "ASCII ##{ascii_code.to_s}"

    pie_chart.data(legend_label, count)
  end

  pie_chart.write('Ruby_symbol_distribution.png')
end

# Main Execution
filename = 'fake_tweets.csv'
tweets = process_tweets(filename)
top_words, posts_per_month, symbol_counts = analyze_tweets(tweets)

create_word_cloud(top_words)
create_bar_chart(posts_per_month)
create_pie_chart(symbol_counts)

puts "\n\n\nWord cloud saved as 'Ruby_word_cloud.png'"
puts "Bar chart saved as 'Ruby_posts_per_month.png'"
puts "Pie chart saved as 'Ruby_symbol_distribution.png'"
