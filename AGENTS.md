# Instruções para agentes de código

Projeto pessoal: landing + inscrição da **Corrida de Aniversário GUGA 35K** (Matinhos, PR). Stack leve — **não** é Next.js nem monorepo.

## Antes de alterar código

Leia, nesta ordem:

1. `docs/PRD.md` — escopo do produto e do evento
2. `docs/DESIGN_SYSTEM.md` — paleta, tipografia, seções, logos
3. `docs/ARCHITECTURE.md` — Supabase, deploy, fluxo de dados
4. `assets/js/event.config.js` e `docs/EVENTO.md` — constantes do evento
5. Inspecione `index.html` (quase tudo está aí) e `supabase/migrations/`

## Estrutura do repositório

| Caminho | Função |
|--------|--------|
| `index.html` | HTML, CSS, JS da página inteira |
| `assets/js/event.config.js` | Zap, Pix, slots, data do evento (clonar primeiro) |
| `assets/images/`, `assets/video/` | Mídia estática |
| `supabase/migrations/` | Schema Postgres, RLS, RPC `registrar_atleta` |
| `_headers` | Cache no Netlify |
| `index.backup.html` | Backup manual; não editar salvo pedido explícito |
| `docs/` | Contexto de produto, UI e arquitetura |

## Regras gerais

- **Mobile first.** Desktop só muda quando o pedido pedir desktop ou quando o breakpoint já existir no CSS.
- **Minimize o diff.** Não refatore para framework nem quebre o site em vários arquivos sem pedido.
- **Copy em português (BR)**, tom direto e humano; não inventar regras do evento (data, local, Pix, preço da medalha).
- **Identidade:** usar logos em `assets/images/` (hero, header do form, ícone nas seções, empilhada no rodapé). Não reintroduzir toggle de tema claro/escuro — o site usa faixas **noite** e **papel** alternadas.
- **Animações:** GSAP + ScrollTrigger em `initMotion()`. Respeitar `prefers-reduced-motion`. Marquee de distâncias **sem** pausa no hover nem aceleração no scroll.
- **Commits:** só quando o usuário pedir explicitamente.
- **Deploy:** produção em Netlify (`https://corrida-guga-35k.netlify.app`). Branch principal de entrega recente: `dark-mode` (confirmar com `git branch` antes de publicar).

## Supabase e dados

- Cliente público: `window.gugaDb` (anon key no `index.html` — esperado para leitura + RPC).
- **Escrita pública:** apenas via RPC `registrar_atleta`. Anon **não** tem `UPDATE`/`DELETE` em `inscritos`.
- Telefone fica em `inscritos_contato` (sem SELECT para anon).
- Ajustes manuais (ex.: recado de quem já se inscreveu): `supabase db query --linked` ou SQL no dashboard — **nunca** expor service role no front.
- Peito **#1** é do aniversariante (Guga); não inscrever outro no 1.

## Segurança

- Não commitar `.env`, service role nem senhas.
- Escapar texto vindo do banco no mural (`esc()` já existe).
- Não relaxar RLS para “facilitar” edição pelo browser.

## Comandos úteis

```bash
# Servir local (exemplo)
npx --yes serve .

# Supabase (projeto linkado: qskzgjdndyudpbwdyzph)
supabase link --project-ref qskzgjdndyudpbwdyzph
supabase db query --linked "SELECT numero, nome FROM inscritos ORDER BY numero;"
```

Não há `npm run dev` / `build` no repo — o build é estático.

## O que não fazer sem alinhar

- Migrar para Next.js, React ou bundler.
- Painel admin, login de organizador ou pagamento integrado no site.
- Expor telefones dos inscritos na UI pública.
- Mudar chave Pix, preço da medalha ou data do evento sem confirmação.

## Kickoff (copiar no chat)

```
Antes de codar, leia AGENTS.md, docs/PRD.md, docs/DESIGN_SYSTEM.md e docs/ARCHITECTURE.md.
Use como fonte da verdade. Reaproveite padrões em index.html antes de criar coisa nova.
Se faltar decisão, pergunte antes de assumir.
```
