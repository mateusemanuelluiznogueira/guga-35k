# Arquitetura — GUGA 35K

## Visão do sistema

```
Visitante (browser)
    │
    ▼
Netlify (HTML/CSS/JS estático + _headers)
    │
    ├── CDN: Tailwind, GSAP, confetti, Supabase JS
    │
    ▼
Supabase (Postgres + Realtime + PostgREST)
    │
    ├── SELECT público → tabela inscritos
    ├── RPC registrar_atleta → INSERT inscritos + inscritos_contato
    └── Realtime → postgres_changes em inscritos
    │
    ▼
WhatsApp (wa.me) — confirmação humana com Guga
```

Não há servidor próprio nem API Node no projeto.

## Stack

| Camada | Tecnologia |
|--------|------------|
| Front | Um arquivo `index.html` (HTML + CSS + JS vanilla) |
| Estilo utilitário | Tailwind CDN + CSS custom (`:root`, `.band-paper`) |
| Motion | GSAP + ScrollTrigger (script tags) |
| Backend | Supabase project `qskzgjdndyudpbwdyzph` (sa-east-1) |
| Deploy | Netlify → `https://corrida-guga-35k.netlify.app` |
| Assets | `assets/images/`, `assets/video/hero.mp4` |

## Estrutura de pastas

```
guga-35k/
├── index.html              # App inteiro
├── _headers                # Cache Netlify
├── assets/
├── supabase/migrations/    # DDL + RPC (versionado)
└── docs/                   # PRD, design, este arquivo
```

## Modelo de dados

### `public.inscritos` (leitura pública)

| Coluna | Tipo | Notas |
|--------|------|--------|
| `numero` | smallint PK | 1–40 |
| `nome` | text | |
| `distancia` | text | ex.: `5km`, `35km` |
| `medalha` | boolean | |
| `almoco` | boolean | |
| `recado` | text | até 500 chars; mural se não vazio |
| `created_at` | timestamptz | |

### `public.inscritos_contato` (sem acesso anon)

| Coluna | Tipo |
|--------|------|
| `numero` | FK → inscritos |
| `telefone` | text |

RLS: anon só `SELECT` em `inscritos`. Escrita via função `security definer`.

### RPC `registrar_atleta`

Parâmetros: `p_numero`, `p_nome`, `p_telefone`, `p_distancia`, `p_medalha`, `p_almoco`, `p_recado`.

Regras relevantes:

- Número 1 bloqueado para terceiros.
- Um WhatsApp não pode ocupar dois peitos (migration `um_whatsapp_um_peito`).
- Limite de recados por telefone (função pode zerar recado extra).
- Conflito de peito → exceção amigável no front.

## Fluxo no cliente

1. **Boot:** módulo ESM cria `window.gugaDb`, dispara `guga-db-ready`.
2. **loadRunners:** `from('inscritos').select(...)` → `runnersCache` → `renderPelotao` + `renderMural`.
3. **watchRunners:** canal Realtime + poll 20s + refresh ao voltar à aba.
4. **handleInscricao:** valida passos → `rpc('registrar_atleta', …)` → reload → confetti → modal com `wa.me/554197333676`.

Zap, Pix, slots, preço da medalha e data do countdown ficam em **`assets/js/event.config.js`** (ver `docs/EVENTO.md`). A anon key do Supabase continua no `<script type="module">` do `index.html`.

## Segurança

- Anon key no front é intencional para leitura/RPC.
- Não conceder `UPDATE`/`DELETE` a anon em produção.
- Edições administrativas: Supabase SQL Editor ou `supabase db query --linked`.

## Deploy e cache

- `_headers`: HTML e `/assets/*` com `max-age=0, must-revalidate`.
- Meta tags no HTML também pedem no-cache (redundante com Netlify).
- OG/Twitter apontam para URL Netlify e `assets/images/og.png`.

## Evolução possível (não implementado)

- Extrair JS/CSS para arquivos separados + build mínimo.
- RPC `atualizar_recado` autenticada por token do organizador.
- Edge function para validar Turnstile antes da inscrição.
- Domínio customizado no Netlify.

## Dependências externas (runtime)

- `cdn.tailwindcss.com`
- `fonts.googleapis.com` (Barlow, IBM Plex Mono)
- `cdn.jsdelivr.net` (@supabase/supabase-js, gsap, canvas-confetti)
- `qskzgjdndyudpbwdyzph.supabase.co`

Falha de CDN ou Supabase → pelotão mostra erro; inscrição não confirma.

## Manter o Supabase ativo (plano free)

Projetos free podem **pausar** após inatividade. O site usa a função agendada **`netlify/functions/supabase-keepalive.mjs`** (cron diário ~06:15 BRT, produção Netlify). Teste manual: `/.netlify/functions/supabase-ping` (público). O agendado `supabase-keepalive` roda só no cron da Netlify. Visitas ao site também contam como uso.
