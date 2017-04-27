init_file = '~/Documents/github/100_days_of_spice/csv/1_23_17_EMOTIONS.csv'
files = c('~/Documents/github/100_days_of_spice/csv/1_24_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/1_25_17_EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/1_30_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/1_31_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_1_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_2_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_3_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_7_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_8_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_9_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_14_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_21_17_EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_22_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_23_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/2_27_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_7_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_8_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_9_17_EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_10_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_13_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_14_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_16_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_20_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_21_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_22_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_23_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_24_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_27_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_28_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_29_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_30_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/3_31_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/4_3_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/4_10_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/4_11_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/4_13_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/4_17_17-EMOTIONS.csv',
          '~/Documents/github/100_days_of_spice/csv/4_24_17-EMOTIONS.csv'
)


data <- read.csv(init_file, header=T, stringsAsFactors = F)
colnames <- colnames(data)
for (file in files){
  newd = read.csv(file, header=T, stringsAsFactors = F)
  if (file == '~/Documents/github/100_days_of_spice/csv/3_28_17-EMOTIONS.csv') {
    newd$date = '3_28_17'
  }
  if (file == '~/Documents/github/100_days_of_spice/csv/4_11_17-EMOTIONS.csv') {
    newd$date = '4_11_17'
  }
  colnames(newd) <- colnames
  if (file == '~/Documents/github/100_days_of_spice/csv/3_13_17-EMOTIONS.csv') {
    newd$date = '3_13_17'
  }
  if (file == '~/Documents/github/100_days_of_spice/csv/3_10_17-EMOTIONS.csv') {
    newd$date = '3_10_17'
  }
  data <- rbind(data, newd)
}

