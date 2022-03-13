# Duplicate handling

`identify.R` updates `duplicates.csv`, `uncategorized.csv`, and `summary-by-field.csv`:

- `duplicates.csv`: All duplicates. `reason` column has a value if we’ve marked it in `categorized.csv` (see below).
- `uncategorized.csv`: List of duplicates that we haven't yet looked into.
- `summary-by-field.csv`: Count of duplicates by field that causes `distinct()` to fail. `count_duplicates` may sum to a higher number than `uncategorized.csv`, because some entries may differ across multiple fields.

We update `categorized.csv` manually, after having reviewed `uncategorized.csv` and assigned it a code based on the categories below. The `h3` (e.g., `Misc`) is the category namespace and the `h4` (e.g., `Different entries with same request number`) is the category issue. Combined, they form the `reason` column in `categorized.csv`: `Misc/Different entries with same request number`.

[See issues related to `duplicate handling`.](https://github.com/lchski/gc-ati-summaries-data/labels/duplicate%20handling)

## Duplicate categories

### lib/cleaning/encoding.R

#### Invalid multibyte character

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

#### Unicode long stroke overlay character

Looks like `Ì¶` in version that needs re-encoding; renders as ` ̶` (two characters: a space with a hyphen overlay).


### Misc

#### Different entries with same request number

What it says on the tin. Likely a manual entry error with the year. Two clearly different requests.

#### Entries with same request number but slightly different descriptions

#### Missing summary for one entry but not for other

Summary `is.na` for one entry, while `! is.na` for another (i.e., one has a summary, the other is blank—can likely just `filter(! is.na)` to fix, but would want to verify).

#### Summary has trailing whitespace

Likely just need to `str_trim()`.

#### Summary has inconsistent internal whitespace

Maybe `str_squish()`?

#### One summary uppercase the other lowercase

Maybe just eliminate the one that's all upper case?

#### Missing request number

This'll just be a bigger issue, probably.
