/**
 * ProfilePage — 个人设置页 "让它更懂你"
 * Reference: stitch_reference/_7/code.html
 * AI persona, budget, owned items, cool-down preference, privacy & data
 */
import { C, Shadow, Font, BW, PersonaOptions, PersonaOption, CoolingOptions } from '../common/Theme';

interface OwnedItem {
  name: string;
  bgColor: string;
  textColor: string;
}

@Component
export struct ProfilePage {
  @State selectedPersona: string = 'toxic';
  @State budget: string = '3000';
  @State selectedCooling: number = 1;
  @State ownedItems: OwnedItem[] = [
    { name: 'Sony WH-1000XM4 Headphones', bgColor: C.tertiaryContainer, textColor: C.onTertiaryContainer },
    { name: '3 Unread Biographies', bgColor: C.secondaryFixed, textColor: C.onSecondaryFixed },
  ];

  build() {
    Scroll() {
      Column() {
        // ── Page Headline ─────────────────────
        Column() {
          Text('让它更懂你，\n不是更了解你的隐私。')
            .fontSize(Font.headlineMd.size)
            .fontWeight(Font.headlineMd.weight)
            .fontColor(C.onBackground)
            .textAlign(TextAlign.Center)
            .maxLines(2)
          Text('Customize your internal monologue.')
            .fontSize(Font.bodyMd.size)
            .fontWeight(Font.bodyMd.weight)
            .fontColor(C.onSurfaceVariant)
            .textAlign(TextAlign.Center)
            .margin({ top: 8 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 32, bottom: 24 })

        // ── Section 1: AI Persona ─────────────
        this.Section1Persona()

        // ── Section 2: Monthly Budget ────────
        this.Section2Budget()

        // ── Section 3: Owned Items ───────────
        this.Section3OwnedItems()

        // ── Section 4: Cooling Preference ────
        this.Section4Cooling()

        // ── Section 5: Privacy & Data ────────
        this.Section5Privacy()
      }
      .width('100%')
      .padding({ bottom: 40 })
    }
    .width('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(C.background)
  }

  // ── Section 1: AI Persona ─────────────────
  @Builder
  Section1Persona() {
    Column() {
      // Vibe Check badge
      Row() {
        Text('Vibe Check')
          .fontSize(Font.noteHandwritten.size)
          .fontWeight(Font.noteHandwritten.weight)
          .fontColor(C.onSecondaryContainer)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor(C.secondaryContainer)
          .border(BW.full)
          .shadow(Shadow.hardSm)
          .rotate({ angle: 3 })
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .margin({ bottom: 12 })

      // Title
      Row() {
        Text('🧠')
          .fontSize(20)
          .margin({ right: 8 })
        Text('AI 说话人格')
          .fontSize(20)
          .fontWeight(Font.headlineMd.weight)
          .fontColor(C.onBackground)
      }
      .margin({ bottom: 16 })

      // 2x2 grid
      Column() {
        Row() {
          this.PersonaCard(PersonaOptions[0])
          this.PersonaCard(PersonaOptions[1])
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          this.PersonaCard(PersonaOptions[2])
          this.PersonaCard(PersonaOptions[3])
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 12 })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor(C.surfaceContainerLowest)
    .border(BW.full)
    .shadow(Shadow.hard)
    .borderRadius(4)
    .rotate({ angle: -1 })
    .margin({ left: 20, right: 20, bottom: 32 })
  }

  // ── Section 2: Monthly Budget ─────────────
  @Builder
  Section2Budget() {
    Column() {
      Row() {
        Text('💰')
          .fontSize(20)
          .margin({ right: 8 })
        Text('每月可支配预算')
          .fontSize(20)
          .fontWeight(Font.headlineMd.weight)
          .fontColor(C.onBackground)
      }
      .margin({ bottom: 8 })

      Text('Set a soft limit to trigger extra reflection warnings.')
        .fontSize(Font.bodyMd.size)
        .fontColor(C.onSurfaceVariant)
        .margin({ bottom: 16 })

      Row() {
        Text('¥')
          .fontSize(Font.headlineMd.size)
          .fontWeight(Font.headlineMd.weight)
          .fontColor(C.onSurfaceVariant)
          .margin({ right: 4 })

        TextInput({ text: this.budget })
          .fontSize(32)
          .fontWeight(800)
          .fontColor(C.onBackground)
          .backgroundColor(Color.Transparent)
          .border({ width: { bottom: '4vp' }, color: C.onBackground })
          .padding({ bottom: 4 })
          .layoutWeight(1)
          .onChange((v: string) => { this.budget = v })

        Text('✏️')
          .fontSize(20)
          .fontColor(C.primary)
          .margin({ left: 8 })
      }
      .width('100%')
      .alignItems(VerticalAlign.Bottom)
    }
    .width('100%')
    .padding(20)
    .backgroundColor(C.surfaceContainerLowest)
    .border(BW.full)
    .shadow(Shadow.hard)
    .borderRadius(4)
    .rotate({ angle: 1 })
    .margin({ left: 20, right: 20, bottom: 32 })
  }

  // ── Section 3: Owned Items ────────────────
  @Builder
  Section3OwnedItems() {
    Column() {
      Row() {
        Text('📦')
          .fontSize(20)
          .margin({ right: 8 })
        Text('我已有的物品')
          .fontSize(20)
          .fontWeight(Font.headlineMd.weight)
          .fontColor(C.onBackground)
        Blank()
        Button() {
          Text('+')
            .fontSize(18)
            .fontWeight(700)
            .fontColor(C.onPrimaryContainer)
        }
        .width(32)
        .height(32)
        .borderRadius(16)
        .backgroundColor(C.primaryContainer)
        .border(BW.full)
        .shadow(Shadow.hardSm)
      }
      .width('100%')

      Text('Remind me I already have these before I buy similar things.')
        .fontSize(14)
        .fontColor(C.onSurfaceVariant)
        .margin({ top: 4, bottom: 16 })

      ForEach(this.ownedItems, (item: OwnedItem) => {
        Row() {
          Text(item.name)
            .fontSize(Font.noteHandwritten.size)
            .fontWeight(Font.noteHandwritten.weight)
            .fontColor(item.textColor)
            .layoutWeight(1)
          Text('✕')
            .fontSize(14)
            .opacity(0.6)
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 10, bottom: 10 })
        .backgroundColor(item.bgColor)
        .border(BW.full)
        .shadow(Shadow.hardSm)
        .borderRadius(4)
        .rotate({ angle: 1 })
        .margin({ bottom: 12 })
      })
    }
    .width('100%')
    .padding(20)
    .backgroundColor(C.surfaceContainerLowest)
    .border(BW.full)
    .shadow(Shadow.hard)
    .borderRadius(4)
    .margin({ left: 20, right: 20, bottom: 32 })
  }

  // ── Section 4: Cooling Preference ─────────
  @Builder
  Section4Cooling() {
    Column() {
      Row() {
        Text('⏳')
          .fontSize(20)
          .margin({ right: 8 })
        Text('冷静期偏好')
          .fontSize(20)
          .fontWeight(Font.headlineMd.weight)
          .fontColor(C.onBackground)
      }
      .margin({ bottom: 16 })

      Row() {
        ForEach(CoolingOptions, (opt: string, idx: number) => {
          Text(opt)
            .fontSize(Font.labelCaps.size)
            .fontWeight(Font.labelCaps.weight)
            .fontColor(this.selectedCooling === idx ? C.onPrimaryContainer : C.onSurface)
            .padding({ left: 16, right: 16, top: 10, bottom: 10 })
            .backgroundColor(this.selectedCooling === idx ? C.primaryContainer : C.surface)
            .border(BW.full)
            .borderRadius(4)
            .shadow(this.selectedCooling === idx ? Shadow.hardSm : Shadow.none)
            .margin({ right: 10 })
            .onClick(() => { this.selectedCooling = idx })
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor(C.surfaceContainerLowest)
    .border(BW.full)
    .shadow(Shadow.hard)
    .borderRadius(4)
    .rotate({ angle: -1 })
    .margin({ left: 20, right: 20, bottom: 32 })
  }

  // ── Section 5: Privacy & Data ─────────────
  @Builder
  Section5Privacy() {
    Column() {
      Row() {
        Text('🔒')
          .fontSize(20)
          .margin({ right: 8 })
        Text('隐私与数据')
          .fontSize(20)
          .fontWeight(Font.headlineMd.weight)
          .fontColor(C.onBackground)
      }
      .margin({ bottom: 8 })

      Text('Your reflections are yours. We don\'t sell your impulse data.')
        .fontSize(14)
        .fontColor(C.onSurfaceVariant)
        .margin({ bottom: 20 })

      Row() {
        Text('Export My Data')
          .fontSize(16)
          .fontWeight(700)
          .fontColor(C.onBackground)
          .layoutWeight(1)
        Text('→')
          .fontSize(18)
          .fontColor(C.outline)
      }
      .width('100%')
      .border({ width: { bottom: '2vp' }, color: C.surfaceVariant })
      .padding({ bottom: 12 })
      .margin({ bottom: 12 })

      Row() {
        Text('Clear All History')
          .fontSize(16)
          .fontWeight(700)
          .fontColor(C.error)
          .layoutWeight(1)
        Text('🗑️')
          .fontSize(18)
      }
      .width('100%')
      .border({ width: { bottom: '2vp' }, color: C.surfaceVariant })
      .padding({ bottom: 12 })
    }
    .width('100%')
    .padding(20)
    .backgroundColor(C.surfaceContainerLowest)
    .border(BW.full)
    .shadow(Shadow.hard)
    .borderRadius(4)
    .margin({ left: 20, right: 20, bottom: 32 })
  }

  // ── Persona Card ──────────────────────────
  @Builder
  PersonaCard(opt: PersonaOption) {
    Column() {
      if (this.selectedPersona === opt.id) {
        Text('SELECTED')
          .fontSize(9)
          .fontWeight(Font.labelCaps.weight)
          .fontColor(C.onPrimaryContainer)
          .opacity(0.8)
          .margin({ bottom: 4 })
      } else {
        Text('OPTION')
          .fontSize(9)
          .fontColor(Color.Transparent)
          .margin({ bottom: 4 })
      }

      Text(opt.label)
        .fontSize(18)
        .fontWeight(Font.headlineMd.weight)
        .fontColor(this.selectedPersona === opt.id ? C.onPrimaryContainer : C.onSurface)

      Text(opt.sub)
        .fontSize(14)
        .fontColor(this.selectedPersona === opt.id ? C.onPrimaryContainer : C.onSurfaceVariant)
        .margin({ top: 4 })
        .opacity(0.9)
    }
    .width('48%')
    .padding(14)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(this.selectedPersona === opt.id ? C.primaryContainer : C.surface)
    .border(BW.full)
    .borderRadius(4)
    .shadow(this.selectedPersona === opt.id ? Shadow.none : Shadow.hard)
    .onClick(() => { this.selectedPersona = opt.id })
  }
}
