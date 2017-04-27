setwd('~/Documents/spicer-100days/data')
library(ggplot2)
library(reshape2)
library(infotheo)
library(dplyr)
source('readtranscripts.R')
source('readfiles.R')

## === get complete emotion frames only ==== 

summary(data)
s <- data[complete.cases(data),]
corr <- cor(s[,2:9])
#plot(s[,2:9])

### ==== mutual information === ###
mi <- mutinformation(discretize(s[,2:9]))

###=====  Correlation plot/ Mutual information plot =====###

reorder_cormat <- function(cormat){
  # Use correlation between variables as distance
  dd <- as.dist((1-cormat)/2)
  hc <- hclust(dd)
  cormat <-cormat[hc$order, hc$order]
}
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}

# use (corr) for correlation plot; use (mi) for mutual information plot
corr <- reorder_cormat(corr)
upper_tri <- get_upper_tri(corr)
corr_melted <- melt(upper_tri, na.rm = TRUE)

ggplot(data = corr_melted, aes(x=Var1, y=Var2, fill=value)) + 
  # scale_fill_gradient2(low = "blue", high = "red", mid = "white", limit = c(0,1))+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, 
                       limit = c(-1,1), space = "Lab",name="Pearson\nCorrelation")+
  geom_tile(color="white")+
  theme_minimal()+
  ggtitle('Mutual information between emotions')+
  theme(axis.text.x = element_text(angle = 90, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed()


## ===== data cleaning ===== ##

# delete guest gaps from -s
for (i in 1:nrow(gaps)){
  s[(s$frame_time>= gaps$gap_start[i] & s$frame_time<= gaps$gap_end[i] & s$date == gaps$date[i]),2:9] <- NA
}
s <- s[complete.cases(s),]

# ? maybe you want to break down by preQA and QA
qa <- read.csv('gaps.csv', header=T, stringsAsFactors = F)
s$qa <- F
for (i in 1:nrow(qa)) {
  s[s$date == qa$date[i] & s$frame_time > qa$qa_start[i], ]$qa = T
}

## ===== Group frames by minute ===== ##

s_by_minute <- s %>% 
  # insert qa filter here
  # filter(qa ==F) %>%
  group_by(date, minute = ceiling((frame_time+0.001)/60)) %>%
  summarise(
    neutral = mean(sean_neutral, na.rm=T),
    angry = mean(sean_anger, na.rm=T),
    surprise = mean(sean_surprise, na.rm=T),
    sadness = mean(sean_sadness, na.rm=T),
    happiness = mean(sean_happiness, na.rm=T),
    disgust = mean(sean_disgust, na.rm=T),
    comtempt = mean(sean_contempt, na.rm=T)
  )

## === combine emotions with transcript === ##

s_bymin_melt <- melt(s_by_minute, id=c('minute', 'date'))
s_bymin_melt$formatted_date <- as.Date(s_bymin_melt$date, "%m_%d_%y")
s_bymin_melt <- merge(s_bymin_melt, trans_by_minute, by=c('date','minute'), all.x=T)


### === Get emotion plots === ###
top_10 = 1-(20/nrow(s_by_minute))
chuncks = round(nrow(s_by_minute)/20)

s_bymin_melt$top_angry <- ifelse(s_bymin_melt$variable == 'angry' & s_bymin_melt$value >= as.numeric(quantile(filter(s_bymin_melt, variable=='angry')$value, top_10)), T, F)
s_bymin_melt$top_sadness <- ifelse(s_bymin_melt$variable == 'sadness' & s_bymin_melt$value >= as.numeric(quantile(filter(s_bymin_melt, variable=='sadness')$value, top_10)), T, F)
s_bymin_melt$top_surprise <- ifelse(s_bymin_melt$variable == 'surprise' & s_bymin_melt$value >= as.numeric(quantile(filter(s_bymin_melt, variable=='surprise')$value, top_10)), T, F)
s_bymin_melt$top_happiness <- ifelse(s_bymin_melt$variable == 'happiness' & s_bymin_melt$value >= as.numeric(quantile(filter(s_bymin_melt, variable=='happiness')$value, top_10)), T, F)
s_bymin_melt$top_disgust <- ifelse(s_bymin_melt$variable == 'disgust' & s_bymin_melt$value >= as.numeric(quantile(filter(s_bymin_melt, variable=='disgust')$value, top_10)), T, F)

tops <- s_bymin_melt %>% 
  filter(top_angry == T | top_sadness==T | top_surprise==T | top_happiness==T | top_disgust==T)
write.csv(tops, 'top_emotions/top20s.csv', row.names=F)


# plot emotions
plotBubbles <- function(emotion) {
  colorVar = paste('top',emotion,sep="_")
  dt = filter(s_bymin_melt, variable==emotion)
  qtile = ecdf(quantile(dt$value, seq(0,1, length=chuncks)))

  # line chart, small multiples
  p1 <-
    ggplot(dt)+
    geom_line(aes(x=minute, y=value), alpha=0.5)+
    geom_point(aes(x=minute, y=value), alpha=1)+
    theme_minimal()+
    facet_wrap(~formatted_date, ncol=3)+
    ggtitle(paste('Moments when Spicer is', emotion, sep=' '))
  
  ggsave(paste(c('top_emotions/plots_lines/plot_',emotion,'.pdf'),collapse=''), p1, width=15, height=10)
  
  # # tile chart
  # ggplot(dt)+
  #   geom_tile(aes(x=as.factor(formatted_date), y=minute, fill=qtile(value)**2))+
  #   scale_fill_continuous(low='#ffffff', high='red')+
  #   theme_minimal()
  
  # # bubble chart
  #   ggplot(dt)+
  #   geom_point(aes(x=as.factor(formatted_date), y=minute, size=qtile(value)**2, color= get(colorVar)), alpha=0.5)+
  #   scale_color_manual(values=c('#999999','red'))+
  #   scale_radius(range=c(0,4))+
  #   coord_flip()+
  #   theme_minimal()+
  #   theme(axis.text.x = element_text(angle = 90, vjust = 1, 
  #                                    size = 10, hjust = 1))+
  #   ggtitle(paste('Moments when Spicer is', emotion, sep=' '))
  
}

plotBubbles('angry')
plotBubbles('happiness')
plotBubbles('sadness')
plotBubbles('disgust')
plotBubbles('surprise')



#### ===== code not used down ===== ##### 

#hist(scale(filter(s_bymin_melt, variable=='emotion')$value))
# sd(scale(filter(s_bymin_melt, variable=='neutral')$value))


s1_bymin_stream <- s1_bymin_melt %>% filter(variable!='neutral') %>%
  group_by(minute) %>%
  mutate(pct = value/sum(value))

ggplot(s1_bymin_melt)+
  geom_bar(aes(x=minute, y = value, fill=variable), stat='identity')+
  ggtitle('Jan 23 - March 31, emotion by minute')+
  facet_wrap(~variable, scales='free', ncol=1)+
  theme_minimal()

ggplot(s1_bymin_stream)+
  geom_bar(aes(x=minute, y = pct, fill=variable), stat='identity')+
  ggtitle('Jan 23, emotion by minute')+
  theme_minimal()



##### ======== get primary emotions ======= #####

s_melt <- melt(s, id=c('frame_time', 'date', 'qa'))
s_melt$value <- as.numeric(s_melt$value)
s_melt <- s_melt[complete.cases(s_melt),]
head(s_melt)

s_primary <- s_melt %>%
  filter(variable != 'sean_neutral') %>%
  group_by(frame_time, date, qa) %>%
  top_n(1, value) %>%
  arrange(date, frame_time)

s_primary$formatted_date <- as.Date(s_primary$date, "%m_%d_%y")

ggplot(s_primary)+
  geom_tile(aes(x=as.factor(formatted_date), y=frame_time, fill=variable))+
  scale_fill_manual(values=c('brown1','brown2','brown','yellow','skyblue','orange'))+
  theme_minimal()
  

s_primary_bymin <- s_bymin_melt %>%
  filter(variable != 'neutral') %>%
  group_by(date, minute, formatted_date) %>%
  top_n(1, value) %>%
  arrange(formatted_date, minute)

ggplot(s_primary_bymin)+
  geom_tile(aes(x=as.factor(formatted_date), y=minute, fill=variable))+
  scale_fill_manual(values=c('brown1','orange','skyblue','yellow'))+
  theme_minimal()


