---
mode: ask
description: >
  Inspect and evaluate your .squad/ artifacts after Module 2 Step 9, or any
  time you want to understand whether the team's memory is doing real work.
  Paste the contents of your key .squad/ files and get an honest assessment.
---

I've completed work with my Squad team and I want to evaluate the quality of the artifacts they left behind. Please give me an honest assessment — not flattery.

**Paste the contents of these files** (run each command in your `reading-list-squad-lab` terminal and paste below):

**`.squad/decisions.md`:**
```powershell
Get-Content .squad\decisions.md
```
```
[paste output]
```

**`.squad/identity/wisdom.md`:**
```powershell
Get-Content .squad\identity\wisdom.md
```
```
[paste output]
```

**One agent history (pick any member):**
```powershell
Get-ChildItem .squad\agents\ -Recurse -Include history.md | Select-Object -First 1 | Get-Content
```
```
[paste output]
```

---

For each file, please evaluate:

1. **Is this real work or AI confetti?**
   - Real work: specific decisions with project-specific rationale, file paths and conventions, patterns that would survive being applied to a different project
   - AI confetti: generic best-practice bullet lists, "I completed the task successfully", platitudes about writing clean code

2. **Would you consult this file in three months when picking up the project again?** If yes, it's working. If no, the memory is decorative.

3. **What's missing?** What decisions, patterns, or lessons should have been captured but weren't?

4. **What does this tell me about whether Squad is earning its keep for this project?**

Be direct. This assessment is the point of Module 2 Step 9 — honest evaluation is more valuable than encouragement.
