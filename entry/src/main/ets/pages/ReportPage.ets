/**
 * ReportPage — 消费战报
 * Reference: stitch_reference/_6/code.html
 * Hero statement, Bento Grid metrics, trigger rankings, personal insight
 */
import { C, Shadow, Font, BW } from '../common/Theme';

interface TriggerItem {
  rank: number;
  label: string;
  bgColor: string;
  textColor: string;
}

@Component
export struct ReportPage {
  private triggers: TriggerItem[] = [
    { rank: 1, label: '深夜刷手机', bgColor: C.secondaryContainer, textColor: C.onSecondary },
    { rank: 2, label: '压力大', bgColor: C.primaryContainer, textColor: C.onPrimary },
    { rank: 3, label: '看到打折', bgColor: C.tertiaryContainer, textColor: C.onTertiary },
  ];

  build() {
    Scroll() {
      Column() {
        // ── Hero Statement ────────────────────
        Column() {
          Text('这个月，\n你把 6 次心动\n变成了 2 次真正需要。')
            .fontSize(Font.headlineLg.size)
            .fontWeight(Font.headlineLg.weight)
            .fontColor(C.onBackground)
            .lineHeight(36)
            .maxLines(4)

          Text('You are doing great.')
            .fontSize(Font.noteHandwritten.size)
            .fontWeight(Font.noteHandwritten.weight)
            .fontColor(C.outline)
            .margin({ top: 12 })
        }
        .width('100%')
        .padding(24)
        .backgroundColor(C.surfaceContainer)
        .border(BW.full)
        .shadow(Shadow.hard)
        .borderRadius(4)
        .rotate({ angle: -1 })
        .margin({ left: 20, right: 20, top: 24 })

        // ── Bento Grid Metrics ──────────────
        Column() {
          // Row 1: Analyzed (8) + Purchased (2)
          Row() {
            this.MetricCard('分析商品', '8', C.primaryContainer, C.onPrimaryContainer, 1)
            this.MetricCard('最终购买', '2', C.surface, C.primary, -2)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          // Row 2: Abandoned (4) — full width
          Column() {
            Row() {
              Text('主动放弃')
                .fontSize(Font.labelCaps.size)
                .fontWeight(Font.labelCaps.weight)
                .fontColor(C.onSecondaryContainer)
              Blank()
              Text('🗑️')
                .fontSize(18)
            }
            .width('100%')

            Row() {
              Text('4')
                .fontSize(Font.displayLg.size)
                .fontWeight(Font.displayLg.weight)
                .fontColor(C.onBackground)
              Text(' 为你省下了不少冲动税。')
                .fontSize(Font.bodyMd.size)
                .fontWeight(Font.bodyMd.weight)
                .fontColor(C.onSurfaceVariant)
                .margin({ left: 8 })
                .layoutWeight(1)
            }
            .width('100%')
            .margin({ top: 4 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(C.secondaryContainer)
          .border(BW.full)
          .shadow(Shadow.hard)
          .borderRadius(4)
          .rotate({ angle: 2 })
          .margin({ top: 16 })

          // Row 3: Still Cooling (2) — full width
          Column() {
            Text('仍在冷静')
              .fontSize(Font.labelCaps.size)
              .fontWeight(Font.labelCaps.weight)
              .fontColor(C.onTertiaryContainer)
            Text('2')
              .fontSize(Font.displayLg.size)
              .fontWeight(Font.displayLg.weight)
              .fontColor(C.onBackground)
              .margin({ top: 4 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(C.tertiaryContainer)
          .border(BW.full)
          .shadow(Shadow.hard)
          .borderRadius(4)
          .rotate({ angle: -1 })
          .margin({ top: 16 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 24 })

        // ── Triggers Ranking ────────────────
        Column() {
          Text('你最容易在哪些时候心动?')
            .fontSize(Font.headlineMd.size)
            .fontWeight(Font.headlineMd.weight)
            .fontColor(C.onBackground)
            .margin({ bottom: 20 })

          ForEach(this.triggers, (t: TriggerItem) => {
            Row() {
              // Rank number circle
              Text(`${t.rank}`)
                .fontSize(Font.labelCaps.size)
                .fontWeight(Font.labelCaps.weight)
                .fontColor(t.textColor)
                .width(32)
                .height(32)
                .textAlign(TextAlign.Center)
                .borderRadius(16)
                .backgroundColor(t.bgColor)
                .border(BW.full)

              Text(t.label)
                .fontSize(Font.bodyLg.size)
                .fontWeight(Font.bodyLg.weight)
                .fontColor(C.onBackground)
                .margin({ left: 12 })
            }
            .width('100%')
            .border({ width: { bottom: '2vp' }, color: C.onBackground })
            .padding({ bottom: 8 })
            .margin({ bottom: 14 })
          })
        }
        .width('100%')
        .padding(24)
        .backgroundColor(C.surface)
        .border(BW.full)
        .shadow(Shadow.hard)
        .borderRadius(4)
        .rotate({ angle: 1 })
        .margin({ left: 20, right: 20, top: 24 })

        // ── Personal Insight ────────────────
        Column() {
          Row() {
            Text('INSIGHT')
              .fontSize(10)
              .fontWeight(Font.labelCaps.weight)
              .fontColor(C.onSecondary)
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor(C.secondaryContainer)
              .border(BW.full)
              .rotate({ angle: 6 })
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .margin({ bottom: 12 })

          Text('"你不是爱乱花钱，你只是在某些时刻需要一些安慰。试着用其他方式奖励自己，比如睡个好觉。"')
            .fontSize(Font.noteHandwritten.size)
            .fontWeight(Font.noteHandwritten.weight)
            .fontColor(C.onSurfaceVariant)
            .lineHeight(24)
        }
        .width('100%')
        .padding(24)
        .backgroundColor(C.surfaceContainerHigh)
        .border(BW.full)
        .shadow(Shadow.hard)
        .borderRadius(4)
        .rotate({ angle: -2 })
        .margin({ left: 20, right: 20, top: 24 })

        // ── Reminder Card ───────────────────
        Row() {
          Text('⚠️')
            .fontSize(28)
            .margin({ right: 16 })

          Column() {
            Text('小提醒')
              .fontSize(Font.headlineMd.size)
              .fontWeight(Font.headlineMd.weight)
              .fontColor(C.onBackground)
              .margin({ bottom: 8 })
            Text('晚上 11 点后购买数码产品的退货率极高。下次遇到，先把它丢进心愿单睡一觉再说。')
              .fontSize(Font.bodyMd.size)
              .fontWeight(Font.bodyMd.weight)
              .fontColor(C.onSurfaceVariant)
              .lineHeight(22)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .width('100%')
        .padding(24)
        .backgroundColor(C.errorContainer)
        .border(BW.full)
        .shadow(Shadow.hard)
        .borderRadius(4)
        .rotate({ angle: 1 })
        .margin({ left: 20, right: 20, top: 24, bottom: 40 })
      }
      .width('100%')
    }
    .width('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(C.background)
  }

  @Builder
  MetricCard(label: string, value: string, bgColor: string, textColor: string, cardRotate: number) {
    Column() {
      Text(label)
        .fontSize(Font.labelCaps.size)
        .fontWeight(Font.labelCaps.weight)
        .fontColor(textColor)
      Text(value)
        .fontSize(Font.displayLg.size)
        .fontWeight(Font.displayLg.weight)
        .fontColor(C.onBackground)
        .margin({ top: 8 })
    }
    .width('48%')
    .height(120)
    .padding(16)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(bgColor)
    .border(BW.full)
    .shadow(Shadow.hard)
    .borderRadius(4)
    .rotate({ angle: cardRotate })
  }
}
