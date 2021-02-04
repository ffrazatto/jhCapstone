library(dplyr)
library(tidyr)


pF <- readRDS("./predFile.rds")

cleanText <- function(text) {
  
  newText <- text %>% 
    tolower() %>% 
    gsub(pattern = "[[:punct:]]", replacement =  " ") %>% 
    gsub(pattern = "[0-9]", replacement = " ") %>% 
    gsub(pattern = "\\b(?=\\w*(\\w){3}\\1)\\w+\\b", replacement = " ", perl = TRUE) %>%
    gsub(pattern = " +", replacement = " ")
  
  return(newText)
  
}


prep <- function(input.Str){
  
  # Initialize vector. Used for the string splititng into a word data frame
  words <- c()
  
  # Cleans String
  cleanStr <- cleanText(input.Str)
  
  # Counts number of words
  wordCount <- length(strsplit(cleanStr, " ")[[1]])
  
  # Populate words vector
  for(i in 1:wordCount){
    
    # Builds names following the format: "w" + i, where i = 1, 2, ..., n
    words <- c(words, 
               paste("w", i, sep = ""))
    
  }
  
  
  # Separates the cleaned input string into a word data frame
  strEval <- separate(data.frame(str = cleanStr), 
                      str, 
                      sep = " ", 
                      into = words)
  
  return(strEval)
  
}


ngramFilter <- function(strEval, ngram){
  
  # Filters initial pF dataframe by the wanted ngram
  subSet <- filter(pF, n == ngram) 
  
  # Calculates the input string size
  inputSize <- dim(strEval)[2]
  
  # Sequential filtering, word by word
  for(j in 1:(ngram - 1)){
    
    subSet <- subSet %>% 
      filter(.[,j] == strEval[, inputSize - ngram + j + 1])
    
  }
  
  # Calculates the probability for each sequence to occur
  subSet$prob <- subSet$freq/sum(subSet$freq)   
  
  return(subSet)
  
}

# Prediction

## pred


pred <- function(input.Str){
  
  # Prepares input string
  strEval <- prep(input.Str)
  
  # Load inital data set
  subSet <- pF
  
  # Finds the longest ngram in the data set
  ngramLim <- max(subSet$n)
  
  # Looks for a possible output prediction. Begins from the longest ngram 
  # available to the shortest one (bigram). The loop will quit as soon as 
  # a valid sequence is found.
  for(i in ngramLim:2){
    
    subSet <- ngramFilter(strEval, ngram = i)
    
    if(dim(subSet)[1] != 0)
    {
      break
    }
    
  }
  
  # If a sequence is found, suggest the word with highest probability (first
  # printed word) and picks randomly a second word, following the Mass
  # Probability Distribution calculated for the sequence.
  if(dim(subSet)[1] != 0){
    
    samples <- 0 
    randProb <- c()
    
    if(dim(subSet)[1] > 1){
      
      randProb <- sample(subSet[,max(subSet$n)], 2, prob = subSet$prob)
      
    }
    
    else{
      randProb <- c(".","")
    }
    
    maxProb <- subSet[which.max(subSet$prob), max(subSet$n)]
    
    
    output <- c(maxProb, randProb)
    
  }
  
  # If no valid sequence is found, suggests a period.
  else{output <- "."}
  
  return(output)
  
}