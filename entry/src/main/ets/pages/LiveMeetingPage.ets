import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { AnswerPreviewCard } from '../components/AnswerPreviewCard';
import { FloatingAnswerCard } from '../components/FloatingAnswerCard';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { StatusBadge } from '../components/StatusBadge';
import { TranscriptBubble } from '../components/TranscriptBubble';
import { mockAnswer } from '../mock/MockAnswers';
import { AnswerBundle } from '../model/AnswerBundle';
import { Meeting } from '../model/Meeting';
import { TranscriptItem } from '../model/TranscriptItem';
import { MockAIAnswerService } from '../services/MockAIAnswerService';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockMeetingService } from '../services/MockMeetingService';
import { MockStorageService } from '../services/MockStorageService';
import { MockTranscriptService } from '../services/MockTranscriptService';
import { ITranscriptService } from '../services/TranscriptService';

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

@Entry
@Component
struct LiveMeetingPage {
  private meetingService: MockMeetingService = new MockMeetingService();
  private transcriptService: MockTranscriptService = new MockTranscriptService();
  private answerService: MockAIAnswerService = new MockAIAnswerService();
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
  @State questionDetected: boolean = false;
  @State seconds: number = 0;
  @State answer: AnswerBundle = mockAnswer;
  @State answerPartCount: number = 0;
  @State showPreview: boolean = false;
  @State showFloating: boolean = false;
  @State playbackText: string = '';
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    const params = router.getParams() as PageParams;
    if (params && params.meetingId) { this.meetingId = params.meetingId; }
    this.loadLiveMeeting();
  }

  aboutToDisappear(): void {
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
    this.answerPartCount = 0;
    this.showPreview = false;
    this.showFloating = false;
    this.transcriptionState = 'not_started';
    this.loadTimer = setTimeout((): void => {
      try {
        this.meeting = this.meetingService.getMeetingById(this.meetingId);
        this.transcriptService = new MockTranscriptService();
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
    this.transcriptService.startTranscription(this.meetingId);
    this.visibleTranscripts = this.transcriptService.getVisibleTranscripts();
    this.transcriptionState = this.transcriptService.getTranscriptionState();
    if (this.visibleTranscripts.length === 0) {
      this.pageState = 'empty';
      return;
    }
    this.pageState = 'success';
    this.ensureTranscriptTimer();
  }

  private ensureTranscriptTimer(): void {
    if (this.transcriptTimer > 0 || this.transcriptionState !== 'transcribing') {
      return;
    }
    this.transcriptTimer = setInterval((): void => {
      if (this.transcriptService.getTranscriptionState() !== 'transcribing') {
        this.clearTranscriptTimer();
        this.transcriptionState = this.transcriptService.getTranscriptionState();
        return;
      }
      this.seconds += 2;
      const next: TranscriptItem | undefined = this.transcriptService.getNextTranscript();
      if (next) {
        this.visibleTranscripts = [...this.visibleTranscripts, next];
        if (next.isQuestion) { this.questionDetected = true; }
      }
      if (!this.transcriptService.hasMoreTranscripts()) {
        this.clearTranscriptTimer();
      }
    }, 1600);
  }

  private pause(): void {
    if (this.transcriptionState !== 'transcribing') {
      return;
    }
    this.transcriptService.pauseTranscription();
    this.clearTranscriptTimer();
    this.transcriptionState = this.transcriptService.getTranscriptionState();
  }

  private resume(): void {
    if (this.transcriptionState !== 'paused') {
      return;
    }
    this.transcriptService.resumeTranscription();
    this.transcriptionState = this.transcriptService.getTranscriptionState();
    this.ensureTranscriptTimer();
  }

  private stopTranscription(): void {
    if (this.transcriptionState === 'stopped') {
      return;
    }
    this.transcriptService.stopTranscription();
    this.clearTimers();
    this.answerRequestId += 1;
    this.transcriptionState = this.transcriptService.getTranscriptionState();
    this.answerState = 'idle';
    this.answerPartCount = 0;
    promptAction.showToast({ message: I18n.t('transcriptionStopped', this.language) });
  }

  private generateAnswer(): void {
    if (this.answerState === 'generating' || (this.transcriptionState !== 'transcribing' && this.transcriptionState !== 'paused')) { return; }
    this.answerState = 'generating';
    this.answerRequestId += 1;
    const requestId: number = this.answerRequestId;
    this.answerService.generateAnswer({
      meetingId: this.meetingId,
      question: I18n.answerQuestion(this.language),
      context: {
        transcript: this.visibleTranscripts,
        meeting: this.meeting
      },
      duration: 30,
      tone: 'professional'
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
    }).catch((): void => {
      if (requestId !== this.answerRequestId) {
        return;
      }
      this.answerState = 'idle';
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
            Row() { Button(I18n.t('back', this.language)).height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text(I18n.meetingTitle(this.meeting.id, this.meeting.title, this.language)).layoutWeight(1).textAlign(TextAlign.Center).fontSize(17).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
            if (this.pageState === 'loading') {
              PageStateView({ state: 'loading', title: I18n.t('startingTranscription', this.language), description: I18n.t('startingTranscriptionDesc', this.language) }).margin({ top: 16 })
            } else if (this.pageState === 'error') {
              PageStateView({ state: 'error', title: I18n.t('transcriptionError', this.language), description: this.errorText, actionLabel: I18n.t('retry', this.language), actionEnabled: !this.isLoading, onAction: (): void => this.loadLiveMeeting() }).margin({ top: 16 })
            } else if (this.pageState === 'empty') {
              PageStateView({ state: 'empty', title: I18n.t('noTranscriptSource', this.language), description: I18n.t('noTranscriptSourceDesc', this.language), actionLabel: I18n.t('reload', this.language), actionEnabled: !this.isLoading, onAction: (): void => this.loadLiveMeeting() }).margin({ top: 16 })
            } else {
              Column() {
                Row() { StatusBadge({ label: this.transcriptionStateLabel(), type: this.transcriptionStatusType() }); StatusBadge({ label: `${this.seconds}s`, type: 'normal' }).margin({ left: 8 }) }.width('100%')
                Text(I18n.t('meetingRunningStatus', this.language)).width('100%').margin({ top: 10 }).fontSize(13).fontColor(AppTheme.secondaryText)
              }.alignItems(HorizontalAlign.Start).width('100%').padding(14).margin({ top: 14 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
              Row() { Button(this.primaryTranscriptActionLabel()).layoutWeight(1).height(42).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(this.canUsePrimaryTranscriptAction()).onClick((): void => this.handlePrimaryTranscriptAction()); Button(I18n.t('stop', this.language)).layoutWeight(1).height(42).backgroundColor(AppTheme.errorSoft).fontColor(AppTheme.errorColor).enabled(this.canStopTranscription()).margin({ left: 10 }).onClick((): void => this.stopTranscription()) }.margin({ top: 12 }).width('100%')
              SectionHeader({ title: I18n.t('transcript', this.language), subtitle: I18n.t('transcriptSubtitle', this.language) })
              ForEach(this.visibleTranscripts, (item: TranscriptItem) => { TranscriptBubble({ item: item, language: this.language }).margin({ bottom: 8 }) }, (item: TranscriptItem): string => item.id)
              if (this.questionDetected) { Text(I18n.t('questionDetected', this.language)).width('100%').padding(12).fontSize(12).fontColor(AppTheme.warningColor).backgroundColor(AppTheme.warningSoft).borderRadius(AppTheme.radiusMedium) }
              SectionHeader({ title: I18n.t('actions', this.language) })
              Button(I18n.t('helpMeAnswer', this.language)).width('100%').height(42).backgroundColor(AppTheme.accentColor).fontColor(AppTheme.primaryButtonText).enabled((this.transcriptionState === 'transcribing' || this.transcriptionState === 'paused') && this.answerState !== 'generating').onClick((): void => this.generateAnswer())
              Button(I18n.t('showFloatingAnswer', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(this.transcriptionState !== 'stopped' && this.showPreview).onClick((): void => { this.showFloating = true; })
              if (this.answerPartCount > 0) { SectionHeader({ title: I18n.t('aiStream', this.language), subtitle: I18n.answerState(this.answerState, this.language) }); ForEach(I18n.answerStreamParts(this.answer, this.language).slice(0, this.answerPartCount), (part: string) => { Text(part).width('100%').padding(10).margin({ bottom: 7 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusSmall) }, (part: string): string => part) }
              if (this.showPreview) { AnswerPreviewCard({ answer: this.answer, language: this.language }).margin({ top: 12, bottom: 90 }) }
              if (this.playbackText.length > 0) { Text(this.playbackText).width('100%').margin({ bottom: 90 }).fontSize(12).fontColor(AppTheme.accentColor) }
            }
          }.padding(18)
        }
      }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
      FloatingAnswerCard({ answer: this.answer, language: this.language, visible: $showFloating, onPlayback: (text: string): void => { this.playbackText = this.audioService.simulateEarphonePlayback(text); setTimeout((): void => { this.playbackText = ''; }, 2000); } }).margin({ bottom: 18 })
    }
  }
}
