import { promptAction, router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { DeviceStatusBar } from '../components/DeviceStatusBar';
import { SectionHeader } from '../components/SectionHeader';
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
  @State mode: string = MockStorageService.getPreferences().environmentMode;

  build() {
    Scroll() {
      Column() {
        Row() { Button('Back').height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text('Settings').layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
        SectionHeader({ title: 'Device status', subtitle: 'Phone and earphone prompt only.' })
        DeviceStatusBar({ status: this.audioService.getEarphoneStatus() })
        Button('Test earphone mock').width('100%').height(40).margin({ top: 10 }).fontColor('#06110F').backgroundColor(AppTheme.accentColor).onClick((): void => { promptAction.showToast({ message: this.audioService.testEarphonePlayback() }); })
        SectionHeader({ title: 'Privacy' })
        this.SwitchLine('Save transcript text', this.saveTranscript, 'transcript')
        this.SwitchLine('Save raw audio off by default', this.saveAudio, 'audio')
        this.SwitchLine('Cloud analysis', this.cloudAnalysis, 'cloud')
        this.SwitchLine('Local first', this.localFirst, 'local')
        Text('Auto delete cycle: 30 days').width('100%').padding(12).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        Button('Clear meeting records').width('100%').height(40).margin({ top: 8 }).backgroundColor('#3A2026').fontColor(AppTheme.errorColor).onClick((): void => { promptAction.showDialog({ title: 'Confirm', message: 'Mock clear only. No real data is deleted.' }); })
        SectionHeader({ title: 'Answer preference' })
        Text('Default duration: 30s / default tone: professional / show sources and risks.').width('100%').padding(12).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        this.SwitchLine('Auto show floating answer card', this.autoFloating, 'floating')
        SectionHeader({ title: 'Environment mode' })
        Row() { Button('Quiet').layoutWeight(1).height(38).onClick((): void => { this.mode = 'quiet'; }); Button('Noisy').layoutWeight(1).height(38).margin({ left: 8 }).onClick((): void => { this.mode = 'noisy'; }); Button('Speech').layoutWeight(1).height(38).margin({ left: 8 }).onClick((): void => { this.mode = 'speech'; }) }.width('100%')
        Text(`Current mode: ${this.mode}`).width('100%').margin({ top: 8, bottom: 20 }).fontSize(12).fontColor(AppTheme.secondaryText)
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
      })
    }.width('100%').padding(12).margin({ bottom: 8 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
  }
}
