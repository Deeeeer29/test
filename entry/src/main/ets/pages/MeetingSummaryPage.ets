import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { ActionItem } from '../model/ActionItem';
import { MeetingSummary } from '../model/MeetingSummary';
import { MockAIAnswerService } from '../services/MockAIAnswerService';
import { MockMeetingService } from '../services/MockMeetingService';
import { MockStorageService } from '../services/MockStorageService';

interface PageParams { meetingId?: string; }

const EMPTY_SUMMARY: MeetingSummary = {
  id: '',
  meetingId: '',
  meetingTitle: '',
  date: '',
  startTime: '',
  endTime: '',
  duration: '',
  attendees: [],
  conclusions: [],
  decisions: [],
  actionItems: [],
  unresolvedQuestions: [],
  aiAssistCount: 0,
  answers: []
};

@Entry
@Component
struct MeetingSummaryPage {
  private answerService: MockAIAnswerService = new MockAIAnswerService();
  private meetingService: MockMeetingService = new MockMeetingService();
  private loadTimer: number = 0;
  private isLoading: boolean = false;
  @State meetingId: string = 'product-review';
  @State summary: MeetingSummary = EMPTY_SUMMARY;
  @State pageState: PageLoadState = 'loading';
  @State errorText: string = '';
  @State saved: boolean = false;
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    const params = router.getParams() as PageParams;
    if (params && params.meetingId) { this.meetingId = params.meetingId; }
    this.loadSummary();
  }

  aboutToDisappear(): void {
    this.clearLoadTimer();
  }

  private clearLoadTimer(): void {
    if (this.loadTimer > 0) { clearTimeout(this.loadTimer); this.loadTimer = 0; }
  }

  private loadSummary(): void {
    if (this.isLoading) {
      return;
    }
    this.clearLoadTimer();
    this.isLoading = true;
    this.pageState = 'loading';
    this.errorText = '';
    this.saved = false;
    this.loadTimer = setTimeout((): void => {
      try {
        this.meetingService.getMeetingById(this.meetingId);
        const nextSummary: MeetingSummary = this.answerService.generateMeetingSummary(this.meetingId);
        this.summary = nextSummary;
        const itemCount: number = nextSummary.conclusions.length + nextSummary.decisions.length + nextSummary.actionItems.length + nextSummary.unresolvedQuestions.length;
        this.pageState = itemCount > 0 ? 'success' : 'empty';
      } catch (error) {
        this.errorText = 'Failed to generate meeting summary.';
        this.pageState = 'error';
      }
      this.isLoading = false;
      this.loadTimer = 0;
    }, 120);
  }

  private save(): void {
    if (this.pageState !== 'success' || this.saved || this.isLoading) {
      return;
    }
    try {
      this.meetingService.saveMeetingSummary(I18n.summary(this.summary, this.language));
      this.saved = true;
      promptAction.showToast({ message: I18n.t('savedToHistory', this.language) });
    } catch (error) {
      promptAction.showToast({ message: 'Failed to save summary' });
    }
  }

  build() {
    Scroll() {
      Column() {
        Row() { Button(I18n.t('back', this.language)).height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text(I18n.t('meetingSummary', this.language)).layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
        if (this.pageState === 'loading') {
          PageStateView({ state: 'loading', title: 'Generating summary', description: 'Reading the meeting result and building the mock summary.' }).margin({ top: 16 })
        } else if (this.pageState === 'error') {
          PageStateView({ state: 'error', title: 'Unable to generate summary', description: this.errorText, actionLabel: 'Retry', actionEnabled: !this.isLoading, onAction: (): void => this.loadSummary() }).margin({ top: 16 })
        } else if (this.pageState === 'empty') {
          PageStateView({ state: 'empty', title: 'No summary content', description: 'There are no conclusions, decisions, action items, or unresolved questions to show.', actionLabel: I18n.t('backHome', this.language), onAction: (): void => { router.replaceUrl({ url: 'pages/Index' }); } }).margin({ top: 16 })
        } else {
          Text(I18n.summaryMeta(I18n.summary(this.summary, this.language), this.language)).width('100%').padding(16).margin({ top: 16 }).fontSize(16).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
          SectionHeader({ title: I18n.t('conclusions', this.language) })
          ForEach(I18n.summary(this.summary, this.language).conclusions, (item: string) => { Text(`- ${item}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (item: string): string => item)
          SectionHeader({ title: I18n.t('decisions', this.language) })
          ForEach(I18n.summary(this.summary, this.language).decisions, (item: string) => { Text(`- ${item}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (item: string): string => item)
          SectionHeader({ title: I18n.t('actionItems', this.language) })
          ForEach(I18n.summary(this.summary, this.language).actionItems, (item: ActionItem) => { Text(`${item.completed ? I18n.t('done', this.language) : I18n.t('todo', this.language)} / ${item.title} / ${item.owner} / ${item.deadline} / ${I18n.actionPriority(item.priority, this.language)}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(item.completed ? AppTheme.successColor : AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (item: ActionItem): string => item.id)
          SectionHeader({ title: I18n.t('unresolved', this.language) })
          ForEach(I18n.summary(this.summary, this.language).unresolvedQuestions, (item: string) => { Text(`- ${item}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.warningColor).backgroundColor('#2B2517').borderRadius(AppTheme.radiusMedium) }, (item: string): string => item)
          Button(this.saved ? I18n.t('saved', this.language) : I18n.t('saveSummary', this.language)).width('100%').height(42).margin({ top: 14 }).fontColor('#07110F').backgroundColor(AppTheme.accentColor).enabled(!this.saved && !this.isLoading).onClick((): void => this.save())
          Button(I18n.t('mockExportText', this.language)).width('100%').height(42).margin({ top: 8 }).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).enabled(!this.isLoading).onClick((): void => { promptAction.showDialog({ title: I18n.t('export', this.language), message: I18n.summary(this.summary, this.language).conclusions.join('\n') }); })
          Button(I18n.t('backHome', this.language)).width('100%').height(42).margin({ top: 8, bottom: 20 }).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).onClick((): void => { router.replaceUrl({ url: 'pages/Index' }); })
        }
      }.padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
