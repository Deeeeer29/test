import { router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { TopTitleBar } from '../components/TopTitleBar';
import { Meeting } from '../model/Meeting';
import { MeetingDocument } from '../model/MeetingDocument';
import { PredictedQuestion } from '../model/PredictedQuestion';
import { KeyMetric, MeetingPreparation } from '../services/MeetingService';
import { AuthService } from '../services/AuthService';
import { MockMeetingService } from '../services/MockMeetingService';
import { MockStorageService } from '../services/MockStorageService';

interface PageParams { meetingId?: string; }

const EMPTY_MEETING: Meeting = {
  id: '',
  title: '',
  startTime: '',
  endTime: '',
  location: '',
  participants: [],
  goal: '',
  status: 'pending',
  preparationStatus: 'not_started',
  aiAssistedCount: 0
};

const EMPTY_PREPARATION: MeetingPreparation = {
  meeting: EMPTY_MEETING,
  documents: [],
  predictedQuestions: [],
  keyMetrics: [],
  backgroundSummary: []
};

@Entry
@Component
struct MeetingPreparationPage {
  private meetingService: MockMeetingService = new MockMeetingService();
  private loadTimer: number = 0;
  private isLoading: boolean = false;
  @State meetingId: string = 'product-review';
  @State meeting: Meeting = EMPTY_MEETING;
  @State preparation: MeetingPreparation = EMPTY_PREPARATION;
  @State pageState: PageLoadState = 'loading';
  @State errorText: string = '';
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    AuthService.ensureAuthenticated().then((authenticated: boolean): void => {
      if (!authenticated) {
        return;
      }
      const params = router.getParams() as PageParams;
      if (params && params.meetingId) { this.meetingId = params.meetingId; }
      this.loadPreparation();
    });
  }

  aboutToDisappear(): void {
    this.clearLoadTimer();
  }

  private clearLoadTimer(): void {
    if (this.loadTimer > 0) { clearTimeout(this.loadTimer); this.loadTimer = 0; }
  }

  private loadPreparation(): void {
    if (this.isLoading) {
      return;
    }
    this.clearLoadTimer();
    this.isLoading = true;
    this.pageState = 'loading';
    this.errorText = '';
    this.loadTimer = setTimeout((): void => {
      try {
        const nextMeeting: Meeting = this.meetingService.getMeetingById(this.meetingId);
        const nextPreparation: MeetingPreparation = this.meetingService.getMeetingPreparation(this.meetingId);
        this.meeting = nextMeeting;
        this.preparation = nextPreparation;
        const itemCount: number = nextPreparation.documents.length + nextPreparation.predictedQuestions.length + nextPreparation.backgroundSummary.length + nextPreparation.keyMetrics.length;
        this.pageState = itemCount > 0 ? 'success' : 'empty';
      } catch (error) {
        this.errorText = I18n.t('preparationErrorDesc', this.language);
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
          TopTitleBar({ title: I18n.t('preparation', this.language), showBack: true })
          if (this.pageState === 'loading') {
            PageStateView({ state: 'loading', title: I18n.t('loadingPreparation', this.language), description: I18n.t('loadingPreparationDesc', this.language) }).margin({ top: 16 })
          } else if (this.pageState === 'error') {
            PageStateView({ state: 'error', title: I18n.t('preparationError', this.language), description: this.errorText, actionLabel: I18n.t('retry', this.language), actionEnabled: !this.isLoading, onAction: (): void => this.loadPreparation() }).margin({ top: 16 })
          } else if (this.pageState === 'empty') {
            PageStateView({ state: 'empty', title: I18n.t('noPreparationData', this.language), description: I18n.t('noPreparationDataDesc', this.language), actionLabel: I18n.t('backHome', this.language), onAction: (): void => { router.replaceUrl({ url: 'pages/Index' }, router.RouterMode.Single); } }).margin({ top: 16 })
          } else {
            Text(I18n.meetingTitle(this.meeting.id, this.meeting.title, this.language)).width('100%').margin({ top: 16 }).padding(16).fontSize(22).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
            SectionHeader({ title: I18n.t('backgroundSummary', this.language) })
            ForEach(I18n.backgroundSummary(this.meetingId, this.language), (item: string) => { Text(`- ${item}`).width('100%').padding(10).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusSmall) }, (item: string): string => item)
            SectionHeader({ title: I18n.t('keyMetrics', this.language) })
            ForEach(this.preparation.keyMetrics, (item: KeyMetric) => { Text(I18n.keyMetricLine(item.name, item.value, item.unit, this.language)).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).borderRadius(AppTheme.radiusMedium) }, (item: KeyMetric): string => item.name)
            SectionHeader({ title: I18n.t('materials', this.language) })
            ForEach(this.preparation.documents, (doc: MeetingDocument) => { Text(I18n.documentLine(doc, this.language)).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (doc: MeetingDocument): string => doc.id)
            SectionHeader({ title: I18n.t('predictedQuestions', this.language) })
            ForEach(this.preparation.predictedQuestions, (question: PredictedQuestion) => { Text(I18n.questionLine(question, this.language)).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium).onClick((): void => { router.pushUrl({ url: 'pages/AnswerDetailPage', params: { questionId: question.id } }, router.RouterMode.Single); }) }, (question: PredictedQuestion): string => question.id)
          }
        }.padding(18)
      }.layoutWeight(1)
      Button(I18n.t('enterMeetingMode', this.language)).width('100%').height(50).fontColor(AppTheme.primaryButtonText).backgroundColor(AppTheme.accentColor).enabled(this.pageState === 'success').onClick((): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: this.meetingId } }, router.RouterMode.Single); })
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
