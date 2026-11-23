# Public showcase workflow

This repository contains one sanitized snapshot from the private development repository, published on 23 November 2026. It has no production branch, deployment connection, customer database or production credentials. Historic references in the source documentation describe earlier reviewed product versions; they are not deployment instructions for this repository.

## Changes and verification

Use a branch and pull request for future updates. Preserve the source-available license and fictional demo fixtures. Before publishing another snapshot, review its complete contents for secrets, customer records, private URLs and operational history. Do not copy private branches or commit history.

Follow [LOCAL_CI_POLICY.md](LOCAL_CI_POLICY.md). Routine checks run directly on the laptop or mini PC; the existing [CI workflow](https://github.com/IamRedi/redionflow-showcase/actions/workflows/ci.yml) runs only when cloud verification is explicitly selected. Required assertions and review gates remain in effect.

The local application commands remain:

```bash
npm ci
npm run db:generate
npm run lint
npm run typecheck
npm test
npm run build
npm run test:integration:local
npm run test:e2e:local
```

Integration/browser wrappers require their documented disposable database prerequisites. Never supply production databases or customer credentials for showcase verification.

## Security maintenance

The explicitly requested security-watch workflow performs scheduled passive checks of public sites and a production-dependency audit. Its target list excludes the private AL-Steel application. Dependabot proposes weekly npm and monthly Actions updates. Scheduled operational checks are separate from routine development CI; do not dispatch them simply to claim a local test result.

## Deployment boundary

This showcase must not deploy the private product. Product release branches, approvals, backups, environment variables and runtime verification belong to the private development repository. No production Git branch or Railway configuration is changed by publishing this source snapshot.
