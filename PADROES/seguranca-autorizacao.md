# Padrão: Autorização, whitelist e segurança operacional

**Referência:** SHELDON (autorização self-service), THEO, Sentinel/Artoo (secret-leak).

## Auth gate (todos os notifiers sérios)
- Whitelist de IDs Telegram (`SHELDON_SUPERADMIN_IDS`, admins do grupo via `getChatAdministrators`).
- Quem não está na whitelist é **ignorado silenciosamente** — não recebe erro (não vaza existência de comandos).
- Comandos destrutivos/sensíveis (`/learn`, `/forget`, `/disparar`, `/g`, `/fixar`) só superadmin.

## Autorização self-service (só Sheldon — candidato a padrão)
`/start` de um novo usuário → notifica o superadmin com botões inline **Aprovar/Rejeitar**
(`approve_admin`/`reject_admin`). Onboarding sem editar env à mão.

## Segredos (ADR-005 → ADR-006 proposta)
- **Hoje:** token/chaves em `~/.env` por host (chmod 600), nunca no repo.
- **Dívida conhecida:** secrets hardcoded já apareceram (`RTSP_PASS` em `nexus/scripts/dvr-check.py`,
  `ADMIN_TIME_ID`/`SHELDON_SUPERADMIN_IDS` default em código). O vigia `secret_exposto` 🔑 do Sentinel
  existe justamente por isso — deveria rodar sobre todos os repos.
- **Caminho recomendado:** `systemd-creds` (ganho imediato, sem infra) → Infisical self-hosted
  (realização do "MATRIX como cofre central" do ADR-005). SOPS+age se preferir GitOps puro.

## Validação de entrada externa
- Webhook GitHub→Telegram valida HMAC `X-Hub-Signature-256` (`WEBHOOK_SECRET`) — Sentinel/Artoo.
- Foto/PDF recebidos passam por classificação (vision/heurística "é TI?") antes de ingerir — Sheldon.
