import { AppTheme } from '../common/theme/AppTheme';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { Meeting } from '../model/Meeting';
import { StatusBadge } from './StatusBadge';

@Component
export struct MeetingCard {
  @Prop meeting: Meeting;
  @Prop language: AppLanguage = 'zh';
  onPrepare: (id: string) => void = (id: string): void => {};
  onStart: (id: string) => void = (id: string): void => {};

  build() {
    Column() {
      Row() {
        Text(I18n.meetingTitle(this.meeting.id, this.meeting.title, this.language)).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).layoutWeight(1)
        StatusBadge({ label: I18n.meetingStatus(this.meeting.status, this.language), type: this.meeting.status === 'ready' ? 'success' : 'warning' })
      }.width('100%')
      Text(`${this.meeting.startTime}-${this.meeting.endTime} / ${I18n.meetingLocation(this.meeting.id, this.meeting.location, this.language)}`).width('100%').margin({ top: 8 }).fontSize(13).fontColor(AppTheme.secondaryText)
      Text(I18n.meetingMeta(this.meeting, this.language)).width('100%').margin({ top: 6 }).fontSize(12).fontColor(AppTheme.mutedText)
      Row() {
        Button(I18n.t('prepare', this.language)).layoutWeight(1).height(38).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).onClick((): void => this.onPrepare(this.meeting.id))
        Button(I18n.t('start', this.language)).layoutWeight(1).height(38).fontColor('#07110F').backgroundColor(AppTheme.accentColor).margin({ left: 8 }).onClick((): void => this.onStart(this.meeting.id))
        Button(I18n.t('remind', this.language)).layoutWeight(1).height(38).fontColor(AppTheme.secondaryText).backgroundColor('#151A20').margin({ left: 8 })
      }.margin({ top: 14 }).width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
