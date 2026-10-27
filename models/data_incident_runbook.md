# Data Incident Runbook

Project: Google Cloud SMB Marketing Analytics  
Status: Synthetic portfolio exercise

## Purpose

Describe how to investigate and resolve data problems before affected reporting is refreshed.

## Responsibilities

| Role | Responsibility |
|---|---|
| Analytics Engineer | Investigates failed models and tests, assesses metric impact, and coordinates recovery |
| Data Engineering | Resolves extraction, ingestion, missing-record and source-delivery problems |
| Marketing Operations | Confirms campaign mappings, lead scoring and marketing definitions |
| Sales Operations | Confirms opportunity stages and sales qualification rules |
| Finance / Billing | Confirms charges, credits, currency treatment and financial reconciliation |
| BI owner | Holds or resumes the dependent dashboard refresh |

These are proposed responsibilities for this simulated project.

## Incident response steps

### 1. Identify the failure

Record:

- Failed model or test.
- dbt run link and failure time.
- Error message or failing records.
- Affected source and reporting tables.

Distinguish a SQL execution error from a test that successfully found invalid data.

### 2. Assess business impact

Determine which metrics may be incorrect.

Examples:

- Duplicate spend records may overstate advertising cost.
- Missing campaign references may exclude leads from campaign reporting.
- Invalid opportunity amounts may understate pipeline.
- Duplicate account attribution may overstate usage revenue.

### 3. Hold affected reporting

Do not refresh the affected dashboard until the issue is understood and required checks pass.

Record the last successful reporting cutoff. A failed dbt run does not automatically roll back every model or stop an independently scheduled Power BI refresh.

### 4. Investigate the cause

Trace the affected records through:

Raw source → Staging → Intermediate → Mart

Compare identifiers, revisions, load dates, join keys and exclusion reasons.

### 5. Assign the issue

- Extraction or loading problem: Data Engineering.
- Campaign or scoring interpretation: Marketing Operations.
- Opportunity interpretation: Sales Operations.
- Billing or financial interpretation: Finance / Billing.
- SQL, joins, aliases or test configuration: Analytics Engineering.

### 6. Correct and rebuild

Correct the underlying cause rather than hiding the failure.

Do not remove a required test, replace an unknown amount with zero, or use DISTINCT to conceal an unexplained join problem.

For affected spend models:

```text
dbt run --select +fct_spend
```

For affected lead models:

```text
dbt run --select +fct_lead
```

### 7. Validate recovery

Run the relevant tests, then the required model chain:

```text
dbt build --select +fct_lead +fct_spend dim_date
```

Confirm:

- No unexplained failures or skipped resources.
- Fact identifiers are unique.
- Source-to-target counts reconcile.
- Monetary totals reconcile within the approved tolerance.
- Exclusion counts are understood.

### 8. Resume reporting and close

The BI owner resumes the dependent refresh after validation.

Record the root cause, correction, validation evidence and preventive action.

## Example: duplicate advertising spend

| Item | Response |
|---|---|
| Detection | `unique_fct_spend_spend_id` fails |
| Business impact | Spend may be overstated |
| First check | Determine whether staging retained multiple revisions |
| Second check | Check FX uniqueness and campaign join multiplicity |
| Correction | Fix revision selection or the invalid join |
| Validation | Rebuild spend models; pass uniqueness and spend reconciliation |
| Closure | Resume reporting and document the cause |

## Incident record template

- Incident ID:
- Detected at:
- Failed model or test:
- Run link:
- Affected records:
- Business impact:
- Assigned owner:
- Last successful reporting cutoff:
- Root cause:
- Correction:
- Validation evidence:
- Reporting resumed at:
- Preventive action:
- Status: