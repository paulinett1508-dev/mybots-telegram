# ROADMAP — Poderes do Sentinel

O **motor** (Sentinel @ `theuniverse`) é quem varre todos os repos do org, decide e dispara via os
notificadores. Este roadmap é o que `sentinel-core` (governança) define como contrato; o Sentinel
implementa. Score de postura por repo é o destino: cada repo recebe uma nota de conformidade.

Legenda: ✅ feito · 🚧 em andamento · ⬜ planejado.

## Segurança
- ✅ **Secret-audit de conteúdo** — `theuniverse/scripts/secret_scan.py` + workflow diário. Regex de
  conteúdo (token, PEM, PAT, senha hardcoded) complementando o secret-scanning nativo. Notifica 🔑.
- ⬜ **Repo público com segredo** = alerta P1 imediato (cruzar visibilidade × achados).
- ⬜ **Rotação rastreada** — registrar quando um segredo flagrado foi rotacionado/remediado.

## Compliance
- 🚧 **Branch protection** — aplicada nos **19 repos públicos** + core (force-push e deleção barrados,
  enforce em admin; sem exigir PR pra não travar push direto/workflows). **8 privados pendentes**
  (`nexus-labsobral`, `the-matrix`, `sbrgestao`, `sbrchecks`, `sigmed`, `FinanceFlow`, `GessoExpress`,
  `mcp-eventos`): branch protection em repo privado exige **GitHub Pro** (HTTP 403 no plano free).
  > OBS (2026-06-23): Pro adiado por decisão do Arquiteto. Quando assinar, re-rodar a proteção nos 8
  > privados (o 403 é teto de plano, não de permissão — o PAT já tem Administration: write).
- ⬜ **Arquivos obrigatórios**: LICENSE, README, CODEOWNERS, SECURITY.md, .gitignore.
- ⬜ **CI presente** e verde no default branch.
- ⬜ **Visibilidade intencional** — repo público só com flag explícita; senão alerta.

## Auditoria & Postura
- ⬜ **Score de postura por repo** (0–100): segurança + compliance + boas práticas, publicado no Telegram.
- ⬜ **Digest semanal** de postura do org (ranking de repos, regressões).
- ⬜ **Drift** — repo que sai de conformidade após estar OK gera alerta.

## Boas práticas
- ⬜ **Testes presentes** + cobertura mínima onde aplicável.
- ⬜ **SCA / dependências** — vulnerabilidades conhecidas (Dependabot/osv).
- ⬜ **Estrutura consistente** por tipo de projeto.

## Convergência
- ⬜ **agnostic-core adotado** — todo repo do org tem o submódulo + CLAUDE.md derivado.
- ⬜ **CI/CD convergente** — mesmos workflows-base (lint, test, secret-audit) em todos.
- ⬜ **Naming/lore** consistente com o ecossistema (Matrix/Universe/Nexus).

## Embaixada (integração à Matrix)
- ✅ **Contrato `posture-status@1`** no matrix-core (entidade `sentinel` registrada).
- ✅ **Sentinel emite postura** (`state/posture-status.json`) a cada run — estado vivo por repo
  (score 0–100, visibilidade, achados redigidos com `ref_key`). Outras entidades referenciam.
- ⬜ Bridge host: sincronizar `posture-status.json` para `entity-exchange/posture/sentinel.json`.
- ⬜ Bot próprio do Sentinel (corrigir SPOF; hoje reusa Obi-Wan).

## Entrega (notificadores)
- ✅ Canal Telegram do Sentinel (`secret_exposto` nativo + secret-audit).
- ⬜ Ver [`PROPAGACAO.md`](PROPAGACAO.md) — propagar alerta-como-estado, ACK inline, escalação,
  dead-man's-switch para todos os notificadores; bot dedicado para as Sentinelas (corrigir SPOF).

---
Cada item que sair de ⬜ vira issue/PR no `theuniverse` (motor) e atualiza este arquivo + a matriz.
