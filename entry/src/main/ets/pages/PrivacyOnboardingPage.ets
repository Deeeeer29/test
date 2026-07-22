import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { PermissionItem } from '../components/PermissionItem';
import { SectionHeader } from '../components/SectionHeader';
import { MockStorageService } from '../services/MockStorageService';

@Entry
@Component
struct PrivacyOnboardingPage {
  @State micOn: boolean = false;
  @State calendarOn: boolean = false;
  @State noticeOn: boolean = false;
  @State fileOn: boolean = false;

  build() {
    Scroll() {
      Column() {
        Text('AI Meeting Answer Assistant').width('100%').fontSize(28).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
        Text('Prepare before meetings, assist answers in meetings, summarize after meetings. Mock data only.').width('100%').margin({ top: 8 }).fontSize(15).fontColor(AppTheme.secondaryText)
        SectionHeader({ title: 'Privacy and permissions', subtitle: 'Mic is only active after user enters meeting mode.' })
        PermissionItem({ icon: 'Mic', title: 'Microphone', reason: 'Mock transcription after meeting mode starts.', isEnabled: this.micOn, onToggle: (title: string): void => { this.micOn = !this.micOn; } }).margin({ bottom: 10 })
        PermissionItem({ icon: 'Cal', title: 'Calendar', reason: 'Reserved for real calendar integration.', isEnabled: this.calendarOn, onToggle: (title: string): void => { this.calendarOn = !this.calendarOn; } }).margin({ bottom: 10 })
        PermissionItem({ icon: 'Msg', title: 'Notification', reason: 'Reserved for reminders.', isEnabled: this.noticeOn, onToggle: (title: string): void => { this.noticeOn = !this.noticeOn; } }).margin({ bottom: 10 })
        PermissionItem({ icon: 'Doc', title: 'Files', reason: 'Reserved for uploaded materials.', isEnabled: this.fileOn, onToggle: (title: string): void => { this.fileOn = !this.fileOn; } }).margin({ bottom: 10 })
        SectionHeader({ title: 'Rules' })
        Text('No background listening. Raw audio is off by default. User can pause or end assistance anytime. Current version uses mock data.').width('100%').padding(14).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        Button('Finish setup and enter home').width('100%').height(48).margin({ top: 22, bottom: 20 }).fontColor('#07110F').backgroundColor(AppTheme.accentColor).onClick((): void => { MockStorageService.saveOnboardingStatus(true); router.replaceUrl({ url: 'pages/Index' }); })
      }.alignItems(HorizontalAlign.Start).padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
