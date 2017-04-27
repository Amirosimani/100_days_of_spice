### === read transcripts data === ###

init_transcript = '~/Documents/github/100_days_of_spice/transcripts/1_23-transcript.csv'
transcripts = c('~/Documents/github/100_days_of_spice/transcripts/1_24-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/1_25-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/1_30-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/1_31-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_1-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_2-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_3-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_7-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_8-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_9-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_14-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_21-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_22-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_23-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/2_27-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_7-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_8-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_9-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_10-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_13-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_14-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_16-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_20-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_21-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_22-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_23-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_24-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_27-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_28-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_29-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_30-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/3_31-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/4_3-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/4_10-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/4_11-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/4_13-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/4_17-transcript.csv',
                '~/Documents/github/100_days_of_spice/transcripts/4_24-transcript.csv'
)

trans <- read.csv(init_transcript, header=T, stringsAsFactors = F)
trans$date <- paste(unlist(strsplit(unlist(strsplit(init_transcript,'/'))[6],'-'))[1],'_17',sep='')
colnames <- colnames(trans)
for (file in transcripts){
  newd = read.csv(file, header=T, stringsAsFactors = F)
  newd$date = paste(unlist(strsplit(unlist(strsplit(file,'/'))[6],'-'))[1],'_17',sep='')
  # colnames(newd) <- colnames
  trans <- rbind(trans, newd)
}

trans <- trans %>% 
  filter(is.na(as.numeric(duration))==F) %>%
  mutate(duration = as.numeric(duration), end = start + duration)

# take out the frames when the guest were talking ##
gaps <- read.csv('gaps.csv', header=T, stringsAsFactors = F)
gaps <- gaps[complete.cases(gaps),]

for (i in 1:nrow(gaps)){
  trans[(trans$start >= gaps$gap_start[i] & trans$end <= gaps$gap_end[i] & trans$date == gaps$date[i]),]$text <- NA
}
trans <- trans[complete.cases(trans),]


trans_by_minute <- trans %>% 
  group_by(minute = ceiling((start+0.001)/60), date) %>%
  summarise(text = paste(text, collapse = " "))



