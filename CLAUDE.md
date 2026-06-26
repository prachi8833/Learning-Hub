## Playwright / Browser Debugging Policy

Default:
- Do not use Playwright for small text, CSS, or simple HTML changes.
- Do not launch a browser automatically for every task.

Allowed:
Use Playwright when the issue needs browser inspection, such as:
- UI looks broken
- layout overlap
- button not clicking
- modal not opening
- console errors
- Supabase data not loading
- navigation issue
- mobile/responsive issue
- parent dashboard form not saving
- reward/wishlist logic not behaving correctly

Required behavior:
- Use Playwright only for the specific issue being worked on.
- Do not browse the whole app unless asked.
- First inspect code, then use Playwright only if needed.
- Report what was found before making major changes.
- Fix one issue at a time.
- After fixing, stop and ask Prachi before continuing.

Browser rule:
- If Playwright is used, launch a separate browser session.
- Do not interact with Prachi’s existing Chrome tabs.
- Close the browser session after debugging/testing.

Playwright Usage Policy

Priority 1:
Always solve the issue by reading the code first.

Priority 2:
If the cause cannot be determined from the code alone, ask:
"Would you like me to use Playwright to investigate?"

Priority 3:
Use Playwright only after approval, unless Prachi explicitly requested browser debugging.

Keep browser sessions as short as possible and inspect only the page related to the current task.