# Build brief — Holic Haus cafe&garden marketing site

Project folder: this folder (single static site, no build step).
Local server: `node serve.mjs` → http://localhost:3000.
Output rules: follow `./CLAUDE.md` (single `index.html`, Tailwind via CDN, all styles inline, custom palette, layered shadows, display+sans pair, no `transition-all`, hover/focus-visible/active on every interactive element).

## Cafe facts (verified from Google Maps + web search)

- **Name:** Holic Haus cafe&garden — โฮลิคเฮ้าส์ คาเฟ่แอนด์การ์เด้น
- **Location:** Srinagarindra Rd, Mueang Samut Prakan District, Samut Prakan 10270, Thailand (across from iMall)
- **Plus code:** HJW5+8J Samut Prakan, Pak Nam
- **Phone:** 064 174 9462 (+66 64 174 9462)
- **Hours (Asia/Bangkok):** Tue–Sun 8:30–17:00, Mon closed
- **Rating:** 4.6 ★ (98 reviews on Google Maps)
- **Price:** ฿1–200 per person
- **Service options:** Dine-in · Kerbside pickup · Delivery · LGBTQ+ friendly
- **Vibe descriptors from reviews:** small neighbourhood cafe, beautiful garden, shady, lots of greenery, warm and comfortable, good for working and chilling
- **Menu highlights** (with prices used as plausible placeholders — confirm in store):
  - Ice Cappuccino ฿85
  - Hazelnut Latte ฿110 (guest pick — Thai review: "อร่อยมากๆๆๆๆๆ")
  - Orange Coffee ฿120
  - Cold Brew ฿95
  - Strawberry Cake ฿130
  - Butter Croissant ฿70
- **Real review quotes** to use verbatim:
  - "The atmosphere is very nice, feeling warm and comfortable. There's a lot of greenery in the outdoor area, making it shady and pleasant. Highly recommended." — Panchanita S., Local Guide
  - "Very nice little coffee shop with a decent brunch menu. Has outdoor seating in a nice little nature cove. Service is good." — Ben R., Local Guide
  - "Nice place and vibe! Love the staff too. Best to work, best to chill. Love the coffee and the croissant." — Janene G., Local Guide

## Links

- Google Maps: https://www.google.com/maps/place/Holic+Haus+cafe%26garden/@13.5958463,100.6090177,17z
- Facebook: https://www.facebook.com/holichaus/
- Instagram: https://www.instagram.com/holichauscafeandgarden/

## Real photos available

- `images/hero-large.jpg` — exterior with orange container wall, outdoor seating, tree canopy (≈1600×900, sourced from Google Maps listing).
- `images/hero-exterior.jpg` — same composition, smaller (≈1598×900).
- More photos are still to pull from the Facebook page once login flow is sorted (see "Open items" below).

## Conversion priorities (in order)

1. **Get directions** — the cafe has no online ordering page yet; directions is the highest-intent primary CTA, repeated sticky in the nav and as a mobile bottom bar.
2. **Click-to-call** — secondary CTA, large tap targets.
3. **Map + hours visibility** — visible without scrolling on visit section.
4. **Social proof** — 4.6 ★ / 98 reviews shown next to hero CTA + a 3-up review wall.

Patterns borrowed from Blue Bottle / Verve / % Arabica / boutique cafes:
- Sticky nav with single primary CTA
- One-line hero value prop + single primary action
- Social-proof rating bar inside hero
- Menu preview with prices + one starred "guest pick" card
- Visit card combining hours + map + click-to-call
- Photo gallery with at least one large hero tile
- Mobile sticky CTA pinned to bottom
- Footer with FB + IG + address + hours

## Brand palette (derived from the cafe's actual scene — do NOT use default Tailwind)

- Terracotta primary (cafe container wall): `#c2410c` (700 `#8a2a08`, 300 `#ea6b2a`, 100 `#fbd9c2`)
- Garden green: `#1f2a1e` / `#3d5639` / `#6d8a4f` / `#a3b87f` / `#dde6ce`
- Cream paper: `#fffaf2`, `#faf6ef`, `#f3ece0`, `#e6dccb`
- Ink: `#1a1410`, `#3b322b`, `#6b5e54`

## Typography

- Display serif: **Fraunces** (700 for headings; italic 500 for accent words)
- Body sans: **Inter** (400/500/600/700)
- Tight tracking on large headings (`-0.035em`)
- Generous body line-height (`1.7`)

## Already in place (built by previous pass)

- Single `index.html` with Tailwind CDN, inline styles, custom palette, layered shadows (`box-shadow` tinted with terracotta low-opacity)
- Sections: sticky nav, hero, info strip, menu preview, visit (address/hours table/map iframe), gallery, review wall, final CTA, footer, mobile sticky CTA
- Live "Open now / Closed · opens tomorrow at 8:30" status in Asia/Bangkok via `Intl.DateTimeFormat`
- Lazy-loaded images, focus-visible outlines, prefers-reduced-motion fallback
- `serve.mjs` for `node serve.mjs` (localhost:3000) and `start-server.bat` to launch it

## Open items / hand-off to Claude Code

1. **Pull from Facebook** (`facebook.com/holichaus`): menu items + prices, About section, recent posts/events, opening-hours overrides, additional photos. Try `m.facebook.com/holichaus` if main domain hits a login wall. Insert real prices into menu cards and add a "What's on this week" row from recent posts.
2. **Iterate on visual craft** per CLAUDE.md "at least 2 comparison rounds": screenshot localhost:3000, compare to a reference cafe site of your choice, fix mismatches.
3. **Add an `og:image`** and `<link rel="icon">` (favicon) using a cropped version of the hero.
4. **Performance pass**: inline critical CSS for above-the-fold; replace external font import with a `<link rel="preload">` + `font-display: swap` (already swap in URL).

## How to run

```bat
:: From this folder
node serve.mjs
```

Then open http://localhost:3000.
