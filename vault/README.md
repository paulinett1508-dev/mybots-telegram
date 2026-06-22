# Vault

Cofre de segredos da família de bots, criptografado com [`age`](https://age-encryption.org).

## Como funciona
- `secrets.age` — todos os segredos, **criptografados** (ciphertext). Versionável: inútil sem a chave.
- `recipient.txt` — chave **pública** (recipient). Segura, versionada.
- `secrets.template.env` — esquema com placeholders (sem segredos). Documenta as chaves esperadas.
- **Chave privada** — `~/.config/mybots-telegram/identity.key`, **FORA do repo**, nunca versionada.
  É o único segredo que importa proteger. Faça backup dela num gerenciador de senhas; se perdê-la,
  o vault é irrecuperável (basta recriar e re-gravar os tokens).

## Comandos
```bash
./vault.sh list                  # lista as CHAVES (nunca valores)
./vault.sh get  CHAVE            # imprime um valor
./vault.sh set  CHAVE VALOR      # upsert (decripta → altera → re-encripta)
./vault.sh decrypt               # todo o plaintext no stdout (cuidado)
./vault.sh export-host PREFIXO   # linhas KEY=VAL de um bot p/ colar no .env do host
```

Outra máquina/host: copie `identity.key` para `~/.config/mybots-telegram/` (por canal seguro,
nunca git) ou aponte `MYBOTS_VAULT_KEY=/caminho/identity.key`.

## Guardrails (em `../.githooks/`)
- `pre-commit` — bloqueia commit com token/secret no conteúdo staged ou arquivo proibido.
- `pre-push` — varre arquivos rastreados (ignora `*.age`) como backstop.
- Ativados via `git config core.hooksPath .githooks` (já configurado neste repo).
- Bypass consciente só com `git commit --no-verify` (desaconselhado).

## Tokens atuais
Os 5 tokens de produção (Obi-Wan, Hermes, BigCartola, THEO, SHELDON) estão **gravados no vault**
(`<BOT>_TOKEN`). Foram expostos em chat em 2026-06-22; o dono optou por **não rotacionar** porque
rodam em vários projetos — risco residual aceito conscientemente. Se um dia rotacionar:
`./vault.sh set SHELDON_TOKEN <novo_token>` e atualizar o `.env` do host correspondente.
