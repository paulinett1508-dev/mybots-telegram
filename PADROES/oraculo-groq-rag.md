# Padrão: Oráculo (Groq LLM + RAG)

**Referência:** SHELDON, THEO, HERMES, Obi-Wan, BigCartola. Todos sobre Groq `llama-3.3-70b-versatile`.

## Princípio
O lado "responde perguntas" do bot **nunca responde de memória**. Sempre injeta: persona +
**estado real** do domínio (infra/liga/SAP…) + **RAG documental**. O LLM redige; os fatos vêm do contexto.

## Variantes de RAG no ecossistema
- **BM25** (`rank-bm25`) — Obi-Wan. Leve, sem serviço.
- **Markdown/docs em arquivo** (`conhecimento.md`, `custom.md`) — THEO, Sheldon. `/aprender`/`/learn` editam.
- **Qdrant (vector store)** — HERMES (`lab_knowledge`). Mais escalável; candidato a padrão se a base crescer.

## Gatilhos de ativação (quando o oráculo fala)
- Menção ao `@username`, `reply` ao bot, ou prefixo de nome ("Theo", "sheldon").
- No privado: só admins.
- Obi-Wan: allowlist de chat único + confirmação de contexto ("entrar em órbita") antes de gastar LLM.

## Higiene
- `sendChatAction` (typing) antes de responder.
- Respostas deferidas em grupo (BigCartola: 60s) para agrupar.
- Filtro de conteúdo + rate-limit (só BigCartola — ver PROPAGACAO).
