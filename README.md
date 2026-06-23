# sentinel-core

**O núcleo do guardião do ecossistema** `paulinett1508-dev`. Control plane de **segurança,
compliance, auditoria, boas práticas e convergência de repos** — entregue por notificadores de alta
performance. Não tem runtime: é a camada de **padrões e políticas** que o motor executa e os bots anunciam.

> Ex-`mybots-telegram`. Começou como governança dos bots Telegram; convergiu para a control plane do org.

## Os três planos

| Plano | Onde | Papel |
|-------|------|-------|
| **Motor** | `theuniverse` / Sentinel | Detecção e enforcement: varre os repos, decide, dispara. Ganha poderes → [`ROADMAP.md`](ROADMAP.md) |
| **Entrega** | Família de bots Telegram | Notificação de alta performance: alerta-como-estado, tópicos, escalação |
| **Governança** | **este repo** | O norte: padrões que todo repo deve cumprir, matriz de capacidades, convergência, propagação |

## Domínios de governança

1. **Segurança** — segredos hardcoded (✅ secret-audit no Sentinel), repos públicos sem vazamento, chaves.
2. **Compliance** — branch protection, LICENSE, CODEOWNERS, security policy, CI obrigatório.
3. **Auditoria** — varreduras periódicas + score de postura por repo, com trilha no Telegram.
4. **Boas práticas** — README, testes, estrutura, .gitignore, dependências (SCA).
5. **Convergência** — todo repo adota `agnostic-core`? CI e estrutura consistentes? Drift detectado?

## Navegação

- [`ROADMAP.md`](ROADMAP.md) — poderes do Sentinel (feito + próximos)
- [`bots/`](bots/) — camada de entrega: ficha de cada bot (8 personas / 5 bots físicos)
- [`MATRIX-CAPACIDADES.md`](MATRIX-CAPACIDADES.md) — matriz bot × capacidade
- [`PADROES/`](PADROES/) — specs de comportamento de notificador
- [`PROPAGACAO.md`](PROPAGACAO.md) — backlog de cross-pollination entre bots
- [`tools/`](tools/) — auditorias CLI + [`AUDIT-FINDINGS.md`](tools/AUDIT-FINDINGS.md)
- [`vault/`](vault/) — segredos criptografados (age) + guardrails

## Regra de ouro
Segredo **nunca** em texto no git. Vault age (ciphertext) + hooks `pre-commit`/`pre-push` que
bloqueiam token/secret. A implementação vive no motor/repos de origem — aqui se referencia, não se duplica.
