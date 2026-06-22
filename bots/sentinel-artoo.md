# Sentinel & Artoo (TheUniverse)

Personas que **compartilham o mesmo bot físico** do Obi-Wan (`@guardiao_universo_bot`,
ID `8385018866`, mesmo `TELEGRAM_TOKEN`). Confirmado pelo `/mybots`: não há bot separado para
Sentinel/Artoo. São os componentes *só-envio* do observatório TheUniverse — Obi-Wan é o único que recebe.

- **Repo de origem:** `theuniverse` (`scripts/`, `webhook/`)
- **Stack:** Python stdlib (`urllib.request`) nos scripts; FastAPI + `httpx` no receiver.

## Sentinel — "Sistema Nervoso" (`scripts/sentinel.py`)
- Notificador agendado (GitHub Actions, cron 15 min). Faz polling da API GitHub de todos os repos
  do org, compara com `state/sentinel-state.json` e emite eventos: `novo_planeta` 🆕,
  `planeta_sumido` 💥, `ci_falhou` 🔴, `issue_nova` 🚨, `secret_exposto` 🔑.
- Em `ci_falhou`, dispara o **Artoo** automaticamente.

## Artoo (`scripts/artoo.py`)
- Mensageiro: abre issue de alerta no repo afetado (label `observatory-alert`) e notifica o dono no
  Telegram em 3 momentos: 🛸 lançamento, ✅ entrega (issue #N), ❌ falha.
- `carta_apresentacao.py`: abre issue de boas-vindas em todos os repos.

## Webhook Receiver (`webhook/receiver.py`)
- Bridge **GitHub → Telegram** (FastAPI, porta 9120, systemd). Valida HMAC `X-Hub-Signature-256`
  (`WEBHOOK_SECRET`). Formata `push` (commits/branch/autor) e `pull_request`
  (aberto/mergeado/fechado/reaberto) e envia via `sendMessage`. Endpoint `/health`.
- Nota: é webhook *do GitHub*, não `setWebhook` do Telegram. A família inteira recebe via long-poll.

## Único deles (candidato a propagar — alto valor)
- **`secret_exposto` 🔑**: detecção de segredo vazado em repo como evento de alerta — dado o histórico
  de secrets hardcoded no ecossistema (RTSP em nexus, RTSP em dvr-check), este vigia deveria ser padrão.
- **Bridge GitHub→Telegram via webhook com HMAC** — tempo real, complementa o poll de 15 min do Sentinel.
- **Auto-encadeamento Sentinel→Artoo** (evento dispara abertura de issue + notificação) — automação fim-a-fim.

## Configs (env, sem valores)
`TELEGRAM_TOKEN`, `SOL_CHAT_ID`, `WEBHOOK_SECRET`, `UNIVERSE_PAT`/`GITHUB_TOKEN`/`ARTOO_TOKEN`.
GitHub Actions: `secrets.TELEGRAM_TOKEN`, `secrets.SOL_CHAT_ID`, `secrets.UNIVERSE_PAT`.

## Arquivos-chave
- `scripts/sentinel.py` — notificador agendado.
- `scripts/artoo.py` — mensageiro/abre issues.
- `webhook/receiver.py` — bridge GitHub→Telegram.
- `.github/workflows/sentinel.yml` — cron 15 min.
