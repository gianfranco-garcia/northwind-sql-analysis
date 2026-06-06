# Northwind Sales Analysis — SQL

A business-driven SQL analysis of **Northwind Traders**, a wholesale gourmet-food
importer/distributor, answering seven management questions about products,
customers, sales team, and growth — and turning the results into concrete
business recommendations.

> **Tools:** SQLite · SQL · 830 orders, 77 products, 91 customers (2016–2018)

📄 **Jump to:** [Results](#results) · [Full analysis](analysis.md) · [SQL queries](queries.sql)

---

## Executive Summary

Northwind is a **profitable, fast-growing business** — monthly revenue grew nearly
**5x** (from ~$25K/month in mid-2016 to ~$124K in April 2018) — but it runs on
**high concentration**: a small set
of "star" products, "whale" customers, and top sales reps generate the majority of
revenue. The same pattern appears in every angle analyzed.

This makes the business **efficient to manage but fragile**: losing any single top
piece (a flagship product, a key account, a star rep) would hit revenue at the level
of an entire category or country. The analysis closes with three actions: **protect
the top, diversify the tail, and capitalize on the 2018 growth.**

---

## Business Problem

Northwind's management wants to grow but doesn't know where to focus:
**which products and markets drive revenue, which customers matter most, who on the
sales team performs, and where is the business heading?** This project uses SQL to
answer those questions and recommend 2–3 concrete actions.

---

## Methodology

1. **Data quality first.** I compared two public versions of Northwind and found one
   inflated with random data plus a junk record, so I discarded it and used the clean,
   classic version (830 real orders, real customers, 2016–2018).
2. **Seven business questions.** I wrote each one as a documented SQL query
   ([`queries.sql`](queries.sql)).
3. **Interpretation over output.** I read each result as a business insight, not just
   a table, and ran follow-up queries to test a hypothesis whenever one came up.

Revenue is calculated per order line as `UnitPrice * Quantity * (1 - Discount)`.

---

## Skills Demonstrated

| Area | Techniques |
|------|------------|
| Filtering & sorting | `SELECT`, `WHERE`, `ORDER BY`, `LIMIT` |
| Aggregation | `SUM`, `AVG`, `COUNT(DISTINCT)`, `GROUP BY`, `HAVING` |
| Joins | multi-table `JOIN` (up to 3 tables) |
| Dates | `strftime` for monthly trend analysis |
| Subqueries | nested query to find above-average products |
| Analytical thinking | hypothesis testing, average-vs-distribution, data-quality checks |

---

## Results

| # | Question | Key finding |
|---|----------|-------------|
| 1 | Top products by revenue | Côte de Blaye leads (~$141K), nearly 2x the #2 — revenue concentrated in a few premium products |
| 2 | Revenue by category | Beverages is #1 ($268K), but a **single wine = 53%** of the category |
| 3 | Revenue by country | USA & Germany lead by broad customer base; "whale" clients hide in Austria, Ireland, Sweden |
| 4 | Top customers | A handful of accounts dominate — Hungry Owl is **100%** of Ireland; Ernst Handel **82%** of Austria |
| 5 | Sales by employee | Sales Reps drive the bulk; top performer by *revenue per order* is Anne Dodsworth, not the highest-volume rep |
| 6 | Monthly trend | Strong upward growth, **~5x** by 2018 (the May-2018 dip is a **truncated month**, not a decline) |
| 7 | Above-average products | Only **24 of 77** products beat the average — the mean is inflated 8.6x by Côte de Blaye |

**Central thesis:** the same **high-concentration** pattern shows up across products,
categories, customers, employees, and time — a profitable but fragile business.

---

## Analytical Highlights

Beyond writing queries, this project applies analytical judgment:

- **Averages can hide the distribution** — Northwind's "average product" ($16,439) is
  inflated 8.6x by a single outlier; only 24 of 77 products actually beat it.
- **Total ≠ per-unit** — the highest-volume sales rep is *not* the most efficient per
  order, so totals alone would point to the wrong "top performer."
- **Check before concluding** — the apparent May-2018 sales "crash" was just an
  incomplete month (the data ends on May 6), not a real decline.

---

## Business Recommendations

1. **Protect the top (concentration risk).** Secure supply of flagship products
   (Côte de Blaye) and build a formal retention program for whale accounts
   (Ernst Handel, QUICK-Stop, Save-a-lot, Hungry Owl). Losing one impacts a whole
   category or country.
2. **Diversify to reduce fragility.** Develop more mid-size customers in single-account
   markets. On the product side, focus the review on the genuinely *low-volume, slow-moving*
   tail — not simply the products "below average," since that average is inflated ~8.6x by a
   single outlier (Côte de Blaye) and most products fall below it by definition.
3. **Capitalize on 2018 growth & replicate the best.** Invest in inventory/suppliers
   while the trend is rising, and study the playbook of the most *efficient* reps
   (Anne Dodsworth, Andrew Fuller) to lift the team's average order value.

---

## Data & Reproducibility

Every figure in this analysis is **fully reproducible**: the complete database
(`northwind.db`) and all queries (`queries.sql`) are included in this repository. To reproduce
the results, run:

```bash
sqlite3 -header -column northwind.db < queries.sql
```

Dataset: the classic **Northwind** sample database (a widely used, public retail dataset),
clean version — 830 orders across 2016–2018.

---

## Files

| File | Description |
|------|-------------|
| [`queries.sql`](queries.sql) | All 7 business queries, documented |
| [`analysis.md`](analysis.md) | Detailed analysis: findings, insights & method per query |
| `northwind.db` | SQLite database (classic clean version) |

---

*Author: Gianfranco García — Business Analytics, Florida International University.*
