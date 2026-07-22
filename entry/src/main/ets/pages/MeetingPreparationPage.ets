import { router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { Meeting } from '../model/Meeting';
import { MeetingDocument } from '../model/MeetingDocument';
import { PredictedQuestion } from '../model/PredictedQuestion';
import { MeetingPreparation } from '../services/MeetingService';
import { MockMeetingService } from '../services/MockMeetingService';
import { MockStorageService } from '../services/MockStorageService';

interface PageParams { meetingId?: string; }

const EMPTY_MEETING: Meeting = {
  id: '',
  title: '',
  startTime: '',
  endTime: '',
  location: '',
  attendees: [],
  objective: '',
  status: 'waiting',
  preparedDocumentCount: 0,
  predictedQuestionCount: 0,
  preparationProgress: 0
};

const EMPTY_PREPARATION: MeetingPreparation = {
  documents: [],
  questions: [],
  backgroundSummary: [],
  keyMetrics: []
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
    const params = router.getParams() as PageParams;
    if (params && params.meetingId) { this.meetingId = params.meetingId; }
    this.loadPreparation();
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
        const itemCount: number = nextPreparation.documents.length + nextPreparation.questions.length + nextPreparation.backgroundSummary.length + nextPreparation.keyMetrics.length;
        this.pageState = itemCount > 0 ? 'success' : 'empty';
      } catch (error) {
        this.errorText = 'Failed to load meeting preparation.';
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
          Row() { Button(I18n.t('back', this.language)).height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text(I18n.t('preparation', this.language)).layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
          if (this.pageState === 'loading') {
            PageStateView({ state: 'loading', title: 'Loading preparation', description: 'Reading meeting documents, metrics, and predicted questions.' }).margin({ top: 16 })
          } else if (this.pageState === 'error') {
            PageStateView({ state: 'error', title: 'Unable to load preparation', description: this.errorText, actionLabel: 'Retry', actionEnabled: !this.isLoading, onAction: (): void => this.loadPreparation() }).margin({ top: 16 })
          } else if (this.pageState === 'empty') {
            PageStateView({ state: 'empty', title: 'No preparation data', description: 'This meeting has no documents, metrics, background notes, or predicted questions yet.', actionLabel: I18n.t('backHome', this.language), onAction: (): void => { router.replaceUrl({ url: 'pages/Index' }); } }).margin({ top: 16 })
          } else {
            Text(I18n.meetingTitle(this.meeting.id, this.meeting.title, this.language)).width('100%').margin({ top: 16 }).padding(16).fontSize(22).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
            SectionHeader({ title: I18n.t('backgroundSummary', this.language), subtitle: I18n.t('mockData', this.language) })
            ForEach(this.preparation.backgroundSummary, (item: string) => { Text(`- ${item}`).width('100%').padding(10).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusSmall) }, (item: string): string => item)
            SectionHeader({ title: I18n.t('keyMetrics', this.language) })
            ForEach(this.preparation.keyMetrics, (item: string) => { Text(item).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).borderRadius(AppTheme.radiusMedium) }, (item: string): string => item)
            SectionHeader({ title: I18n.t('materials', this.language) })
            ForEach(this.preparation.documents, (doc: MeetingDocument) => { Text(I18n.documentLine(doc, this.language)).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (doc: MeetingDocument): string => doc.id)
            SectionHeader({ title: I18n.t('predictedQuestions', this.language) })
            ForEach(this.preparation.questions, (question: PredictedQuestion) => { Text(I18n.questionLine(question, this.language)).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium).onClick((): void => { router.pushUrl({ url: 'pages/AnswerDetailPage', params: { questionId: question.id } }); }) }, (question: PredictedQuestion): string => question.id)
          }
        }.padding(18)
      }.layoutWeight(1)
      Button(I18n.t('enterMeetingMode', this.language)).width('100%').height(50).fontColor('#07110F').backgroundColor(AppTheme.accentColor).enabled(this.pageState === 'success').onClick((): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: this.meetingId } }); })
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
