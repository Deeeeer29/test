import { router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { AppTheme } from '../common/theme/AppTheme';
import { DeviceStatusBar } from '../components/DeviceStatusBar';
import { MeetingCard } from '../components/MeetingCard';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { PageLoadState } from '../common/state/PageLoadState';
import { DeviceStatus } from '../model/DeviceStatus';
import { Meeting } from '../model/Meeting';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockMeetingService } from '../services/MockMeetingService';
import { MockStorageService } from '../services/MockStorageService';

const EMPTY_DEVICE_STATUS: DeviceStatus = {
  phoneAvailable: false,
  earphoneConnected: false,
  aiServiceAvailable: false,
  microphoneActive: false,
  lastCheckTime: ''
};

@Entry
@Component
struct Index {
  private meetingService: MockMeetingService = new MockMeetingService();
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  private loadTimer: number = 0;
  private isLoading: boolean = false;
  @State meetings: Meeting[] = [];
  @State status: DeviceStatus = EMPTY_DEVICE_STATUS;
  @State pageState: PageLoadState = 'loading';
  @State errorText: string = '';
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    if (!MockStorageService.getOnboardingStatus()) {
      router.replaceUrl({ url: 'pages/PrivacyOnboardingPage' });
      return;
    }
    this.loadHomeData();
  }

  aboutToDisappear(): void {
    this.clearLoadTimer();
  }

  private clearLoadTimer(): void {
    if (this.loadTimer > 0) { clearTimeout(this.loadTimer); this.loadTimer = 0; }
  }

  private loadHomeData(): void {
    if (this.isLoading) {
      return;
    }
    this.clearLoadTimer();
    this.isLoading = true;
    this.pageState = 'loading';
    this.errorText = '';
    this.loadTimer = setTimeout((): void => {
      try {
        const nextStatus: DeviceStatus = this.audioService.getEarphoneStatus();
        const nextMeetings: Meeting[] = this.meetingService.getTodayMeetings();
        this.status = nextStatus;
        this.meetings = nextMeetings;
        this.pageState = nextMeetings.length > 0 ? 'success' : 'empty';
      } catch (error) {
        this.errorText = 'Failed to load today meetings.';
        this.meetings = [];
        this.pageState = 'error';
      }
      this.isLoading = false;
      this.loadTimer = 0;
    }, 120);
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Column() {
              Text(I18n.t('today', this.language)).fontSize(12).fontColor(AppTheme.secondaryText)
              Text(I18n.t('dashboard', this.language)).margin({ top: 6 }).fontSize(22).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            Button(I18n.t('settings', this.language)).height(36).fontColor(AppTheme.accentColor).backgroundColor(AppTheme.elevatedBackground).onClick((): void => { router.pushUrl({ url: 'pages/SettingsPage' }); })
          }.width('100%')
          if (this.pageState === 'loading') {
            PageStateView({ state: 'loading', title: 'Loading dashboard', description: 'Reading meeting and device status.' }).margin({ top: 16 })
          } else if (this.pageState === 'error') {
            PageStateView({ state: 'error', title: 'Unable to load dashboard', description: this.errorText, actionLabel: 'Retry', actionEnabled: !this.isLoading, onAction: (): void => this.loadHomeData() }).margin({ top: 16 })
          } else if (this.pageState === 'empty') {
            PageStateView({ state: 'empty', title: 'No meetings today', description: 'There are no scheduled meetings available from the mock service.', actionLabel: I18n.t('startAdHocMeeting', this.language), onAction: (): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: 'product-review' } }); } }).margin({ top: 16 })
          } else {
            DeviceStatusBar({ status: this.status, language: this.language }).margin({ top: 16 })
            SectionHeader({ title: I18n.t('todayMeetings', this.language), subtitle: I18n.t('mockPhoneEarphoneOnly', this.language) })
            ForEach(this.meetings, (meeting: Meeting) => {
              MeetingCard({ meeting: meeting, language: this.language, onPrepare: (id: string): void => { router.pushUrl({ url: 'pages/MeetingPreparationPage', params: { meetingId: id } }); }, onStart: (id: string): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: id } }); } }).margin({ bottom: 12 })
            }, (meeting: Meeting): string => meeting.id)
            Button(I18n.t('startAdHocMeeting', this.language)).width('100%').height(44).fontColor('#07110F').backgroundColor(AppTheme.accentColor).onClick((): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: 'product-review' } }); })
            SectionHeader({ title: I18n.t('recentRecords', this.language) })
            Text(I18n.t('recentRecordsDesc', this.language)).width('100%').padding(14).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
          }
        }.padding(18)
      }.layoutWeight(1)
      Row() {
        Text(I18n.t('today', this.language)).fontColor(AppTheme.accentColor).layoutWeight(1).textAlign(TextAlign.Center)
        Text(I18n.t('assistant', this.language)).fontColor(AppTheme.secondaryText).layoutWeight(1).textAlign(TextAlign.Center).onClick((): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: 'product-review' } }); })
        Text(I18n.t('history', this.language)).fontColor(AppTheme.secondaryText).layoutWeight(1).textAlign(TextAlign.Center).onClick((): void => { router.pushUrl({ url: 'pages/HistoryPage' }); })
        Text(I18n.t('mine', this.language)).fontColor(AppTheme.secondaryText).layoutWeight(1).textAlign(TextAlign.Center).onClick((): void => { router.pushUrl({ url: 'pages/SettingsPage' }); })
      }.width('100%').height(58).backgroundColor(AppTheme.cardBackground)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
