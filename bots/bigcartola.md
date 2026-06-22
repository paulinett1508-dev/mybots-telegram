# BigCartola

- **Username:** `@bigcartola_bot`
- **Bot ID numérico:** `8667204937` — token em produção, no vault (`BIGCARTOLA_TOKEN`). Rotação adiada (risco residual aceito).
- **Persona:** "o olho que tudo vê" — comentarista/oráculo da liga Cartola FC e da Copa 2026.
- **Repo de origem:** `SuperCartolaManagerv5-production`
- **Stack:** Node.js (ESM, node ≥ 20) + **grammY** `^1.30.0` (long-polling). É o único bot da
  família que usa SDK; todos os outros falam Bot API HTTP crua.
- **Auxiliares:** `dotenv`, `mongodb` (driver nativo), `groq-sdk` (llama-3.3-70b).

## Arquitetura
Dois processos: o app principal **só enfileira eventos no MongoDB** (`utils/telegram-eventos.js`);
o microsserviço `bigcartola/` consome a fila e posta no Telegram. App ↔ bot autenticam por
header `x-bigcartola-token` (`BIGCARTOLA_SERVICE_TOKEN`).

Opera em dois modos:
- **Liga Mode** (Cartola): chat RAG da liga (ranking, saldo, Pontos Corridos, Mata-Mata, Resta Um);
  broadcast de rodada consolidada e avisos no grupo único `TELEGRAM_GROUP_ID`.
- **Copa Mode** (Copa 2026): engine de broadcasts ao vivo por múltiplos grupos, cada grupo ligado
  a um bolão na API 365scores via `COPA_GROUP_MAPPING`.

## Capacidades
- Comandos: `/start <token>` (deep-link de vínculo de conta, uso único; trata também
  `copa`, `ranking_<id>`, `premiacao_<id>`), `/status`, `/ajuda`, `/copa`, `/premiacao`,
  `/aprender <fato>` (admin), `/g`, `/disparar`, `/fixar`, `/apagar` (GOD-only).
- **Chat livre RAG + LLM** (Groq) com **filtro de conteúdo** (bloqueia receitas/sexo/política/etc.),
  rate-limit anti-flood + teto diário, respostas deferidas (60s) em grupo, resposta a menção/reply.
- **Broadcast Liga** (poll 60s em `GET /api/telegram/eventos-pendentes`): rodada consolidada
  (mito/mico/top3), aviso publicado.
- **Copa Engine**: poll adaptativo (2/15/30 min), gols ao vivo, parciais T+5min, palpites,
  resultado final, lembrete pré-jogo (1h), novo líder, ranking diário, boletim 8h BRT, saída de
  participantes. Anti-duplicata em coleções MongoDB. Usa `inline_keyboard` (deep-links),
  `pinChatMessage`, `getChatMember`, `deleteMessage`.
- **Dispatch CLI** (`dispatch-server.js`): HTTP local `127.0.0.1:3200`, broadcast manual autenticado.
- **Reminder** agendado (DM ao GOD).

## Único dele (candidato a propagar)
- **Filtro de conteúdo** no chat livre — nenhum outro bot tem.
- **Rate-limit por usuário** (anti-flood + teto diário) — só ele.
- **Deep-link de vínculo de conta** (`/start <token>` de uso único ligando conta do app web ao
  Telegram) — só ele.
- **Engine de broadcast ao vivo orientada a API externa** com poll adaptativo + anti-duplicata
  por snapshot — o mais sofisticado da família nesse eixo.

## Não tem (candidato a receber)
- ACK por `inline_keyboard` com `callback_query` (tem botões só como deep-links, não como ack de estado).
- Alerta-como-estado / `editMessageText` (posta eventos novos, não edita mensagem viva).
- Roteamento por tópicos de supergrupo (`message_thread_id`).
- Escalação por silêncio.

## Configs (env, sem valores)
`TELEGRAM_BOT_TOKEN`, `TELEGRAM_GROUP_ID`, `COPA_GROUP_MAPPING`, `GOD_TELEGRAM_ID`,
`BOT_USERNAME`/`BIGCARTOLA_BOT_USERNAME`, `BIGCARTOLA_SERVICE_TOKEN`, `DISPATCH_SECRET`/`DISPATCH_PORT`,
`GROQ_API_KEY`/`GROQ_MODEL`/`GROQ_MAX_TOKENS`, `MONGO_URI`, `BOLAO_365_TOKEN`/`BOLAO_365_BASE_URL`,
`RATE_LIMIT_DIARIO`, `LLM_RATE_LIMIT_DIARIO`, `DRY_RUN`, `BROADCAST_INTERVALO_MS`.
Hardcoded: `ADMIN_TIME_ID = 13935277` em `controllers/telegramController.js`.

## Arquivos-chave
- `bigcartola/src/bot.js` — entrypoint grammY.
- `bigcartola/src/comandos.js` — handlers + rate-limit.
- `bigcartola/src/chat-handler.js` — chat RAG/LLM.
- `bigcartola/src/broadcast.js` — consumidor de eventos Liga.
- `bigcartola/src/copa-engine.js` — engine de broadcasts Copa.
- `bigcartola/src/dispatch-server.js` — dispatch manual.
- `controllers/telegramController.js`, `routes/telegram-routes.js`, `utils/telegram-eventos.js` — integração no app.
