# HEARTBEAT -- Phase 0 (Web-only, Minimal)

Only run heartbeat mode if Mark explicitly asks for a "heartbeat" or says "heartbeat" in the request.
Otherwise, answer normally.

If Mark explicitly asks for a heartbeat and there are no explicit, current tasks from Mark in this session:
Reply HEARTBEAT_OK and add a one-sentence reason on the next line.

If Mark has provided an explicit "heartbeat task list" in the current session (copy/pasted by Mark):
- Produce a short status check (<=7 bullets)
- List next actions (<=7, prioritized)
- Ask up to 1 clarifying question
If nothing is actionable: reply HEARTBEAT_OK and add a one-sentence reason on the next line.

Do NOT perform web searches during heartbeat unless Mark explicitly instructed you to monitor a named topic.
Do NOT infer tasks from prior conversations.
