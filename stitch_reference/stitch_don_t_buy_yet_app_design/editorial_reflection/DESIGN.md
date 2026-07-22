---
name: Editorial Reflection
colors:
  surface: '#fbf9f4'
  surface-dim: '#dbdad5'
  surface-bright: '#fbf9f4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3ee'
  surface-container: '#f0eee9'
  surface-container-high: '#eae8e3'
  surface-container-highest: '#e4e2dd'
  on-surface: '#1b1c19'
  on-surface-variant: '#4d4634'
  inverse-surface: '#30312e'
  inverse-on-surface: '#f2f1ec'
  outline: '#7f7662'
  outline-variant: '#d0c6ae'
  surface-tint: '#735c00'
  primary: '#735c00'
  on-primary: '#ffffff'
  primary-container: '#ffd54f'
  on-primary-container: '#735c00'
  inverse-primary: '#ebc23e'
  secondary: '#ac3509'
  on-secondary: '#ffffff'
  secondary-container: '#fe6f42'
  on-secondary-container: '#631800'
  tertiary: '#006a63'
  on-tertiary: '#ffffff'
  tertiary-container: '#84eadf'
  on-tertiary-container: '#006a63'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffe087'
  primary-fixed-dim: '#ebc23e'
  on-primary-fixed: '#241a00'
  on-primary-fixed-variant: '#574500'
  secondary-fixed: '#ffdbd0'
  secondary-fixed-dim: '#ffb59f'
  on-secondary-fixed: '#3a0a00'
  on-secondary-fixed-variant: '#852300'
  tertiary-fixed: '#8ef4e9'
  tertiary-fixed-dim: '#71d7cd'
  on-tertiary-fixed: '#00201d'
  on-tertiary-fixed-variant: '#00504a'
  background: '#fbf9f4'
  on-background: '#1b1c19'
  surface-variant: '#e4e2dd'
typography:
  display-lg:
    fontFamily: Epilogue
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Epilogue
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Epilogue
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 30px
  body-lg:
    fontFamily: Work Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Work Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  note-handwritten:
    fontFamily: Bricolage Grotesque
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 22px
    letterSpacing: 0.01em
  label-caps:
    fontFamily: Work Sans
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 8px
  container-padding: 20px
  element-gap: 16px
  tilt-angle: 2deg
---

## Brand & Style

This design system is built for a reflective consumer experience that slows down the impulse to purchase through emotional resonance and editorial charm. The brand personality is witty and trustworthy, acting as a sophisticated "internal monologue" rather than a clinical financial tool.

The visual style is **Editorial Collage**. It blends the structural boldness of Neobrutalism with the tactile warmth of high-end print magazines. The interface should feel like a curated scrap-book: intentional, slightly irregular, and deeply human. We use "tilted" elements and paper-texture metaphors to break the digital monotony, ensuring the user feels they are interacting with a personal journal of reflections.

## Colors

The palette is anchored by a warm **Cream White (#F9F7F2)** background, which provides a non-clinical, organic canvas. 

- **Primary (#FFD54F):** A sun-drenched warm yellow used for semantic emphasis and key calls to action.
- **Danger/Risk (#FF7043):** A vibrant Coral-Red used for "impulse alerts," annotations, and warnings.
- **Success (#4DB6AC):** A muted Teal used for positive outcomes and "savings milestones."
- **Stroke/Border (#000000):** Pure black is used for all structural borders and shadows to provide an illustrative, ink-on-paper feel.

## Typography

The typography strategy relies on a "High-Low" mix:
1. **Epilogue** (Headlines): A geometric, heavy sans-serif that provides the "Editorial Poster" impact. It should be used for big questions and product names.
2. **Work Sans** (Body): A reliable, grounded typeface for descriptions and data.
3. **Bricolage Grotesque** (Annotations): Used to represent the "Handwritten" voice. It appears on labels, "stamps," and personal notes, adding a quirky, characterful layer to the UI.

Always use heavy weights for headlines to maintain the magazine aesthetic. Use `label-caps` for small, uppercase metadata.

## Layout & Spacing

The layout is a fluid mobile-first grid but with **intentional disruption**. 
- **The "Tilted" Rule:** Key elements like Polaroid cards or labels should have a subtle rotation (between -2 and 2 degrees) to mimic items laid out on a physical desk.
- **Margins:** High-contrast layout with a generous 20px safe area on all sides.
- **Structure:** Use a 4-column fluid grid for mobile. Elements should often overlap slightly (e.g., a "Stamp" element overlapping the corner of a card) to reinforce the collage feel.
- **Stacking:** Items should be stacked vertically like a receipt strip, using varying heights to keep the eye engaged.

## Elevation & Depth

This system rejects soft, blurred shadows in favor of **Sharp Offset Shadows**. 
- **Shadow Character:** Hard black shadows (#000000) offset by 4px down and 4px right. No blur.
- **Borders:** Every interactive surface or container must have a 2px solid black border. 
- **Tonal Layers:** Depth is created by "stacking paper." A card sits on the cream background with its black shadow; a label might sit on top of that card with a smaller 2px shadow.
- **Collage Textures:** Use subtle noise or paper grain overlays on large background areas to avoid a "flat" digital appearance.

## Shapes

The shape language is "Slightly Imperfect." 
- **Corners:** Use "Soft" roundedness (4px - 8px) to prevent the UI from feeling too aggressive or "Brutalist." It should feel like high-quality cardstock.
- **Polaroid Style:** Cards should have a thicker bottom margin than the top/sides to mimic instant film photos.
- **Receipt Strips:** Long list items should have a "jagged" or perforated edge at the bottom where possible.
- **Buttons:** Rectangular with sharp shadows, providing a satisfying, tactile "click" feel.

## Components

- **Reflection Cards:** Polaroid-style containers with a 2px border and 4px offset shadow. Use for product images and "reasons to wait."
- **Primary Buttons:** Warm Yellow (#FFD54F) fill, 2px black border, and bold uppercase Epilogue text. On press, the shadow should disappear as the button "sinks" into the page.
- **Risk Annotations:** Small Coral-Red (#FF7043) labels that look like hand-placed stickers or stamps.
- **Success Strips:** Muted Teal (#4DB6AC) horizontal bars that look like "Washi tape," used to celebrate a saved purchase.
- **Input Fields:** Minimalist cream backgrounds with a heavy bottom-only border, appearing like a line on a notepad.
- **Icons:** "Hand-drawn" style with varied line weights, always in pure black. Avoid perfect geometric icons.
- **Receipt List:** A vertical list of "Don't Buy" items where each item is a horizontal strip with a perforated bottom edge.