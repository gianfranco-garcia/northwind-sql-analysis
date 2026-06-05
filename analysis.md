# Detailed Analysis — Northwind Sales

Full findings behind the [README](README.md). Each section states the business
question, the result, and the insight drawn from it. All revenue figures use
`UnitPrice * Quantity * (1 - Discount)`.

---

## Q1 — Top products by revenue
- Côte de Blaye leads with ~$141K, almost double the #2 (Thüringer Rostbratwurst, ~$80K).
- The top 10 are expensive, specialized goods (wines, meats, cheeses) — not cheap
  high-volume items.
- **Insight:** revenue is concentrated in a few premium products — high margin, but
  it creates dependency risk.

## Q2 — Revenue by category
- Beverages leads ($268K), then Dairy ($235K); the lowest is Grains ($96K). The spread
  (~2.8x) is narrower than at the product level.
- **Key insight (links Q1 + Q2):** Côte de Blaye ($141K) is ~53% of the *entire*
  Beverages category. The category's lead rests on a single wine — not broad strength,
  but concentration.

## Q3 — Revenue by country (with customer-level check)
- USA ($246K) and Germany ($230K) lead; the tail (Canada, Ireland) sits near ~$50K.
  The business spans three continents — healthy diversification.
- A hypothesis ("USA buys premium") was tested with data (customers + spend per customer)
  and **did not hold**: USA/Germany lead on a *broad base* (13 and 11 customers, ~$19–21K
  each). The real "whale" clients are in small countries — Austria, Ireland, Sweden.
- **Insight:** two different markets exist — broad base (USA, Germany) vs. whale accounts
  (Austria, Ireland). Leading total revenue ≠ having the most valuable customers.

## Q4 — Top 5 customers
- QUICK-Stop (Germany, $110K) · Ernst Handel (Austria, $105K) · Save-a-lot Markets
  (USA, $104K) · Rattlesnake Canyon Grocery (USA, $51K) · Hungry Owl (Ireland, $50K).
- Customer-to-country concentration: QUICK-Stop = 48% of Germany · Ernst Handel = 82%
  of Austria · Save-a-lot + Rattlesnake = 63% of USA · **Hungry Owl = 100% of Ireland**
  (the country's only customer).
- **Insight:** the business leans on a few large "whale" accounts rather than a broad
  base. Advantage: few accounts to manage. Risk: losing one relationship drops revenue
  sharply.
- **Method note:** a follow-up showed Austria's earlier "$64K per customer" was a
  *misleading average* — the reality was Ernst Handel $105K vs. Piccolo $23K (~5x apart).
  An average can hide the distribution; check the data point by point before concluding.

## Q5 — Sales by employee
- 9 employees. Top by total revenue: Margaret Peacock ($233K / 156 orders), then Janet
  Leverling and Nancy Davolio.
- **Sales Representatives drive the bulk** (6 of 9 employees) — the field reps, not the
  office roles (VP, Sales Manager).
- Looking at a second dimension — *revenue per order* — tells a different story: the most
  efficient is **Anne Dodsworth ($1,798/order)** with few but large orders, ahead of VP
  Andrew Fuller ($1,735). The highest-volume rep (Margaret) is not the most efficient
  per order.
- **Insight:** total and per-unit metrics tell different stories; normalize the big
  number before concluding.

## Q6 — Monthly sales trend
- Range: Jul-2016 to May-2018. The business is clearly **growing**: ~$25–45K/month in
  2016, holding through 2017, then climbing sharply in 2018 (Jan $94K → Feb $99K →
  Mar $105K → **Apr $123K**, the best month in the series — roughly 5x a typical 2016 month).
- **Data-quality note:** May-2018 shows only ~$18K / 14 orders, which looks like a crash —
  but the database ends on **2018-05-06**, so that month is *incomplete* (truncated), not
  a real decline. Always confirm the last period is complete before reading a drop as a trend.

## Q7 — Products above the average (subquery)
- Average revenue per product = **$16,439**. Only **24 of 77 products** beat it; 53 fall
  below.
- The average is **inflated by a few giants**: Côte de Blaye ($141K) sits **8.6x** above it.
  So the mean does not describe a "typical" product — the distribution is heavily skewed.
- **Insight:** the company is highly dependent on its top products. Easy to manage (few
  products carry the business), but fragile — losing a top product would hit revenue hard.

---

## Central thesis
The same **high-concentration** pattern appears across every angle:

| Angle | Concentration signal |
|-------|----------------------|
| Products | Côte de Blaye = 8.6x the average product |
| Categories | One wine = 53% of the Beverages category |
| Customers | Hungry Owl = 100% of Ireland; Ernst Handel = 82% of Austria |
| Employees | A few reps close the bulk of sales |
| Time | Strong growth into 2018 |

**Northwind is profitable and growing, but highly concentrated** — very efficient to
manage, yet fragile to the loss of any top product, customer, or sales rep.

## Business recommendations
1. **Protect the top (concentration risk).** Secure supply of flagship products
   (Côte de Blaye) and create a formal retention program for whale accounts
   (Ernst Handel, QUICK-Stop, Save-a-lot, Hungry Owl) — losing one impacts a full
   category or country.
2. **Diversify to reduce fragility.** Grow more mid-size customers in single-account
   markets, and review the 53 below-average products to free capital and focus.
3. **Capitalize on 2018 growth and replicate the best.** Invest in inventory/suppliers
   while the trend is rising, and study the playbook of the most efficient reps
   (Anne Dodsworth, Andrew Fuller) to raise the team's average order value.

## Analytical principles applied
- An **average can hide the distribution** — read the data point by point, not just the summary.
- **Total vs. per-unit** metrics tell different stories — normalize before concluding.
- **Confirm the last period is complete** before reading a drop as a decline.
- **Test hypotheses against the data** before stating them.
- **Check data quality before analyzing** (a clean dataset was chosen over an inflated one).
