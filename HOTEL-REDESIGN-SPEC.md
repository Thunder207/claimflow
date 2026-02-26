# Hotel Section Redesign — Trip Form

## Summary
- **REMOVE** yellow Hotel/Accommodation summary card from Trip form (keep on AT form)
- **ENHANCE** Hotel Receipt section → single source of truth for hotel costs on trips
- **MOVE UP** between trip header and day-by-day cards
- **Support multiple hotels** per trip with overlap validation
- **Auto-distribute** costs to day cards based on check-in/check-out dates

## Hotel Expense Section Fields
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| Hotel Name | Text | Yes | e.g., "Marriott Downtown" |
| City | Text | Yes | e.g., "Ottawa, ON" |
| Check-in Date | Date picker | Yes | ≥ trip start |
| Check-out Date | Date picker | Yes | > check-in, ≤ trip end |
| Nights Stayed | Auto-calc | — | checkout - checkin (read-only) |
| Total Invoice | Dollar | Yes | Actual hotel invoice total |
| Receipt | File upload | Yes | Photo or PDF |

## Date Logic
- Check-in Feb 26 = sleep night of Feb 26
- Check-out Mar 2 = leave morning Mar 2, last night is Mar 1
- Nights = Check-out - Check-in (in days)

## Auto-Distribution
- Total ÷ Nights = per-night rate
- Populate hotel amount on day cards within check-in→checkout range
- Days outside hotel stay = no hotel amount
- Employee can toggle off a night → total redistributes across remaining active nights
- Rounding: last night absorbs remainder so sum = exact total

## Multiple Hotels
- "+ Add Another Hotel" button
- Each hotel: own name, city, dates, total, receipt
- Total Hotel Cost = sum of all invoices
- Overlap validation: error if date ranges overlap

## Trip Form Layout (new order)
1. Trip Header
2. 🏨 Hotel Expense (NEW, moved up)
3. Day-by-Day Cards (hotel auto-filled from above)
4. Transportation
5. Vehicle / Mileage
6. Other Expenses
7. Budget Comparison (Variance)
8. Trip Total + Submit

## What Stays the Same
- AT form: yellow Hotel/Accommodation card unchanged (estimate only)
- Day card hotel toggles still work (but amounts auto-populated)
- Variance: AT estimated hotel vs actual invoice total

## Validation
- Hotel Name + City: required, non-blank
- Check-in: ≥ trip start
- Check-out: > check-in, ≤ trip end
- Total: > $0
- Receipt: required for submission
- Nights ≥ 1
- No overlapping date ranges between hotels
- Hotel section optional (not everyone needs hotel)

## 10 Test Cases
See original spec for full test descriptions (basic entry, toggle off night, change total, change dates, multiple hotels, overlap validation, rounding, variance, no hotel, AT carry-over).
