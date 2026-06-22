# Sentinelas (Oráculo) — NEXUS

- **Username:** sem bot próprio. **Confirmado:** `sentinela.py`/`sentinela-zion.py` leem
  `TELEGRAM_BOT_TOKEN` de `/etc/nexus-sentinela.env` e o `/mybots` não tem bot de sentinela →
  **reusam o token do SHELDON** (`@sheldonsbr_bot`, ID 8841226177).
- **Bot ID numérico:** 8841226177 (herdado do Sheldon).
- **⚠️ SPOF:** o dead-man's-switch posta com o MESMO token que vigia. Se o token do Sheldon for
  revogado/comprometido, o watchdog morre junto — derrotando o propósito de canal independente.
  Correção ideal: bot próprio para os Sentinelas (token distinto). Ver PROPAGACAO.
- **Persona:** dead-man's-switch externo. Vigiam o Sheldon-local (.213) e a VPS irmã "Zion" por um
  canal **independente** — se o Sheldon cai, os Sentinelas avisam.
- **Repo de origem:** `nexus-labsobral` (em `servers/nexus-vps01/`)
- **Stack:** Python stdlib (`urllib.request`). Lêem config de `/etc/nexus-sentinela.env`.

## Capacidades
- Vigília externa de host/serviço com **debounce por estado** (transição), distinguindo
  "túnel WireGuard caiu" de "host caiu".
- Alarme on / all-clear; postam no `TELEGRAM_TOPIC_CRITICO`.
- `matrix-issues-digest.py`: digest read-only de issues do GitHub por "condado" no grupo MATRIX.
- `embaixada.sh`: watcher via `curl` avisando quando documentos novos cruzam a fronteira entre entidades.

## Único deles (candidato a propagar)
- **Dead-man's-switch externo** — padrão de observabilidade que nenhum outro bot aplica a si mesmo.
  Candidato forte a virar padrão: todo notifier crítico deveria ter um watcher externo.
- **Debounce por transição de estado** distinguindo causa-raiz (túnel vs host).

## Configs (env, sem valores) — `/etc/nexus-sentinela.env`
`TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`, `TELEGRAM_TOPIC_CRITICO`, `MATRIX_CHAT_ID`.

## Arquivos-chave
- `servers/nexus-vps01/sentinela.py` — vigia o .213.
- `servers/nexus-vps01/sentinela-zion.py` — vigia a VPS irmã Zion.
- `servers/nexus-vps01/matrix/matrix-issues-digest.py` — digest MATRIX.
- `servers/nexus-vps01/embaixada.sh` — watcher de fronteira.
