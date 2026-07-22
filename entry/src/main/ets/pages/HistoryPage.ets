import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { AnswerBundle } from '../model/AnswerBundle';
import { MeetingSummary } from '../model/MeetingSummary';
import { MockMeetingService } from '../services/MockMeetingService';
import { MockStorageService } from '../services/MockStorageService';

@Entry
@Component
struct HistoryPage {
  private meetingService: MockMeetingService = new MockMeetingService();
  private loadTimer: number = 0;
  private isLoading: boolean = false;
  @State active: string = 'All';
  @State keyword: string = '';
  @State history: MeetingSummary[] = [];
  @State favoriteAnswers: AnswerBundle[] = [];
  @State pageState: PageLoadState = 'loading';
  @State errorText: string = '';
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    this.loadHistory();
  }

  aboutToDisappear(): void {
    this.clearLoadTimer();
  }

  private clearLoadTimer(): void {
    if (this.loadTimer > 0) { clearTimeout(this.loadTimer); this.loadTimer = 0; }
  }

  private loadHistory(): void {
    if (this.isLoading) {
      return;
    }
    this.clearLoadTimer();
    this.isLoading = true;
    this.pageState = 'loading';
    this.errorText = '';
    this.loadTimer = setTimeout((): void => {
      try {
        const nextHistory: MeetingSummary[] = this.meetingService.getMeetingHistory();
        const nextFavorites: AnswerBundle[] = MockStorageService.getFavorites();
        this.history = nextHistory;
        this.favoriteAnswers = nextFavorites;
        this.pageState = nextHistory.length + nextFavorites.length > 0 ? 'success' : 'empty';
      } catch (error) {
        this.errorText = 'Failed to load history records.';
        this.history = [];
        this.favoriteAnswers = [];
        this.pageState = 'error';
      }
      this.isLoading = false;
      this.loadTimer = 0;
    }, 120);
  }

  private keywordMatched(text: string): boolean {
    if (this.keyword.length === 0) {
      return true;
    }
    return text.toLowerCase().indexOf(this.keyword.toLowerCase()) >= 0;
  }

  private meetingVisible(summary: MeetingSummary): boolean {
    return this.active !== 'Answers' && this.keywordMatched(I18n.historySummaryLine(summary, this.language));
  }

  private answerVisible(answer: AnswerBundle): boolean {
    return this.active !== 'Meetings' && this.keywordMatched(`${I18n.answer(answer, this.language).question} ${I18n.answer(answer, this.language).transitionSentence}`);
  }

  private hasVisibleMeetings(): boolean {
    return this.history.some((summary: MeetingSummary): boolean => this.meetingVisible(summary));
  }

  private hasVisibleAnswers(): boolean {
    return this.favoriteAnswers.some((answer: AnswerBundle): boolean => this.answerVisible(answer));
  }

  private hasVisibleData(): boolean {
    return this.hasVisibleMeetings() || this.hasVisibleAnswers();
  }

  build() {
    Scroll() {
      Column() {
        Row() { Button(I18n.t('back', this.language)).height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text(I18n.t('history', this.language)).layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
        if (this.pageState === 'loading') {
          PageStateView({ state: 'loading', title: 'Loading history', description: 'Reading saved summaries and favorite answers.' }).margin({ top: 16 })
        } else if (this.pageState === 'error') {
          PageStateView({ state: 'error', title: 'Unable to load history', description: this.errorText, actionLabel: 'Retry', actionEnabled: !this.isLoading, onAction: (): void => this.loadHistory() }).margin({ top: 16 })
        } else if (this.pageState === 'empty') {
          PageStateView({ state: 'empty', title: I18n.t('noHistory', this.language), description: I18n.t('saveSummaryFirst', this.language), actionLabel: I18n.t('startAdHocMeeting', this.language), onAction: (): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: 'product-review' } }); } }).margin({ top: 16 })
        } else {
          Row() { Button(I18n.t('all', this.language)).layoutWeight(1).height(34).enabled(!this.isLoading).onClick((): void => { this.active = 'All'; }); Button(I18n.t('meetings', this.language)).layoutWeight(1).height(34).enabled(!this.isLoading).margin({ left: 6 }).onClick((): void => { this.active = 'Meetings'; }); Button(I18n.t('answers', this.language)).layoutWeight(1).height(34).enabled(!this.isLoading).margin({ left: 6 }).onClick((): void => { this.active = 'Answers'; }) }.margin({ top: 16 }).width('100%')
          TextInput({ placeholder: I18n.t('searchPlaceholder', this.language), text: this.keyword }).margin({ top: 12 }).height(42).fontColor(AppTheme.primaryText).placeholderColor(AppTheme.mutedText).backgroundColor(AppTheme.cardBackground).enabled(!this.isLoading).onChange((value: string): void => { this.keyword = value; })
          if (!this.hasVisibleData()) {
            PageStateView({ state: 'empty', title: 'No matching records', description: 'No saved meeting summaries or favorite answers match the current filter.', actionLabel: 'Reload', actionEnabled: !this.isLoading, onAction: (): void => this.loadHistory() }).margin({ top: 16 })
          } else {
            if (this.hasVisibleMeetings()) {
              SectionHeader({ title: I18n.t('meetingHistory', this.language) })
              ForEach(this.history, (summary: MeetingSummary) => {
                if (this.meetingVisible(summary)) {
                  Text(I18n.historySummaryLine(summary, this.language)).width('100%').padding(14).margin({ bottom: 10 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium).onClick((): void => { router.pushUrl({ url: 'pages/MeetingSummaryPage', params: { meetingId: summary.meetingId } }); })
                }
              }, (summary: MeetingSummary): string => summary.id)
            }
            if (this.hasVisibleAnswers()) {
              SectionHeader({ title: I18n.t('answerHistory', this.language) })
              ForEach(this.favoriteAnswers, (answer: AnswerBundle) => {
                if (this.answerVisible(answer)) {
                  Column() { Text(I18n.answer(answer, this.language).question).width('100%').fontSize(15).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText); Text(`${I18n.answer(answer, this.language).transitionSentence} / ${answer.durationMode} / ${I18n.toneLabel(answer.tone, this.language)}`).width('100%').margin({ top: 8 }).fontSize(12).fontColor(AppTheme.secondaryText); Button(I18n.t('favorited', this.language)).width('100%').height(34).margin({ top: 8 }).onClick((): void => { promptAction.showToast({ message: I18n.t('favorited', this.language) }); }) }.alignItems(HorizontalAlign.Start).width('100%').padding(14).margin({ bottom: 10 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium).onClick((): void => { router.pushUrl({ url: 'pages/AnswerDetailPage' }); })
                }
              }, (answer: AnswerBundle): string => answer.id)
            }
          }
        }
      }.padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
