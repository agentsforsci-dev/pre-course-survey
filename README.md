# Pre-course survey: Agents for Scientists

The pre-course survey of the Agents for Scientists workshop, built with
[surveydown](https://surveydown.org), an open-source survey platform based on
R, Quarto and Shiny. Responses are stored in a PostgreSQL database on
[Supabase](https://supabase.com/), and the survey runs on
[Posit Connect Cloud](https://connect.posit.cloud/).

The survey is adapted from the
[pre-course survey of the Data Science for openwashdata course](https://github.com/ds4owd-dev/pre-course-survey)
(CC-BY-4.0). This repository is a fork of that repository. The original
KoboToolbox XLSForm is kept in `forms/` as the source.

## What the survey collects

The survey takes about 10 minutes and has 16 questions on five pages. Every
question is required.

- GitHub username (the only identifier, no name and no email address),
  operating system and reference manager
- Technical experience (programming, Git and GitHub use since the previous
  workshop, IDEs, command line, data formats, narrative documents)
- Current use of AI tools
- Goals for the workshop
- Consent

No browser details and no IP addresses are stored (`capture-metadata: false`).

Question ids and stored values follow the names in the original XLSForm
wherever a question is unchanged, so that answers stay comparable across
courses.

## Repository contents

```
pre-course-survey/
├── survey.qmd                          # Pages, questions and survey settings
├── app.R                               # Shiny app: database, display logic, validation
├── custom.scss                         # Font and colours of the workshop website
├── forms/
│   └── ds4owd-precourse-survey.xlsx    # The original XLSForm (source)
├── prompts/                            # Archived prompts of Claude-assisted commits
├── CITATION.cff                        # Citation metadata
└── README.md                           # This file
```

Not in the repository, on purpose: `.env` (database credentials),
`preview_data.csv` (local test responses), `_survey/` (rendered cache) and
`rsconnect/` (deployment records).

## Run the survey locally

1. Install [R](https://cran.r-project.org/) and [Quarto](https://quarto.org/).
2. Install surveydown, version 1.3.0 or later:

   ```r
   install.packages("surveydown")
   ```

3. Open the project and run the app:

   ```r
   shiny::runApp("app.R")
   ```

For local testing without a database, set `mode: preview` in the
`survey.qmd` YAML header. Responses then go to a local `preview_data.csv`.

surveydown re-renders the survey when `survey.qmd` or `app.R` changes. After
editing only `custom.scss`, touch `survey.qmd` so that the change shows.

## Database (Supabase)

1. Create a Supabase project. This survey uses the Central EU (Zurich) region.
2. Open Connect, then the Direct tab, and read the connection parameters of the
   **session pooler** (port 5432 on the pooler host). The transaction pooler
   (port 6543) fails with RPostgres under load, because RPostgres sends each
   query as a prepared statement in two steps and transaction mode can route
   them to different backends.
3. Run `surveydown::sd_db_config()` once in the project folder and enter host,
   port, database name, user, table name and password. It writes them to a
   local `.env` file, which is git-ignored.
4. Keep `mode: database` in the `survey.qmd` YAML header.

`app.R` requires TLS for the database connection (`PGSSLMODE=require`) and
turns off GSSAPI negotiation, which the Supabase pooler does not offer.
surveydown creates the table on first use and enables row level security on
it, so the public Supabase API cannot read responses.

Use a new table name for each cohort.

## Deployment (Posit Connect Cloud)

1. Log in once in your own R console with `rsconnect::connectCloudUser()`.
2. Deploy with the `deploy-posit-cloud` script of the
   [surveydown-skill](https://github.com/surveydown-dev/surveydown-skill)
   repository:

   ```sh
   deploy-posit-cloud/deploy.sh --title "Agents for Scientists: pre-course survey" \
     --slug agentsforsci-ghe-survey --dir path/to/pre-course-survey
   ```

   The script bundles the survey with a fresh `_survey/` cache, publishes it,
   and ships the six `SD_*` values from `.env` as content secrets. `.env`
   itself never leaves the machine. Redeploying updates the app in place.

## Responses never enter this repository

Survey responses are personal data. The files `.env`, `preview_data.csv` and
`local_data.csv` are listed in `.gitignore`, and exports of responses belong in
a folder outside any git repository. Export with `surveydown::sd_get_data()`.

## Adapt for the next workshop

1. Edit the cohort values (workshop date, due date, website links) in the first
   code chunk of `survey.qmd`.
2. Edit the pages and questions in `survey.qmd`. Page ids and question ids must
   all be unique. Keep the `required` list in the YAML header in step with the
   questions.
3. Adjust the display logic (`sd_show_if()`) and the validation
   (`sd_stop_if()`) in `app.R`.
4. Set a new table name with `surveydown::sd_db_config(table = "...")`.
5. Redeploy.

## License

The survey is released under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/).
You are free to reuse and adapt it with attribution.

## Citation

If you reuse this survey, please cite it. See [`CITATION.cff`](CITATION.cff)
for full metadata, including the reference to the original survey.

## Workshop context

This survey is part of the pre-course work of the Agents for Scientists
workshop. For more about the workshop, see the
[workshop website](https://agentsforsci-ghe.github.io/website/).
