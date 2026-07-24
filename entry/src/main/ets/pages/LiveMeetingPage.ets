import { promptAction, router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { AnswerPreviewCard } from '../components/AnswerPreviewCard';
import { BottomNavigationBar } from '../components/BottomNavigationBar';
import { FloatingAnswerCard } from '../components/FloatingAnswerCard';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { StatusBadge } from '../components/StatusBadge';
import { TopTitleBar } from '../components/TopTitleBar';
import { TranscriptBubble } from '../components/TranscriptBubble';
import { AnswerBundle } from '../model/AnswerBundle';
import { Meeting } from '../model/Meeting';
import { MeetingDocument } from '../model/MeetingDocument';
import { TranscriptItem } from '../model/TranscriptItem';
import { AuthService } from '../services/AuthService';
import { ApiAIAnswerService } from '../services/ApiAIAnswerService';
import { ApiTranscriptService } from '../services/ApiTranscriptService';
import { IAIAnswerService } from '../services/AIAnswerService';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockMeetingService } from '../services/MockMeetingService';
import { MockStorageService } from '../services/MockStorageService';
import { MeetingPreparation } from '../services/MeetingService';

type AnswerState = 'idle' | 'generating' | 'ready';
type TranscriptionState = 'not_started' | 'transcribing' | 'paused' | 'stopped';
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

const EMPTY_ANSWER: AnswerBundle = {
  id: '',
  meetingId: '',
  question: '',
  stages: [],
  durationMode: '30s',
  tone: 'professional',
  createdAt: '',
  isFavorite: false,
  keyPoints: [],
  supportingFacts: [],
  riskWarnings: [],
  immediateAnswer: ''
};

@Entry
@Component
struct LiveMeetingPage {
  private meetingService: MockMeetingService = new MockMeetingService();
  private transcriptService: ApiTranscriptService | undefined = undefined;
  private answerService: IAIAnswerService = new ApiAIAnswerService();
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  private loadTimer: number = 0;
  private isLoading: boolean = false;
  private transcriptTimer: number = 0;
  private answerTimer: number = 0;
  private answerRequestId: number = 0;
  @State meetingId: string = 'product-review';
  @State meeting: Meeting = EMPTY_MEETING;
  @State visibleTranscripts: TranscriptItem[] = [];
  @State pageState: PageLoadState = 'loading';
  @State errorText: string = '';
  @State transcriptionState: TranscriptionState = 'not_started';
  @State answerState: AnswerState = 'idle';
  @State answerErrorText: string = '';
  @State questionDetected: boolean = false;
  @State seconds: number = 0;
  @State answer: AnswerBundle = EMPTY_ANSWER;
  @State answerPartCount: number = 0;
  @State showPreview: boolean = false;
  @State showFloating: boolean = false;
  @State playbackText: string = '';
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    AuthService.ensureAuthenticated().then((authenticated: boolean): void => {
      if (!authenticated) {
        return;
      }
      const params = router.getParams() as PageParams;
      if (params && params.meetingId) { this.meetingId = params.meetingId; }
      this.loadLiveMeeting();
    });
  }

  aboutToDisappear(): void {
    if (this.transcriptService) {
      this.transcriptService.stopTranscription();
    }
    this.clearTimers();
    this.clearLoadTimer();
  }

  private clearTimers(): void {
    this.clearTranscriptTimer();
    if (this.answerTimer > 0) { clearInterval(this.answerTimer); this.answerTimer = 0; }
  }

  private clearTranscriptTimer(): void {
    if (this.transcriptTimer > 0) { clearInterval(this.transcriptTimer); this.transcriptTimer = 0; }
  }

  private clearLoadTimer(): void {
    if (this.loadTimer > 0) { clearTimeout(this.loadTimer); this.loadTimer = 0; }
  }

  private loadLiveMeeting(): void {
    if (this.isLoading) {
      return;
    }
    this.clearTimers();
    this.clearLoadTimer();
    this.isLoading = true;
    this.pageState = 'loading';
    this.errorText = '';
    this.visibleTranscripts = [];
    this.questionDetected = false;
    this.seconds = 0;
    this.answerState = 'idle';
    this.answerErrorText = '';
    this.answerPartCount = 0;
    this.showPreview = false;
    this.showFloating = false;
    this.transcriptionState = 'not_started';
    this.loadTimer = setTimeout((): void => {
      try {
        this.meeting = this.meetingService.getMeetingById(this.meetingId);
        this.transcriptService = this.createTranscriptService();
        this.pageState = 'success';
        this.visibleTranscripts = [];
        this.transcriptionState = this.transcriptService.getTranscriptionState();
      } catch (error) {
        this.errorText = I18n.t('transcriptionErrorDesc', this.language);
        this.pageState = 'error';
        this.transcriptionState = 'not_started';
      }
      this.isLoading = false;
      this.loadTimer = 0;
    }, 120);
  }

  private startTranscription(): void {
    if (this.pageState !== 'success' || this.transcriptionState === 'stopped') {
      return;
    }
    if (!this.transcriptService) {
      this.transcriptService = this.createTranscriptService();
    }
    this.transcriptService.startTranscription(this.meetingId);
    this.visibleTranscripts = this.transcriptService.getVisibleTranscripts();
    this.transcriptionState = 'transcribing';
    this.pageState = 'success';
    this.ensureTranscriptTimer();
  }

  private ensureTranscriptTimer(): void {
    if (this.transcriptTimer > 0 || this.transcriptionState !== 'transcribing') {
      return;
    }
    this.transcriptTimer = setInterval((): void => {
      if (!this.transcriptService || this.transcriptService.getTranscriptionState() !== 'transcribing') {
        this.clearTranscriptTimer();
        this.transcriptionState = this.transcriptService ? this.transcriptService.getTranscriptionState() : 'stopped';
        return;
      }
      this.seconds += 1;
    }, 1000);
  }

  private pause(): void {
    if (this.transcriptionState !== 'transcribing') {
      return;
    }
    if (!this.transcriptService) { return; }
    this.transcriptService.pauseTranscription();
    this.clearTranscriptTimer();
    this.transcriptionState = this.transcriptService.getTranscriptionState();
  }

  private resume(): void {
    if (this.transcriptionState !== 'paused') {
      return;
    }
    if (!this.transcriptService) { return; }
    this.transcriptService.resumeTranscription();
    this.transcriptionState = this.transcriptService.getTranscriptionState();
    this.ensureTranscriptTimer();
  }

  private stopTranscription(): void {
    if (this.transcriptionState === 'stopped') {
      return;
    }
    const transcriptService: ApiTranscriptService | undefined = this.transcriptService;
    if (transcriptService) {
      transcriptService.stopTranscription();
    }
    this.clearTimers();
    this.answerRequestId += 1;
    this.transcriptionState = transcriptService ? transcriptService.getTranscriptionState() : 'stopped';
    this.answerState = 'idle';
    this.answerErrorText = '';
    this.answerPartCount = 0;
    promptAction.showToast({ message: I18n.t('transcriptionStopped', this.language) });
  }

  private createTranscriptService(): ApiTranscriptService {
    const context = getContext(this) as common.UIAbilityContext;
    return new ApiTranscriptService(
      context,
      (): AppLanguage => this.language,
      (item: TranscriptItem): void => this.handleTranscriptItem(item),
      (message: string): void => this.handleTranscriptionError(message)
    );
  }

  private handleTranscriptItem(item: TranscriptItem): void {
    if (this.transcriptionState === 'stopped') {
      return;
    }
    this.visibleTranscripts = [...this.visibleTranscripts, item];
    if (item.isQuestion || item.content.indexOf('?') >= 0 || item.content.indexOf('？') >= 0) {
      this.questionDetected = true;
    }
    this.pageState = 'success';
  }

  private handleTranscriptionError(message: string): void {
    this.clearTranscriptTimer();
    this.errorText = message.length > 0 ? message : I18n.t('transcriptionErrorDesc', this.language);
    this.pageState = 'error';
    this.transcriptionState = 'stopped';
    promptAction.showToast({ message: I18n.t('transcriptionError', this.language) });
  }

  private generateAnswer(): void {
    if (this.answerState === 'generating' || (this.transcriptionState !== 'transcribing' && this.transcriptionState !== 'paused')) { return; }
    this.answerState = 'generating';
    this.answerErrorText = '';
    this.answerRequestId += 1;
    const requestId: number = this.answerRequestId;
    const preparation: MeetingPreparation = this.meetingService.getMeetingPreparation(this.meetingId);
    const documents: MeetingDocument[] = preparation.documents;
    this.answerService.generateAnswer({
      meetingId: this.meetingId,
      question: I18n.answerQuestion(this.language),
      context: {
        transcript: this.visibleTranscripts,
        meeting: this.meeting,
        documents: documents
      },
      duration: 30,
      tone: 'professional',
      language: this.language
    }).then((answer: AnswerBundle) => {
      if (requestId !== this.answerRequestId || this.transcriptionState === 'stopped') {
        return;
      }
      this.answer = answer;
      this.answerPartCount = 1;
      this.showPreview = false;
      const parts: string[] = I18n.answerStreamParts(answer, this.language);
      let index: number = 0;
      if (this.answerTimer > 0) {
        clearInterval(this.answerTimer);
        this.answerTimer = 0;
      }
      this.answerTimer = setInterval((): void => {
        if (requestId !== this.answerRequestId || this.transcriptionState === 'stopped') {
          clearInterval(this.answerTimer);
          this.answerTimer = 0;
          return;
        }
        if (index < parts.length - 1) {
          this.answerPartCount += 1;
          index += 1;
        } else {
          clearInterval(this.answerTimer);
          this.answerTimer = 0;
          this.answerState = 'ready';
          this.showPreview = true;
          this.showFloating = true;
          promptAction.showToast({ message: I18n.t('answerGenerated', this.language) });
        }
      }, 900);
    }).catch((error: Error): void => {
      if (requestId !== this.answerRequestId) {
        return;
      }
      this.answerState = 'idle';
      this.answerErrorText = error && error.message ? error.message : I18n.t('answerGenerateFailed', this.language);
      promptAction.showToast({ message: I18n.t('answerGenerateFailed', this.language) });
    });
  }

  private primaryTranscriptActionLabel(): string {
    if (this.transcriptionState === 'not_started') { return I18n.t('start', this.language); }
    if (this.transcriptionState === 'paused') { return I18n.t('resume', this.language); }
    if (this.transcriptionState === 'stopped') { return I18n.t('stopped', this.language); }
    return I18n.t('pause', this.language);
  }

  private transcriptionStateLabel(): string {
    return I18n.transcriptionState(this.transcriptionState, this.language);
  }

  private transcriptionStatusType(): string {
    if (this.transcriptionState === 'paused') { return 'warning'; }
    if (this.transcriptionState === 'stopped') { return 'error'; }
    return this.transcriptionState === 'transcribing' ? 'success' : 'normal';
  }

  private canUsePrimaryTranscriptAction(): boolean {
    return this.pageState === 'success' && this.transcriptionState !== 'stopped';
  }

  private canStopTranscription(): boolean {
    return this.pageState === 'success' && (this.transcriptionState === 'transcribing' || this.transcriptionState === 'paused');
  }

  private handlePrimaryTranscriptAction(): void {
    if (this.transcriptionState === 'not_started') { this.startTranscription(); return; }
    if (this.transcriptionState === 'transcribing') { this.pause(); return; }
    if (this.transcriptionState === 'paused') { this.resume(); }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Scroll() {
          Column() {
            TopTitleBar({ title: I18n.t('assistant', this.language), showBack: false })
            if (this.pageState === 'loading') {
              PageStateView({ state: 'loading', title: I18n.t('startingTranscription', this.language), description: I18n.t('startingTranscriptionDesc', this.language) }).margin({ top: 16 })
            } else if (this.pageState === 'error') {
              PageStateView({ state: 'error', title: I18n.t('transcriptionError', this.language), description: this.errorText, actionLabel: I18n.t('retry', this.language), actionEnabled: !this.isLoading, onAction: (): void => this.loadLiveMeeting() }).margin({ top: 16 })
            } else if (this.pageState === 'empty') {
              PageStateView({ state: 'empty', title: I18n.t('noTranscriptSource', this.language), description: I18n.t('noTranscriptSourceDesc', this.language), actionLabel: I18n.t('reload', this.language), actionEnabled: !this.isLoading, onAction: (): void => this.loadLiveMeeting() }).margin({ top: 16 })
            } else {
              Column() {
                Row() { StatusBadge({ label: this.transcriptionStateLabel(), type: this.transcriptionStatusType() }); StatusBadge({ label: `${this.seconds}s`, type: 'normal' }).margin({ left: 8 }) }.width('100%')
                Text(I18n.meetingTitle(this.meeting.id, this.meeting.title, this.language)).width('100%').margin({ top: 10 }).fontSize(15).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
              }.alignItems(HorizontalAlign.Start).width('100%').padding(14).margin({ top: 14 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
              Row() { Button(this.primaryTranscriptActionLabel()).layoutWeight(1).height(42).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(this.canUsePrimaryTranscriptAction()).onClick((): void => this.handlePrimaryTranscriptAction()); Button(I18n.t('stop', this.language)).layoutWeight(1).height(42).backgroundColor(AppTheme.errorSoft).fontColor(AppTheme.errorColor).enabled(this.canStopTranscription()).margin({ left: 10 }).onClick((): void => this.stopTranscription()) }.margin({ top: 12 }).width('100%')
              SectionHeader({ title: I18n.t('transcript', this.language) })
              ForEach(this.visibleTranscripts, (item: TranscriptItem) => { TranscriptBubble({ item: item, language: this.language }).margin({ bottom: 8 }) }, (item: TranscriptItem): string => item.id)
              if (this.questionDetected) { Text(I18n.t('questionDetected', this.language)).width('100%').padding(12).fontSize(12).fontColor(AppTheme.warningColor).backgroundColor(AppTheme.warningSoft).borderRadius(AppTheme.radiusMedium) }
              SectionHeader({ title: I18n.t('actions', this.language) })
              Button(I18n.t('helpMeAnswer', this.language)).width('100%').height(42).backgroundColor(AppTheme.accentColor).fontColor(AppTheme.primaryButtonText).enabled((this.transcriptionState === 'transcribing' || this.transcriptionState === 'paused') && this.answerState !== 'generating').onClick((): void => this.generateAnswer())
              if (this.answerErrorText.length > 0) {
                Column() {
                  Text(I18n.t('answerGenerateFailed', this.language)).width('100%').fontSize(13).fontWeight(FontWeight.Medium).fontColor(AppTheme.errorColor)
                  Text(this.answerErrorText).width('100%').margin({ top: 4 }).fontSize(12).fontColor(AppTheme.secondaryText).lineHeight(18)
                  Button(I18n.t('retry', this.language)).width('100%').height(38).margin({ top: 10 }).backgroundColor(AppTheme.errorSoft).fontColor(AppTheme.errorColor).enabled(this.answerState !== 'generating').onClick((): void => this.generateAnswer())
                }.width('100%').padding(12).margin({ top: 10 }).backgroundColor(AppTheme.cardBackground).border({ width: 1, color: AppTheme.errorSoft }).borderRadius(AppTheme.radiusMedium)
              }
              Button(I18n.t('showFloatingAnswer', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(this.transcriptionState !== 'stopped' && this.showPreview).onClick((): void => { this.showFloating = true; })
              if (this.answerPartCount > 0) { SectionHeader({ title: I18n.t('aiStream', this.language), subtitle: I18n.answerState(this.answerState, this.language) }); ForEach(I18n.answerStreamParts(this.answer, this.language).slice(0, this.answerPartCount), (part: string) => { Text(part).width('100%').padding(10).margin({ bottom: 7 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusSmall) }, (part: string): string => part) }
              if (this.showPreview) { AnswerPreviewCard({ answer: this.answer, language: this.language }).margin({ top: 12, bottom: 90 }) }
              if (this.playbackText.length > 0) { Text(this.playbackText).width('100%').margin({ bottom: 90 }).fontSize(12).fontColor(AppTheme.accentColor) }
            }
          }.padding({ left: 18, right: 18, top: 14, bottom: 86 })
        }.layoutWeight(1)
        BottomNavigationBar({ current: 'assistant', language: this.language })
      }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
      FloatingAnswerCard({ answer: this.answer, language: this.language, visible: $showFloating, onPlayback: (text: string): void => { this.playbackText = this.audioService.simulateEarphonePlayback(text); setTimeout((): void => { this.playbackText = ''; }, 2000); } }).margin({ bottom: 80 })
    }
  }
}
