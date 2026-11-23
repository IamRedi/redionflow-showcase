# RediON Connect entry point

Shared operating rules: read [workspace-core](https://github.com/IamRedi/redion-connect/blob/plugin-source/plugin/skills/workspace-core/SKILL.md), then its applicable skills. This file is a routing pointer, not a policy copy.

## Showcase boundary

This repository is a sanitized, source-available public snapshot. Active product development, customer operations and deployment history remain private. Do not add customer data, private endpoints, credentials or production branches. Existing demo images use fictitious data. Preserve the source-available license.

## Local verification

Follow [docs/LOCAL_CI_POLICY.md](docs/LOCAL_CI_POLICY.md). Repository commands are in package.json and the READMEs: npm ci, npm run db:generate, npm run lint, npm run typecheck, npm test and npm run build. Integration and browser checks use the documented disposable local database wrappers. No routine push/PR cloud verification or production deployment. The explicitly requested scheduled passive security watch and dependency updates are separate operational checks.
