import { router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { AppTheme } from '../common/theme/AppTheme';
import { BottomNavigationBar } from '../components/BottomNavigationBar';
import { DeviceStatusBar } from '../components/DeviceStatusBar';
import { MeetingCard } from '../components/MeetingCard';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { TopTitleBar } from '../components/TopTitleBar';
import { PageLoadState } from '../common/state/PageLoadState';
import { DeviceStatus } from '../model/DeviceStatus';
import { Meeting } from '../model/Meeting';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockMeetingService } from '../services/MockMeetingService';
import { MockStorageService } from '../services/MockStorageService';

const EMPTY_DEVICE_STATUS: DeviceStatus = {
  phone: {
    isAvailable: false,
    microphonePermission: false,
    batteryLevel: 0
  },
  headphone: {
    isConnected: false,
    isAvailable: false
  },
  aiService: {
    isAvailable: false,
    mode: 'local',
    status: 'idle'
  }
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
        this.errorText = I18n.t('dashboardErrorDesc', this.language);
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
          TopTitleBar({ title: I18n.t('dashboard', this.language), showBack: false })
          if (this.pageState === 'loading') {
            PageStateView({ state: 'loading', title: I18n.t('loadingDashboard', this.language), description: I18n.t('loadingDashboardDesc', this.language) }).margin({ top: 16 })
          } else if (this.pageState === 'error') {
            PageStateView({ state: 'error', title: I18n.t('dashboardError', this.language), description: this.errorText, actionLabel: I18n.t('retry', this.language), actionEnabled: !this.isLoading, onAction: (): void => this.loadHomeData() }).margin({ top: 16 })
          } else if (this.pageState === 'empty') {
            PageStateView({ state: 'empty', title: I18n.t('noMeetingsToday', this.language), actionLabel: I18n.t('startAdHocMeeting', this.language), onAction: (): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: 'product-review' } }, router.RouterMode.Single); } }).margin({ top: 16 })
          } else {
            DeviceStatusBar({ status: this.status, language: this.language }).margin({ top: 16 })
            SectionHeader({ title: I18n.t('todayMeetings', this.language) })
            ForEach(this.meetings, (meeting: Meeting) => {
              MeetingCard({ meeting: meeting, language: this.language, onPrepare: (id: string): void => { router.pushUrl({ url: 'pages/MeetingPreparationPage', params: { meetingId: id } }, router.RouterMode.Single); }, onStart: (id: string): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: id } }, router.RouterMode.Single); } }).margin({ bottom: 12 })
            }, (meeting: Meeting): string => meeting.id)
            Button(I18n.t('startAdHocMeeting', this.language)).width('100%').height(44).fontColor(AppTheme.primaryButtonText).backgroundColor(AppTheme.accentColor).onClick((): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: 'product-review' } }, router.RouterMode.Single); })
          }
        }.padding({ left: 18, right: 18, top: 14, bottom: 18 })
      }.layoutWeight(1)
      BottomNavigationBar({ current: 'today', language: this.language })
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
