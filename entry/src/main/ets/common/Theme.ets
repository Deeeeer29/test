/**
 * Design System — Editorial Collage / Neobrutalism
 * Reference: stitch_reference DESIGN.md
 */

// ── Color Palette ──────────────────────────────────────
export interface ThemeColors {
  background: string;
  surface: string;
  surfaceContainerLowest: string;
  surfaceContainerLow: string;
  surfaceContainer: string;
  surfaceContainerHigh: string;
  surfaceVariant: string;
  surfaceDim: string;
  onBackground: string;
  onSurface: string;
  onSurfaceVariant: string;
  primary: string;
  onPrimary: string;
  primaryContainer: string;
  onPrimaryContainer: string;
  primaryFixed: string;
  primaryFixedDim: string;
  secondary: string;
  onSecondary: string;
  secondaryContainer: string;
  onSecondaryContainer: string;
  secondaryFixed: string;
  onSecondaryFixed: string;
  tertiary: string;
  onTertiary: string;
  tertiaryContainer: string;
  onTertiaryContainer: string;
  tertiaryFixedDim: string;
  error: string;
  onError: string;
  errorContainer: string;
  onErrorContainer: string;
  outline: string;
  outlineVariant: string;
  inverseSurface: string;
  inverseOnSurface: string;
}

export const C: ThemeColors = {
  background: '#FBF9F4',
  surface: '#FBF9F4',
  surfaceContainerLowest: '#FFFFFF',
  surfaceContainerLow: '#F5F3EE',
  surfaceContainer: '#F0EEE9',
  surfaceContainerHigh: '#EAE8E3',
  surfaceVariant: '#E4E2DD',
  surfaceDim: '#DBDAD5',

  onBackground: '#1B1C19',
  onSurface: '#1B1C19',
  onSurfaceVariant: '#4D4634',

  primary: '#735C00',
  onPrimary: '#FFFFFF',
  primaryContainer: '#FFD54F',
  onPrimaryContainer: '#735C00',
  primaryFixed: '#FFE087',
  primaryFixedDim: '#EBC23E',

  secondary: '#AC3509',
  onSecondary: '#FFFFFF',
  secondaryContainer: '#FE6F42',
  onSecondaryContainer: '#631800',
  secondaryFixed: '#FFDBD0',
  onSecondaryFixed: '#3A0A00',

  tertiary: '#006A63',
  onTertiary: '#FFFFFF',
  tertiaryContainer: '#84EADF',
  onTertiaryContainer: '#006A63',
  tertiaryFixedDim: '#71D7CD',

  error: '#BA1A1A',
  onError: '#FFFFFF',
  errorContainer: '#FFDAD6',
  onErrorContainer: '#93000A',

  outline: '#7F7662',
  outlineVariant: '#D0C6AE',

  inverseSurface: '#30312E',
  inverseOnSurface: '#F2F1EC',
};

// ── Shadows (Neobrutalism) ─────────────────────────────
export class ShadowDef {
  radius: number;
  color: string;
  offsetX: number;
  offsetY: number;

  constructor(radius: number, color: string, offsetX: number, offsetY: number) {
    this.radius = radius;
    this.color = color;
    this.offsetX = offsetX;
    this.offsetY = offsetY;
  }
}

export class ShadowTokens {
  hard: ShadowDef = new ShadowDef(0, '#000000', 4, 4);
  hardSm: ShadowDef = new ShadowDef(0, '#000000', 2, 2);
  hardLg: ShadowDef = new ShadowDef(0, '#000000', 6, 6);
  navTop: ShadowDef = new ShadowDef(0, '#000000', 0, -4);
  none: ShadowDef = new ShadowDef(0, 'transparent', 0, 0);
}

export const Shadow: ShadowTokens = new ShadowTokens();

// ── Border Widths ───────────────────────────────────────
export class BorderDef {
  width: string;
  color: string;

  constructor(width: string, color: string) {
    this.width = width;
    this.color = color;
  }
}

export class BorderTokens {
  full: BorderDef = new BorderDef('2vp', '#1B1C19');
}

export const BW: BorderTokens = new BorderTokens();

// ── Typography ──────────────────────────────────────────
export class FontDef {
  size: number;
  weight: number;

  constructor(size: number, weight: number) {
    this.size = size;
    this.weight = weight;
  }
}

export class FontTokens {
  displayLg: FontDef = new FontDef(40, 800);
  headlineLg: FontDef = new FontDef(30, 700);
  headlineMd: FontDef = new FontDef(24, 700);
  bodyLg: FontDef = new FontDef(18, 400);
  bodyMd: FontDef = new FontDef(16, 400);
  noteHandwritten: FontDef = new FontDef(16, 500);
  labelCaps: FontDef = new FontDef(12, 700);
}

export const Font: FontTokens = new FontTokens();

// ── Spacing ─────────────────────────────────────────────
export class SpacingDef {
  containerPadding: number;
  elementGap: number;
  base: number;

  constructor(containerPadding: number, elementGap: number, base: number) {
    this.containerPadding = containerPadding;
    this.elementGap = elementGap;
    this.base = base;
  }
}

export const SP: SpacingDef = new SpacingDef(20, 16, 8);

// ── Tab Navigation Data ─────────────────────────────────
export class TabItem {
  index: number;
  label: string;
  icon: string;

  constructor(index: number, label: string, icon: string) {
    this.index = index;
    this.label = label;
    this.icon = icon;
  }
}

export const NavTabs: TabItem[] = [
  new TabItem(0, 'REFLECT', 'auto_stories'),
  new TabItem(1, 'MUSEUM', 'receipt_long'),
  new TabItem(2, 'WISHLIST', 'favorite'),
  new TabItem(3, 'ME', 'face_6'),
];

// ── AI Personality Options ──────────────────────────────
export class PersonaOption {
  id: string;
  label: string;
  sub: string;

  constructor(id: string, label: string, sub: string) {
    this.id = id;
    this.label = label;
    this.sub = sub;
  }
}

export const PersonaOptions: PersonaOption[] = [
  new PersonaOption('toxic', '毒舌闺蜜', 'Brutally honest.'),
  new PersonaOption('gentle', '温柔搭子', 'Gentle support.'),
  new PersonaOption('strict', '严厉会计', 'Cold numbers.'),
  new PersonaOption('reverse', '反向销售', 'Talks you out of it.'),
];

// ── Cooling Period Options ──────────────────────────────
export const CoolingOptions: string[] = ['6 HOURS', '24 HOURS', '3 DAYS', 'AUTO'];

// ── Flow State Enum ────────────────────────────────────
export enum FlowStep {
  HOME = 0,
  CONFIRM = 1,
  AI_ANALYSIS = 2,
  INTERROGATION = 3,
  VERDICT = 4,
}

// ── Shared Flow Product Data ───────────────────────────
@Observed
export class FlowProduct {
  name: string = '无线降噪耳机';
  brand: string = '示例型号 X1';
  price: string = '¥1,899';
  category: string = '数码产品';
  params: string = '主动降噪、蓝牙连接、约 30 小时续航';
  imageUrl: string = '';

  copyFrom(src: FlowProduct): void {
    this.name = src.name;
    this.brand = src.brand;
    this.price = src.price;
    this.category = src.category;
    this.params = src.params;
    this.imageUrl = src.imageUrl;
  }
}
