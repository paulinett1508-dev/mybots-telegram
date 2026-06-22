# Matriz de Capacidades — bot × comportamento

Foto do "quem tem o quê". Fonte: varredura dos repos de origem (2026-06-22). Atualizar quando o
comportamento real mudar nos repos. `✅` tem · `—` não tem · `~` parcial/por design não se aplica.

| Capacidade | BigCartola | THEO | SHELDON | Sentinelas | HERMES | Obi-Wan | Sentinel/Artoo |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Long-poll `getUpdates` (recebe msg) | ✅ | ✅ | ✅ | — | ✅ | ✅ | — |
| SDK de bot (grammY) | ✅ | — | — | — | — | — | — |
| Bot API HTTP crua | — | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Oráculo conversacional (Groq+RAG) | ✅ | ✅ | ✅ | — | ✅ | ✅ | — |
| Alerta-como-estado (`editMessageText`) | — | ✅ | ✅ | ~ | — | — | — |
| Roteamento por tópico (`thread_id`) | — | ✅ | ✅ | ✅ | ~ | — | — |
| ACK inline (`callback_query`) | — | ✅ | ✅ | — | — | — | — |
| Botão Runbook inline | — | — | ✅ | — | — | — | — |
| Escalação por silêncio (@menção) | — | ✅ | ✅ | — | — | — | — |
| Quiet hours | — | ✅ | ✅ | — | — | — | — |
| Digests agendados | — | ✅ | ✅ | ✅ | ✅ | — | ~ |
| Supressão de flapping | — | — | ✅ | ~ | — | — | — |
| Filtro de conteúdo (chat) | ✅ | — | — | — | — | — | — |
| Rate-limit por usuário | ✅ | — | — | — | — | — | — |
| Deep-link de vínculo de conta | ✅ | — | — | — | — | — | — |
| Autorização self-service de admin (botão) | ~ | — | ✅ | — | — | — | — |
| Ensinar conhecimento (`/aprender`,`/learn`) | ✅ | ✅ | ✅ | — | ~ | — | — |
| Recebe/classifica foto (vision) | — | — | ✅ | — | — | — | — |
| Recebe/classifica documento/PDF | — | — | ✅ | — | — | — | — |
| Broadcast ao vivo de API externa | ✅ | — | — | — | — | — | — |
| Poll adaptativo + anti-duplicata | ✅ | — | — | — | — | — | — |
| Notificação de deploy (resumo commits) | — | — | ✅ | — | — | — | ~ |
| GitHub issues → alerta | — | ✅ | — | ✅ | ✅ | — | ✅ |
| Detecção de secret vazado | — | — | — | — | — | — | ✅ |
| Bridge GitHub→Telegram (webhook HMAC) | — | — | — | — | — | — | ✅ |
| Dead-man's-switch externo | — | — | — | ✅ | — | — | — |
| Stickers como UX | — | — | — | — | — | ✅ | — |
| Confirmação de contexto antes de LLM | — | — | — | — | — | ✅ | — |
| Parse de notificação em reply | — | ~ | ~ | — | — | ✅ | — |
| CLI selftest/ask | — | ✅ | — | — | — | — | — |
| Embaixada (comms entre entidades) | — | ✅ | — | ✅ | ~ | — | — |

## Leitura rápida

- **Mais completo em alertas/observabilidade:** SHELDON (referência), THEO logo atrás.
- **Mais completo em engajamento/produto:** BigCartola (filtro, rate-limit, deep-link, broadcast ao vivo).
- **Mais elegante em UX conversacional:** Obi-Wan (stickers, confirmação de órbita, parse de reply).
- **Capacidades em um só lugar (alto valor pra propagar):** botão Runbook, vision/PDF, deploy-notify,
  flapping (todas só no Sheldon); filtro de conteúdo, rate-limit, deep-link (só BigCartola);
  secret-leak + bridge webhook (só Sentinel/Artoo); dead-man's-switch (só Sentinelas).
