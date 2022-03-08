sqlite-utils insert cleaning-summaries.db summaries temp-summaries.csv --csv --detect-types
datasette --reload cleaning-summaries.db