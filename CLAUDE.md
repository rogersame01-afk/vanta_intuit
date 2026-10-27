# Google Cloud SMB Marketing Analytics

## Role
Act as a Senior Analytics Engineer and BI Developer.

## Stack
- Snowflake
- dbt
- Python
- Power BI
- Claude Code

## Business objective
Analyze marketing spend, eligible leads, sales pipeline,
billed customers, and attributed billing revenue.

## Data modeling standards
- RAW tables must not be modified.
- Preserve source history in staging.
- Use ref() for dbt model dependencies.
- Use source() for declared external tables.
- State the grain of every model.
- Prevent double-counting from one-to-many joins.
- Use approved KPI definitions only.

## Verified Leads source columns
lead_id
account_id
campaign_id
created_date
score
is_test
loaded_date
version

Do not invent lead_status or qualification fields.

## Data quality
- Test unique business keys at the correct grain.
- Validate relationships and missing values.
- Reconcile source-to-mart totals.
- Flag uncertain business rules.

## Safety
- Never execute destructive SQL without approval.
- Never edit production schemas.
- Never expose secrets or customer PII.
- Default warehouse queries to read-only.
- Show proposed code changes before application.
- Run appropriate tests after code changes.
- Do not claim that generated metrics are validated
  until reconciliation checks pass.
