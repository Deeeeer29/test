import { AppTheme } from '../common/theme/AppTheme';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { TranscriptItem } from '../model/TranscriptItem';
import { StatusBadge } from './StatusBadge';

@Component
export struct TranscriptBubble {
  @Prop item: TranscriptItem;
  @Prop language: AppLanguage = 'zh';

  build() {
    Column() {
      Row() {
        Text(I18n.transcriptSpeaker(this.item, this.language)).fontSize(13).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
        Text(this.item.timestamp).fontSize(11).fontColor(AppTheme.mutedText).margin({ left: 8 })
        if (this.item.isQuestion) { StatusBadge({ label: I18n.t('question', this.language), type: 'warning' }).margin({ left: 8 }) }
      }.width('100%')
      Text(I18n.transcriptContent(this.item, this.language)).width('100%').margin({ top: 6 }).fontSize(14).lineHeight(21).fontColor(AppTheme.secondaryText)
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
