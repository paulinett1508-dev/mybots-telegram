# Auditoria de segredos — 1ª varredura (2026-06-22)

Ferramenta: ripgrep sobre os 5 repos clonados. Valores **redigidos** (a senha real nunca entra neste
repo; o guardrail bloquearia). Localização exata para remediar. Item P1 do [PROPAGACAO](../PROPAGACAO.md).

## Tokens Telegram
**Nenhum** token hardcoded nos repos — todos vêm de env (`TELEGRAM_BOT_TOKEN`). Consistente: a
exposição dos 5 tokens de bot veio do chat, não do código.

## Credenciais reais committadas — remediar

| # | Tipo | Arquivo:linha | Repo / visibilidade | Gravidade | Status |
|---|------|---------------|---------------------|-----------|--------|
| 2 | `ADMIN_PASSWORD='Sen***26'` + IP SSH `191.101.18.82` | `sbrgestao` → `apps/agnvendas/docs/superpowers/plans/2026-03-26-agnostic-core-improvements.md:1382` | 🌐→🔒 (era PÚBLICO, virou PRIVADO em 2026-06-22) | 🔴 ALTA | repo privado ✅ · **FORA DE ESCOPO**: a senha pertence a outra instância (não é alçada deste ecossistema); rotação é do dono daquela instância |
| 1 | Senha RustDesk (acesso remoto desktop) `rus***11` | `nexus-labsobral` → `fileexplorer/static/install-rustdesk.ps1:20` **e** `servers/labsobral-214/rustdesk/share-pack/install-rustdesk.ps1:31` | 🔒 PRIVADO | 🔴 CRÍTICA (blast radius) | pendente |
| 5 | Credencial admin do **Portainer** `@ce***dm` | `nexus-labsobral` → `fileexplorer/api/portainer.py:11` | 🔒 PRIVADO | 🔴 CRÍTICA (controle de containers) | pendente — achado novo pelo `secret_scan.py` (o grep inicial perdeu) |
| 3 | Pi-hole `WEBPASSWORD "@ce***97"` | `nexus-labsobral` → `infra/docker/pihole/docker-compose.yml:12` | 🔒 PRIVADO | 🟠 MÉDIA-ALTA | pendente |
| 4 | RTSP/DVR (câmeras) `sob***11` | `nexus-labsobral` → `scripts/dvr-check.py:28` | 🔒 PRIVADO | 🟠 MÉDIA | pendente |

Visibilidade importa: #2 estava em repo **público** (exposto à internet) → maior urgência; tornado
privado em 2026-06-22 (estanca exposição futura, mas a senha já vazada deve ser tratada como
comprometida → rotacionar). #1/#3/#4 sempre em repo **privado** (exposição limitada a colaboradores).

## Falsos positivos descartados
Fixtures/exemplos de teste: `senha123`, `xyz789` (CODEIUM_API_KEY de teste), `apiKey:'k$+/='`,
`JWT_SECRET='test_secret_...'`, `INTERNAL_API_KEY='test_internal...'`.

## Remediação recomendada (por item)
1. **Trocar a senha real** no sistema (RustDesk/Pi-hole/DVR/admin) — rotação é o que de fato fecha o buraco.
2. **Remover do código** → mover para env/vault (`docker-compose` lê de `.env`; scripts lêem de env).
3. **Limpar o histórico git** (`git filter-repo` ou BFG) — senão a senha antiga continua acessível no log.
4. **Re-rodar** `tools/audit-secrets.sh` (ou o Sentinel) para confirmar repo limpo.

## Próximo passo durável — ✅ FEITO
Migrado para o **Sentinel** em `theuniverse` (PR #6): `scripts/secret_scan.py` + workflow
`secret-audit.yml` (cron diário) varrem o conteúdo de todos os repos do org e notificam no Telegram,
complementando o `secret_exposto` nativo. Novos vazamentos agora são pegos sozinhos.
