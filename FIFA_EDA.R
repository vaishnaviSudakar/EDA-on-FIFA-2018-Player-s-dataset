library(ggplot2)
library(dplyr)
library(gridExtra)

#read
df = read.csv(file = "C:/Users/HP/OneDrive/Desktop/BDA/Sem_2/Adv_Stats/Project/fifa2018.csv", stringsAsFactors = FALSE)



df

df = tbl_df(df)
df <- select(df, ID, X, Name, Age, Nationality, Overall, Club, Value, Wage, Preferred.Positions)


head(df, 10)


#To convert the Value and the Wage columns to actual currency values
# Error ----
toNumberCurrency <- function(vector) {
  vector <- as.character(vector)
  vector <- gsub("(???|,)","", vector)
  result <- as.numeric(vector)
  
  k_positions <- grep("K", vector)
  result[k_positions] <- as.numeric(gsub("K","",vector[k_positions])) * 1000
  
  m_positions <- grep("M", vector)
  result[m_positions] <- as.numeric(gsub("M","",vector[m_positions])) * 1000000
  
  return(result)
}
df$Wage <- toNumberCurrency(df$Wage) 


df$Value <- toNumberCurrency(df$Value)

df
#-------

#positions
df$Preferred.Positions <- gsub(" ", "", substr(df$Preferred.Positions, 1, 3))

x <- as.factor(df$Preferred.Positions)
levels(x) <- list(GK  = c("GK"), 
                  DEF = c("LWB", "LB", "CB", "RB", "RWB"), 
                  MID = c("LW","LM","CDM","CM","CAM","RM","RW"), 
                  FWD = c("CF", "ST"))
df <- mutate(df, Position = x)
head(df)


#distribution of players based on the age. We see that there is a high number of players around 25 years of age.
g_age <- ggplot(data = df, aes(Age))
g_age + 
  geom_histogram(col="orange", aes(fill = ..count..)) + ggtitle("Distribution based on Age")

#relation between the Age of the players and their general playing position.
g_age + 
  geom_density(col="orange", aes(fill = Position), alpha=0.5) + facet_grid(.~Position) + 
  ggtitle("Distribution based on Age and Position")

#Distribution of players based on their overall rating. We see that the majority number of players have an overall rating of around 65
g_overall <- ggplot(data = df, aes(Overall))
g_overall + 
  geom_histogram(col="orange", aes(fill = ..count..)) + ggtitle("Distribution based on Overall Rating")

# Number of players from different (top 10) countries
countries_count <- count(df, Nationality)
top_10_countries <- top_n(countries_count, 10, n)
top_10_country_names <- top_10_countries$Nationality

country <- filter(df, Nationality == top_10_country_names)
ggplot(country, aes(x = Nationality)) + 
  geom_bar(col = "orange", aes(fill = ..count..)) + ggtitle("Distribution based on Nationality of Players (Top 10 Countries)")

#obtain the top 1 % count of the player Value and Wage 
#A large number of players earn a weekly wage of ???100000

top_1_percent_wage   <- quantile(df$Wage, probs=0.99)
filtered_wage <- filter(df, Wage > top_1_percent_wage)

g_value <- ggplot(filtered_wage, aes(Wage))
g_value + 
  geom_histogram(aes(fill=..count..)) + 
  ggtitle("Distribution of top 1% value")

# Create wage brackets
wage_breaks <- c(0, 100000, 200000, 300000, 400000, 500000, Inf)
wage_labels <- c("0-100k", "100k-200k", "200k-300k", "300k-400k", "400k-500k", "500k+")
wage_brackets <- cut(x=df$Wage, breaks=wage_breaks, 
                     labels=wage_labels, include.lowest = TRUE)
df <- mutate(df, wage_brackets)
# Create value brackets

value_breaks <- c(0, 10000000, 20000000, 30000000, 40000000, 50000000, 60000000, 70000000, 80000000, 90000000, 100000000, Inf)
value_labels <- c("0-10M", "10-20M", "20-30M", "30-40M", "40-50M","50-60M", "60-70M", "70-80M", "80-90M","90-100M","100M+")
value_brackets <- cut(x=df$Value, breaks=value_breaks, 
                      labels=value_labels, include.lowest = TRUE)
df <-mutate(df, value_brackets)
head(df)

#____
#A very large number of players have wages which lie between 0-100k and valuation between 0-50M 
not0To100K <- filter(df, wage_brackets != "0-100k") 
ggplot(not0To100K, aes(x = wage_brackets)) + 
  geom_bar(aes(fill = ..count..)) + 
  ggtitle("Distribution of top Wage between 100K-500K+")

moreThan50M <- filter(df, Value>50000000)
ggplot(moreThan50M, aes(x = value_brackets)) + 
  geom_bar(aes(fill = ..count..)) + 
  ggtitle("Distribution of value between 50M-100M+")
#________

#Age vs Overall of players divided amongst wage brackets. The highest wages are commanded by players of overall 85+ and age around 30 years.
g_age_overall <- ggplot(df, aes(Age, Overall))
g_age_overall + 
  geom_point(aes(color=wage_brackets)) + geom_smooth(color="darkblue") + 
  ggtitle("Distribution between Age and Overall of players based  on Wage bracket")

#The player valuation of Age vs Overall graph follows pretty much the same trend as above.
g_age_overall <- ggplot(df, aes(Age, Overall))
g_age_overall + geom_point(aes(color=value_brackets)) + geom_smooth(color="darkblue") + 
  ggtitle("Distribution between Age and Overall of players based on Value bracket")


#Number of players as per their general playing positions. Number of midfielders is the highest followed by defenders, forwards, and finally goalkeepers.
ggplot(df, aes(Position)) + 
  geom_bar(aes(fill = ..count..)) + 
  ggtitle("Distribution based on General Playing Position")

#Number of players as per their preferred playing positions. 
#Based on the above graph, we'd expect some specific midfielder position 
#to have the highest count, but here number of center-backs is the 
#highest followed by the number of strikers.
ggplot(df, aes(Preferred.Positions)) + geom_bar(aes(fill=..count..)) + 
  ggtitle("Distribution of players based on preferred position")



#how much are the players paid as wages and their valuation based on their preferred positions.
gf1 <- filter(df, Value<30000000)
g1 <- ggplot(gf1, aes(Preferred.Positions)) + geom_bar(aes(fill=value_brackets)) + 
  ggtitle("Position based on Value (0-50M)")
gf2 <- filter(df,Value>30000000)
g2 <- ggplot(gf2, aes(Preferred.Positions)) + geom_bar(aes(fill=value_brackets)) + 
  ggtitle("Position based on Value (50M +)")
grid.arrange(g1, g2, ncol=1)

#The top ten valuable clubs. The club value is calculated by summing up the player valuation for each club
group_clubs <- group_by(df, Club)
club_value <- summarise(group_clubs, total_val = sum(Value))
top_10_valuable_clubs <- top_n(club_value, 10, total_val)

top_10_valuable_clubs$Club <-as.factor(top_10_valuable_clubs$Club)

ggplot(top_10_valuable_clubs, aes(x = Club, y = total_val)) + geom_bar(stat = "identity", aes(fill=total_val)) + coord_flip() + ggtitle("Top 10 valuable clubs")

