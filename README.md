# EDA-on-FIFA-2018-Player-s-dataset

To analyze the player’s dataset from Kaggle and form a team using the various attributes given in the dataset. 

#### Key insights from EDA
1.	We grouped players by their age and found that most of the player’s are between the age group of 20-26 years. The players aged 25 years are highest in number.
2.	The plot for overall potential of the players is normally distributed and has its peak at the overall potential of 66. 
3.	The highest number of players are from England followed by Germany, France and Spain.
4.	Most of the player’s wage are in the range of 100K – 200K euros. The wage is seen to increase based on the overall potential and their playing position.
5.	Taking overall and age into consideration, we see the highest pay is commanded by player’s whose overall potential is 85 plus and age 30 plus

#### Correlation
With given 4 numerical variables we found the correlation matrix and found that
1.	There is exist a strong correlation between Wage and overall r = 0.59
2.	Correlation between age and overall r = 0.459
3.	There is weak negative correlation between Value and Age r = -0.067
We conducted the Pearson Correlation for Age and Overall and found that correlation exists but the plot for the same shows that there is no linear correlation
We conducted the same test for Wage and Overall which shows that there exists correlation but not Linear. The wage increases exponentially with the increase in Overall potential.

#### Chi – Squared Test
Chi Squared test was performed to find the independence of variables.
The test was performed by calculating the frequency for preferred position based on the age brackets. 
The Chi – Squared test gave a p-value lesser than 0.05, thus we neglect the null hypothesis that the variables age and position are independent.
The variables position and age are dependent.

Done by
Franklin, Jaswanth, Vaishnavi Sudakar

