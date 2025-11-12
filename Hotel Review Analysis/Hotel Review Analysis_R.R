# Load the package
install.packages("tidyverse")
library(tidyverse)
install.packages("tidytext")
library(tidytext)

# Import data exported from Python
df <- readr::read_csv("C:/Users/pe225/Desktop/Work Samples/Hotel Review Analysis/hotel_reviews_for_tableau.csv")

# Check the data structure
glimpse(df)
summary(df$Reviewer_Score)
summary(df$sentiment_score)

# Average scores and mood of each passenger type
summary_table <- df %>%
  group_by(stay_purpose) %>%
  summarise(
    mean_score = mean(Reviewer_Score, na.rm = TRUE),
    mean_sentiment = mean(sentiment_score, na.rm = TRUE),
    sd_score = sd(Reviewer_Score, na.rm = TRUE),
    count = n()
  )

print(summary_table)

# One-way variance analysis (ANOVA)
anova_model <- aov(Reviewer_Score ~ stay_purpose, data = df)
summary(anova_model)

# Result interpretation:
# The ANOVA test shows a significant difference in reviewer scores across traveler types
# (F(4, 515,733) = 1666, p < 0.001), indicating that at least one group rated hotels differently.
# The null hypothesis is rejected.


# Post-hoc comparison (Tukey HSD)
TukeyHSD(anova_model)

# Result interpretation (Tukey HSD):
# Business travelers rated significantly lower than all other groups (p < 0.001).
# Couples had the highest average ratings, significantly above Families and Solo travelers.
# No significant differences between "Other–Couple" and "Solo–Family".


# Visualization: Scoring Box Plot
ggplot(df, aes(x = stay_purpose, y = Reviewer_Score, fill = stay_purpose)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Reviewer Score by Traveler Type",
       x = "Traveler Type", y = "Reviewer Score") +
  theme(legend.position = "none")

# Visualization: Emotion Score Box Plot
ggplot(df, aes(x = stay_purpose, y = sentiment_score, fill = stay_purpose)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Sentiment Score by Traveler Type",
       x = "Traveler Type", y = "Sentiment Score") +
  theme(legend.position = "none")

# Examine the correlation between mood and rating
cor_test <- cor.test(df$sentiment_score, df$Reviewer_Score, method = "pearson")
print(cor_test)

# Conclusion:
# ANOVA confirmed significant differences in hotel ratings among traveler types (p < 0.001).
# Business travelers rated significantly lower than all other groups.
# Couples and families showed the highest satisfaction levels.
# Pearson correlation (r = 0.50, p < 0.001) indicates a moderate positive relationship
# between sentiment score and reviewer rating, showing textual and numerical feedback are aligned.

