---
name: calories
description: Estimate and track daily calories for Scott's EMBED Study food log. Use when Scott asks to log calories, update his calorie count, check today's total, or estimate calories from his food log. Runs find_latest_embed_log.sh to get the current log, reads memorised_foods.md for known values, estimates calories for each entry, updates the daily total header in the log file, and sends Scott a Telegram summary.
---

# Calories Skill

## Workflow

**DO NOT manually search for the log file.** Always use the script.

1. **Find the log** — ALWAYS run `bash ~/.openclaw/workspace/skills/calories/scripts/find_latest_embed_log.sh` to get the correct path. This ensures you only search the Journal directory (not trash or elsewhere).
2. **Load known foods** — read `/home/node/.openclaw/workspace/memory/memorised_foods.md`
3. **Read the log file** — load the food log at the path returned by the script
4. **Estimate calories** — for each bullet entry, estimate calories using:
   - Exact values from memorised_foods.md where applicable
   - Best-effort estimates for anything else (use common sense / typical UK portions)
   - Annotate each line with `(X cal)` or `(X cal estimate)` if not already present — update existing annotations if the estimate has changed
5. **Update the daily total** — rewrite or create the header line at the top of the file:
   `**📊 DAILY TOTAL: X calories**`
6. **Save the file** — write the updated content back to the same path
7. **Ping Scott on Telegram** — send a message with the total and a brief breakdown

## Notes

- The log format is freeform markdown bullets with timestamps, e.g. `- 11:07 - banana`
- Don't add entries, only annotate and total existing ones
- If the log is empty or has no food entries, say so and don't write anything
- memorised_foods.md can be updated by Scott at any time — always re-read it fresh
