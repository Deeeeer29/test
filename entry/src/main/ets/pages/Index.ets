import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { DeviceStatusBar } from '../components/DeviceStatusBar';
import { MeetingCard } from '../components/MeetingCard';
import { SectionHeader } from '../components/SectionHeader';
import { DeviceStatus } from '../model/DeviceStatus';
import { Meeting } from '../model/Meeting';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockMeetingService } from '../services/MockMeetingService';
import { MockStorageService } from '../services/MockStorageService';

@Entry
@Component
struct Index {
  private meetingService: MockMeetingService = new MockMeetingService();
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  @State meetings: Meeting[] = this.meetingService.getTodayMeetings();
  @State status: DeviceStatus = this.audioService.getEarphoneStatus();

  aboutToAppear(): void {
    if (!MockStorageService.getOnboardingStatus()) {
      router.replaceUrl({ url: 'pages/PrivacyOnboardingPage' });
    }
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Column() {
              Text('Today').fontSize(12).fontColor(AppTheme.secondaryText)
              Text('Meeting assistant dashboard').margin({ top: 6 }).fontSize(22).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            Button('Settings').height(36).fontColor(AppTheme.accentColor).backgroundColor(AppTheme.elevatedBackground).onClick((): void => { router.pushUrl({ url: 'pages/SettingsPage' }); })
          }.width('100%')
          DeviceStatusBar({ status: this.status }).margin({ top: 16 })
          SectionHeader({ title: 'Today meetings', subtitle: 'Mock data, phone and earphone prompt only.' })
          ForEach(this.meetings, (meeting: Meeting) => {
            MeetingCard({ meeting: meeting, onPrepare: (id: string): void => { router.pushUrl({ url: 'pages/MeetingPreparationPage', params: { meetingId: id } }); }, onStart: (id: string): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: id } }); } }).margin({ bottom: 12 })
          }, (meeting: Meeting): string => meeting.id)
          Button('Start ad-hoc meeting').width('100%').height(44).fontColor('#07110F').backgroundColor(AppTheme.accentColor).onClick((): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: 'product-review' } }); })
          SectionHeader({ title: 'Recent records' })
          Text('Latest summary, answer and action item are ready in mock history.').width('100%').padding(14).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        }.padding(18)
      }.layoutWeight(1)
      Row() {
        Text('Today').fontColor(AppTheme.accentColor).layoutWeight(1).textAlign(TextAlign.Center)
        Text('Assistant').fontColor(AppTheme.secondaryText).layoutWeight(1).textAlign(TextAlign.Center).onClick((): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: 'product-review' } }); })
        Text('History').fontColor(AppTheme.secondaryText).layoutWeight(1).textAlign(TextAlign.Center).onClick((): void => { router.pushUrl({ url: 'pages/HistoryPage' }); })
        Text('Mine').fontColor(AppTheme.secondaryText).layoutWeight(1).textAlign(TextAlign.Center).onClick((): void => { router.pushUrl({ url: 'pages/SettingsPage' }); })
      }.width('100%').height(58).backgroundColor(AppTheme.cardBackground)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
