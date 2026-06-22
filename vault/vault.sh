#!/usr/bin/env bash
# Vault da família de bots Telegram — criptografia age.
# Chave privada: $HOME/.config/mybots-telegram/identity.key (FORA do repo, nunca versionada).
# Chave pública: vault/recipient.txt (segura, versionada).
# Segredos:      vault/secrets.age (ciphertext age; inútil sem a chave privada).
#
# Uso:
#   ./vault.sh init                 cria o vault a partir do template (1ª vez)
#   ./vault.sh list                 lista as CHAVES (nunca os valores)
#   ./vault.sh get  CHAVE           imprime UM valor (stdout)
#   ./vault.sh set  CHAVE VALOR     upsert de um segredo (re-encripta)
#   ./vault.sh decrypt              imprime TODO o plaintext (stdout) — use com cuidado
#   ./vault.sh export-host PREFIXO  imprime as linhas KEY=VAL de um bot p/ colar no .env do host
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IDENTITY="${MYBOTS_VAULT_KEY:-$HOME/.config/mybots-telegram/identity.key}"
RECIPIENT_FILE="$ROOT/recipient.txt"
VAULT="$ROOT/secrets.age"

die() { echo "ERRO: $*" >&2; exit 1; }
[ -f "$IDENTITY" ] || die "chave privada não encontrada em $IDENTITY"
[ -f "$RECIPIENT_FILE" ] || die "recipient.txt não encontrado"
command -v age >/dev/null || die "age não instalado"
RECIPIENT="$(tr -d '[:space:]' < "$RECIPIENT_FILE")"

_decrypt() { age -d -i "$IDENTITY" "$VAULT"; }
_encrypt() { age -r "$RECIPIENT" -o "$VAULT"; }   # lê plaintext do stdin

cmd="${1:-}"; shift || true
case "$cmd" in
  init)
    [ -f "$VAULT" ] && die "vault já existe ($VAULT). Use set/decrypt."
    [ -f "$ROOT/secrets.template.env" ] || die "template não encontrado"
    _encrypt < "$ROOT/secrets.template.env"
    echo "Vault criado: $VAULT"
    ;;
  list)
    _decrypt | grep -E '^[A-Za-z0-9_]+=' | sed 's/=.*//' | sort
    ;;
  get)
    [ $# -ge 1 ] || die "uso: get CHAVE"
    _decrypt | grep -E "^$1=" | head -1 | sed "s/^$1=//"
    ;;
  set)
    [ $# -ge 2 ] || die "uso: set CHAVE VALOR"
    key="$1"; shift; val="$*"
    tmp="$(_decrypt)"
    if printf '%s\n' "$tmp" | grep -qE "^$key="; then
      tmp="$(printf '%s\n' "$tmp" | sed "s|^$key=.*|$key=$val|")"
    else
      tmp="$(printf '%s\n%s=%s\n' "$tmp" "$key" "$val")"
    fi
    printf '%s\n' "$tmp" | _encrypt
    echo "OK: $key atualizado."
    ;;
  decrypt)
    _decrypt
    ;;
  export-host)
    [ $# -ge 1 ] || die "uso: export-host PREFIXO (ex: SHELDON)"
    _decrypt | grep -E "^$1_" | sed "s/^$1_//"
    ;;
  *)
    grep -E '^#( |$)' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' | head -20
    exit 1
    ;;
esac
