package org.example

/*
********************
Last names:
*   Avelino
*   Balingit
*   Liong
*   Wong
Language: Kotlin
Paradigm(s): functional, imperative, object-oriented, procedural
********************
*/
import java.awt.*
import java.io.File
import java.util.*
import javax.swing.JFrame
import javax.swing.JPanel

data class Tweet(
    val tweetId: Long,
    val userId: Long,
    val dateCreated: String,
    val text: String,
    val language: String
)

fun loadFile(): Pair<String, List<Tweet>> {
    val filePath = "fake_tweets.csv"
    if (!File(filePath).exists()) {
        println("File not found: $filePath")
        return Pair("", emptyList())
    }
    val tweets: List<Tweet> = File(filePath).readLines().drop(1).map { tweet ->
        val field = tweet.split(",")
        Tweet(
            tweetId = field[0].trim().toLong(),
            userId = field[1].trim().toLong(),
            dateCreated = field[2].trim(),
            text = field[3].trim(),
            language = field[4].trim()
        )
    }
    tweets.forEach{println(it)}
    val corpus = tweets.joinToString(" ") {it.text}
    return Pair(corpus, tweets)
}

fun monthlyPost(tweets: List<Tweet>): Map<String, Int> {
//    println("\nMonthly Tweet Counts:")
    val dateFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
    return tweets.groupingBy { tweet ->
        val date = java.time.LocalDate.parse(tweet.dateCreated, dateFormatter)
        "${date.year}-${date.monthValue.toString().padStart(2, '0')}"
    }.eachCount().toSortedMap()
}

fun countSymbols(corpus: String): Map<Char, Int> {
    val seen = mutableSetOf<Char>()
    println("\n Symbols:")
    corpus.filter { it.isLetterOrDigit().not() }.forEach { symbol ->
        if (seen.add(symbol)) {
            println("Symbol: '$symbol' (Unicode: ${symbol.code})")
        }
    }
    return corpus
        .filter { it.isLetterOrDigit().not() }
        .groupingBy { it }
        .eachCount()
}

fun analysis(corpus: String, tweets: List<Tweet>) {
    val words = corpus.split("\\s+".toRegex()).filter { it.isNotBlank() }.map{it.lowercase()}
    println("\nWord Count: ${words.size}")

    val uniqueWords = words.toSet()
    println("Vocabulary Size: ${uniqueWords.size}")

    val wordFrequency = words.groupingBy { it }.eachCount().toList().sortedByDescending { it.second }
    println("\nWord Frequency: ")
    wordFrequency.forEach { (word, count) ->
        println("$word: $count")
    }

    val characters = corpus.filter { it.isLetterOrDigit() || it.isWhitespace().not() }
        .groupingBy { it }.eachCount().toList().sortedByDescending { it.second }
    println("\nCharacter Frequency: ")
    characters.forEach { (character, count) ->
        println("$character: $count")
    }

    val topWords = wordFrequency.take(20)
    println("\nFrequency Analysis(Top 20 most frequent words and their counts): ")
    topWords.forEachIndexed { index, (word, count) ->
        println("${index+1}. $word: $count")
    }

    val stopWordIdentification = setOf(
        "a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "aren't",
        "as", "at", "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", "can't",
        "cannot", "could", "couldn't", "did", "didn't", "do", "does", "doesn't", "doing", "don't", "down", "during",
        "each", "few", "for", "from", "further", "had", "hadn't", "has", "hasn't", "have", "haven't", "having", "he",
        "he'd", "he'll", "he's", "her", "here", "here's", "hers", "herself", "him", "himself", "his", "how", "how's",
        "i", "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "isn't", "it", "it's", "its", "itself", "let's",
        "me", "more", "most", "mustn't", "my", "myself", "no", "nor", "not", "of", "off", "on", "once", "only", "or",
        "other", "ought", "our", "ours", "ourselves", "out", "over", "own", "same", "she", "she'd", "she'll", "she's",
        "should", "shouldn't", "so", "some", "such", "than", "that", "that's", "the", "their", "theirs", "them",
        "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this",
        "those", "through", "to", "too", "under", "until", "up", "very", "was", "wasn't", "we", "we'd", "we'll", "we're",
        "we've", "were", "weren't", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who",
        "who's", "whom", "why", "why's", "with", "won't", "would", "wouldn't", "you", "you'd", "you'll", "you're", "you've",
        "your", "yours", "yourself", "yourselves"
    )
    val stopWords = words.filter { it in stopWordIdentification }
        .groupingBy { it }.eachCount().toList().sortedByDescending { it.second }
    println("\nTop 10 Common Words: ")
    stopWords.take(10).forEachIndexed { index, (word, count) ->
        println("${index+1}. $word: $count")
    }
//    do{
//        println("\nData Visualization:")
//        println("[1] Word Cloud")
//        println("[2] Bar Chart")
//        println("[3] Pie Chart")
//        println("[4] Exit")
//        val choice = readlnOrNull()?.toIntOrNull() ?: -1
//        if(choice == 1){
//            generateWordCloud(topWords)
//        }
//        else if(choice == 2){
//            generateBarChart(monthlyPost(tweets))
//        }
//    } while(choice != 4)
    generateWordCloud(topWords)
    generateBarChart(monthlyPost(tweets))
    generatePieChart(countSymbols(corpus))
}

fun generatePieChart(symbolCounts: Map<Char, Int>) {
    val frame = JFrame("Symbol Distribution Pie Chart")
    frame.defaultCloseOperation = JFrame.DISPOSE_ON_CLOSE
    frame.setSize(800, 600)
    val panel = object : JPanel() {
        override fun paintComponent(g: Graphics) {
            super.paintComponent(g)
            val g2d = g as Graphics2D
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
            val totalSymbols = symbolCounts.values.sum()
            var startAngle = 0.0
            val random = Random()
            val colors = symbolCounts.keys.associateWith {
                Color(random.nextInt(256), random.nextInt(256), random.nextInt(256))
            }
            val panelWidth = width
            val panelHeight = height
            val diameter = minOf(panelWidth, panelHeight) - 50
            val centerX = (panelWidth - diameter) / 2
            val centerY = (panelHeight - diameter) / 2

            symbolCounts.forEach { (symbol, count) ->
                val sliceAngle = (count.toDouble() / totalSymbols) * 360
                g2d.color = colors[symbol]
                g2d.fillArc(centerX, centerY, diameter, diameter, startAngle.toInt(), sliceAngle.toInt())
                startAngle += sliceAngle
            }
            val legendX = centerX + diameter + 20
            var legendY = centerY
            g2d.font = Font("SansSerif", Font.PLAIN, 14)
            symbolCounts.forEach { (symbol, count) ->
                g2d.color = colors[symbol]
                g2d.fillRect(legendX, legendY, 15, 15)
                g2d.color = Color.BLACK
                g2d.drawString("$symbol (${count})", legendX + 20, legendY + 12)
                legendY += 20
            }
        }
    }
    frame.add(panel)
    frame.isVisible = true
}

fun generateBarChart(monthlyCounts: Map<String, Int>) {
    val frame = JFrame("Bar Chart")
    frame.defaultCloseOperation = JFrame.DISPOSE_ON_CLOSE
    frame.setSize(800, 600)
    frame.add(object : JPanel() {
        override fun paintComponent(g: Graphics) {
            super.paintComponent(g)
            val g2d = g as Graphics2D
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
            val panelWidth = width
            val panelHeight = height
            val maxCount = monthlyCounts.values.maxOrNull() ?: 1
            val barWidth = panelWidth / monthlyCounts.size
            val padding = 10
            var x = padding
            g2d.font = Font("SansSerif", Font.PLAIN, 12)
            monthlyCounts.forEach { (month, count) ->
                val barHeight = ((count.toDouble() / maxCount) * (panelHeight * 0.8)).toInt()
                g2d.color = Color(70, 130, 180)
                g2d.fillRect(x, panelHeight - barHeight - padding, barWidth - padding, barHeight)
                g2d.color = Color.BLACK
                val labelWidth = g2d.fontMetrics.stringWidth(month)
                g2d.drawString(month, x + (barWidth - labelWidth) / 2, panelHeight - 5)
                x += barWidth
            }
        }
    })
    frame.isVisible = true
}

fun generateWordCloud(topWords: List<Pair<String, Int>>){
    val frame = JFrame("Word Cloud")
    frame.defaultCloseOperation = JFrame.DISPOSE_ON_CLOSE
    frame.setSize(800, 600)
    frame.isVisible = true
    val wordPanel = object: JPanel(){
        override fun paintComponent(g: Graphics) {
            super.paintComponent(g)
            val g2d = g as Graphics2D
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
            val random = Random()
            val panelWidth = width
            val panelHeight = height
            val maxFrequency = topWords.maxOfOrNull { it.second } ?: 1
            val minFontSize = 12
            val maxFontSize = 50
            topWords.forEach { (word, count) ->
                val fontSize = ((count.toDouble() / maxFrequency) * (maxFontSize - minFontSize) + minFontSize).toInt()
                g2d.font = Font("SansSerif", Font.BOLD, fontSize)
                val wordWidth = g2d.fontMetrics.stringWidth(word)
                val wordHeight = g2d.fontMetrics.height
                var x: Int
                var y: Int
                do {
                    x = random.nextInt(panelWidth - wordWidth)
                    y = random.nextInt(panelHeight - wordHeight) + wordHeight
                } while (x < 0 || y < 0)
                g2d.color = Color(random.nextInt(256), random.nextInt(256), random.nextInt(256))
                g2d.drawString(word, x, y)
            }
        }
    }
    frame.add(wordPanel)
    frame.repaint()
}

fun main() {
    val corpus = loadFile()
    analysis(corpus.first, corpus.second)
}