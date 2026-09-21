# Pre-course survey: Agents for Scientists

The pre-course survey of the Agents for Scientists workshop, built with
[surveydown](https://surveydown.org), an open-source survey platform based on
R, Quarto and Shiny.

The survey is adapted from the
[pre-course survey of the Data Science for openwashdata course](https://github.com/ds4owd-dev/pre-course-survey)
(CC-BY-4.0). This repository is a fork of that repository. The original
KoboToolbox XLSForm is kept in `forms/` as the source.

## What the survey collects

The survey takes about 5 minutes and has 14 questions on five pages:

- GitHub username (the only identifier, no name and no email address)
- Technical experience (programming, Git and GitHub use since the previous
  workshop, IDEs, command line, data formats, narrative documents)
- Current use of AI tools (voluntary)
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
├── forms/
│   └── ds4owd-precourse-survey.xlsx    # The original XLSForm (source)
├── CITATION.cff                        # Citation metadata
└── README.md                           # This file
```

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

With `mode: preview` in the `survey.qmd` YAML header, responses are saved to a
local `preview_data.csv` and no database is used.

## Collect responses

Responses are stored in a PostgreSQL database, for example a free
[Supabase](https://supabase.com/) project.

1. Run `surveydown::sd_db_config()` once in the project folder. It stores the
   database credentials in a local `.env` file.
2. Change `mode: preview` to `mode: database` in the `survey.qmd` YAML header.
3. Deploy the app to a host that runs R, see the
   [surveydown deployment docs](https://surveydown.org/docs/deployment). On a
   host without a `.env` file, the app reads the same `SD_*` values from
   environment variables.

## Responses never enter this repository

Survey responses are personal data. The files `.env`, `preview_data.csv` and
`local_data.csv` are listed in `.gitignore`, and exports of responses belong in
a folder outside any git repository.

## Adapt for the next workshop

1. Edit the cohort values (workshop date, due date, website links) in the first
   code chunk of `survey.qmd`.
2. Edit the pages and questions in `survey.qmd`. Page ids and question ids must
   all be unique.
3. Adjust the display logic (`sd_show_if()`) and the validation
   (`sd_stop_if()`) in `app.R`.
4. Use a new database table name for each cohort.

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
