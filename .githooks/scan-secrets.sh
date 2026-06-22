#!/usr/bin/env bash
# Scanner de segredos compartilhado pelos hooks. Recebe texto no stdin, sai !=0 se achar segredo.
# NUNCA imprime o valor do segredo — só o tipo e em qual contexto.
set -uo pipefail

# Padrões de segredo (rótulo|regex ERE). Token Telegram é o alvo principal deste repo.
PATTERNS=(
  "Telegram bot token|[0-9]{8,10}:[A-Za-z0-9_-]{35}"
  "age private key|AGE-SECRET-KEY-1[0-9A-Z]+"
  "Private key block|-----BEGIN[ A-Z]*PRIVATE KEY-----"
  "GitHub PAT (classic)|gh[pousr]_[A-Za-z0-9]{36,}"
  "GitHub PAT (fine)|github_pat_[A-Za-z0-9_]{40,}"
  "Groq/OpenAI key|(gsk|sk)_[A-Za-z0-9]{20,}"
  "AWS access key|AKIA[0-9A-Z]{16}"
  "Generic bearer secret|(api[_-]?key|secret|token)[\"' ]*[:=][\"' ]*[A-Za-z0-9_\\-]{24,}"
)

input="$(cat)"
found=0
for entry in "${PATTERNS[@]}"; do
  label="${entry%%|*}"
  regex="${entry#*|}"
  if printf '%s' "$input" | grep -Eiq -e "$regex"; then
    # mostra só o rótulo e quantas linhas casaram — nunca o valor
    n="$(printf '%s' "$input" | grep -Eic -e "$regex")"
    echo "  ✗ possível segredo: $label ($n ocorrência(s))" >&2
    found=1
  fi
done
exit $found
