# T.H.E.O.

- **Username:** `@theosbr_bot`
- **Bot ID numérico:** `8827228415` — token em produção, no vault (`THEO_TOKEN`). Rotação adiada (risco residual aceito).
- **Persona:** entidade de inteligência operacional do TI do Laboratório Sobral. Notificador único
  + oráculo de perguntas. Criado via BotFather em 2026-06-06. Design herdado do "SHELDON".
- **Repo de origem:** `sbrgestao` (em `scripts/theo/`)
- **Stack:** Python 3, **stdlib pura** (`urllib.request`) contra a Bot API. Sem libs de bot.
  Única dep opcional do projeto: `jsonschema`. Deploy: systemd user service (`Restart=always`).

## Arquitetura
Duas threads: long-poll `getUpdates` (~50s) na principal; vigias/heartbeats num tick ~60s em thread
separada. Estado em `~/.theo/state.json`; offset em `~/.theo/update_offset`.

## Capacidades
- **Notificações como ESTADO** (não evento): ~13 serviços monitorados via HTTP probe + `docker ps`.
  Cada condição vira alerta com `key` estável → **uma mensagem viva editada** (`editMessageText`):
  resolve → edita com ✅ riscado; escala severidade → fecha e reabre no tópico certo.
- **Roteamento por tópico** (`message_thread_id`): crítico / avisos / resumos.
- **Quiet hours** 21h–06h seguram 🟡; críticos passam sempre.
- **ACK inline:** alertas críticos com botão "✅ Reconhecer" (`callback_data=ack:<key>`),
  tratado em `processa_callback` (`answerCallbackQuery`).
- **Escalação por silêncio:** crítico sem ACK por 15/30 min → @menção ao "Arquiteto"
  (dono via `getChatAdministrators`).
- **Digests:** diário 07h (tópico resumos); semanal de issues paradas (segunda 7h).
- **GitHub issues** (via `gh` CLI, `issue_poller.py`): issue nova/crítica vira alerta vivo.
- **Oráculo:** responde quando endereçado (menção `@theosbr_bot`, reply, ou texto iniciando com
  "Theo"); no privado só admins. Groq (llama-3.3-70b) + persona + estado real + RAG documental;
  nunca de memória. `sendChatAction` (typing) antes.
- Comando `/aprender <fato>` — só superadmin (creator do grupo); grava em `conhecimento.md`.
- **Embaixada:** processa inbox de envelopes (`embaixada.py`), escala decisões à MATRIX e captura
  resposta do Arquiteto via reply.
- Métodos Bot API: `sendMessage`, `editMessageText`, `deleteMessage`, `getUpdates`,
  `getChatAdministrators`, `answerCallbackQuery`, `sendChatAction`.
- CLI: `--once`, `--selftest`, `--ask "pergunta"`.

## Único dele (candidato a propagar)
- Junto com Sheldon, é a referência de **alerta-como-estado + escalação por silêncio**.
- **CLI de selftest/ask** (`--selftest`, `--ask`) — bom padrão de operabilidade.

## Não tem (candidato a receber)
- Recebimento/classificação de fotos e documentos (Sheldon tem).
- Filtro de conteúdo e rate-limit por usuário (BigCartola tem).
- Fluxo de autorização self-service de novos admins por botão (Sheldon tem).

## Configs (env, sem valores) — lidos de `~/.theo.env`
`TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`, `TELEGRAM_TOPIC_CRITICO`/`_AVISOS`/`_RESUMOS`,
`MATRIX_CHAT_ID`, `GROQ_API_KEY`, `THEO_DESTINATARIO`. Hardcoded: `BOT_USERNAME = "theosbr_bot"`.

## Arquivos-chave
- `scripts/theo/dispatcher.py` — núcleo (toda lógica Telegram, oráculo, callbacks, loop).
- `scripts/theo/dispatcher_issues.py`, `issue_poller.py` — issues.
- `scripts/theo/embaixada.py` — protocolo entre entidades.
- `scripts/theo/rag_*.py` — RAG.
- `docs/THEO.md` — runbook.
