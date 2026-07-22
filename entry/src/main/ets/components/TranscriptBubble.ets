import { AppTheme } from '../common/theme/AppTheme';
import { TranscriptItem } from '../model/TranscriptItem';
import { StatusBadge } from './StatusBadge';

@Component
export struct TranscriptBubble {
  @Prop item: TranscriptItem;

  build() {
    Column() {
      Row() {
        Text(this.item.speaker).fontSize(13).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
        Text(this.item.timestamp).fontSize(11).fontColor(AppTheme.mutedText).margin({ left: 8 })
        if (this.item.isQuestion) { StatusBadge({ label: 'Question', type: 'warning' }).margin({ left: 8 }) }
      }.width('100%')
      Text(this.item.content).width('100%').margin({ top: 6 }).fontSize(14).lineHeight(21).fontColor(AppTheme.secondaryText)
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
