See `known-duplicates.csv` for affected entries.

Run `read_csv("cleaning/known-duplicates.csv") %>% arrange(reason, owner_org) %>% write_csv("cleaning/known-duplicates.csv")` to arrange by reason.

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

The invisible character is  `­` or `U+00AD : SOFT HYPHEN [SHY] {discretionary hyphen}`. Should be addressed with these two replacements (we make the hyphens explicit, instead of hiding them):

```
"Â\u00AD" = "-",
"\u00AD" = "-",
```

## Unicode long stroke overlay character

Looks like `Ì¶` in version that needs re-encoding; renders as ` ̶` (two characters: a space with a hyphen overlay).


# Misc

## Different entries with same request number

What it says on the tin. Likely a manual entry error with the year. Two clearly different requests.

## Entries with same request number but slightly different descriptions

## Missing summary for one entry but not for other

Summary `is.na` for one entry, while `! is.na` for another (i.e., one has a summary, the other is blank—can likely just `filter(! is.na)` to fix, but would want to verify).

## Summary has trailing whitespace

Likely just need to `str_trim()`.

## Summary has inconsistent internal whitespace

Maybe `str_squish()`?

## One summary uppercase the other lowercase

Maybe just eliminate the one that's all upper case?

## Missing request number

This'll just be a bigger issue, probably.
