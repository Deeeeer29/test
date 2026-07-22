import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { AnswerBundle } from '../model/AnswerBundle';

@Component
export struct FloatingAnswerCard {
  @Prop answer: AnswerBundle;
  @Link visible: boolean;
  @State expanded: boolean = false;
  onPlayback: (text: string) => void = (text: string): void => {};

  build() {
    if (this.visible) {
      Column() {
        Row() {
          Text(this.answer.transitionSentence).fontSize(14).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).layoutWeight(1)
          Button(this.expanded ? 'Fold' : 'More').height(30).fontSize(12).backgroundColor(AppTheme.accentSoft).fontColor(AppTheme.accentColor).onClick((): void => { this.expanded = !this.expanded; })
          Button('Close').height(30).fontSize(12).fontColor(AppTheme.secondaryText).backgroundColor('#2B323B').margin({ left: 6 }).onClick((): void => { this.visible = false; })
        }.width('100%')
        Text('UX / AI answer / latency').width('100%').margin({ top: 8 }).fontSize(12).fontColor(AppTheme.accentColor)
        if (this.expanded) {
          Text(this.answer.immediateAnswer).width('100%').margin({ top: 10 }).fontSize(13).lineHeight(20).fontColor(AppTheme.primaryText)
          Text(`Risk: ${this.answer.riskWarnings[0]}`).width('100%').margin({ top: 8 }).fontSize(12).fontColor(AppTheme.warningColor)
          Row() {
            Button('Earphone mock').layoutWeight(1).height(36).fontSize(12).fontColor('#06110F').backgroundColor(AppTheme.accentColor).onClick((): void => this.onPlayback(this.answer.transitionSentence))
            Button('Full answer').layoutWeight(1).height(36).fontSize(12).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).margin({ left: 8 }).onClick((): void => { router.pushUrl({ url: 'pages/AnswerDetailPage', params: { from: 'floating' } }); })
          }.margin({ top: 10 }).width('100%')
        }
      }
      .width('92%')
      .padding(14)
      .backgroundColor('#E61A2027')
      .borderRadius(AppTheme.radiusLarge)
      .shadow({ radius: 18, color: '#66000000', offsetX: 0, offsetY: 8 })
    }
  }
}
