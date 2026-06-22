# HERMES

- **Username:** `@sbrhermesagent_bot`
- **Bot ID numérico:** `8897587372` — token em produção, no vault (`HERMES_TOKEN`). Rotação adiada (risco residual aceito).
- **Persona:** agente consultivo RAG (pergunte-e-responda) + digest de issues. Voz consultiva do
  grupo MATRIX. Acrônimo da família de entidades virtuais.
- **Repo de origem:** `nexus-labsobral` (container externo) / especificado em `the-matrix`
- **Stack:** agente LLM conteinerizado externo (`image: hermes-agent`, base
  `NousResearch/hermes-agent`) — bot Telegram próprio embutido, fora do código do repo.
  Lê config de `/opt/hermes/.env`.

## Capacidades
- **RAG consultivo** sobre `lab_knowledge` (Qdrant): responde perguntas no grupo MATRIX.
- **Digest diário read-only** no grupo MATRIX: issues por condado, críticas, consultas pendentes.
- Roadmap: notificações proativas (push, não só pull).

## Único dele (candidato a propagar)
- **RAG com vector store dedicado (Qdrant)** — os outros usam RAG mais simples (BM25/docs em md).
  Se a base de conhecimento crescer, é o padrão de RAG mais escalável da família.
- **Papel puramente consultivo** (não notifica infra) — modelo limpo de separação de responsabilidade.

## Não tem (candidato a receber)
- Notificações proativas/push (ainda só pull) — Sheldon/Theo já têm.

## Configs (env, sem valores) — `/opt/hermes/.env`
`TELEGRAM_BOT_TOKEN`, `TELEGRAM_ALLOWED_USERS`, `GROQ_API_KEY`.

## Arquivos-chave
- `servers/nexus-vps01/hermes/docker-compose.yml`, `hermes/deploy.sh` (nexus-labsobral).
- Specs/design em `the-matrix` (`entidades/virtuais.md`, planos Hermes).
