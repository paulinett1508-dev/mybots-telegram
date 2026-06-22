# Padrão: Roteamento por tópico de supergrupo

**Referência:** SHELDON, THEO, Sentinelas. Config via env `TELEGRAM_TOPIC_*`.

## Princípio
Um único supergrupo (modo fórum) com **threads fixas por severidade/propósito**; cada mensagem vai
ao `message_thread_id` certo. Separa ruído de sinal sem multiplicar grupos.

## Convenção estabelecida no ecossistema
| Tópico | Env var | Conteúdo | Regra |
|---|---|---|---|
| 🔴 Crítico | `TELEGRAM_TOPIC_CRITICO` | P1 | passa sempre, inclusive em quiet hours |
| 🟡 Avisos | `TELEGRAM_TOPIC_AVISOS` | P2 | seguro em quiet hours 21h–06h |
| 📊 Resumos | `TELEGRAM_TOPIC_RESUMOS` | digests | agendado (07h) |
| 📅 Dia | `TELEGRAM_TOPIC_DIA` | boletim do dia | só Sheldon |

Grupo agregador entre entidades: **A MATRIX** (`MATRIX_CHAT_ID`, com `MATRIX_TOPIC_*`).

## Regra de convivência (do the-matrix)
"Bot não vê bot": cada entidade é dona do seu notifier; a MATRIX recebe digest read-only, não chatter.
