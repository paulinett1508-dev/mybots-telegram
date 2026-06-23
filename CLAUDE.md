sentinel-core — O núcleo do guardião do ecossistema

Control plane de governança do ecossistema paulinett1508-dev: segurança, compliance, auditoria,
boas práticas e convergência de repos. NÃO tem código de runtime — é a camada de PADRÕES e POLÍTICAS
que o motor executa e os notificadores anunciam. (Ex-`mybots-telegram`; reescopado em 2026-06.)

Três planos do ecossistema:
  MOTOR        Sentinel @ theuniverse — detecção/enforcement (secret-audit, compliance, drift,
               score de postura, convergência). É quem VARRE e DECIDE. Ganha poderes — ver ROADMAP.md.
  ENTREGA      Família de bots Telegram (Sheldon, Theo, Obi-Wan, Sentinel, Hermes, BigCartola) —
               notificação de alta performance (alerta-como-estado, tópicos, escalação).
  GOVERNANÇA   ESTE repo — o "norte": padrões que todo repo deve cumprir, matriz de capacidades,
               regras de convergência, backlog de propagação. Define O QUE o motor cobra.

Estrutura:
  ROADMAP.md             Poderes do Sentinel: o que já existe e o que vem (compliance, SCA, postura…)
  bots/                  Camada de ENTREGA — ficha por bot (persona, stack, capacidades)
  MATRIX-CAPACIDADES.md  Matriz bot × capacidade (foto do "quem tem o quê")
  PADROES/               Specs de comportamento de notificador (referência compartilhável)
  PROPAGACAO.md          Backlog: capacidade de A → B (cross-pollination)
  tools/                 Auditorias one-shot/CLI (a versão durável vive no Sentinel)
  vault/                 Segredos criptografados (age) + guardrails anti-vazamento

Regras do repo:
  - Nunca commitar segredos. Plaintext fica em ~/.env por host (ADR-005). Aqui: vault age (ciphertext)
    + guardrails .githooks que bloqueiam token/secret no commit/push.
  - Referenciar, não duplicar. Implementação vive no motor/repos de origem; aqui aponta-se o
    arquivo-chave (repo:caminho), não se cola o código.
  - Padrão é descritivo e versionado; convergência é o objetivo, não imposição cega caso a caso.
  - Toda capacidade/política nova atualiza MATRIX-CAPACIDADES.md / ROADMAP.md e, se aplicável, PROPAGACAO.md.

Submodulo: .agnostic-core/

---

Antes de implementar:

Backend:
  REST API design:    .agnostic-core/skills/backend/rest-api-design.md
  Error handling:     .agnostic-core/skills/backend/error-handling.md
  Seguranca de API:   .agnostic-core/skills/security/api-hardening.md
  OWASP checklist:    .agnostic-core/skills/security/owasp-checklist.md
  Banco de dados:     .agnostic-core/skills/database/query-compliance.md
  Schema design:      .agnostic-core/skills/database/schema-design.md
  Node.js patterns:   .agnostic-core/skills/nodejs/nodejs-patterns.md
  Express setup:      .agnostic-core/skills/nodejs/express-best-practices.md
  OpenAPI:            .agnostic-core/skills/documentation/openapi-swagger.md

Frontend:
  HTML e CSS:          .agnostic-core/skills/frontend/html-css-audit.md
  Acessibilidade:      .agnostic-core/skills/frontend/accessibility.md
  UX Guidelines:       .agnostic-core/skills/frontend/ux-guidelines.md
  CSS Governance:      .agnostic-core/skills/frontend/css-governance.md
  Tailwind:            .agnostic-core/skills/frontend/tailwind-patterns.md
  SEO:                 .agnostic-core/skills/frontend/seo-checklist.md
  Design com MCP:      .agnostic-core/skills/design/paper-mcp-workflow.md

Qualidade:
  Testes unitarios:    .agnostic-core/skills/testing/unit-testing.md
  Testes integracao:   .agnostic-core/skills/testing/integration-testing.md
  Testes E2E:          .agnostic-core/skills/testing/e2e-testing.md
  TDD workflow:        .agnostic-core/skills/testing/tdd-workflow.md
  Performance:         .agnostic-core/skills/performance/performance-audit.md
  Caching:             .agnostic-core/skills/performance/caching-strategies.md
  Validacao:           .agnostic-core/skills/audit/validation-checklist.md

Operacional:
  Commits:             .agnostic-core/skills/git/commit-conventions.md
  Branching:           .agnostic-core/skills/git/branching-strategy.md
  Deploy procedures:   .agnostic-core/skills/devops/deploy-procedures.md
  Documentacao:        .agnostic-core/skills/documentation/technical-docs.md
  Fact checking:       .agnostic-core/skills/behavioral/fact-checker.md
  Debugging:           .agnostic-core/skills/audit/systematic-debugging.md

AI / LLM (se aplicavel):
  AI patterns:         .agnostic-core/skills/ai/ai-integration-patterns.md
  Prompt engineering:  .agnostic-core/skills/behavioral/prompt-engineering.md

Planejamento:
  Goal-backward:       .agnostic-core/skills/behavioral/goal-backward-planning.md
  Workflow 6 fases:    .agnostic-core/skills/behavioral/project-workflow.md
  Context management:  .agnostic-core/skills/behavioral/context-management.md
  Claude Code tips:    .agnostic-core/skills/behavioral/claude-code-productivity.md

Antes de fazer deploy:
  .agnostic-core/skills/devops/pre-deploy-checklist.md
  .agnostic-core/skills/devops/deploy-procedures.md

---

Todos os Agents disponiveis:

Reviewers:
  Security Reviewer:       .agnostic-core/agents/reviewers/security-reviewer.md
  Frontend Reviewer:       .agnostic-core/agents/reviewers/frontend-reviewer.md
  Code Inspector (SPARC):  .agnostic-core/agents/reviewers/code-inspector.md
  Test Reviewer:           .agnostic-core/agents/reviewers/test-reviewer.md
  Performance Reviewer:    .agnostic-core/agents/reviewers/performance-reviewer.md
  Codebase Mapper:         .agnostic-core/agents/reviewers/codebase-mapper.md

Validators:
  Migration Validator:     .agnostic-core/agents/validators/migration-validator.md

Generators:
  Project Planner:         .agnostic-core/agents/generators/project-planner.md
  Boilerplate Generator:   .agnostic-core/agents/generators/boilerplate-generator.md
  Docs Generator:          .agnostic-core/agents/generators/docs-generator.md
  UI Designer (Paper MCP): .agnostic-core/agents/generators/ui-designer.md

Specialists:
  DevOps Engineer:         .agnostic-core/agents/specialists/devops-engineer.md
  Database Architect:      .agnostic-core/agents/specialists/database-architect.md
  Mobile Developer:        .agnostic-core/agents/specialists/mobile-developer.md
  SEO Specialist:          .agnostic-core/agents/specialists/seo-specialist.md

Workflows:
  Brainstorm:              .agnostic-core/commands/workflows/brainstorm.md
  Create:                  .agnostic-core/commands/workflows/create.md
  Debug:                   .agnostic-core/commands/workflows/debug.md
  Deploy:                  .agnostic-core/commands/workflows/deploy.md

Guia de roteamento (qual agent/skill usar):
  .agnostic-core/docs/agent-routing-guide.md

---

Git Auto-Push Workflow:
  Após cada commit, o hook PostToolUse faz push automático para a branch atual.
  Hook script:       .agnostic-core/scripts/hooks/post-tool-use-autopush
  Configuração:      ~/.claude/settings.json (PostToolUse → Bash matcher)
  Instalação:        scripts/install.sh configura automaticamente (passo 5/6)
  Comportamento:     detecta "git commit" → push origin <branch> → retry 1x se falhar

---

Convencoes do projeto:

  Natureza: repo de documentação/governança (Markdown). Não há build, runtime ou deploy.
  Conteúdo: registry de bots, matriz de capacidades, specs de padrões, backlog de propagação.
  Fonte dos fatos: repos de origem (planetas) — sempre verificar no código real antes de afirmar.
  Estilo de commits: Conventional Commits.

  Repos de origem (planetas):
    SuperCartolaManagerv5-production  -> BigCartola (Node.js + grammY)
    sbrgestao                          -> T.H.E.O. (Python stdlib)
    nexus-labsobral                    -> S.H.E.L.D.O.N., Sentinelas, HERMES (Python httpx/stdlib)
    theuniverse                        -> Obi-Wan, Sentinel, Artoo (Python httpx/stdlib)
    the-matrix                         -> base de conhecimento (specs, ADRs; sem código)

---

Orquestração do fluxo de trabalho:

  Plan mode (padrão):
    - Entre em plan mode para qualquer tarefa não-trivial (3+ etapas ou decisões arquiteturais).
    - Se algo der errado durante a execução, pare e replanjeje antes de prosseguir.
    - Use plan mode também para etapas de verificação, não apenas para construção.
    - Escreva especificações detalhadas antes de codar para reduzir ambiguidade.

  Subagentes:
    - Use subagentes liberalmente para manter a janela de contexto principal limpa.
    - Offload pesquisa, exploração e análise paralela para subagentes.
    - Uma tarefa por subagente — execução focada.

  Loop de auto-aperfeiçoamento:
    - Após qualquer correção do usuário, atualize tasks/lessons.md com o padrão identificado.
    - Escreva regras para si mesmo que previnam o mesmo erro.
    - No início da sessão, releia tasks/lessons.md para o projeto atual.

  Verificação antes de concluir:
    - Nunca marque uma tarefa como concluída sem provar que funciona.
    - Execute testes, verifique logs, demonstre a correção.
    - Pergunta padrão: "Um engenheiro de equipe aprovaria isso?"

  Exigência de elegância (equilibrada):
    - Para mudanças não-triviais, pause e pergunte: "existe uma maneira mais elegante?"
    - Se uma correção parecer paliativa: "Sabendo o que sei agora, implemente a solução elegante."
    - Para fixes simples e óbvios, pule este passo — não super-engenhe.

  Correção de bugs autônoma:
    - Ao receber um relatório de bug: apenas conserte. Não peça ajuda.
    - Aponte para logs, erros, testes falhando — depois resolva.
    - Zero troca de contexto exigida do usuário.

Gerenciamento de tarefas:

  1. Plano primeiro:        escreva o plano em tasks/todo.md com itens marcáveis.
  2. Verifique o plano:     valide antes de iniciar a implementação.
  3. Acompanhe o progresso: marque os itens conforme avança.
  4. Explique as mudanças:  resumo de alto nível a cada etapa.
  5. Documente resultados:  seção de revisão no fim de tasks/todo.md.
  6. Capture lições:        atualize tasks/lessons.md após correções do usuário.

Princípios básicos:

  - Simplicidade primeiro:  faça cada mudança a mais simples possível; impacto mínimo.
  - Sem previsão:           encontre causas-raiz; sem fixes temporários; padrões de dev sênior.
  - Impacto mínimo:         toque apenas no que é necessário; sem efeitos colaterais.

---
Auto-invocação de skills

  Leia `.agnostic-core/docs/keywords-map.md` no início de cada sessão.
  Monitore keywords ao longo da conversa e invoque a skill correspondente:
  - Skills técnicas: entre em plan mode e aguarde confirmação antes de executar.
  - Skills comportamentais: ative silenciosamente, sem notificação.

---
Comportamento
  Ao iniciar cada sessão, execute automaticamente o comando /status.
  Status panel skill:  .agnostic-core/skills/ai/project-status.md
  Comando:             .agnostic-core/templates/commands/status.md
