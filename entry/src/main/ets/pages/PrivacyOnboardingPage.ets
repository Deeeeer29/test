import { router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
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
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  build() {
    Scroll() {
      Column() {
        Text(I18n.t('appName', this.language)).width('100%').fontSize(28).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
        Text(I18n.t('appSubtitle', this.language)).width('100%').margin({ top: 8 }).fontSize(15).fontColor(AppTheme.secondaryText)
        SectionHeader({ title: I18n.t('privacyPermissions', this.language), subtitle: I18n.t('micAfterMeetingMode', this.language) })
        PermissionItem({ icon: 'Mic', title: I18n.t('microphone', this.language), reason: I18n.t('microphoneReason', this.language), isEnabled: this.micOn, language: this.language, onToggle: (title: string): void => { this.micOn = !this.micOn; } }).margin({ bottom: 10 })
        PermissionItem({ icon: 'Cal', title: I18n.t('calendar', this.language), reason: I18n.t('calendarReason', this.language), isEnabled: this.calendarOn, language: this.language, onToggle: (title: string): void => { this.calendarOn = !this.calendarOn; } }).margin({ bottom: 10 })
        PermissionItem({ icon: 'Msg', title: I18n.t('notification', this.language), reason: I18n.t('notificationReason', this.language), isEnabled: this.noticeOn, language: this.language, onToggle: (title: string): void => { this.noticeOn = !this.noticeOn; } }).margin({ bottom: 10 })
        PermissionItem({ icon: 'Doc', title: I18n.t('files', this.language), reason: I18n.t('filesReason', this.language), isEnabled: this.fileOn, language: this.language, onToggle: (title: string): void => { this.fileOn = !this.fileOn; } }).margin({ bottom: 10 })
        SectionHeader({ title: I18n.t('rules', this.language) })
        Text(I18n.t('rulesDesc', this.language)).width('100%').padding(14).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        Button(I18n.t('finishSetup', this.language)).width('100%').height(48).margin({ top: 22, bottom: 20 }).fontColor('#07110F').backgroundColor(AppTheme.accentColor).onClick((): void => { MockStorageService.saveOnboardingStatus(true); router.replaceUrl({ url: 'pages/Index' }); })
      }.alignItems(HorizontalAlign.Start).padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
