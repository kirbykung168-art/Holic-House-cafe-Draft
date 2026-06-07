# Mobile Audit — Holic Haus (iPhone 14 viewport)

**Audit run:** headless Chromium via Playwright at iPhone 14 Pro device profile (393×660 viewport, DPR 3, mobile user agent), against the local `index.html` served from `python -m http.server`.

**Vercel live URL** (https://holic-house-cafe-draft.vercel.app/) still returns HTTP 404 / `x-vercel-error: DEPLOYMENT_NOT_FOUND` at audit time. Audit was therefore run against the working copy that matches `origin/main@dc2b40e`, plus the surgical fixes documented below.

## Methodology

1. Loaded `http://127.0.0.1:9090/` in headless Chromium with `iPhone 14 Pro` device emulation.
2. Captured a full-page screenshot (`full.png`, 10,974px tall) and seven section-anchored screenshots (`section-top.png`, `section-manifesto.png`, `section-menu.png`, `section-brunch.png`, `section-visit.png`, `section-gallery.png`, `section-reviews.png`).
3. Inspected each section for:
   - Horizontal overflow (`document.documentElement.scrollWidth > window.innerWidth`)
   - Broken images (`naturalWidth === 0 && complete`)
   - Failed network requests (4xx/5xx)
   - Console errors/warnings
   - Tap targets smaller than 44×44 (Apple Human Interface Guidelines)
   - Text overflowing the viewport
4. Compared visual rendering of section screenshots to the design intent (cream + forest + terracotta palette, Thai script + English).

## Findings (before fixes)

### Critical — content unreadable

**1. Thai script rendered as tofu (□□□□) on real headless Chromium.**

The two display fonts (Cormorant Garamond, Fraunces) and the body font (Inter) bundle **only Latin glyphs**. Headless Chromium has no Thai-capable system fallback, so every Thai string fell back to a `.notdef` glyph and rendered as a row of blank rectangles. Confirmed via screenshot:
- Manifesto attribution `โฮลิคเฮ้าส์ คาเฟ่ในสวน บรรยากาศเป็นกันเอง` — fully tofu.
- Menu cards in `#brunch`: every Thai dish name on cards (Croissant `คร็องซองต์`, Egg Bacon Croissant `ครัวซองต์ไข่เบคอน`, Bacon & Egg Bagel `เบเกิลเบคอนไข่`, …) — fully tofu.
- Footer Thai tagline `โฮลิคเฮ้าส์ คาเฟ่แอนด์การ์เด้น` — same.

On real iOS Safari this often renders via the system Thai fallback (Thonburi / Noto Sans Thai), but on Android Chrome and some browsers it won't — and the audit shows this is **not** something that's guaranteed to work just because the markup is there.

Severity: high (it's half the brand identity).

### Polish — tap-target sizing

**2. Thirteen inline anchors below the 44×44 Apple HIG minimum.**

These are body-copy links used as standalone tap targets — footer phone/email/social, visit-card phone/email, gallery credit links ("Wongnai", "Google Maps listing", "Facebook"), menu-note "Live prices on Wongnai →" link, brunch-card "Facebook page" link, and the brand mark + nav CTA which were just under.

Specific dimensions recorded:

| Element | Width × Height | Location |
| --- | --- | --- |
| `HH Holic Haus` (brand mark) | 132 × 36 | Nav |
| `Directions →` (nav CTA) | 128 × 41 | Nav |
| `Live prices on Wongnai →` | 224 × 36 | Drinks menu footer |
| `Facebook page` | 98 × 16 | Bread & Brunch credit |
| `064 174 9462` (visit) | 108 × 20 | Visit card |
| `holichaus.cafe@gmail.com` (visit) | 201 × 20 | Visit card |
| `Wongnai` | 55 × 16 | Gallery credit |
| `Google Maps listing` | 123 × 16 | Gallery credit |
| `Facebook` (gallery) | 62 × 16 | Gallery credit |
| `064 174 9462` (footer) | 92 × 17 | Footer |
| `holichaus.cafe@gmail.com` (footer) | 174 × 17 | Footer |
| `Facebook` (footer) | 68 × 17 | Footer |
| `Instagram` (footer) | 63 × 17 | Footer |

Severity: medium (functional, but fails iOS HIG and feels fiddly on a thumb).

### Console / network

- Tailwind CDN production warning — expected, not a bug for a marketing prototype.
- No 4xx/5xx responses, no broken images among the 11 `<img>` tags.

### No bugs found in

- Horizontal overflow: `0px` — page width stays at the 393px viewport exactly.
- Manifesto sizing: H2-sized Cormorant italic at ~24px → readable on mobile, copy doesn't feel cramped.
- Bread & Brunch menu card stacking: cards collapse from 3-up → 1-up cleanly via `sm:grid-cols-2 lg:grid-cols-3`.
- Brunch menu boards (Facebook screenshots): the two `aspect-ratio:3/5` tiles render as a 1-up stacked column on mobile (the wrapping grid is `grid-cols-1 md:grid-cols-2`).
- Gallery: 2-up grid renders cleanly. No rotations causing edge bleed.
- Visit card: address, phone, email, hours table, two CTAs, and map iframe all stack and render. Map appears at the bottom.
- Reviews: three blockquote cards stack 1-up with proper padding.
- Sticky bottom CTA: visible on screens ≤720px wide, `body { padding-bottom: 80px }` keeps it from covering content permanently.

## Fixes applied (staged in `index.html`, **NOT** pushed)

### Fix 1 — Thai font fallback

Added two Google Fonts to the `<link rel="stylesheet">`:
- **Sarabun** — primary Thai sans-serif (very legible, used by the Thai government style guide).
- **Noto Serif Thai** — Thai counterpart for the Cormorant Garamond / Fraunces serif look.

Then chained them into the font-family stacks:
- `body { font-family: 'Inter', 'Sarabun', 'Noto Sans Thai', system-ui, sans-serif }` — picks up Sarabun for any Thai chars in body copy that Inter can't render.
- `h1,h2,h3,h4 { font-family: 'Cormorant Garamond', 'Fraunces', 'Noto Serif Thai', Georgia, serif }` — serif headlines get a Thai serif fallback.
- All inline `font-family:'Cormorant Garamond',serif` declarations updated to include `'Noto Serif Thai'`.
- `.menu-card .menu-price` updated to include `'Sarabun'` (price chip occasionally has Thai punctuation).
- Manifesto Thai phrase wrapped in `<span lang="th">` to give browser language-aware font fallback signaling.
- Added a global `:lang(th), .thai { font-family: 'Sarabun', 'Noto Sans Thai', 'Tahoma', sans-serif }` rule as a belt-and-braces fallback.

**Verified visually:** re-ran the audit. The Bread & Brunch card Thai labels (`คร็องซองต์`, `ครัวซองต์ไข่เบคอน`, `เบเกิลเบคอนไข่`) and the manifesto attribution (`โฮลิคเฮ้าส์ คาเฟ่ในสวน บรรยากาศเป็นกันเอง`) now render in proper Thai glyphs.

### Fix 2 — Tap targets ≥44px on mobile

Added one media-query block inside the existing `<style>`:

```css
@media (max-width: 720px) {
  /* Tap targets — Apple HIG 44px min on mobile.
     Bumps small inline anchors in body copy without affecting desktop layout. */
  footer a,
  #visit dd a,
  section p a,
  .menu-note a {
    display:inline-block;
    padding:10px 6px;
    margin:-8px 0;
    min-height:44px;
    line-height:1.5;
  }
  /* The brand mark and primary nav CTA need a tiny vertical bump */
  header a[href="#top"] { padding:6px 0; }
  header .btn { min-height:44px; }
}
```

The negative `margin:-8px 0` keeps the visual rhythm of the text identical — only the hit box grows. Desktop is untouched (the rules are scoped to `max-width:720px`).

**Verified:** re-ran the audit. `small_tap_targets` went from **13 → 0**. Horizontal overflow stayed at `0px`. No new visual regressions in the re-screenshots.

## What I deliberately did NOT change

- **Tailwind CDN warning.** Switching to a build pipeline is a bigger refactor that contradicts the CLAUDE.md "single index.html, Tailwind via CDN" rule. Leave for a v2 if Kirby wants to optimise prod CSS.
- **Gallery caption "Shopfront, Srinagarindra Rd" wraps to 2 lines.** It's intentional — the caption is on a dark scrim tile and 2 lines reads fine.
- **The sticky bottom CTA covers ~78px when scrolled to the very bottom of the reviews section.** This is the standard pattern from Blue Bottle / Verve / % Arabica and the `body { padding-bottom:80px }` already provides headroom for the last fold; no change needed.

## Files touched

- `index.html` only.
- Estimated diff: +9 lines in the `<link>` URL + font-family stacks, +1 manifesto wrapper span, +16 lines for the mobile media query.

## Output artefacts (for review)

All under `/sessions/blissful-bold-franklin/mnt/outputs/mobile_audit/`:
- `full.png` — full 393×10,974 mobile capture
- `section-top.png`, `section-manifesto.png`, `section-menu.png`, `section-brunch.png`, `section-visit.png`, `section-gallery.png`, `section-reviews.png` — anchored captures
- `report.json` — full machine-readable audit output

## Status

**HH mobile fixes staged.**

Two surgical fixes applied to `index.html`:
1. Thai font fallback chain (Sarabun + Noto Serif Thai)
2. Mobile tap-target padding rule

No commit, no push — Dispatch drives the push when ready. The current commit on `origin/main` is `dc2b40e`; the working-tree `index.html` has the two new edits on top of that.
