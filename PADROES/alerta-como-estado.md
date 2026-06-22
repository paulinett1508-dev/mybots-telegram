# Padrão: Alerta como ESTADO (mensagem viva)

**Referência:** SHELDON (`sheldon/notifier/channels/telegram.py`), THEO (`scripts/theo/dispatcher.py`).

## Princípio
Um alerta não é um evento que gera mensagem nova a cada tick — é um **estado** identificado por uma
`key` estável. Enquanto o estado existir, **uma única mensagem é editada** (`editMessageText`),
não reenviada. Isso elimina spam e torna o canal legível.

## Mecânica
1. Toda condição monitorada gera uma `key` determinística (ex.: `service:ocomon:down`).
2. Primeira ocorrência → `sendMessage`, guarda `message_id` mapeado à `key`.
3. Mudança (texto, severidade, contagem) → `editMessageText` na mesma mensagem.
4. Resolução → edita com ✅ e texto riscado + duração; libera a `key`.
5. Mudança de severidade pode **fechar a mensagem atual e reabrir** no tópico correto.

## Complementos
- **Supressão de flapping** (só Sheldon): segura transições rápidas demais para não piscar.
- **Anti-duplicata por snapshot** (variante do BigCartola Copa): coleções MongoDB
  (`*_eventos_postados`, `*_snapshots_tabela`) garantem idempotência do broadcast.

## Quem deveria adotar
- **BigCartola** posta eventos novos em vez de editar — ver PROPAGACAO. Para avisos/status de mercado
  o padrão caberia; para broadcast de gols ao vivo, não (cada gol é evento legítimo).
