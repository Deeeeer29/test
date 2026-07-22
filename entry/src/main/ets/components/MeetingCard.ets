import { AppTheme } from '../common/theme/AppTheme';
import { Meeting } from '../model/Meeting';
import { StatusBadge } from './StatusBadge';

@Component
export struct MeetingCard {
  @Prop meeting: Meeting;
  onPrepare: (id: string) => void = (id: string): void => {};
  onStart: (id: string) => void = (id: string): void => {};

  build() {
    Column() {
      Row() {
        Text(this.meeting.title).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).layoutWeight(1)
        StatusBadge({ label: this.meeting.status === 'ready' ? 'Ready' : 'Preparing', type: this.meeting.status === 'ready' ? 'success' : 'warning' })
      }.width('100%')
      Text(`${this.meeting.startTime}-${this.meeting.endTime} / ${this.meeting.location}`).width('100%').margin({ top: 8 }).fontSize(13).fontColor(AppTheme.secondaryText)
      Text(`${this.meeting.attendees.length} attendees / ${this.meeting.preparedDocumentCount} docs / ${this.meeting.predictedQuestionCount} questions`).width('100%').margin({ top: 6 }).fontSize(12).fontColor(AppTheme.mutedText)
      Row() {
        Button('Prepare').layoutWeight(1).height(38).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).onClick((): void => this.onPrepare(this.meeting.id))
        Button('Start').layoutWeight(1).height(38).fontColor('#07110F').backgroundColor(AppTheme.accentColor).margin({ left: 8 }).onClick((): void => this.onStart(this.meeting.id))
        Button('Remind').layoutWeight(1).height(38).fontColor(AppTheme.secondaryText).backgroundColor('#151A20').margin({ left: 8 })
      }.margin({ top: 14 }).width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
