# Design system — GUGA 35K

Direção visual: **noite roxa-azulada**, **âmbar** de destaque, **azul** para links e acentos frios, faixas **papel/areia** para respiro e transição para a foto clara do rodapé. Sem modo claro global — alternância por seção.

## Tipografia

| Uso | Família |
|-----|---------|
| Corpo e títulos | **Barlow** (400–800) |
| Destaque display (hero) | **Barlow Condensed** italic 800 |
| Números / detalhes técnicos | **IBM Plex Mono** |

Escala fluida com `clamp()` nos títulos de seção (`.section-title`, `.lede`). No mobile, blocos `.only-mobile` reforçam hierarquia; desktop pode omitir redundância.

## Tokens — faixa noite (padrão `:root`)

| Token | Valor | Uso |
|-------|-------|-----|
| `--paper` | `#141028` | Fundo principal (noite) |
| `--ink` | `#F6F1E7` | Texto principal |
| `--sun` | `#E8A317` | Destaque, preços, CTAs âmbar |
| `--sun-ink` | `#FFD27A` | Texto em ênfase quente |
| `--sea` | `#8EB4FF` | Acento azul, links |
| `--violet` | `#C9B8F0` | Acento roxo claro |
| `--card` | `#241C48` | Cards, campos |
| `--line` | `#3E3568` | Bordas |
| `--muted` | `#D2CAE2` | Texto secundário |
| `--error` | `#FFC2CE` | Erros |

Classes utilitárias de cor no copy: `.t-sun`, `.t-sea`, `.t-violet`.

## Tokens — faixa papel (`.band-paper`)

| Token | Valor |
|-------|-------|
| `--paper` | `#F6F3EC` |
| `--ink` | `#12263F` |
| `--sea` | `#1B4F8A` |
| `--sun-ink` | `#9A3412` |
| `--line` | `#E4DDD2` |

Usar em: medalha, inscrição, recados (última faixa clara antes do footer).

## Ritmo de seções (ordem no `main`)

1. Hero — noite, 100svh, vídeo + logo centralizada (não sticky no scroll).
2. Desafio (`#como`) — noite, ~100svh, marquee km.
3. Almoço — noite, ~100svh.
4. Medalha — **papel**.
5. Pelotão — noite.
6. Inscrição — **papel**.
7. Recados — **papel** (encontro com céu claro do footer).
8. Footer — foto `footer-orla.jpg` full bleed; logo `logo-stacked.png` centralizada embaixo com **gradiente suave** para legibilidade (sem caixa/placa).

## Logos e marcas

| Arquivo | Uso |
|---------|-----|
| `logo-header-white.png` / hero | Topo hero (se aplicável) |
| `logo-header.png` | Cabeçalho do card do form |
| `logo-icon.png` | `.mark` nas seções |
| `logo-stacked.png` | Rodapé |
| `logo-horizontal.png`, `logo-mark.svg`, etc. | Reserva / OG / favicons |

Não colocar logo extra em lugares que o usuário já pediu para remover (ex.: sheet decorativo no meio da página).

## Componentes

### Botões

- `.btn-sun` — primário âmbar.
- `.btn-ghost` — secundário borda.
- `.btn-zap` — WhatsApp no modal.
- `.btn-text` — texto simples.

Hover com movimento só em `(hover: hover)` (ponteiro fino).

### Pelotão (`.bib`)

- **Ocupado:** fundo sólido, borda definida, número em tom âmbar/terra (`--sun-ink` na faixa papel), nome com ênfase `--sea`.
- **Livre (`.bib-free`):** borda tracejada, botão “Escolher”.
- **Guga (`.bib-guga`):** borda `--sun`, meta “Aniversariante”.

### Formulário

- `.form-card` — card centralizado; logo do form no topo.
- `.field`, `.choice`, `.dist-btn` / `.is-on` — distância selecionada.
- Passos: `[data-step]` + `#passo-label`.

### Mural

- `.note-card` — recado + `.note-by` com `#peito Nome, distância`.

## Motion

- Biblioteca: **GSAP 3.12** + **ScrollTrigger** (`initMotion`, `gsap.matchMedia`).
- Entradas com scrub leve no scroll; `revealOnce` para não repetir animação.
- `prefers-reduced-motion: reduce` — sem esconder conteúdo; reduzir ou desligar scrub/confetti.
- Marquee `.km-track`: animação CSS contínua, **sem** interação mouse/scroll.

## Responsivo

- Base: mobile (360–430px) primeiro.
- `.wrap`: `min(72rem, calc(100% - 2rem))`.
- Footer mobile: enquadramento do corredor inteiro; logo não cortada (safe area inferior).
- Breakpoints Tailwind no markup do modal (`sm:`); CSS custom em `@media` onde já existir.

## Acessibilidade

- `lang="pt-BR"`, skip link, `aria-*` no modal e pelotão.
- Foco visível: outline 3px `--ink`.
- Vídeo hero: não bloquear leitura do conteúdo; poster fallback.

## Referência rápida de implementação

Tudo vive em `index.html` (`<style>` + classes). Ao mudar cor, prefira **variáveis CSS** nas faixas noite/papel em vez de hex solto no markup.
