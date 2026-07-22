import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { AnswerBundle } from '../model/AnswerBundle';

@Component
export struct AnswerPreviewCard {
  @Prop answer: AnswerBundle;
  @Prop language: AppLanguage = 'zh';

  build() {
    Column() {
      Text(I18n.t('mockAnswerPreview', this.language)).width('100%').fontSize(13).fontColor(AppTheme.accentColor)
      Text(I18n.answer(this.answer, this.language).transitionSentence).width('100%').margin({ top: 8 }).fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
      ForEach(I18n.answer(this.answer, this.language).keyPoints.slice(0, 3), (point: string) => {
        Text(`- ${point}`).width('100%').margin({ top: 7 }).fontSize(13).fontColor(AppTheme.secondaryText)
      }, (point: string): string => point)
      Text(`${I18n.riskPrefix(this.language)}${I18n.answer(this.answer, this.language).riskWarnings[0]}`).width('100%').margin({ top: 10 }).fontSize(12).fontColor(AppTheme.warningColor)
      Button(I18n.t('openFullAnswer', this.language)).width('100%').height(42).margin({ top: 14 }).fontColor('#06110F').backgroundColor(AppTheme.accentColor).onClick((): void => { router.pushUrl({ url: 'pages/AnswerDetailPage', params: { from: 'live' } }); })
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(16)
    .backgroundColor('#162E2D')
    .borderRadius(AppTheme.radiusMedium)
  }
}
