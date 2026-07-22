import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { AppTheme } from '../common/theme/AppTheme';
import { DeviceStatusBar } from '../components/DeviceStatusBar';
import { SectionHeader } from '../components/SectionHeader';
import { EnvironmentMode, UserPreferences } from '../model/UserPreferences';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockStorageService } from '../services/MockStorageService';

@Entry
@Component
struct SettingsPage {
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  @State saveTranscript: boolean = MockStorageService.getPreferences().saveTranscript;
  @State saveAudio: boolean = MockStorageService.getPreferences().saveAudio;
  @State cloudAnalysis: boolean = MockStorageService.getPreferences().cloudAnalysis;
  @State localFirst: boolean = MockStorageService.getPreferences().localFirst;
  @State autoFloating: boolean = MockStorageService.getPreferences().autoShowFloatingCard;
  @State mode: EnvironmentMode = MockStorageService.getPreferences().environmentMode;
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  private saveCurrentPreferences(): void {
    const preferences: UserPreferences = MockStorageService.getPreferences();
    const nextPreferences: UserPreferences = {
      language: this.language,
      saveTranscript: this.saveTranscript,
      saveAudio: this.saveAudio,
      cloudAnalysis: this.cloudAnalysis,
      localFirst: this.localFirst,
      autoDeleteDays: preferences.autoDeleteDays,
      defaultAnswerDuration: preferences.defaultAnswerDuration,
      defaultTone: preferences.defaultTone,
      showSources: preferences.showSources,
      showRiskWarnings: preferences.showRiskWarnings,
      autoShowFloatingCard: this.autoFloating,
      environmentMode: this.mode
    };
    MockStorageService.savePreferences(nextPreferences);
  }

  private changeLanguage(language: AppLanguage): void {
    this.language = language;
    MockStorageService.saveLanguage(language);
    promptAction.showToast({ message: I18n.t('languageSaved', this.language) });
  }

  build() {
    Scroll() {
      Column() {
        Row() { Button(I18n.t('back', this.language)).height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text(I18n.t('settings', this.language)).layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
        SectionHeader({ title: I18n.t('languageSettings', this.language), subtitle: I18n.t('languageSettingsDesc', this.language) })
        Row() {
          Button(I18n.t('chinese', this.language)).layoutWeight(1).height(38).backgroundColor(this.language === 'zh' ? AppTheme.accentColor : AppTheme.elevatedBackground).fontColor(this.language === 'zh' ? '#06110F' : AppTheme.primaryText).onClick((): void => { this.changeLanguage('zh'); })
          Button(I18n.t('english', this.language)).layoutWeight(1).height(38).margin({ left: 8 }).backgroundColor(this.language === 'en' ? AppTheme.accentColor : AppTheme.elevatedBackground).fontColor(this.language === 'en' ? '#06110F' : AppTheme.primaryText).onClick((): void => { this.changeLanguage('en'); })
        }.width('100%')
        SectionHeader({ title: I18n.t('deviceStatus', this.language), subtitle: I18n.t('mockPhoneEarphoneOnly', this.language) })
        DeviceStatusBar({ status: this.audioService.getEarphoneStatus(), language: this.language })
        Button(I18n.t('testEarphoneMock', this.language)).width('100%').height(40).margin({ top: 10 }).fontColor('#06110F').backgroundColor(AppTheme.accentColor).onClick((): void => { promptAction.showToast({ message: this.audioService.testEarphonePlayback() }); })
        SectionHeader({ title: I18n.t('privacy', this.language) })
        this.SwitchLine(I18n.t('saveTranscriptText', this.language), this.saveTranscript, 'transcript')
        this.SwitchLine(I18n.t('saveRawAudioOff', this.language), this.saveAudio, 'audio')
        this.SwitchLine(I18n.t('cloudAnalysis', this.language), this.cloudAnalysis, 'cloud')
        this.SwitchLine(I18n.t('localFirst', this.language), this.localFirst, 'local')
        Text(I18n.t('autoDeleteCycle', this.language)).width('100%').padding(12).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        Button(I18n.t('clearMeetingRecords', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor('#3A2026').fontColor(AppTheme.errorColor).onClick((): void => { promptAction.showDialog({ title: I18n.t('confirm', this.language), message: I18n.t('mockClearOnly', this.language) }); })
        SectionHeader({ title: I18n.t('answerPreference', this.language) })
        Text(I18n.t('answerPreferenceDesc', this.language)).width('100%').padding(12).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        this.SwitchLine(I18n.t('autoShowFloating', this.language), this.autoFloating, 'floating')
        SectionHeader({ title: I18n.t('environmentMode', this.language) })
        Row() { Button(I18n.t('quiet', this.language)).layoutWeight(1).height(38).onClick((): void => { this.mode = 'quiet'; this.saveCurrentPreferences(); }); Button(I18n.t('noisy', this.language)).layoutWeight(1).height(38).margin({ left: 8 }).onClick((): void => { this.mode = 'noisy'; this.saveCurrentPreferences(); }); Button(I18n.t('speech', this.language)).layoutWeight(1).height(38).margin({ left: 8 }).onClick((): void => { this.mode = 'speech'; this.saveCurrentPreferences(); }) }.width('100%')
        Text(I18n.currentMode(this.mode, this.language)).width('100%').margin({ top: 8, bottom: 20 }).fontSize(12).fontColor(AppTheme.secondaryText)
      }.padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }

  @Builder
  SwitchLine(label: string, checked: boolean, key: string) {
    Row() {
      Text(label).layoutWeight(1).fontSize(14).fontColor(AppTheme.primaryText)
      Toggle({ type: ToggleType.Switch, isOn: checked }).onChange((value: boolean): void => {
        if (key === 'transcript') { this.saveTranscript = value; }
        if (key === 'audio') { this.saveAudio = value; }
        if (key === 'cloud') { this.cloudAnalysis = value; }
        if (key === 'local') { this.localFirst = value; }
        if (key === 'floating') { this.autoFloating = value; }
        this.saveCurrentPreferences();
      })
    }.width('100%').padding(12).margin({ bottom: 8 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
  }
}
