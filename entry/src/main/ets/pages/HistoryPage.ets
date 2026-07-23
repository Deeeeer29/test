import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { BottomNavigationBar } from '../components/BottomNavigationBar';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { TopTitleBar } from '../components/TopTitleBar';
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
        this.errorText = I18n.t('historyErrorDesc', this.language);
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

  private filterBackground(filter: string): string {
    return this.active === filter ? AppTheme.accentSoft : AppTheme.cardBackground;
  }

  private filterColor(filter: string): string {
    return this.active === filter ? AppTheme.accentColor : AppTheme.secondaryText;
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          TopTitleBar({ title: I18n.t('history', this.language), showBack: false })
          if (this.pageState === 'loading') {
            PageStateView({ state: 'loading', title: I18n.t('loadingHistory', this.language) }).margin({ top: 14 })
          } else if (this.pageState === 'error') {
            PageStateView({ state: 'error', title: I18n.t('historyError', this.language), description: this.errorText, actionLabel: I18n.t('retry', this.language), actionEnabled: !this.isLoading, onAction: (): void => this.loadHistory() }).margin({ top: 14 })
          } else if (this.pageState === 'empty') {
            PageStateView({ state: 'empty', title: I18n.t('noHistory', this.language), description: I18n.t('saveSummaryFirst', this.language), actionLabel: I18n.t('startAdHocMeeting', this.language), onAction: (): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: 'product-review' } }, router.RouterMode.Single); } }).margin({ top: 14 })
          } else {
            TextInput({ placeholder: I18n.t('searchPlaceholder', this.language), text: this.keyword })
              .margin({ top: 14 })
              .height(40)
              .padding({ left: 12, right: 12 })
              .fontSize(14)
              .fontColor(AppTheme.primaryText)
              .placeholderColor(AppTheme.mutedText)
              .backgroundColor(AppTheme.cardBackground)
              .borderRadius(AppTheme.radiusMedium)
              .enabled(!this.isLoading)
              .onChange((value: string): void => { this.keyword = value; })
            Row() {
              Button(I18n.t('all', this.language)).layoutWeight(1).height(34).fontSize(13).fontColor(this.filterColor('All')).backgroundColor(this.filterBackground('All')).enabled(!this.isLoading).onClick((): void => { this.active = 'All'; })
              Button(I18n.t('meetings', this.language)).layoutWeight(1).height(34).fontSize(13).fontColor(this.filterColor('Meetings')).backgroundColor(this.filterBackground('Meetings')).enabled(!this.isLoading).margin({ left: 8 }).onClick((): void => { this.active = 'Meetings'; })
              Button(I18n.t('answers', this.language)).layoutWeight(1).height(34).fontSize(13).fontColor(this.filterColor('Answers')).backgroundColor(this.filterBackground('Answers')).enabled(!this.isLoading).margin({ left: 8 }).onClick((): void => { this.active = 'Answers'; })
            }.margin({ top: 10 }).width('100%')
            if (!this.hasVisibleData()) {
              PageStateView({ state: 'empty', title: I18n.t('noMatchingRecords', this.language), description: I18n.t('noMatchingRecordsDesc', this.language), actionLabel: I18n.t('reload', this.language), actionEnabled: !this.isLoading, onAction: (): void => this.loadHistory() }).margin({ top: 14 })
            } else {
              if (this.hasVisibleMeetings()) {
                SectionHeader({ title: I18n.t('meetingHistory', this.language) })
                ForEach(this.history, (summary: MeetingSummary) => {
                  if (this.meetingVisible(summary)) {
                    Column() {
                      Text(I18n.meetingTitle(summary.meetingId, summary.meetingTitle, this.language)).width('100%').fontSize(15).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
                      Text(I18n.historySummaryLine(summary, this.language)).width('100%').margin({ top: 6 }).fontSize(12).fontColor(AppTheme.secondaryText)
                    }.alignItems(HorizontalAlign.Start).width('100%').padding(14).margin({ bottom: 8 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium).onClick((): void => { router.pushUrl({ url: 'pages/MeetingSummaryPage', params: { meetingId: summary.meetingId } }, router.RouterMode.Single); })
                  }
                }, (summary: MeetingSummary): string => summary.id)
              }
              if (this.hasVisibleAnswers()) {
                SectionHeader({ title: I18n.t('answerHistory', this.language) })
                ForEach(this.favoriteAnswers, (answer: AnswerBundle) => {
                  if (this.answerVisible(answer)) {
                    Column() {
                      Text(I18n.answer(answer, this.language).question).width('100%').fontSize(15).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
                      Text(`${I18n.answer(answer, this.language).transitionSentence} / ${answer.durationMode} / ${I18n.toneLabel(answer.tone, this.language)}`).width('100%').margin({ top: 6 }).fontSize(12).fontColor(AppTheme.secondaryText).maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(I18n.t('favorited', this.language)).margin({ top: 8 }).padding({ left: 10, right: 10, top: 4, bottom: 4 }).fontSize(11).fontColor(AppTheme.accentColor).backgroundColor(AppTheme.accentSoft).borderRadius(AppTheme.radiusSmall).onClick((): void => { promptAction.showToast({ message: I18n.t('favorited', this.language) }); })
                    }.alignItems(HorizontalAlign.Start).width('100%').padding(14).margin({ bottom: 8 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium).onClick((): void => { router.pushUrl({ url: 'pages/AnswerDetailPage', params: { questionId: answer.id, from: 'history' } }, router.RouterMode.Single); })
                  }
                }, (answer: AnswerBundle): string => answer.id)
              }
            }
          }
        }.padding({ left: 18, right: 18, top: 14, bottom: 18 })
      }.layoutWeight(1)
      BottomNavigationBar({ current: 'history', language: this.language })
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
