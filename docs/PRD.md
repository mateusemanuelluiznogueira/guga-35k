# PRD — Corrida de Aniversário GUGA 35K

## Visão em uma linha

Site único para divulgar a corrida de aniversário do Guga, mostrar o pelotão ao vivo e guiar a inscrição (número de peito + confirmação no WhatsApp).

## Problema

Amigos e família precisam de um lugar claro para ver quem já está inscrito, escolher um número entre 40, informar distância/medalha/almoço e avisar o organizador — sem planilha solta nem grupo de WhatsApp como “fonte da verdade”.

## Objetivo

- Lista de peitos atualizada em tempo quase real.
- Inscrição em poucos passos, com mensagem pronta para o WhatsApp do Guga.
- Página bonita no celular, compartilhável (OG image, link estável).

## Público

- Corredores e apoiadores do círculo do Guga (Matinhos / região).
- Quem recebe o link no WhatsApp e decide na hora.

## Evento (fonte da verdade)

| Item | Valor |
|------|--------|
| Data | 20 de novembro |
| Concentração | 07:00 — Pico de Matinhos |
| Largada | 07:30 — orla de Matinhos |
| Desafio do aniversariante | 35 km (1 km por ano de vida) |
| Distância dos participantes | Livre, de **500 m** a **35 km** (texto livre no form) |
| Peitos | 40 números; **#1 = Guga** (aniversariante) |
| Inscrição na corrida | Gratuita |
| Medalha | Opcional, **R$ 40** (custo fundição/fita); Pix **Luiz Augusto Nogueira**, chave CPF `080.702.289-62`; comprovante no WhatsApp |
| Almoço | Opcional após a prova |

## Funcionalidades principais (v1 entregue)

1. **Hero** — vídeo full screen, CTA para inscrição, data/local.
2. **Seções informativas** — desafio (marquee de distâncias), almoço, medalha (foto + Pix copiável).
3. **Pelotão** — grade 1–40; ocupados vs livres; stats; clique no livre leva ao form.
4. **Inscrição** — 3 passos: nome/WhatsApp → distância → peito/medalha/almoço/recado → RPC Supabase → confetti + modal + link WhatsApp.
5. **Mural de recados** — só mensagens não vazias salvas no banco.
6. **Rodapé** — foto orla full bleed + logo empilhada.

## Fluxos do usuário

### Visitante

1. Abre o link → lê o evento → rola pelotão/recados.
2. Opcional: copia Pix na seção medalha.

### Inscrição

1. Preenche nome e WhatsApp (um WhatsApp = um peito).
2. Escolhe ou digita distância.
3. Escolhe número livre, medalha, almoço, recado opcional.
4. Confirma → registro no Supabase → modal → “Abrir WhatsApp” com texto estruturado.

### Organizador

- Confirma pagamento de medalha no WhatsApp.
- Correções pontuais no banco (ex.: recado depois da inscrição) via Supabase, não pelo site público.

## Requisitos

| Tipo | Detalhe |
|------|---------|
| Funcional | Lista e mural refletem banco; número duplicado ou WhatsApp já usado → erro amigável |
| UX | Mobile first; foco visível; skip link; formulário em passos |
| Performance | Página estática + CDN; lazy load em imagens pesadas |
| Plataforma | Browsers modernos; Netlify HTTPS |

## Métricas de sucesso (práticas)

- Taxa de peitos ocupados antes do evento.
- Inscrições que completam fluxo até abrir WhatsApp.
- Poucas reclamações de “número já tomado” sem a lista ter atualizado (realtime + poll).

## Fora de escopo (por enquanto)

- Pagamento online integrado.
- App nativo, login, painel admin.
- Certificado, cronometragem oficial, integração Strava.
- Multi-evento ou white-label.

## Conteúdo sensível / política

- Recados são públicos no mural; não moderar automaticamente no v1.
- Telefone dos inscritos não aparece no site público.
