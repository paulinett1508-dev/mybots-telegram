# Obi-Wan

- **Username:** `@guardiao_universo_bot`
- **Bot ID numérico:** `8385018866` — token em produção, no vault (`OBIWAN_TOKEN`). Rotação adiada (risco residual aceito).
- **Persona:** conselheiro/oráculo do ecossistema "TheUniverse" (observatório dos repos do org).
  Único bot da família conversacional puro voltado a *navegar repos*.
- **Repo de origem:** `theuniverse` (em `obi-wan/`)
- **Stack:** Python 3.12 + `httpx` contra a Bot API (long-polling). RAG via BM25 (`rank-bm25`)
  + LLM Groq (llama-3.3-70b). Deploy systemd (host Polaris).

## Capacidades
- Long-poll `getUpdates`; **allowlist de chat único** (`SOL_CHAT_ID` / "TheGod"), ignora qualquer outro.
- Sem comandos slash — interpreta texto livre via RAG BM25 + LLM.
- **Detecção de planeta + confirmação de "órbita":** menção a um repo conhecido → manda sticker e
  pergunta "entro na órbita?"; aceita confirmação/negação por linguagem natural. Repos "soberanos"
  (`the-matrix`, `matrix-core`) recebem aviso especial.
- **Reply contextual:** detecta `reply_to_message`; se for reply a uma notificação, extrai fatos
  (`brain._parse_notification`: repo, branch, horário, commits) e entra na órbita automaticamente.
- `sendChatAction` (typing), **stickers por estado** (`orbit_proposed/confirmed/denied/no_info`),
  HTML, histórico de 10 turnos.

## Único dele (candidato a propagar)
- **Stickers por estado de conversa** — nenhum outro bot usa stickers como sinal de UX.
- **Confirmação de contexto ("entrar em órbita")** antes de gastar LLM num repo — bom padrão de
  controle de custo/foco; outros oráculos respondem direto.
- **Parse de notificação em reply** para auto-contextualizar — elegante; THEO/Sheldon poderiam usar.

## Não tem (candidato a receber)
- Alerta-como-estado / tópicos / escalação (é conversacional puro, por design).
- Filtro de conteúdo / rate-limit.

## Configs (env, sem valores) — `obi-wan/config.py`
`TELEGRAM_TOKEN`, `SOL_CHAT_ID`, `GROQ_API_KEY`/`GROQ_MODEL`. (Webhook/Artoo: `WEBHOOK_SECRET`,
`UNIVERSE_PAT`/`GITHUB_TOKEN`/`ARTOO_TOKEN`.)

## Arquivos-chave
- `obi-wan/bot.py` — bot conversacional (long-polling, stickers, órbitas).
- `obi-wan/brain.py` — `_parse_notification()` + LLM Groq.
- `obi-wan/config.py`, `obi-wan/obi-wan.service`, `obi-wan/deploy.sh`.
