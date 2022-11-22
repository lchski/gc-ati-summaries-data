# Summaries of completed Government of Canada Access to Information requests

Mirrors [public dataset of summaries of completed Government of Canada Access to Information requests](https://open.canada.ca/data/en/dataset/0797e893-751e-4695-8229-a5066e4fe43c). You can [view a nice interface to the dataset maintained by the federal Open Government team](https://open.canada.ca/en/search/ati).

Why mirror the dataset? Unfortunately, [completed summaries are generally kept in the dataset for only two years; after that, it’s assumed that the original institution destroyed the response records](https://www.canada.ca/en/treasury-board-secretariat/services/access-information-privacy/reviewing-access-information/the-review-process/ati-review-interim-what-we-heard-report.html#toc5-2-3) (following standard procedures for information like that). But you may still be interested in seeing what’s been asked and answered in the past! Hence, a mirror.

This repository:

- started with an existing dataset of summaries from May 2017 onward (if you have anything from earlier, please share!)
- [combines these summaries with new ones published online](https://github.com/lchski/gc-ati-summaries-data/blob/main/update-ati-summaries.R)
- [cleans the summaries to try to avoid duplicates](https://github.com/lchski/gc-ati-summaries-data/tree/main/cleaning) (to be integrated into updating flow, see #4)
- [automatically checks once a week for those new summaries](https://github.com/lchski/gc-ati-summaries-data/blob/main/.github/workflows/update-ati-summaries.yaml)
- [automatically deploys the resulting CSV to a public datasette instance](https://github.com/lchski/gc-ati-summaries-data/blob/main/.github/workflows/deploy-datasette-site.yaml)

You can [explore the public datasette instance to see, explore, and download the data](https://gc-ati-summaries-data.labs.lucascherkewski.com/). Or you can [download the summaries directly from this repository](https://github.com/lchski/gc-ati-summaries-data/blob/main/ati-summaries.csv).

You can also [check out the issues list](https://github.com/lchski/gc-ati-summaries-data/issues) to see what’s happening and what’s coming next for this project. Feel free to dig in if you’d like!

Thanks:

- [Jamie Duncan](https://jamieduncan.me/), AL, SB for the original dataset and encouragement
- Simon Willison for [git scraping](https://simonwillison.net/series/git-scraping/), [datasette](https://datasette.io/), and a [clear how-to on deploying a git scraping datasette instance in a serverless function](https://simonwillison.net/2020/Jan/21/github-actions-cloud-run/) (what is the internet!?)
- Government of Canada Open Data team, and Access to Information shops everywhere, for [doing the hard work to make things open](https://www.gov.uk/guidance/government-design-principles#make-things-open-it-makes-things-better)

## 2022-11-21: Note on data source

- 2022-10-18, @jdunca contributed the full historical dataset (#9).
- 2022-10-19, @lchski merged the historical dataset, integrating with existing data and removing duplicates (#10).
- 2022-10-25, @jdunca points out that [most of the remaining duplicates (a few hundred that point)](https://github.com/lchski/gc-ati-summaries-data/tree/b68f32b4b5177cdc8c9f25504c166f60b91ba5d3/cleaning/duplicates) were due to errors from the original source data, and they seemed mostly fixed in the full historical dataset (#11).
- 2022-11-21, @lchski (with many apologies for his tardiness) made a few edits and merged #11.

There’s a small possibility some summaries fell through the cracks in this process—but checks by @jdunca in [`cleaning/2022-10-23-exploring-errors-merging-historical-data.R`](https://github.com/lchski/gc-ati-summaries-data/blob/main/cleaning/2022-10-23-exploring-errors-merging-historical-data.R) make us pretty confident all’s good. There are around 250 remaining duplicates, largely due to slight changes in request summary, mostly from SSC—these are left as potentially interesting data points. On the off chance this deleted something, [the previous version of `ati-summaries.csv` remains available in the repository’s history](https://github.com/lchski/gc-ati-summaries-data/blob/5f438c875147a9d2f9431830495b23b3d6c038c7/back-up-ati-summaries.csv).
