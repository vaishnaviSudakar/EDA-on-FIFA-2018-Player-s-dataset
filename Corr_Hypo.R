df = read.csv(file = "C:/Users/HP/OneDrive/Desktop/BDA/Sem_2/Adv_Stats/Project/fifa2018.csv", stringsAsFactors = FALSE)
df

df = tbl_df(df)
df <- select(df, ID, X, Name, Age, Nationality, Overall, Club, Value, Wage, Preferred.Positions)

suppressWarnings(library(corrplot))
#positions
df$Preferred.Positions <- gsub(" ", "", substr(df$Preferred.Positions, 1, 3))

x <- as.factor(df$Preferred.Positions)
levels(x) <- list(GK  = c("GK"), 
                  DEF = c("LWB", "LB", "CB", "RB", "RWB"), 
                  MID = c("LW","LM","CDM","CM","CAM","RM","RW"), 
                  FWD = c("CF", "ST"))

df <- mutate(df, Position = x)
head(df)

#find Dtype
str(df)

d <- df[,-c(1,2,3,5,7,10,11)]
d

#Correlation
cor(d)
corrplot(d,title = "Correlation Plot ")
ggplot(data = d) +
  geom_point(mapping = aes(x = d$Age, y = d$Overall)) +
  geom_smooth(mapping = aes(x = d$Age, y = d$Overall))

Corr <- cor.test(d$Age, d$Overall, 
                 method = "pearson")
Corr

# there is no strong correlation between age and Overall of a player,the relationship is not Linear

#Overall vs Wage
ggplot(data = d) +
  geom_point(mapping = aes(x = d$Overall, y = d$Wage)) +
  geom_smooth(mapping = aes(x = d$Overall, y = d$Wage))

Corr <- cor.test(d$Wage, d$Overall, 
                 method = "pearson")

Corr

#----------------------
#Hypothesis Testing - 1 Sample test
#Statement
#Null Hypothesis - 
#Alternate Hypothesis - 

#----------------------
#Chi-Squared Test 
#using a single variable, chi squared test gives the distribution
prop.table((table(df$Position)))
chisq.test(x = table(df$Position), p = c(0.1128413,0.3025416,0.4465825,0.1380346))

#Finding frequency
table(df$Age)

#df %>% (Didnt work)
#  group_by(group = cut(df$Age, breaks = seq(0, max(age), 5))) %>%
#  summarise(n = n())

ag = df %>%
  
  mutate(
    Age = dplyr::case_when(
      Age < 20 ~ "15-20",
      Age >= 20 & Age < 25 ~ "20-25",
      Age >= 25 & Age < 30 ~ "25-30",
      Age >= 30 & Age < 35 ~ "30-35",
      Age >= 35 & Age < 40 ~ "35-40",
      Age >= 40 ~ "40+")
  )
ag

f <- table(df$Position)
f

c = table(ag$Age,df$Position)
c

g1 <- ggplot(ag, aes(Age)) + geom_bar(aes(fill=ag$Position))
g1

#Chi-Squared test
chisq.test(c)

#Here the p-Value is less than 0.05