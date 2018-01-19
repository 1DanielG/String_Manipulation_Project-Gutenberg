library(tidyverse)
library(rebus)
library(stringr)
library(stringi)

# data import
earnest <- stri_read_lines("importance_of_being_earnest.txt")

# Find the lines that end the foreword and start of afterword 
# by detecting the patterns "START OF THE PROJECT" and "END OF THE PROJECT"
start <- which(str_detect(earnest, fixed("START OF THE PROJECT")))
end <- which(str_detect(earnest, fixed("END OF THE PROJECT")))

# Get rid of gutenberg intro text
earnest_sub  <- earnest[(start + 1) :(end - 1)]

# Detect the line that starts the first act by looking for the pattern "FIRST ACT".
lines_start <- which(str_detect(earnest_sub, fixed("FIRST ACT")))

# Set up index
intro_line_index <- 1:(lines_start - 1)

# Split play into intro and play
intro_text <- earnest_sub[intro_line_index]
book_text <-  earnest_sub[-intro_line_index]

# Take a look at the first 20 lines 
writeLines(book_text[1:20])

# Get rid of empty strings
empty <- stri_isempty(book_text)
book_lines <- book_text[!empty]
book_lines[10:15]

# Create vector of characters
characters <- c("Algernon", "Jack", "Lane", "Cecily", "Gwendolen", "Chasuble", 
                "Merriman", "Lady Bracknell", "Miss Prism")

# Match start, then character name, then .
pattern_chr <- START %R% or1(characters) %R% DOT

# Pull out the lines that match with
lines <- str_subset(book_lines, pattern_chr)

# Extract match from lines
players <- str_extract(lines, pattern_chr)

# See unique players
unique(players)

# Count lines per character
table(players)

# visualization
cast <- as.data.frame(table(players))

ggplot(cast, aes(x=players, y=Freq)) +
  geom_bar(stat="identity", fill="steelblue")+
  labs(y  = "Lines per character", x ="Character names")+
  coord_flip()+
  geom_text(aes(label=Freq), vjust=0.3, size=3.5)+
  theme_minimal()