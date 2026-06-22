# S.H.E.L.D.O.N.

- **Username:** `@sheldonsbr_bot`
- **Bot ID numérico:** `8841226177` — token em produção, no vault (`SHELDON_TOKEN`). Rotação adiada (risco residual aceito).
- **Persona:** bot principal de infra/observabilidade da rede interna NEXUS (Lab Sobral).
  Notificador de alerta + chatops conversacional. É o arquétipo que THEO herdou.
- **Repo de origem:** `nexus-labsobral` (em `sheldon/notifier/`)
- **Stack:** Python + `httpx` (async) contra a Bot API. Sem lib de bot.

## Capacidades (o mais completo da família)
- **Alerta-como-estado:** P1 (🔴) / P2 (🟡) roteados por tópico; ciclo cria → edita → escala →
  resolve (com duração). Supressão de flapping.
- **Roteamento por tópico** (`message_thread_id`): crítico / avisos / resumos / dia.
- **ACK + Runbook inline:** botões `✅ Reconhecer` e `📖 Runbook`; callbacks `ack`, `run`, `mute`.
- **Escalação por silêncio:** P1 sem ACK → @menção, intervalos 15/30 min.
- **Quiet hours** + **digests agendados**: matinal, vespertino, encerramento do dia, e digest do
  Pi-hole (loops asyncio em `scheduler.py`).
- **Notificação de deploy:** resume commits via Groq e posta no grupo + DM dos admins (`git_notify.py`).
- **Autorização self-service:** `/start` → superadmin aprova/rejeita novos admins via botões inline
  (`approve_admin`/`reject_admin`). Auth gate: ignora silenciosamente quem não está na whitelist.
- **Recebe fotos** → vision model classifica se é contexto de TI antes de aceitar.
- **Recebe documentos/PDF** → heurística "parece TI?".
- Comandos: `/start`, `/sheldon`, `/prioridades` (estáticos), `/learn`, `/forget` (superadmin,
  editam KB RAG `custom.md`). Menção a "sheldon" no grupo → resposta LLM (Groq).
- Métodos: `sendMessage`, `editMessageText`, `answerCallbackQuery`, `getFile` + download, `getUpdates`.

## Único dele (candidato a propagar — alto valor)
- **Botão `📖 Runbook` inline** ligando alerta a procedimento — ninguém mais tem.
- **Classificação de foto via vision model** e **heurística de documento/PDF** — só ele.
- **Fluxo de autorização self-service de admins** por botão inline — só ele (THEO/outros não têm).
- **Notificação de deploy com resumo de commits via Groq** — só ele.
- **Supressão de flapping** — só ele.

## Não tem (candidato a receber)
- Deep-link de vínculo de conta (BigCartola).
- Filtro de conteúdo / rate-limit por usuário no chat (BigCartola).

## Configs (env, sem valores) — `fileexplorer/config.py`
`TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`, `TELEGRAM_TOPIC_CRITICO`/`_AVISOS`/`_RESUMOS`/`_DIA`,
`MATRIX_CHAT_ID`, `MATRIX_TOPIC_DIALOGO`/`_MUNDO`/`_CONSELHO`, `SHELDON_SUPERADMIN_IDS`
(default hardcoded `1030157568`), `NOTIFY_*` (intervalos/quiet/escalonamento/flap/digest),
`NOTIFY_ADMIN_MENTION`, `GROQ_API_KEY`/`GROQ_MODEL`, `NOTIFY_AI_ENABLED`.

## Arquivos-chave
- `sheldon/notifier/channels/telegram.py` — adapter Bot API (envio, edição, callbacks, keyboards, download).
- `sheldon/notifier/dispatcher.py` — orquestração (alertas, comandos, autorização, fotos/docs).
- `sheldon/notifier/scheduler.py` — loops asyncio (tick, poll, digests).
- `sheldon/notifier/channels/groq_chat.py` — IA conversacional.
- `fileexplorer/api/git_notify.py` — notificação de deploy.
- `fileexplorer/tests/test_notifier_telegram.py`, `test_notifier_dispatcher.py` — testes.
