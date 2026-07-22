import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { AnswerBundle } from '../model/AnswerBundle';

@Component
export struct AnswerPreviewCard {
  @Prop answer: AnswerBundle;

  build() {
    Column() {
      Text('Mock AI answer preview').width('100%').fontSize(13).fontColor(AppTheme.accentColor)
      Text(this.answer.transitionSentence).width('100%').margin({ top: 8 }).fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
      ForEach(this.answer.keyPoints.slice(0, 3), (point: string) => {
        Text(`- ${point}`).width('100%').margin({ top: 7 }).fontSize(13).fontColor(AppTheme.secondaryText)
      }, (point: string): string => point)
      Text(`Risk: ${this.answer.riskWarnings[0]}`).width('100%').margin({ top: 10 }).fontSize(12).fontColor(AppTheme.warningColor)
      Button('Open full answer').width('100%').height(42).margin({ top: 14 }).fontColor('#06110F').backgroundColor(AppTheme.accentColor).onClick((): void => { router.pushUrl({ url: 'pages/AnswerDetailPage', params: { from: 'live' } }); })
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(16)
    .backgroundColor('#162E2D')
    .borderRadius(AppTheme.radiusMedium)
  }
}
