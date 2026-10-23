# Shared metric contract v1

Owner: fictional North America Marketing Analytics. Business approver: SMB marketing director. Data Engineering owns ingestion and FX availability; Data Quality owns incident triage. Contract changes require a reviewed SQL/DAX change, impact comparison and business approval before promotion.

Snapshot: March 31, 2026. Lead cohorts and ad activity: January 1–February 28, 2026 inclusive. Source dates are UTC dates. `loaded_date` controls what was knowable at the snapshot. ISO date strings are intentional for the portable exercise. All generated fact dates fit the scope. Restrict future refreshes explicitly before extending it.

| Metric | Exact definition | Grain / aggregation |
|---|---|---|
| Spend USD | Latest spend_id version, nonnegative, valid campaign, matching daily FX; round each row's local spend × USD per local to cents | Spend row, additive |
| Leads | Non-test leads linked to valid campaign and account, country agreement, account employee_count 1–499, created in cohort; latest lead_id version loaded by snapshot | One row per lead_id, count |
| MQLs | Eligible lead with score ≥70 | Sum is_mql; a lead count, not distinct accounts |
| Mature MQLs | MQL with created_date +30 days ≤snapshot | Sum is_mature_mql |
| MQL to Opportunity % | Mature MQLs having ≥1 eligible opportunity created on/after lead date and ≤lead date +30 days, divided by mature MQLs | Ratio of sums; multiple opportunities count one converting lead |
| Pipeline USD | Sum estimated opportunity contract values for eligible MQLs, with opportunity created within inclusive day 0–30 and by snapshot | Each opportunity belongs to one lead; all current stages, including lost, retained as **created pipeline** |
| Won Bookings USD | Same created-pipeline population, current stage Closed Won | Estimated contract bookings, not actual cloud usage, ARR or recognized revenue |
| Cost per Lead / MQL | Spend in selected acquisition dates / eligible lead or MQL count in those dates | Blended efficiency; spend includes all campaign audiences, while lead denominator is eligible SMB |
| Pipeline to Spend | Created pipeline / spend | Ratio, not ROI or revenue ROAS |
| Acquired Accounts | One earliest eligible lead per account, ties broken by lead_id | Sum anchor flag, additive across campaign/date slices |
| Net Usage Revenue 30d | Billing for anchored accounts from lead date inclusive to lead date +30 days exclusive; latest billing_id version loaded by snapshot; retain negative credits | USD, assigned once to anchor lead campaign and acquisition date |
| Paid Accounts 30d | Anchored account with net 30d usage revenue >0 | Sum flag; net zero/negative is not paid |
| Paid Account Rate 30d | Paid anchored accounts / acquired accounts | Ratio of sums |
| Early Revenue to Spend | Attributed first-30-day net usage / acquisition-period spend | Early monetization indicator, not lifetime ROI |
| CTR | Sum clicks / sum impressions on accepted spend | Weighted ratio; no average of row rates |

Zero denominators return BLANK in DAX. Display blank as “No eligible denominator” in explanatory text, not 0%. Negative usage is legitimate; negative ad spend is quarantined under this fixture's gross-spend contract. Do not silently fill missing FX with 1 or 0. USD also requires an explicit rate row.

Attribution is a deterministic **first valid lead** policy, including non-MQL leads. It is not causal incrementality, multi-touch attribution, or proof that marketing acquired a new customer. “Acquired account” is shorthand for first observed eligible account in this synthetic extract; customer history is unavailable. Revenue follows that account's anchor even if another lead later converts. Opportunity pipeline follows its actual linked MQL. These two attribution grains intentionally differ.

All Jan–Feb cohorts are mature at this snapshot. The 30-day usage window contains 30 dates; the opportunity SLA includes elapsed day 30. Later cohorts would require maturity guards on paid-rate and revenue measures before comparison. Do not change as_of alone and assume the existing fixed date seeds or metrics become production-ready. Current opportunity stage is snapshot state; historical stages and period-end pipeline cannot be reconstructed from this extract.

Campaign/country/channel/product slicers describe campaign targeting. Account country is a validation attribute and may be used only in lead diagnostics. Account-size filters cannot legitimately filter ad spend; do not expose CPL by account size. Product means promoted campaign product: billing is account-level cloud usage, not product-specific revenue. No independent product-effect claim is supported.
