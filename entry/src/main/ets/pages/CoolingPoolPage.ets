/**
 * CoolingPoolPage — 冷静池
 * Reference: stitch_reference/_5/code.html
 * Three states: cooling (polaroid), reconsidering (pinned note), abandoned (receipt/grayed)
 */
import { C, Shadow, Font, BW } from '../common/Theme';

interface CoolingItem {
  id: number;
  name: string;
  price: string;
  status: 'cooling' | 'reconsider' | 'abandoned';
  timeLeft: string;
  icon: string;
}

@Component
export struct CoolingPoolPage {
  @State items: CoolingItem[] = [
    {
      id: 1,
      name: 'Sony WH-1000XM5 耳机',
      price: '¥ 2,499',
      status: 'cooling',
      timeLeft: '19H LEFT',
      icon: '🎧'
    },
    {
      id: 2,
      name: '客制化机械键盘',
      price: '¥ 899',
      status: 'reconsider',
      timeLeft: '2 DAYS LEFT',
      icon: '⌨️'
    },
    {
      id: 3,
      name: 'GoPro 运动相机',
      price: '¥ 3,199',
      status: 'abandoned',
      timeLeft: '',
      icon: '📹'
    },
  ];

  build() {
    Scroll() {
      Column() {
        // ── Headline Section ──────────────────
        Column() {
          // Water drop decoration
          Stack({ alignContent: Alignment.TopEnd }) {
            Column() {
              Text('先放一放，\n喜欢不会马上过期。')
                .fontSize(Font.headlineLg.size)
                .fontWeight(Font.headlineLg.weight)
                .fontColor(C.onBackground)
                .lineHeight(36)
                .maxLines(3)
              Text('The Cooling Pool — giving your impulses time to chill.')
                .fontSize(Font.noteHandwritten.size)
                .fontWeight(Font.noteHandwritten.weight)
                .fontColor(C.onSurfaceVariant)
                .margin({ top: 8 })
            }
            .width('100%')
            .padding(20)
            .backgroundColor(C.surfaceContainerHigh)
            .border(BW.full)
            .shadow(Shadow.hard)
            .borderRadius(4)
            .rotate({ angle: 1 })

            // Water drop icon badge
            Text('💧')
              .fontSize(24)
              .margin({ top: -12, right: -12 })
          }
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 28 })

        // ── Summary Strip (Washi Tape) ────────
        Row() {
          Text('✅')
            .fontSize(16)
            .margin({ right: 8 })
          Text('本月你已经忍住 3 次冲动')
            .fontSize(Font.labelCaps.size)
            .fontWeight(Font.labelCaps.weight)
            .fontColor(C.onTertiaryContainer)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(C.tertiaryContainer)
        .border(BW.full)
        .shadow(Shadow.hard)
        .borderRadius(4)
        .rotate({ angle: -1 })
        .margin({ left: 20, right: 20, top: 24 })

        // ── Cooling Items ─────────────────────
        ForEach(this.items, (item: CoolingItem, index: number) => {
          if (item.status === 'cooling') {
            this.CoolingCard(item)
          } else if (item.status === 'reconsider') {
            this.ReconsiderCard(item)
          } else {
            this.AbandonedCard(item)
          }
        })
      }
      .width('100%')
      .padding({ bottom: 40 })
    }
    .width('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(C.background)
  }

  // ── Cooling Card (Polaroid style) ──────────
  @Builder
  CoolingCard(item: CoolingItem) {
    Column() {
      // Timer badge
      Stack({ alignContent: Alignment.TopStart }) {
        Column() {
          // Image area
          Column() {
            Text(item.icon)
              .fontSize(64)
          }
          .width('100%')
          .aspectRatio(1)
          .backgroundColor(C.surfaceVariant)
          .border(BW.full)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          // Info row
          Row() {
            Column() {
              Text(item.name)
                .fontSize(Font.headlineMd.size)
                .fontWeight(Font.headlineMd.weight)
                .fontColor(C.onBackground)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(item.price)
                .fontSize(Font.noteHandwritten.size)
                .fontWeight(Font.noteHandwritten.weight)
                .fontColor(C.outline)
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Text('正在冷静')
              .fontSize(Font.labelCaps.size)
              .fontWeight(Font.labelCaps.weight)
              .fontColor(C.onSurfaceVariant)
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor(C.surfaceVariant)
              .border(BW.full)
              .rotate({ angle: -2 })
          }
          .width('100%')
          .margin({ top: 8 })

          // Action buttons
          Row() {
            Button() {
              Text('📊 重新分析')
                .fontSize(Font.labelCaps.size)
                .fontWeight(Font.labelCaps.weight)
                .fontColor(C.onBackground)
            }
            .layoutWeight(1)
            .height(36)
            .backgroundColor(C.surface)
            .border(BW.full)
            .borderRadius(4)
            .shadow(Shadow.hardSm)
            .margin({ right: 8 })

            Button() {
              Text('决定不买')
                .fontSize(Font.labelCaps.size)
                .fontWeight(Font.labelCaps.weight)
                .fontColor(C.onPrimaryContainer)
            }
            .layoutWeight(1)
            .height(36)
            .backgroundColor(C.primaryContainer)
            .border(BW.full)
            .borderRadius(4)
            .shadow(Shadow.hardSm)
          }
          .width('100%')
          .margin({ top: 10 })
        }
        .width('100%')
        .padding({ top: 12, left: 12, right: 12, bottom: 16 })
        .backgroundColor(C.surface)
        .border(BW.full)
        .shadow(Shadow.hard)
        .borderRadius(4)
        .rotate({ angle: 1 })

        // Timer sticker
        Row() {
          Text('⏳')
            .fontSize(14)
            .margin({ right: 4 })
          Text(item.timeLeft)
            .fontSize(Font.labelCaps.size)
            .fontWeight(Font.labelCaps.weight)
            .fontColor(C.onPrimaryContainer)
        }
        .padding({ left: 10, right: 10, top: 4, bottom: 4 })
        .backgroundColor(C.primaryContainer)
        .border(BW.full)
        .shadow(Shadow.hardSm)
        .rotate({ angle: -6 })
        .margin({ top: -12, left: -8 })
      }
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 28 })
  }

  // ── Reconsider Card (pinned note style) ───
  @Builder
  ReconsiderCard(item: CoolingItem) {
    Column() {
      Row() {
        // Small image
        Column() {
          Text(item.icon)
            .fontSize(32)
        }
        .width(80)
        .height(80)
        .backgroundColor(C.surfaceVariant)
        .border(BW.full)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        // Info
        Column() {
          Text(item.timeLeft)
            .fontSize(Font.labelCaps.size)
            .fontWeight(Font.labelCaps.weight)
            .fontColor(C.onSecondary)
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .backgroundColor(C.secondaryContainer)
            .border(BW.full)
            .shadow(Shadow.hardSm)
            .rotate({ angle: -2 })
            .margin({ bottom: 8 })

          Text(item.name)
            .fontSize(20)
            .fontWeight(Font.headlineMd.weight)
            .fontColor(C.onBackground)

          Text('再想想...')
            .fontSize(Font.noteHandwritten.size)
            .fontWeight(Font.noteHandwritten.weight)
            .fontColor(C.secondaryContainer)
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 16 })
        .layoutWeight(1)
      }
      .width('100%')
      .padding(16)
      .backgroundColor(C.secondaryFixed)
      .border(BW.full)
      .shadow(Shadow.hard)
      .borderRadius(4)
      .rotate({ angle: -1.5 })
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 20 })
  }

  // ── Abandoned Card (receipt style, grayed) ─
  @Builder
  AbandonedCard(item: CoolingItem) {
    Column() {
      Row() {
        Text(item.icon)
          .fontSize(32)
          .margin({ right: 16 })

        Column() {
          Text(item.name)
            .fontSize(Font.bodyLg.size)
            .fontWeight(700)
            .fontColor(C.onSurfaceVariant)
            .decoration({ type: TextDecorationType.LineThrough, color: C.outline })
          Text(item.price)
            .fontSize(Font.noteHandwritten.size)
            .fontWeight(Font.noteHandwritten.weight)
            .fontColor(C.outline)
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Text('已放弃')
          .fontSize(Font.labelCaps.size)
          .fontWeight(Font.labelCaps.weight)
          .fontColor(C.onSurfaceVariant)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor(C.surface)
          .border(BW.full)
          .shadow(Shadow.hardSm)
          .rotate({ angle: 2 })
      }
      .width('100%')

      Button() {
        Text('🔍 查看判断记录')
          .fontSize(Font.labelCaps.size)
          .fontWeight(Font.labelCaps.weight)
          .fontColor(C.onBackground)
      }
      .width('100%')
      .height(36)
      .backgroundColor(C.background)
      .border(BW.full)
      .borderRadius(4)
      .shadow(Shadow.hardSm)
      .margin({ top: 12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(C.surfaceVariant)
    .border({ width: '2vp', color: C.onBackground, style: BorderStyle.Dashed })
    .shadow(Shadow.hard)
    .borderRadius(4)
    .opacity(0.75)
    .rotate({ angle: 0.5 })
    .margin({ left: 20, right: 20, top: 20 })
  }
}
