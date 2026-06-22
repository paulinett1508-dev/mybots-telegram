# Padrão: Escalação por silêncio · Quiet hours · Digests

**Referência:** SHELDON, THEO.

## Escalação por silêncio
Alerta P1 (crítico) sem **ACK** dentro de janelas (15 min → 30 min) gera **@menção** ao dono
("Arquiteto"), resolvido via `getChatAdministrators`/`getChatAdministrators`. O ACK vem de botão
inline (`callback_data=ack:<key>`), tratado em `answerCallbackQuery`.

Config: `NOTIFY_ADMIN_MENTION` e intervalos em `NOTIFY_*` (Sheldon).

## Quiet hours
Janela 21h–06h: avisos 🟡 (P2) ficam represados; críticos 🔴 (P1) passam sempre. Evita acordar o
time por ruído sem perder emergência real.

## Digests agendados (loops asyncio em `scheduler.py`)
- Matinal (07h, tópico resumos), vespertino, encerramento do dia.
- Semanal: issues paradas (segunda 7h — THEO).
- Específicos: Pi-hole (Sheldon).
- Read-only na MATRIX: issues por condado (HERMES, Sentinelas).

## ACK como contrato
ACK não é só "vi" — para a escalação. Sem ACK, o sistema assume que ninguém viu e sobe a régua.
Esse loop fechado (notifica → espera ACK → escala) é o que distingue notifier maduro de spammer.
