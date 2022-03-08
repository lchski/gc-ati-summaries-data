See `known-duplicates.csv` for affected entries.

# fix-encoding-errors.R

## Invalid multibyte character

```
saved_summaries %>%
    mutate_if(
        is.character,
        ~ str_replace_all(., c(
            "Â­" = "­"
        ))
    )
```

Yields error: `Error: invalid multibyte character in parser at line 34`. There’s an invisible character of some sort (doesn’t even render in all editors).



# Misc

## Different entries with same request number

What it says on the tin. Likely a manual entry error with the year.

## Missing summary for one entry but not for other

Summary `is.na` for one entry, while `! is.na` for another (i.e., one has a summary, the other is blank—can likely just `filter(! is.na)` to fix, but would want to verify).
