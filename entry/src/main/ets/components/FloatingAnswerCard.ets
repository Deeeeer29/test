import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { AnswerBundle } from '../model/AnswerBundle';

@Component
export struct FloatingAnswerCard {
  @Prop answer: AnswerBundle;
  @Prop language: AppLanguage = 'zh';
  @Link visible: boolean;
  @State expanded: boolean = false;
  onPlayback: (text: string) => void = (text: string): void => {};

  build() {
    if (this.visible) {
      Column() {
        Row() {
          Text(I18n.answer(this.answer, this.language).transitionSentence).fontSize(14).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).layoutWeight(1)
          Button(this.expanded ? I18n.t('fold', this.language) : I18n.t('more', this.language)).height(30).fontSize(12).backgroundColor(AppTheme.accentSoft).fontColor(AppTheme.accentColor).onClick((): void => { this.expanded = !this.expanded; })
          Button(I18n.t('close', this.language)).height(30).fontSize(12).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.elevatedBackground).margin({ left: 6 }).onClick((): void => { this.visible = false; })
        }.width('100%')
        Text(I18n.t('floatingTags', this.language)).width('100%').margin({ top: 8 }).fontSize(12).fontColor(AppTheme.accentColor)
        if (this.expanded) {
          Text(I18n.answer(this.answer, this.language).immediateAnswer).width('100%').margin({ top: 10 }).fontSize(13).lineHeight(20).fontColor(AppTheme.primaryText)
          Text(`${I18n.riskPrefix(this.language)}${I18n.answer(this.answer, this.language).riskWarnings[0]}`).width('100%').margin({ top: 8 }).fontSize(12).fontColor(AppTheme.warningColor)
          Row() {
            Button(I18n.t('earphoneMock', this.language)).layoutWeight(1).height(36).fontSize(12).fontColor(AppTheme.primaryButtonText).backgroundColor(AppTheme.accentColor).onClick((): void => this.onPlayback(I18n.answer(this.answer, this.language).transitionSentence || ''))
            Button(I18n.t('fullAnswer', this.language)).layoutWeight(1).height(36).fontSize(12).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).margin({ left: 8 }).onClick((): void => {
              router.pushUrl({
                url: 'pages/AnswerDetailPage',
                params: { answerId: this.answer.id, answer: this.answer, from: 'floating' }
              }, router.RouterMode.Single);
            })
          }.margin({ top: 10 }).width('100%')
        }
      }
      .width('92%')
      .padding(14)
      .backgroundColor(AppTheme.overlayBackground)
      .borderRadius(AppTheme.radiusLarge)
      .shadow({ radius: 18, color: AppTheme.shadowColor, offsetX: 0, offsetY: 8 })
    }
  }
}
