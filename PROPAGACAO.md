# Backlog de Propagação

"Inteligência X do bot A deveria ir para o bot B." Cada item: origem → alvo, racional, esforço,
e se faz sentido dentro do escopo do alvo (nem todo padrão cabe em todo bot).

Prioridade: 🔴 alta (ganho claro, baixo atrito) · 🟡 média · ⚪ avaliar.

---

## 🔴 P1 — alto valor, baixo atrito

### secret-leak vigia (Sentinel) → TODOS os repos
- **Origem:** `theuniverse/scripts/sentinel.py` (`secret_exposto` 🔑).
- **Racional:** já há secrets hardcoded vazados no ecossistema (`RTSP_PASS` em
  `nexus/scripts/dvr-check.py`, defaults em código do Sheldon). O vigia existe mas só cobre o que o
  Sentinel varre. Deveria ser scan padrão sobre **todo** repo do org.
- **Esforço:** baixo (Sentinel já roda em Actions cron; estender o escopo de repos).
- **✅ FEITO:** versão durável migrada para o Sentinel — `theuniverse` PR #6
  (`scripts/secret_scan.py` + workflow `secret-audit.yml` cron diário + 8 testes). Complementa o
  `secret_exposto` nativo com regex de conteúdo (pega segredos custom em repo privado). O
  `tools/audit-secrets.sh` deste repo fica como CLI one-shot. Achados: `tools/AUDIT-FINDINGS.md`.

### Bot próprio para as Sentinelas (NEXUS) — corrigir SPOF
- **Racional:** as Sentinelas (dead-man's-switch) postam com o token do SHELDON
  (`/etc/nexus-sentinela.env`). Se esse token cai, o watchdog cai junto — anula o canal independente.
- **Correção:** registrar um bot dedicado no BotFather (`@sbrsentinela_bot`?) e usar token distinto.
- **Esforço:** baixo (1 bot novo + trocar a var no env do host).

### ACK inline + escalação por silêncio (Sheldon/THEO) → BigCartola (avisos)
- **Racional:** BigCartola tem `inline_keyboard` só como deep-link, e posta evento novo em vez de
  editar. Para `aviso_publicado` e status de mercado, ACK + alerta-como-estado caberiam.
- **Ressalva:** NÃO aplicar a broadcast de gols ao vivo (cada gol é evento legítimo, não estado).
- **Esforço:** médio (BigCartola é grammY; o resto é Python — não dá pra copiar código, só o padrão).

### Botão Runbook inline (Sheldon) → THEO
- **Racional:** THEO já tem ACK inline; adicionar `📖 Runbook` ligando alerta a procedimento é incremento
  pequeno e ambos são notifiers de infra/operação do mesmo perfil.
- **Esforço:** baixo.

---

## 🟡 P2 — bom ganho, atrito médio

### Filtro de conteúdo + rate-limit por usuário (BigCartola) → THEO, Sheldon, Obi-Wan
- **Racional:** os oráculos de infra não têm proteção contra abuso/flood nem desvio de assunto.
  BigCartola tem ambos maduros. Reduz custo Groq e mantém foco.
- **Ressalva:** Obi-Wan já tem allowlist de 1 chat (risco baixo); ganho maior em Sheldon/THEO que
  respondem em grupo.

### Notificação de deploy com resumo de commits via Groq (Sheldon) → THEO, BigCartola
- **Racional:** `git_notify.py` resume commits e posta no deploy. Padrão replicável a qualquer repo
  com deploy. THEO/BigCartola não têm.
- **Esforço:** baixo-médio.

### Vision/PDF classificado (Sheldon) → THEO
- **Racional:** mesmo perfil (TI); receber print de erro/PDF de chamado e classificar antes de ingerir
  é útil ao THEO. Único no Sheldon hoje.

### Dead-man's-switch externo (Sentinelas) → padrão para todo notifier crítico
- **Racional:** Sheldon/THEO/BigCartola notificam, mas quem avisa se ELES caem? Só o NEXUS tem watcher
  externo. Deveria ser regra: todo notifier P1 tem um sentinela externo independente.
- **Esforço:** médio (1 script stdlib por bot + cron/systemd em host distinto).

---

## ⚪ Avaliar — depende de escopo/custo

### RAG via Qdrant (Hermes) → THEO, Sheldon
- **Racional:** hoje usam `.md` em arquivo (`conhecimento.md`/`custom.md`). Se a base crescer, Qdrant
  escala melhor. Avaliar só quando o RAG em md começar a degradar.

### Stickers por estado + confirmação de contexto (Obi-Wan) → demais oráculos
- **Racional:** UX agradável e economia de LLM (confirmar antes de responder). Mas é estilo de
  produto, não de infra — talvez não caiba em notifier seco.

### Bridge GitHub→Telegram via webhook HMAC (Sentinel/Artoo) → complementar poll do THEO/Sheldon
- **Racional:** tempo real vs poll de 15 min. Avaliar se vale o endpoint exposto + HMAC por host.

### Deep-link de vínculo de conta (BigCartola) → N/A para infra
- **Racional:** específico de produto multiusuário (liga). Notifiers de infra têm whitelist fixa;
  não precisam. Registrado só para não ser reproposto.

---

## Resolvidos
_(nenhum ainda)_
