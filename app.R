# Package setup ---------------------------------------------------------------

# Install required packages:
# install.packages("surveydown")

# Load packages
library(surveydown)

# Database setup --------------------------------------------------------------
#
# Details at: https://surveydown.org/docs/storing-data
#
# surveydown stores data on any PostgreSQL database. This survey uses a
# Supabase project. Run the following function once to store the database
# configuration parameters in a local .env file (git-ignored):
#
# sd_db_config()
#
# The survey mode is set via `mode` in the survey.qmd YAML header. In
# `preview` mode responses are saved locally to preview_data.csv and any
# database connection is ignored. To collect real responses, change `mode`
# to `database`.
#
# On a hosted runtime without a .env file, sd_db_connect() reads the same
# SD_* values from environment variables.

db <- sd_db_connect()

# UI setup --------------------------------------------------------------------

ui <- sd_ui()

# Server setup ----------------------------------------------------------------

server <- function(input, output, session) {
  # Conditional display logic
  sd_show_if(
    # Show the specification fields if "Other" is ticked
    "other" %in% sd_value("ide_used") ~ "ide_used_other",
    "other" %in% sd_value("ai_tools") ~ "ai_tools_other",

    # Show the two AI frequency grids unless "None of the above" is ticked
    # among the AI tools. A blank answer still shows the grids.
    !("none" %in% sd_value("ai_tools")) ~ "ai_data",
    !("none" %in% sd_value("ai_tools")) ~ "ai_text"
  )

  # Validation, checked when the participant clicks Next
  sd_stop_if(
    # GitHub usernames have 1 to 39 letters, digits or hyphens.
    # as_numeric = FALSE keeps a username such as "1e5" as text.
    !grepl(
      "^[A-Za-z0-9-]{1,39}$",
      trimws(sd_value("github_username", as_numeric = FALSE))
    ) ~
      "Please enter your GitHub username without the @. It can contain letters, digits and hyphens.",

    # "None of the above" cannot be combined with other options
    "none" %in% sd_value("ide_used") & length(sd_value("ide_used")) > 1 ~
      "IDEs: please select either \"None of the above\" or the IDEs you have used.",
    "none" %in% sd_value("ai_tools") & length(sd_value("ai_tools")) > 1 ~
      "AI tools: please select either \"None of the above\" or the tools you have used."
  )

  # Run surveydown server and define database
  sd_server(db = db)
}

# Launch the app
shiny::shinyApp(ui = ui, server = server)
