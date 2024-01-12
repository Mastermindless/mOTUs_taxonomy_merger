# Load required libraries
library(dplyr)
library(readr)

# Function to read and process a file
read_process_file <- function(file) {
  # Read the file, skipping the first two rows and not treating the first row as header
  data <- read_tsv(file, col_names = FALSE, skip = 2) 
  
  # Set the first row of the data as column names
  colnames(data) <- data[1, ]
  
  # Remove the first row from the data as it's now the header
  data <- data[-1, ] 
  
  return(data)
}

# Set the working directory (commented out for GitHub, should be set in the user environment)
# setwd("path/to/your/directory")

# List all .motus files in the current directory
file_list <- list.files(pattern="\\.motus$")

# Read and process each file, storing the results in a list of data frames
df_list <- lapply(file_list, read_process_file)

# Merge all data frames by the column '#consensus_taxonomy'
merged_df <- Reduce(function(x, y) merge(x, y, by = "#consensus_taxonomy", all = TRUE), df_list)

# Rename columns to include file names for clarity
colnames(merged_df) <- c("#consensus_taxonomy", file_list)

# Preview the merged data frame (useful for debugging)
head(merged_df)

# Write the merged data frame to a .csv file
write_csv(merged_df, "FileName_cons_tax_merged.csv")


# keep track of versions
sessionInfo()
writeLines(capture.output(sessionInfo()), "sessionInfo.txt")

# END