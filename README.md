# OpenClaw Skills

A collection of specialized skills and utilities for OpenClaw agents. Each skill extends the core capabilities with domain-specific tools and workflows.

## What's Inside

Skills are organized by function and can be imported into OpenClaw agents to unlock new capabilities. Each skill includes:

- **SKILL.md** — Complete documentation and workflow
- **Scripts** — Executable utilities (shell, Python, etc.)
- **References** — Data files, lookups, templates

## Structure

```
skills/
├── skill-name/
│   ├── SKILL.md          # Main documentation
│   ├── scripts/          # Executable files
│   ├── references/       # Data files & lookups
│   └── README.md         # Skill-specific notes
```

## Getting Started

1. Copy a skill folder into your agent's skills directory
2. Read the SKILL.md file for full usage instructions
3. Configure any required environment variables
4. Call the skill with the appropriate parameters

## Contributing

Skills are community-driven. Found a gap? Build a skill and share it.

## Available Skills

- **calorie-tracker** — Process food journals, calculate daily intake, send notifications
- **weather** — Current weather and forecasts via wttr.in or Open-Meteo
- **healthcheck** — Security hardening and risk assessment for OpenClaw deployments
- **node-connect** — Diagnose and fix OpenClaw node connection issues
- **skill-creator** — Create, audit, and improve new skills

See individual SKILL.md files for detailed documentation.

---

*Maintained by Clawdius & co.*
