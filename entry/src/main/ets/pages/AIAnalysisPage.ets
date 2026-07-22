/**
 * AIAnalysisPage — AI 正在分析过渡页
 * Reference: stitch_reference/ai/code.html
 * Shows rotating notes ring around polaroid product, with 3 analysis stages
 */
import { C, Shadow, Font, BW } from '../common/Theme';

@Component
export struct AIAnalysisPage {
  @Prop productName: string = '无线降噪耳机';
  @Prop productPrice: string = '¥1,899';
  onComplete: () => void = () => {};

  @State stage1Done: boolean = false;
  @State stage2Done: boolean = false;
  @State stage3Done: boolean = false;

  aboutToAppear(): void {
    // Simulate analysis stages
    setTimeout(() => { this.stage1Done = true; }, 1500);
    setTimeout(() => { this.stage2Done = true; }, 3000);
    setTimeout(() => {
      this.stage3Done = true;
      setTimeout(() => { this.onComplete(); }, 800);
    }, 4500);
  }

  build() {
    Column() {
      // Headline
      Text('"我替你冷静一下。"')
        .fontSize(Font.headlineLg.size)
        .fontWeight(Font.headlineLg.weight)
        .fontColor(C.onBackground)
        .textAlign(TextAlign.Center)
        .margin({ top: 32, bottom: 16 })
        .width('100%')

      // Central Area: Product Polaroid (simplified)
      Column() {
        // Product image placeholder
        Column() {
          Text('🎧')
            .fontSize(48)
        }
        .width('60%')
        .aspectRatio(1)
        .backgroundColor(C.surfaceContainer)
        .border(BW.full)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        // Dashed separator + loading
        Row() {
          Text('⏳')
            .fontSize(24)
            .fontColor(C.primary)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ top: 12, bottom: 4 })
        .border({ width: { top: '2vp' }, color: C.outlineVariant, style: BorderStyle.Dashed })
        .margin({ top: 12 })
      }
      .width('80%')
      .padding({ top: 12, bottom: 16, left: 12, right: 12 })
      .backgroundColor(C.surfaceContainerLowest)
      .border(BW.full)
      .shadow(Shadow.hardLg)
      .margin({ top: 24, bottom: 24 })

      // Analysis Stages (Receipt Strips)
      Column() {
        // Stage 1: Check real needs
        this.StageRow(
          this.stage1Done ? '✓' : '⏳',
          '正在核对真实需求',
          this.stage1Done,
          C.tertiaryContainer
        )

        // Stage 2: Check budget pressure
        this.StageRow(
          this.stage2Done ? '✓' : '⏳',
          '正在查看预算压力',
          this.stage2Done,
          C.primaryContainer
        )

        // Stage 3: Calculate regret risk
        this.StageRow(
          this.stage3Done ? '✓' : '⏳',
          '正在计算重复购买和后悔风险',
          this.stage3Done,
          C.surfaceContainer
        )
      }
      .width('100%')
      .padding({ left: 20, right: 20 })

      // Floating notes (decorative)
      Column() {
        Row() {
          Text('💬 心动是真的，但需求不一定。')
            .fontSize(14)
            .fontWeight(Font.noteHandwritten.weight)
            .fontColor(C.onSurfaceVariant)
            .padding(8)
            .backgroundColor(C.surface)
            .border(BW.full)
            .shadow(Shadow.hardSm)
            .rotate({ angle: -2 })
        }
        .width('100%')
        .margin({ top: 24, left: 20 })
        .justifyContent(FlexAlign.Start)

        Row() {
          Text('💬 别急，我不只是看价格。')
            .fontSize(14)
            .fontWeight(Font.noteHandwritten.weight)
            .fontColor(C.onPrimaryContainer)
            .padding(8)
            .backgroundColor(C.primaryContainer)
            .border(BW.full)
            .shadow(Shadow.hardSm)
            .rotate({ angle: 2 })
        }
        .width('100%')
        .margin({ left: 20, top: 8 })
        .justifyContent(FlexAlign.End)
      }
      .width('100%')
      .padding({ right: 20 })
    }
    .width('100%')
    .padding({ bottom: 80 })
    .backgroundColor(C.background)
  }

  @Builder
  StageRow(icon: string, text: string, done: boolean, bgColor: string) {
    Row() {
      Text(icon)
        .fontSize(20)
        .fontColor(done ? C.tertiary : C.outline)
        .margin({ right: 12 })

      Text(text)
        .fontSize(Font.bodyMd.size)
        .fontWeight(700)
        .fontColor(done ? C.onBackground : C.onSurfaceVariant)
        .opacity(done ? 1 : 0.7)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(bgColor)
    .border(BW.full)
    .shadow(Shadow.hard)
    .borderRadius(4)
    .rotate({ angle: done ? 0.5 : -0.5 })
    .margin({ bottom: 16 })
  }
}
