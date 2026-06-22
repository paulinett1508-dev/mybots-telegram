# mybots-telegram

Governança **comportamental** da família de bots Telegram do ecossistema `paulinett1508-dev`.
Não tem código de bot — os bots vivem nos repos de origem. Aqui se responde:

1. **Quem já tem o quê** → [`MATRIX-CAPACIDADES.md`](MATRIX-CAPACIDADES.md)
2. **Qual é o padrão** → [`PADROES/`](PADROES/)
3. **O que deveria propagar de um bot pro outro** → [`PROPAGACAO.md`](PROPAGACAO.md)
4. **Ficha de cada bot** → [`bots/`](bots/)

> **5 bots físicos, 8 personas.** O `/mybots` confirmou 5 tokens: Obi-Wan, Hermes, BigCartola, THEO,
> SHELDON. Sentinel/Artoo (theuniverse) compartilham o bot do Obi-Wan; as Sentinelas (nexus)
> provavelmente reusam o token do SHELDON. Superadmin/"GOD" de todos: `@Paulinett_Miranda` (ID 1030157568).

## Bots mapeados (8 personas)

| Bot | Repo | Papel | Stack |
|-----|------|-------|-------|
| [BigCartola](bots/bigcartola.md) | SuperCartolaManager | Cartola FC + Copa 2026 | Node.js + grammY |
| [T.H.E.O.](bots/theo.md) | sbrgestao | Notifier+oráculo TI/gestão | Python stdlib |
| [S.H.E.L.D.O.N.](bots/sheldon.md) | nexus-labsobral | Notifier+chatops infra (arquétipo) | Python httpx |
| [Sentinelas](bots/sentinelas-nexus.md) | nexus-labsobral | Dead-man's-switch externo | Python stdlib |
| [HERMES](bots/hermes.md) | nexus / the-matrix | Agente RAG consultivo | Container externo |
| [Obi-Wan](bots/obi-wan.md) | theuniverse | Oráculo do observatório | Python httpx |
| [Sentinel & Artoo](bots/sentinel-artoo.md) | theuniverse | Notifier GitHub→Telegram | Python stdlib |

## DNA comum
Long-poll `getUpdates` (ninguém usa `setWebhook` do Telegram) · Bot API HTTP crua (exceto BigCartola/grammY)
· Groq `llama-3.3-70b` + RAG · alerta-como-estado · roteamento por tópico · grupo agregador "A MATRIX".

## Segredos — vault age (ver [`vault/`](vault/))
Segredos vivem criptografados em `vault/secrets.age` (age). A chave privada fica **fora do repo**
(`~/.config/mybots-telegram/identity.key`). Guardrails `pre-commit`/`pre-push` (em `.githooks/`)
**bloqueiam** qualquer token/secret antes de entrar no git. Regra única: segredo nunca commitado/pushado.

```
./vault/vault.sh list                 # só as chaves
./vault/vault.sh get  SHELDON_TOKEN    # um valor
./vault/vault.sh set  SHELDON_TOKEN x  # upsert (re-encripta)
./vault/vault.sh export-host SHELDON   # linhas KEY=VAL p/ o .env do host
```

## Pendências
- [x] 5 tokens de produção gravados no vault (rotação adiada — risco residual aceito pelo dono).
- [ ] Preencher chat/topic IDs (dos `.env` dos hosts) no vault.
- [ ] Confirmar se as Sentinelas (nexus) reusam o token do SHELDON (`/etc/nexus-sentinela.env`).
- [x] Cruzar `/mybots` com os mapeados → sem órfãos; 5 bots batem.
