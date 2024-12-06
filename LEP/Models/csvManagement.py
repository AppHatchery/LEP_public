import pandas as pd

# Load the master data from A
original_df = pd.read_csv('originalTranslations.csv')

# Load the data from B and C
cards_df = pd.read_csv('translations_cards.csv')
phrases_df = pd.read_csv('translations_phrases.csv')

# Select the columns to be added
columns_to_add = ['Amharic', 'Burmese', 'Arabic', 'Mandarin Chinese']

# Merge the columns from the original data into B and C based on the 'English' column
updated_cards_df = pd.merge(cards_df, original_df[['English'] + columns_to_add], on='English', how='left')
updated_phrases_df = pd.merge(phrases_df, original_df[['English'] + columns_to_add], on='English', how='left')

# Save the updated B and C dataframes back to their respective CSV files
updated_cards_df.to_csv('updated_translations_cards.csv', index=False)
updated_phrases_df.to_csv('updated_translations_phrases.csv', index=False)

print("Columns added and CSV files updated successfully.")