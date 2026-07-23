import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { AppTheme } from '../common/theme/AppTheme';
import { DeviceStatusBar } from '../components/DeviceStatusBar';
import { SectionHeader } from '../components/SectionHeader';
import { TopTitleBar } from '../components/TopTitleBar';
import { EnvironmentMode, UserPreferences } from '../model/UserPreferences';
import { AuthService } from '../services/AuthService';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockStorageService } from '../services/MockStorageService';

@Entry
@Component
struct SettingsPage {
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  @State saveTranscript: boolean = MockStorageService.getPreferences().privacy.saveTranscript;
  @State saveAudio: boolean = MockStorageService.getPreferences().privacy.saveAudio;
  @State cloudAnalysis: boolean = MockStorageService.getPreferences().privacy.cloudAnalysis;
  @State localFirst: boolean = MockStorageService.getPreferences().privacy.localFirst;
  @State autoFloating: boolean = MockStorageService.getPreferences().answer.autoGenerate;
  @State mode: EnvironmentMode = MockStorageService.getPreferences().environment.mode;
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    AuthService.ensureAuthenticated();
  }

  private saveCurrentPreferences(): void {
    const preferences: UserPreferences = MockStorageService.getPreferences();
    const nextPreferences: UserPreferences = {
      language: this.language,
      privacy: {
        saveTranscript: this.saveTranscript,
        saveAudio: this.saveAudio,
        cloudAnalysis: this.cloudAnalysis,
        localFirst: this.localFirst,
        autoDeletePeriod: preferences.privacy.autoDeletePeriod
      },
      answer: {
        defaultDuration: preferences.answer.defaultDuration,
        defaultTone: preferences.answer.defaultTone,
        autoGenerate: this.autoFloating,
        headphoneOutput: preferences.answer.headphoneOutput
      },
      environment: {
        mode: this.mode,
        autoSwitch: preferences.environment.autoSwitch
      }
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
        TopTitleBar({ title: I18n.t('settings', this.language), showBack: true })
        SectionHeader({ title: I18n.t('languageSettings', this.language), subtitle: I18n.t('languageSettingsDesc', this.language) })
        Row() {
          Button(I18n.t('chinese', this.language)).layoutWeight(1).height(38).backgroundColor(this.language === 'zh' ? AppTheme.accentColor : AppTheme.elevatedBackground).fontColor(this.language === 'zh' ? AppTheme.primaryButtonText : AppTheme.primaryText).onClick((): void => { this.changeLanguage('zh'); })
          Button(I18n.t('english', this.language)).layoutWeight(1).height(38).margin({ left: 8 }).backgroundColor(this.language === 'en' ? AppTheme.accentColor : AppTheme.elevatedBackground).fontColor(this.language === 'en' ? AppTheme.primaryButtonText : AppTheme.primaryText).onClick((): void => { this.changeLanguage('en'); })
        }.width('100%')
        SectionHeader({ title: I18n.t('deviceStatus', this.language) })
        DeviceStatusBar({ status: this.audioService.getEarphoneStatus(), language: this.language })
        Button(I18n.t('testEarphoneMock', this.language)).width('100%').height(40).margin({ top: 10 }).fontColor(AppTheme.primaryButtonText).backgroundColor(AppTheme.accentColor).onClick((): void => { promptAction.showToast({ message: this.audioService.testEarphonePlayback() }); })
        SectionHeader({ title: I18n.t('privacy', this.language) })
        this.SwitchLine(I18n.t('saveTranscriptText', this.language), this.saveTranscript, 'transcript')
        this.SwitchLine(I18n.t('saveRawAudioOff', this.language), this.saveAudio, 'audio')
        this.SwitchLine(I18n.t('cloudAnalysis', this.language), this.cloudAnalysis, 'cloud')
        this.SwitchLine(I18n.t('localFirst', this.language), this.localFirst, 'local')
        Text(I18n.t('autoDeleteCycle', this.language)).width('100%').padding(12).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        Button(I18n.t('clearMeetingRecords', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.errorSoft).fontColor(AppTheme.errorColor).onClick((): void => { promptAction.showDialog({ title: I18n.t('confirm', this.language), message: I18n.t('mockClearOnly', this.language) }); })
        SectionHeader({ title: I18n.t('answerPreference', this.language) })
        Text(I18n.t('answerPreferenceDesc', this.language)).width('100%').padding(12).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        this.SwitchLine(I18n.t('autoShowFloating', this.language), this.autoFloating, 'floating')
        SectionHeader({ title: I18n.t('environmentMode', this.language) })
        Row() { Button(I18n.t('quiet', this.language)).layoutWeight(1).height(38).onClick((): void => { this.mode = 'quiet'; this.saveCurrentPreferences(); }); Button(I18n.t('noisy', this.language)).layoutWeight(1).height(38).margin({ left: 8 }).onClick((): void => { this.mode = 'noisy'; this.saveCurrentPreferences(); }); Button(I18n.t('speech', this.language)).layoutWeight(1).height(38).margin({ left: 8 }).onClick((): void => { this.mode = 'presentation'; this.saveCurrentPreferences(); }) }.width('100%')
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
