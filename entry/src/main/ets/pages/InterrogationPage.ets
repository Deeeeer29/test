/**
 * InterrogationPage — 心动审问 / 问答页
 * Reference: stitch_reference/_3/code.html
 * Multi-step questionnaire with 2x3 grid choice cards
 */
import { C, Shadow, Font, BW } from '../common/Theme';

interface Question {
  id: number;
  text: string;
  options: string[];
}

const Questions: Question[] = [
  {
    id: 1,
    text: '你最近一次想起买它，\n是在什么情境下？',
    options: ['躺在床上刷手机', '上班/上学路上', '朋友推荐', '逛街偶遇', '看广告', '其他']
  },
  {
    id: 2,
    text: '你为什么突然\n想买它？',
    options: ['真的有明确需求', '最近心情不太好', '刷到很多人推荐', '正好在打折', '单纯觉得它很酷', '其他原因']
  },
  {
    id: 3,
    text: '如果不买它，\n你会感到？',
    options: ['完全没影响', '有点小遗憾', '会一直惦记', '感觉错过好机会', '焦虑/不安', '说不清']
  },
  {
    id: 4,
    text: '你上一次买东西后悔\n是在什么时候？',
    options: ['这周刚有过', '上个月', '半年前', '很久没有了', '从不后悔', '记不清了']
  },
  {
    id: 5,
    text: '你觉得这笔消费，\n更接近哪个描述？',
    options: ['投资自己', '犒劳奖励', '填补空虚', '社交需要', '跟风冲动', '说不清楚']
  },
];

@Component
export struct InterrogationPage {
  onComplete: () => void = () => {};

  @State currentQuestion: number = 0;
  @State selectedAnswer: number = -1;
  @State totalQuestions: number = 5;

  selectAnswer(index: number): void {
    this.selectedAnswer = index;
  }

  nextQuestion(): void {
    if (this.selectedAnswer >= 0) {
      if (this.currentQuestion < Questions.length - 1) {
        this.currentQuestion++;
        this.selectedAnswer = -1;
      } else {
        this.onComplete();
      }
    }
  }

  skipQuestion(): void {
    if (this.currentQuestion < Questions.length - 1) {
      this.currentQuestion++;
      this.selectedAnswer = -1;
    } else {
      this.onComplete();
    }
  }

  build() {
    Column() {
      // Progress indicator
      Text(`第 ${this.currentQuestion + 1} 问 / 共 ${this.totalQuestions} 问`)
        .fontSize(Font.labelCaps.size)
        .fontWeight(Font.labelCaps.weight)
        .fontColor(C.onSurface)
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .backgroundColor(C.surface)
        .border(BW.full)
        .shadow(Shadow.hardSm)
        .rotate({ angle: 1 })
        .margin({ left: 20, top: 24 })

      // Question text
      Text(Questions[this.currentQuestion].text)
        .fontSize(Font.headlineLg.size)
        .fontWeight(Font.headlineLg.weight)
        .fontColor(C.onBackground)
        .lineHeight(36)
        .margin({ top: 32, left: 20, right: 20 })
        .rotate({ angle: -1 })

      // Choice grid (2x3)
      Column() {
        Row() {
          this.ChoiceCard(0)
          this.ChoiceCard(1)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          this.ChoiceCard(2)
          this.ChoiceCard(3)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 16 })

        Row() {
          this.ChoiceCard(4)
          this.ChoiceCard(5)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ top: 32 })

      // Handwritten annotation
      Text('✏️ 没有标准答案，诚实一点更有用。')
        .fontSize(Font.noteHandwritten.size)
        .fontWeight(Font.noteHandwritten.weight)
        .fontColor(C.secondaryContainer)
        .margin({ top: 24, right: 20 })
        .width('100%')
        .textAlign(TextAlign.End)
        .rotate({ angle: -3 })

      // Spacer
      Column()
        .layoutWeight(1)

      // Action buttons (sticky bottom)
      Column() {
        Button() {
          Text(this.currentQuestion < Questions.length - 1 ? '下一问' : '完成审问')
            .fontSize(Font.headlineMd.size)
            .fontWeight(Font.headlineMd.weight)
            .fontColor(C.onPrimaryContainer)
        }
        .width('100%')
        .height(56)
        .backgroundColor(this.selectedAnswer >= 0 ? C.primaryContainer : C.surfaceContainer)
        .border(BW.full)
        .borderRadius(4)
        .shadow(this.selectedAnswer >= 0 ? Shadow.hard : Shadow.none)
        .rotate({ angle: -1 })
        .onClick(() => this.nextQuestion())

        Button() {
          Text('先跳过')
            .fontSize(Font.bodyMd.size)
            .fontWeight(Font.bodyMd.weight)
            .fontColor(C.outline)
        }
        .width('100%')
        .height(44)
        .backgroundColor(Color.Transparent)
        .margin({ top: 12 })
        .onClick(() => this.skipQuestion())
      }
      .width('100%')
      .padding({ left: 20, right: 20, bottom: 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(C.background)
  }

  @Builder
  ChoiceCard(optIndex: number) {
    if (optIndex >= Questions[this.currentQuestion].options.length) {
      Column()
        .width('48%')
        .height(100)
    } else {
      Column() {
        Text(Questions[this.currentQuestion].options[optIndex])
          .fontSize(Font.bodyLg.size)
          .fontWeight(Font.bodyLg.weight)
          .fontColor(this.selectedAnswer === optIndex ? C.onPrimaryContainer : C.onSurface)
          .textAlign(TextAlign.Center)
      }
      .width('48%')
      .height(100)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(this.selectedAnswer === optIndex ? C.primaryContainer : C.surface)
      .border(BW.full)
      .borderRadius(4)
      .shadow(this.selectedAnswer === optIndex ? Shadow.none : Shadow.hard)
      .rotate({ angle: optIndex === 0 ? 1 : (optIndex === 1 ? -1 : (optIndex === 2 ? 0 : -2)) })
      .onClick(() => this.selectAnswer(optIndex))
    }
  }
}
