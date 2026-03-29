---
name: agentmail
description: Use the local AgentMail CLI to send, receive, inspect, label, draft, thread, webhook, domain, pod, organization, metrics, and API key operations for AgentMail inboxes. Trigger when working with email in AgentMail from the shell: listing inboxes, reading messages, replying/forwarding, sending drafts, marking read/unread via labels, trashing/restoring messages, inspecting raw email/attachments, checking threads, managing pods/webhooks/domains, or discovering CLI behavior from installed help output.
---

# AgentMail

Use the installed CLI at:

```bash
~/.openclaw/workspace/node_modules/.bin/agentmail
```

## Quick rules

- Prefer the installed CLI over guessing the API.
- Check `--help` on the exact subcommand before doing anything non-trivial.
- Treat `.env` carefully: values sourced with `. .env` are not automatically exported. For one-off commands, prefer either:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail ...
```

or:

```bash
export $(cat .env | xargs)
~/.openclaw/workspace/node_modules/.bin/agentmail ...
```

- By observation, retrieving a message does **not** mark it read.
- By observation, regular message listing appears to exclude messages labeled `trash`.
- Do not assume a destructive command exists. Inspect help first.

## Environment setup

Preferred pattern inside the workspace:

```bash
cd ~/.openclaw/workspace
export $(cat .env | xargs)
~/.openclaw/workspace/node_modules/.bin/agentmail --help
```

If only AgentMail auth is needed, this is simpler and safer:

```bash
cd ~/.openclaw/workspace
AGENTMAIL_API_KEY=$(grep '^AGENTMAIL_API_KEY=' .env | cut -d= -f2-)
~/.openclaw/workspace/node_modules/.bin/agentmail inboxes list
```

## High-value workflows

### List inboxes

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes list
```

### Retrieve one inbox

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes retrieve --inbox-id <inbox_id>
```

### List messages in an inbox

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages list --inbox-id <inbox_id>
```

Useful filters discovered from help:
- `--label`
- `--after`
- `--before`
- `--ascending`
- `--include-spam`
- `--limit`
- `--page-token`

Examples:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages list \
  --inbox-id <inbox_id> \
  --label unread \
  --limit 20
```

### Retrieve a full message

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages retrieve \
  --inbox-id <inbox_id> \
  --message-id <message_id>
```

Observed difference from `list`: retrieve returns full body material such as `text`, `html`, `extracted_text`, and `extracted_html` when available.

### Mark/label a message

Message updates are label-based:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages update \
  --inbox-id <inbox_id> \
  --message-id <message_id> \
  --add-label <label>
```

Remove a label:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages update \
  --inbox-id <inbox_id> \
  --message-id <message_id> \
  --remove-label <label>
```

Observed working pattern for trashing:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages update \
  --inbox-id <inbox_id> \
  --message-id <message_id> \
  --add-label trash
```

Because message deletion was not exposed in `inboxes:messages`, prefer trash-labeling over claiming hard delete exists.

### Send a new message

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages send \
  --inbox-id <inbox_id> \
  --to "recipient@example.com" \
  --subject "Hello" \
  --text "Message body"
```

Supported send fields from help:
- `--to`
- `--cc`
- `--bcc`
- `--reply-to`
- `--subject`
- `--text`
- `--html`
- `--headers`
- `--attachment`
- `--label`

### Reply / reply-all / forward

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages reply \
  --inbox-id <inbox_id> \
  --message-id <message_id> \
  --text "Reply body"
```

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages reply-all \
  --inbox-id <inbox_id> \
  --message-id <message_id> \
  --text "Reply all body"
```

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages forward \
  --inbox-id <inbox_id> \
  --message-id <message_id> \
  --to "recipient@example.com"
```

### Raw message / attachments

Retrieve raw email:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages get-raw \
  --inbox-id <inbox_id> \
  --message-id <message_id>
```

Retrieve one attachment from a message:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:messages get-attachment \
  --inbox-id <inbox_id> \
  --message-id <message_id> \
  --attachment-id <attachment_id>
```

### Threads

List threads for one inbox:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:threads list --inbox-id <inbox_id>
```

Retrieve one thread:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:threads retrieve \
  --inbox-id <inbox_id> \
  --thread-id <thread_id>
```

Delete a thread exists at the CLI level:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:threads delete \
  --inbox-id <inbox_id> \
  --thread-id <thread_id>
```

There is also thread attachment retrieval:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:threads get-attachment \
  --inbox-id <inbox_id> \
  --thread-id <thread_id> \
  --attachment-id <attachment_id>
```

### Drafts

Create a draft:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:drafts create \
  --inbox-id <inbox_id> \
  --to "recipient@example.com" \
  --subject "Draft" \
  --text "Draft body"
```

Update a draft:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:drafts update \
  --inbox-id <inbox_id> \
  --draft-id <draft_id> \
  --text "Updated body"
```

List drafts:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:drafts list --inbox-id <inbox_id>
```

Send a draft:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:drafts send \
  --inbox-id <inbox_id> \
  --draft-id <draft_id>
```

Delete a draft:

```bash
AGENTMAIL_API_KEY=... ~/.openclaw/workspace/node_modules/.bin/agentmail inboxes:drafts delete \
  --inbox-id <inbox_id> \
  --draft-id <draft_id>
```

## Broader resources exposed by the CLI

The installed CLI exposes more than the subset in the external skill doc.

### Inboxes
- `create`
- `retrieve`
- `update`
- `list`
- `delete`
- `list-metrics`

### Messages
- `list`
- `retrieve`
- `update`
- `send`
- `reply`
- `reply-all`
- `forward`
- `get-raw`
- `get-attachment`

### Threads
- Inbox-scoped threads: list, retrieve, delete, get-attachment
- Global threads: `threads list`, `threads retrieve`, `threads retrieve-attachment`

### Drafts
- Inbox-scoped drafts: create, retrieve, update, list, delete, send
- Pod/global listing/retrieval also exist: `pods:drafts`, `drafts`

### Pods
- `pods create/list/retrieve/delete`
- `pods:inboxes create/list/retrieve/delete`
- `pods:threads list/retrieve`
- `pods:domains create/list/delete`
- `pods:drafts list/retrieve`

### Webhooks
- `create`
- `retrieve`
- `update`
- `list`
- `delete`

### Domains
- `create`
- `retrieve`
- `list`
- `delete`
- `verify`
- `get-zone-file`

### Other global resources
- `organizations retrieve`
- `metrics list`
- `api-keys create/list/delete`

## Output handling

Global output flags from the CLI:
- `--format auto|explore|json|jsonl|pretty|raw|yaml`
- `--transform`
- `--format-error`
- `--transform-error`
- `--debug`
- `--base-url`
- `--environment`
- `--api-key`

For reliable automation, prefer:

```bash
--format json
```

## What was observed directly

These are empirical findings from the installed CLI, not assumptions:

- CLI version reported: `0.7.4`
- `agentmail inboxes list` works when `AGENTMAIL_API_KEY` is exported/passed correctly.
- `source .env` alone exposed the variable in shell expansion but did not make the CLI authenticate; explicitly exporting or inline env assignment worked.
- `inboxes:messages retrieve` returned full content fields beyond preview/list metadata.
- `inboxes:messages retrieve` did not remove the `unread` label.
- `inboxes:messages update --add-label trash` caused the message to disappear from the normal `inboxes:messages list` view.
- No `inboxes:messages delete` subcommand was exposed by help.

## References in this skill

Read these files when needed:

- `references/cli-help.txt` — top-level CLI help and major resource groups
- `references/subcommand-help.txt` — subcommand help captures for inboxes/messages/threads/drafts/webhooks/domains/pods
- `references/extra-help.txt` — additional help for update/metrics/organizations/api-keys/global resources
- `references/live-examples.json` — real captured output from this environment for list/retrieve operations

## Suggested operating style

1. Discover capabilities with `--help` first.
2. Use `--format json` when parsing or quoting output matters.
3. Prefer label mutation for mailbox state changes.
4. Verify side effects by re-listing after updates.
5. If the user asks for “exact output”, send the raw CLI output verbatim rather than summarizing it.
