# Google Cloud North America SMB marketing analytics

A fictional portfolio case for a senior BI developer / analytics engineer. All companies, campaigns, figures and policies are synthetic. This does not describe Google's internal architecture or metric definitions. Snowflake/dbt and Power BI are the scenario's assigned stack.

## Your assignment
The North America SMB marketing director asks: “Where should we test a 15% budget shift next month?” Paid Social appears attractive on lead volume. Determine whether qualified opportunity creation and early paid usage support that conclusion. Scope North America explicitly to US, Canada and Mexico. SMB means 1–499 employees at this extract. Compare January–February 2026 acquisition cohorts, observed through March 31, 2026. All reported money is USD.

Deliver one Power BI page, a checked star schema, three findings, one budget experiment, and a two-minute walkthrough. This is a supplied scaffold plus a focused exercise, achievable in 1–2 hours when Python and Power BI Desktop are available. A fresh Snowflake installation or learning Power BI is outside that timebox.

## Start here: local route, no paid account or extra packages
1. Extract the entire ZIP. Install Python 3.10+ if needed.
2. Open a terminal in this folder and run `python run_local.py` (Windows alternative: `py run_local.py`).
3. Run `python check_independent.py` to compare every modeled lead and spend row against independent raw-CSV calculations. Confirm all checks pass. Inspect `local_output/results.json` and `local_output/audit_dispositions.csv`.
4. Load the four documented CSVs from `local_output` into Power BI Desktop. Follow `power_bi/DASHBOARD.md` and paste measures from `power_bi/measures.dax`.
5. Save your own `SMB_Marketing.pbix`, export a screenshot, and replace the draft recommendation with your decision.

Open `dashboard_preview.html` in a browser for an interactive local dashboard with country/channel/date filters. It is a companion preview; create the Power BI page using the included instructions.

Prebuilt, checked outputs are included to avoid setup delays. Re-running recreates them from the raw CSVs. Standard-library SQLite is the local execution engine. This is not a Snowflake emulator. The runner renders only ref(), the fixed as_of variable, and add_days(); it executes the same supplied model SQL, not arbitrary dbt projects.

## Snowflake/dbt route
Use an existing dev database, warehouse and role with schema creation/table privileges. Keep it a dedicated portfolio schema. Install `dbt-snowflake` in a virtual environment, copy `profiles.yml.example` to `profiles.yml`, and set the five SNOWFLAKE_* variables named there. External-browser authentication requires your organization's configured login. No credentials are included.

```text
python -m venv .venv
# Windows PowerShell: .venv\Scripts\Activate.ps1
# macOS/Linux: source .venv/bin/activate
python -m pip install dbt-snowflake
dbt debug --profiles-dir .
dbt seed --profiles-dir .
dbt run --profiles-dir .
dbt test --profiles-dir .
```

Do not commit your profile or credentials. `SMB_PORTFOLIO` is the target schema. Models are full-refresh tables for this small case. CSV seeds simulate connectors only; production fact ingestion belongs in Data Engineering pipelines. Query `REPORT_CAMPAIGN` and compare against `EXPECTED_RESULTS.md` to cents. To use cloud tables in Power BI, use its Snowflake connector with the same four dimensions/facts, rather than the local CSV importer. Local execution was tested; Snowflake credentials and Power BI Desktop execution were not available in this build.

## 110-minute walkthrough
| Minutes | Task | Evidence to keep |
|---|---|---|
| 0–10 | Read the brief and KPI contract. State scope, maturity and attribution. | One sentence on the budget decision |
| 10–20 | Run locally; inspect source grains and deliberate defects. | Passing results and quarantine counts |
| 20–40 | Trace lead dedup, SMB scope, FX and preaggregation in SQL. Explain the first-account anchor. | Model diagram and two reviewed SQL decisions |
| 40–60 | Load Power BI, type fields, create four relationships, paste core measures. | Model-view screenshot |
| 60–85 | Build the single page and apply campaign/channel/country filters. | Dashboard screenshot |
| 85–100 | Reconcile headline totals and a filtered campaign; demonstrate zero denominator behavior. | Completed acceptance checklist |
| 100–110 | Write three findings and propose a bounded budget experiment; rehearse narrative. | 150-word decision memo |

60-minute version: use the prebuilt exports, spend 10 minutes on definitions and checks, 15 on model/relationships, 25 on four cards plus campaign matrix, and 10 on narrative. 120-minute version adds a Snowflake/dbt run if credentials already work. Otherwise use the extra 10 minutes for a design review. Do not build orchestration, embedded authentication, AI integration or a production incremental framework inside this exercise.

The dimensional transformations live in dbt; the governed semantic layer for this exercise is Power BI (shared dimensions plus explicit DAX measures). No MetricFlow service is required.

## Kit map
- `seeds/`: connected, deliberately imperfect source CSVs and calendar.
- `models/`, `macros/`, `tests/`: executable dbt SQL, shared with the local runner.
- `docs/KPI_CONTRACT.md`: definitions, grains, attribution and edge cases.
- `docs/MODELING_AND_DQ.md`: dimensional design, source dictionary, defects and production standards.
- `power_bi/`: import helper, DAX and precise page specification.
- `docs/INTERVIEW.md`: narrative, design review and capability evaluation.
- `EXPECTED_RESULTS.md`: exact fixture controls and channel findings.
- `local_output/`: ready-to-load model CSVs, results and local database.

## Technical references
The project uses [dbt CSV seeds and ref](https://docs.getdbt.com/docs/build/seeds), [Power BI star-schema guidance](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema), and [Snowflake DATEADD](https://docs.snowflake.com/en/sql-reference/functions/dateadd). These document platform behavior. All KPI policies in this kit are invented case assumptions.
