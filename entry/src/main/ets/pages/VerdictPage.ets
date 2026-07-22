/**
 * VerdictPage — 钱包判决书
 * Reference: stitch_reference/_4/code.html
 * Magazine-style verdict with sentiment meters, bento comparison, and action buttons
 */
import { C, Shadow, Font, BW } from '../common/Theme';

interface VerdictIndicator {
  label: string;
  value: number;
  color: string;
  barColor: string;
}

@Component
export struct VerdictPage {
  @Prop productName: string = '无线降噪耳机';
  @Prop productPrice: string = '¥1,899';
  onCoolingPool: () => void = () => {};
  onHome: () => void = () => {};

  private buyReasons: string[] = ['压力大想解压', '促销降价了', '奖励自己'];
  private waitReasons: string[] = ['已有旧耳机', '使用频率低', '超出本月预算'];
  private conditions: string[] = [
    '旧耳机彻底坏掉',
    '连续一周每天通勤超过1小时',
    '下个月发了奖金'
  ];

  private indicators: VerdictIndicator[] = [
    { label: '心动程度', value: 82, color: C.primary, barColor: C.primary },
    { label: '实用程度', value: 46, color: C.onSurfaceVariant, barColor: C.outline },
    { label: '后悔风险', value: 71, color: C.secondary, barColor: C.secondary },
  ];

  build() {
    Scroll() {
      Column() {
        // Verdict tag (coral stamp)
        Row() {
          Text('钱包判决')
            .fontSize(Font.labelCaps.size)
            .fontWeight(Font.labelCaps.weight)
            .fontColor(C.onSecondaryContainer)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor(C.secondaryContainer)
            .border(BW.full)
            .shadow(Shadow.hardSm)
            .rotate({ angle: -3 })
        }
        .width('100%')
        .padding({ left: 20, top: 24 })

        // Magazine headline
        Text('先等等')
          .fontSize(72)
          .fontWeight(900)
          .fontColor(C.onBackground)
          .lineHeight(72)
          .width('100%')
          .padding({ left: 20 })
          .rotate({ angle: -1 })
          .margin({ top: 16 })

        // Handwritten quote
        Text('"你想买的可能不是耳机，\n而是今晚的情绪出口。"')
          .fontSize(Font.noteHandwritten.size)
          .fontWeight(Font.noteHandwritten.weight)
          .fontColor(C.onSurfaceVariant)
          .lineHeight(24)
          .padding({ left: 24 })
          .border({ width: { left: '4vp' }, color: C.primaryContainer })
          .margin({ left: 24, top: 16 })

        // Product Polaroid
        Column() {
          // Image placeholder
          Column() {
            Text('🎧')
              .fontSize(56)
          }
          .width('100%')
          .aspectRatio(1)
          .backgroundColor(C.surfaceContainer)
          .border(BW.full)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          // Product name + price
          Column() {
            Text(this.productName)
              .fontSize(Font.headlineMd.size)
              .fontWeight(Font.headlineMd.weight)
              .fontColor(C.onBackground)
              .margin({ top: 12 })
            Text(this.productPrice)
              .fontSize(Font.labelCaps.size)
              .fontWeight(Font.labelCaps.weight)
              .fontColor(C.onSurfaceVariant)
              .margin({ top: 4 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .width('70%')
        .padding({ top: 12, left: 12, right: 12, bottom: 20 })
        .backgroundColor(C.surface)
        .border(BW.full)
        .shadow(Shadow.hardLg)
        .rotate({ angle: 2 })
        .margin({ top: 24, left: 20, right: 20 })

        // Sentiment indicators (paper strips)
        Column() {
          ForEach(this.indicators, (ind: VerdictIndicator) => {
            this.IndicatorBar(ind)
          })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 24 })

        // Bento Grid: Why Buy vs Why Wait
        Row() {
          // Why Buy (teal)
          this.ReasonBox(
            '😊',
            '你为什么想买',
            this.buyReasons,
            C.tertiaryContainer,
            C.tertiary,
            1
          )

          // Why Wait (coral)
          this.ReasonBox(
            '⚠️',
            '为什么不建议现在买',
            this.waitReasons,
            C.secondaryFixed,
            C.secondary,
            -1
          )
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 24 })
        .justifyContent(FlexAlign.SpaceBetween)

        // Conditions checklist (receipt style)
        Column() {
          // Header with pin icon
          Row() {
            Text('📌')
              .fontSize(16)
              .margin({ right: 8 })
            Text('满足这些条件，可以再买')
              .fontSize(Font.labelCaps.size)
              .fontWeight(Font.labelCaps.weight)
              .fontColor(C.onBackground)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 16 })

          ForEach(this.conditions, (cond: string) => {
            Row() {
              Column() {
              }
              .width(20)
              .height(20)
              .border(BW.full)
              .backgroundColor(C.surfaceContainer)
              .margin({ right: 12 })

              Text(cond)
                .fontSize(Font.bodyMd.size)
                .fontWeight(Font.bodyMd.weight)
                .fontColor(C.onBackground)
            }
            .width('100%')
            .margin({ bottom: 10 })
          })

          // Receipt footer
          Row() {
            Text('VERDICT_ID: 08249')
              .fontSize(Font.labelCaps.size)
              .fontWeight(Font.labelCaps.weight)
              .fontColor(C.onSurfaceVariant)
            Blank()
            Text('TIME: 23:42')
              .fontSize(Font.labelCaps.size)
              .fontWeight(Font.labelCaps.weight)
              .fontColor(C.onSurfaceVariant)
          }
          .width('100%')
          .border({ width: { top: '2vp' }, color: C.onBackground, style: BorderStyle.Dashed })
          .padding({ top: 10 })
          .margin({ top: 8 })
        }
        .width('100%')
        .padding(20)
        .backgroundColor(C.surface)
        .border({ width: '2vp', color: C.onBackground, style: BorderStyle.Dashed })
        .shadow(Shadow.hard)
        .borderRadius(4)
        .margin({ top: 24, left: 20, right: 20 })

        // Action Buttons
        Column() {
          // Primary: Cooling pool
          Button() {
            Row() {
              Text('💤')
                .fontSize(20)
                .margin({ right: 8 })
              Text('放进冷静池 · 24小时')
                .fontSize(Font.headlineMd.size)
                .fontWeight(Font.headlineMd.weight)
                .fontColor(C.onPrimaryContainer)
            }
          }
          .width('100%')
          .height(56)
          .backgroundColor(C.primaryContainer)
          .border(BW.full)
          .borderRadius(4)
          .shadow(Shadow.hardLg)
          .onClick(() => this.onCoolingPool())

          // Secondary row: Buy / Don't Buy
          Row() {
            Button() {
              Text('我还是决定买')
                .fontSize(Font.labelCaps.size)
                .fontWeight(Font.labelCaps.weight)
                .fontColor(C.onBackground)
            }
            .layoutWeight(1)
            .height(44)
            .backgroundColor(C.surface)
            .border(BW.full)
            .borderRadius(4)
            .shadow(Shadow.hard)
            .margin({ top: 16, right: 8 })
            .onClick(() => this.onHome())

            Button() {
              Text('算了，不买了')
                .fontSize(Font.labelCaps.size)
                .fontWeight(Font.labelCaps.weight)
                .fontColor(C.inverseOnSurface)
            }
            .layoutWeight(1)
            .height(44)
            .backgroundColor(C.inverseSurface)
            .border(BW.full)
            .borderRadius(4)
            .shadow(Shadow.hard)
            .margin({ top: 16, left: 8 })
            .onClick(() => this.onHome())
          }
          .width('100%')

          // Share
          Button() {
            Text('↗ 生成我的钱包判决书')
              .fontSize(Font.noteHandwritten.size)
              .fontWeight(Font.noteHandwritten.weight)
              .fontColor(C.primary)
          }
          .width('100%')
          .height(44)
          .backgroundColor(Color.Transparent)
          .margin({ top: 16 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 32, bottom: 40 })
      }
      .width('100%')
    }
    .width('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(C.background)
  }

  @Builder
  IndicatorBar(ind: VerdictIndicator) {
    Row() {
      // Left accent bar
      Column() {
      }
      .width(4)
      .height('100%')
      .backgroundColor(ind.color)
      .border({ width: { right: '2vp' }, color: C.onBackground })

      Text(ind.label)
        .fontSize(Font.labelCaps.size)
        .fontWeight(Font.labelCaps.weight)
        .fontColor(C.onBackground)
        .margin({ left: 12 })

      Column()
        .layoutWeight(1)

      // Progress bar
      Row() {
        Row() {
        }
        .width(`${ind.value}%`)
        .height('100%')
        .backgroundColor(ind.barColor)
        .borderRadius(4)
      }
      .width(120)
      .height(8)
      .backgroundColor(C.surfaceContainerHigh)
      .border(BW.full)
      .borderRadius(4)

      Text(`${ind.value}`)
        .fontSize(Font.headlineMd.size)
        .fontWeight(Font.headlineMd.weight)
        .fontColor(ind.color)
        .margin({ left: 8 })
    }
    .width('100%')
    .height(48)
    .backgroundColor(C.surface)
    .border(BW.full)
    .shadow(Shadow.hardSm)
    .borderRadius(4)
    .rotate({ angle: 0.5 })
    .margin({ bottom: 12 })
  }

  @Builder
  ReasonBox(icon: string, title: string, items: string[], bgColor: string, accentColor: string, cardRotate: number) {
    Column() {
      Row() {
        Text(icon)
          .fontSize(18)
          .margin({ right: 6 })
        Text(title)
          .fontSize(Font.labelCaps.size)
          .fontWeight(Font.labelCaps.weight)
          .fontColor(C.onBackground)
          .flexShrink(1)
      }
      .width('100%')
      .border({ width: { bottom: '2vp' }, color: C.onBackground })
      .padding({ bottom: 8 })
      .margin({ bottom: 8 })

      ForEach(items, (item: string) => {
        Row() {
          Text('#')
            .fontSize(Font.noteHandwritten.size)
            .fontColor(accentColor)
            .margin({ right: 6 })
          Text(item)
            .fontSize(Font.noteHandwritten.size)
            .fontWeight(Font.noteHandwritten.weight)
            .fontColor(C.onSurface)
        }
        .margin({ bottom: 6 })
      })
    }
    .width('48%')
    .padding(14)
    .backgroundColor(bgColor)
    .border(BW.full)
    .borderRadius(4)
    .shadow(Shadow.hard)
    .rotate({ angle: cardRotate })
  }
}
