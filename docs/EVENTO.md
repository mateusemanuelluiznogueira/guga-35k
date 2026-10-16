# Configuração rápida — próximo evento

## Arquivo principal

Edite `assets/js/event.config.js`:

| Campo | Exemplo |
|-------|---------|
| `siteHost` | `meu-evento.netlify.app` |
| `zapPhone` | `5541999999999` (só dígitos, com 55) |
| `pixKey` | chave Pix da medalha/doação |
| `medalPriceBrl` | `40` |
| `maxSlots` | `40` (precisa bater com migration Supabase) |
| `birthdaySlot` | `1` |
| `eventStart` | data/hora da largada (countdown) |

Depois de mudar: testar **Copiar Pix**, **pelotão** e **confirmar inscrição** em preview.

## O que ainda é manual

- Textos e seções em `index.html`
- OG / meta (`og:url`, imagens) no `<head>`
- Supabase: novo projeto, migrations em `supabase/migrations/`, anon key no `<script type="module">` do `index.html`
- Assets: logos, vídeo, `footer-orla.jpg`, `og.png`

## Deploy

Netlify na branch `main`, pasta raiz do repo. Ver `docs/ARCHITECTURE.md`.
