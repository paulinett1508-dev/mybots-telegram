#!/usr/bin/env bash
# Auditoria de segredos vazados — varre repos em busca de tokens/senhas hardcoded.
# Realização do item P1 do PROPAGACAO.md (vigia secret_exposto do Sentinel → todos os repos).
# Versão durável deve viver no Sentinel (theuniverse) em GitHub Actions; esta é a one-shot/CLI.
#
# Uso: ./audit-secrets.sh DIR [DIR...]   (valores são REDIGIDOS na saída; exit !=0 se achar algo)
set -uo pipefail

# rótulo|regex ERE — mira segredos REAIS, não placeholders/fixtures.
PATTERNS=(
  "Telegram bot token|[0-9]{8,10}:[A-Za-z0-9_-]{35}"
  "age private key|AGE-SECRET-KEY-1[0-9A-Z]+"
  "Private key block|BEGIN[ A-Z]*PRIVATE KEY"
  "GitHub PAT|gh[pousr]_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{40,}"
  "Groq/OpenAI key|(gsk|sk)_[A-Za-z0-9]{20,}"
  "AWS access key|AKIA[0-9A-Z]{16}"
  "Senha/secret hardcoded|(senha|password|webpassword|passwd|pwd|rtsp_pass|admin_password)[\"' ]*[:=][\"' ]+[^\"'\$\{[:space:]][^\"']{4,}"
)
# linhas de teste/exemplo a ignorar (reduz falso positivo)
IGNORE='REVOGAR|EXAMPLE|placeholder|xxxx|<[a-z]|your[_-]|changeme|dummy|FAKE|test|spec|fixture|senha123|mock|sample'

EXCLUDES=(--exclude-dir=.git --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build
          --exclude=*.age --exclude=*.png --exclude=*.jpg --exclude=*.lock --exclude=*.min.js
          --binary-files=without-match)

redact() { sed -E 's/([[:alnum:]@#]{3})[[:alnum:]@#:+/._-]{4,}([[:alnum:]]{2})/\1***\2/g'; }

total=0
for dir in "$@"; do
  [ -d "$dir" ] || { echo "skip: $dir" >&2; continue; }
  name="$(basename "$dir")"; hits=0
  for entry in "${PATTERNS[@]}"; do
    label="${entry%%|*}"; regex="${entry#*|}"
    while IFS= read -r line; do
      [ -n "$line" ] || continue
      printf '%s' "$line" | grep -Eiq "$IGNORE" && continue
      loc="${line%%:*}"; rest="${line#*:}"; lno="${rest%%:*}"; txt="${rest#*:}"
      rel="${loc#$dir/}"
      printf '  [%s] %s:%s\n      %s\n' "$label" "$rel" "$lno" "$(printf '%s' "$txt" | sed 's/^[[:space:]]*//' | cut -c1-100 | redact)"
      hits=$((hits+1)); total=$((total+1))
    done < <(grep -rEinH "${EXCLUDES[@]}" -e "$regex" "$dir" 2>/dev/null)
  done
  [ "$hits" -eq 0 ] && echo "✓ $name — limpo" || echo "✗ $name — $hits achado(s)"
done
echo "-----"; echo "TOTAL: $total"
[ "$total" -eq 0 ]
