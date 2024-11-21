/*
***************
Last names:

	Avelino
	Balingit
	Liong
	Wong

Language: Go
Paradigm(s): Imperative, Structured, Concurrent
***************
*/
package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"log"
	"math"
	"math/rand"
	"os"
	"sort"
	"strings"
	"time"
	"unicode"

	"github.com/fogleman/gg"
)

func search(Unique []string, s string) int {
	for i := 0; i < len(Unique); i++ {
		if Unique[i] == s {
			return i
		}
	}
	return -1
}

func charSearch(Unique string, c rune) int {
	for i := 0; i < len(Unique); i++ {
		charAtI := rune(Unique[i])
		if charAtI == c {
			return i
		}
	}
	return -1
}

type mapped struct {
	s string
	v int
}

func isStopWord(word string, stopWords map[string]bool) bool {
	_, exists := stopWords[word]
	return exists
}

func lowercaseFirstChar(s string) string {
	if len(s) == 0 {
		return s
	}
	return string(unicode.ToLower(rune(s[0]))) + s[1:]
}

func main() {
	var count int
	var Unique []string
	var cUnique string
	var sortedPairs, csortedPairs []mapped
	nUnique := 0
	freqCount := make(map[string]int)
	freqChar := make(map[rune]int)
	stopWordCount := make(map[string]int)

	stopWords := map[string]bool{
		"a": true, "about": true, "above": true, "after": true, "again": true, "against": true,
		"all": true, "am": true, "an": true, "and": true, "any": true, "are": true, "aren't": true,
		"as": true, "at": true, "be": true, "because": true, "been": true, "before": true, "being": true,
		"below": true, "between": true, "both": true, "but": true, "by": true, "can't": true, "cannot": true,
		"could": true, "couldn't": true, "did": true, "didn't": true, "do": true, "does": true, "doesn't": true,
		"doing": true, "don't": true, "down": true, "during": true, "each": true, "few": true, "for": true,
		"from": true, "further": true, "had": true, "hadn't": true, "has": true, "hasn't": true, "have": true,
		"haven't": true, "having": true, "he": true, "he'd": true, "he'll": true, "he's": true, "her": true,
		"here": true, "here's": true, "hers": true, "herself": true, "him": true, "himself": true, "his": true,
		"how": true, "how's": true, "i": true, "i'd": true, "i'll": true, "i'm": true, "i've": true, "if": true,
		"in": true, "into": true, "is": true, "isn't": true, "it": true, "it's": true, "its": true, "itself": true,
		"let's": true, "me": true, "more": true, "most": true, "mustn't": true, "my": true, "myself": true,
		"no": true, "nor": true, "not": true, "of": true, "off": true, "on": true, "once": true, "only": true,
		"or": true, "other": true, "ought": true, "our": true, "ours": true, "ourselves": true, "out": true,
		"over": true, "own": true, "same": true, "she": true, "she'd": true, "she'll": true, "she's": true,
		"should": true, "shouldn't": true, "so": true, "some": true, "such": true, "than": true, "that": true,
		"that's": true, "the": true, "their": true, "theirs": true, "them": true, "themselves": true, "then": true,
		"there": true, "there's": true, "these": true, "they": true, "they'd": true, "they'll": true, "they're": true,
		"they've": true, "this": true, "those": true, "through": true, "to": true, "too": true, "under": true,
		"until": true, "up": true, "very": true, "was": true, "wasn't": true, "we": true, "we'd": true, "we'll": true,
		"we're": true, "we've": true, "were": true, "weren't": true, "what": true, "what's": true, "when": true,
		"when's": true, "where": true, "where's": true, "which": true, "while": true, "who": true, "who's": true,
		"whom": true, "why": true, "why's": true, "with": true, "won't": true, "would": true, "wouldn't": true,
		"you": true, "you'd": true, "you'll": true, "you're": true, "you've": true, "your": true, "yours": true,
		"yourself": true, "yourselves": true,
	}

	file, err := os.Open("fake_tweets.csv")
	if err != nil {
		log.Fatal("Error while opening the file:", err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	if _, err := reader.Read(); err != nil {
		if err != io.EOF {
			log.Fatal("Error while skipping the header row:", err)
		}
		// If it's EOF, there's no data to process
		return
	}

	for {
		record, err := reader.Read()
		if err != nil {
			if err == io.EOF {
				break
			}
			log.Fatal("Error while reading the CSV file:", err)
		}
		for i := range record {
			split := strings.Split(record[i], " ")
			if i%5 == 3 {
				for j := range split {
					word := strings.ToLower(split[j])
					word = lowercaseFirstChar(word) //makes sure all is lowercase
					count++
					if isStopWord(word, stopWords) {
						stopWordCount[word]++
					} else {
						if search(Unique, word) == -1 {
							Unique = append(Unique, word)
							nUnique++
							freqCount[word] = 1
						} else {
							freqCount[word]++
						}
					}

					charsplit := []rune(word)
					for _, char := range charsplit {
						if charSearch(cUnique, char) == -1 {
							cUnique += string(char)
							freqChar[char] = 1
						} else {
							freqChar[char]++
						}
					}
				}
			}
		}
	}

	// Output the word count
	fmt.Println("Word Count:", count)
	fmt.Println("Vocabulary size:", nUnique)
	fmt.Println("Word Frequency:")

	for word, freq := range freqCount {
		sortedPairs = append(sortedPairs, mapped{word, freq})
	}
	sort.Slice(sortedPairs, func(i, j int) bool {
		return sortedPairs[i].v > sortedPairs[j].v
	})
	for _, pair := range sortedPairs {
		fmt.Printf("%s: %d\n", pair.s, pair.v)
	}

	fmt.Println("Character Frequency:")
	for ch, frequency := range freqChar {
		csortedPairs = append(csortedPairs, mapped{string(ch), frequency})
	}
	sort.Slice(csortedPairs, func(i, j int) bool {
		return csortedPairs[i].v > csortedPairs[j].v
	})
	for _, pairs := range csortedPairs {
		fmt.Printf("%s: %d\n", pairs.s, pairs.v)
	}

	fmt.Println("Frequency Analysis (Top 20 Words):")
	for i, pair := range sortedPairs {
		if i >= 20 {
			break
		}
		fmt.Printf("%d. %s: %d\n", i+1, pair.s, pair.v)
	}

	var stopWordPairs []mapped
	for word, freq := range stopWordCount {
		stopWordPairs = append(stopWordPairs, mapped{word, freq})
	}
	sort.Slice(stopWordPairs, func(i, j int) bool {
		return stopWordPairs[i].v > stopWordPairs[j].v
	})
	fmt.Println("Top 10 Most Frequent Stop Words:")
	for i, pair := range stopWordPairs {
		if i >= 10 {
			break
		}
		fmt.Printf("%d. %s: %d\n", i+1, pair.s, pair.v)
	}

	// Generate Word Cloud
	generateWordCloud(freqCount, "wordcloud.png")
	fmt.Println("Word cloud generated as 'wordcloud.png'")
	generateMonthlyPostsBarChart("fake_tweets.csv", "monthly_posts_barchart.png")
	generateSymbolDistributionPieChart(freqChar, "symbol_distribution.png")
}

// Function to generate the word cloud image
func generateWordCloud(wordFreq map[string]int, outputPath string) {
	const width = 1024
	const height = 768

	// Sort words by frequency and keep only the top 20
	var sortedPairs []mapped
	for word, freq := range wordFreq {
		sortedPairs = append(sortedPairs, mapped{word, freq})
	}
	sort.Slice(sortedPairs, func(i, j int) bool {
		return sortedPairs[i].v > sortedPairs[j].v
	})

	// Create a map for the top 20 words
	topWords := make(map[string]int)
	for i, pair := range sortedPairs {
		if i >= 20 {
			break
		}
		topWords[pair.s] = pair.v
	}

	// Initialize canvas
	dc := gg.NewContext(width, height)
	dc.SetRGB(1, 1, 1) // White background
	dc.Clear()

	// Randomly position words in the word cloud
	rand.Seed(time.Now().UnixNano())
	for word, freq := range topWords {
		fontSize := 12 + float64(freq)*1.5
		if fontSize > 72 {
			fontSize = 72
		}

		err := dc.LoadFontFace("C:/Windows/Fonts/arial.ttf", fontSize)
		if err != nil {
			fmt.Println("Error loading font:", err)
			return
		}

		x := rand.Float64() * width
		y := rand.Float64() * height

		r := rand.Float64()
		g := rand.Float64()
		b := rand.Float64()
		dc.SetRGB(r, g, b)

		dc.DrawStringAnchored(word, x, y, 0.5, 0.5)
	}

	dc.SavePNG(outputPath)
}

func generateMonthlyPostsBarChart(csvFile string, outputPath string) {
	// Open the CSV file
	file, err := os.Open(csvFile)
	if err != nil {
		log.Fatal("Error while opening the file:", err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	reader.FieldsPerRecord = -1 // allow variable number of fields

	// Map to store post counts by month-year
	monthlyCounts := make(map[string]int)

	// Skip the header row
	if _, err := reader.Read(); err != nil {
		log.Fatal("Error while reading the header:", err)
	}

	// Parse each record to count posts per month
	for {
		record, err := reader.Read()
		if err != nil {
			if err == io.EOF {
				break
			}
			log.Fatal("Error while reading CSV:", err)
		}

		// Access the date in the third column (index 2)
		dateStr := record[2]

		// Parse date while ignoring time part
		date, err := time.Parse("2006-01-02", dateStr[:10])
		if err != nil {
			continue
		}

		// Format as "January 2023" for monthly aggregation
		monthKey := date.Format("Jan 06")
		monthlyCounts[monthKey]++
	}

	// Sort the keys (months) for plotting
	var months []string
	for month := range monthlyCounts {
		months = append(months, month)
	}
	sort.Strings(months)

	// Set up the canvas for the bar chart
	const width = 1000
	const height = 600
	const margin = 50
	const barWidth = 20

	dc := gg.NewContext(width, height)
	dc.SetRGB(1, 1, 1)
	dc.Clear()

	// Find the maximum count for scaling the bars
	var maxCount int
	for _, month := range months {
		if monthlyCounts[month] > maxCount {
			maxCount = monthlyCounts[month]
		}
	}

	// Set up scaling factors for the bar chart
	scaleX := float64(width-2*margin) / float64(len(months))
	scaleY := float64(height-2*margin) / float64(maxCount)

	// Draw bars for each month
	dc.SetRGB(0.2, 0.6, 0.8) // Bar color
	for i, month := range months {
		x := margin + float64(i)*scaleX
		y := height - margin - float64(monthlyCounts[month])*scaleY
		dc.DrawRectangle(x, y, barWidth, float64(monthlyCounts[month])*scaleY)
		dc.Fill()
	}

	// Draw labels for each month
	dc.SetRGB(0, 0, 0)
	err = dc.LoadFontFace("C:/Windows/Fonts/arial.ttf", 12)
	if err != nil {
		fmt.Println("Error loading font:", err)
		return
	}
	for i, month := range months {
		x := margin + float64(i)*scaleX
		dc.DrawStringAnchored(month, x+barWidth/2, height-margin+10, 0.5, 1)
	}

	// Add title and axis labels
	dc.DrawStringAnchored("Monthly Post Counts", width/2, margin/2, 0.5, 0.5)

	// Save the bar chart
	dc.SavePNG(outputPath)
	fmt.Println("Monthly posts bar chart generated:", outputPath)
}

func generateSymbolDistributionPieChart(freqChar map[rune]int, outputPath string) {
	const width = 800
	const height = 800
	const margin = 50
	const radius = float64((width - 2*margin) / 2)

	dc := gg.NewContext(width, height)
	dc.SetRGB(1, 1, 1) // White background
	dc.Clear()

	// Calculate the total frequency for symbols only (excluding letters and digits)
	var totalFrequency int
	for symbol, freq := range freqChar {
		if unicode.IsLetter(symbol) || unicode.IsDigit(symbol) {
			continue
		}
		totalFrequency += freq
	}

	// Define color palette for the slices
	colors := []struct{ r, g, b float64 }{
		{0.8, 0.2, 0.2}, {0.2, 0.8, 0.2}, {0.2, 0.2, 0.8},
		{0.8, 0.8, 0.2}, {0.8, 0.2, 0.8}, {0.2, 0.8, 0.8},
		{0.6, 0.6, 0.2}, {0.2, 0.6, 0.6}, {0.6, 0.2, 0.6},
	}

	// To track previous label positions for overlap checking
	labelPositions := []struct{ x, y float64 }{}

	// Start drawing the pie slices from the top
	angle := 0.0
	colorIndex := 0

	for symbol, freq := range freqChar {
		// Skip letters and digits
		if unicode.IsLetter(symbol) || unicode.IsDigit(symbol) {
			continue
		}

		// Calculate the slice angle for this symbol
		percentage := float64(freq) / float64(totalFrequency)
		sliceAngle := percentage * 2 * math.Pi

		// Set color for the slice
		color := colors[colorIndex%len(colors)]
		dc.SetRGB(color.r, color.g, color.b)
		colorIndex++

		// Draw pie slice
		dc.MoveTo(width/2, height/2)
		for a := angle; a < angle+sliceAngle; a += 0.01 {
			x := width/2 + radius*math.Cos(a)
			y := height/2 + radius*math.Sin(a)
			dc.LineTo(x, y)
		}
		dc.ClosePath()
		dc.Fill()

		// Calculate initial label position for this slice
		labelAngle := angle + sliceAngle/2
		labelRadius := radius + 20
		labelX := width/2 + labelRadius*math.Cos(labelAngle)
		labelY := height/2 + labelRadius*math.Sin(labelAngle)

		// Adjust label position if it overlaps with previous labels
		for {
			overlap := false
			for _, pos := range labelPositions {
				dist := math.Hypot(labelX-pos.x, labelY-pos.y)
				if dist < 20 { // Minimum distance to avoid overlap
					overlap = true
					labelRadius += 10 // Push label outward if overlap detected
					labelX = width/2 + labelRadius*math.Cos(labelAngle)
					labelY = height/2 + labelRadius*math.Sin(labelAngle)
					break
				}
			}
			if !overlap {
				break
			}
		}

		// Store the final label position to prevent future overlaps
		labelPositions = append(labelPositions, struct{ x, y float64 }{labelX, labelY})

		// Draw label with symbol and percentage
		label := fmt.Sprintf("%q: %.1f%%", symbol, percentage*100)
		dc.SetRGB(0, 0, 0)                                       // Black text
		err := dc.LoadFontFace("C:/Windows/Fonts/Arial.ttf", 12) //path to your font
		if err != nil {
			fmt.Println("Error loading font:", err)
			return
		}
		dc.DrawStringAnchored(label, labelX, labelY, 0.5, 0.5)

		// Move to the next slice angle
		angle += sliceAngle
	}

	// Save the pie chart
	dc.SavePNG(outputPath)
	fmt.Println("Symbol distribution pie chart generated:", outputPath)
}
