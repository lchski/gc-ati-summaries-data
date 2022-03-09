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

- JD, AL, SB for the original dataset and encouragement
- Simon Willison for [git scraping](https://simonwillison.net/series/git-scraping/), [datasette](https://datasette.io/), and a [clear how-to on deploying a git scraping datasette instance in a serverless function](https://simonwillison.net/2020/Jan/21/github-actions-cloud-run/) (what is the internet!?)
- Government of Canada Open Data team, and Access to Information shops everywhere, for [doing the hard work to make things open](https://www.gov.uk/guidance/government-design-principles#make-things-open-it-makes-things-better)
