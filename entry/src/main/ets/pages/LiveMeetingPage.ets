import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { AnswerPreviewCard } from '../components/AnswerPreviewCard';
import { FloatingAnswerCard } from '../components/FloatingAnswerCard';
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
import { MockTranscriptService } from '../services/MockTranscriptService';

type LiveState = 'listening' | 'paused' | 'question' | 'generating' | 'ready' | 'ended';
interface PageParams { meetingId?: string; }

@Entry
@Component
struct LiveMeetingPage {
  private meetingService: MockMeetingService = new MockMeetingService();
  private transcriptService: MockTranscriptService = new MockTranscriptService();
  private answerService: MockAIAnswerService = new MockAIAnswerService();
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  private transcriptTimer: number = 0;
  private answerTimer: number = 0;
  @State meeting: Meeting = this.meetingService.getMeetingById('product-review');
  @State allTranscripts: TranscriptItem[] = this.transcriptService.startMockTranscription();
  @State visibleTranscripts: TranscriptItem[] = [];
  @State liveState: LiveState = 'listening';
  @State seconds: number = 0;
  @State answer: AnswerBundle = mockAnswer;
  @State answerParts: string[] = [];
  @State showPreview: boolean = false;
  @State showFloating: boolean = false;
  @State playbackText: string = '';

  aboutToAppear(): void {
    const params = router.getParams() as PageParams;
    if (params && params.meetingId) { this.meeting = this.meetingService.getMeetingById(params.meetingId); }
    this.startTranscription();
  }

  aboutToDisappear(): void { this.clearTimers(); }

  private clearTimers(): void {
    if (this.transcriptTimer > 0) { clearInterval(this.transcriptTimer); this.transcriptTimer = 0; }
    if (this.answerTimer > 0) { clearInterval(this.answerTimer); this.answerTimer = 0; }
  }

  private startTranscription(): void {
    this.clearTimers();
    this.visibleTranscripts = [];
    this.liveState = 'listening';
    let index: number = 0;
    this.transcriptTimer = setInterval((): void => {
      this.seconds += 2;
      if (index < this.allTranscripts.length) {
        const next: TranscriptItem = this.allTranscripts[index];
        this.visibleTranscripts = [...this.visibleTranscripts, next];
        if (next.isQuestion) { this.liveState = 'question'; }
        index += 1;
      } else { clearInterval(this.transcriptTimer); }
    }, 1600);
  }

  private pause(): void { if (this.transcriptTimer > 0) { clearInterval(this.transcriptTimer); this.transcriptTimer = 0; } this.liveState = 'paused'; }
  private resume(): void { this.startTranscription(); }

  private generateAnswer(): void {
    if (this.liveState === 'generating') { return; }
    this.liveState = 'generating';
    this.answer = this.answerService.generateAnswer('What is the current development progress?');
    this.answerParts = ['Preparing answer'];
    this.showPreview = false;
    const parts: string[] = [this.answer.transitionSentence, this.answer.keyPoints[0], this.answer.keyPoints[1], this.answer.keyPoints[2], this.answer.supportingFacts[0].content, this.answer.riskWarnings[0]];
    let index: number = 0;
    if (this.answerTimer > 0) { clearInterval(this.answerTimer); }
    this.answerTimer = setInterval((): void => {
      if (index < parts.length) { this.answerParts = [...this.answerParts, parts[index]]; index += 1; }
      else { clearInterval(this.answerTimer); this.liveState = 'ready'; this.showPreview = true; this.showFloating = true; }
    }, 900);
  }

  private endMeeting(): void { this.clearTimers(); this.liveState = 'ended'; router.replaceUrl({ url: 'pages/MeetingSummaryPage', params: { meetingId: this.meeting.id } }); }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Scroll() {
          Column() {
            Row() { Button('Back').height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text(this.meeting.title).layoutWeight(1).textAlign(TextAlign.Center).fontSize(17).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
            Column() {
              Row() { StatusBadge({ label: this.liveState, type: this.liveState === 'question' ? 'warning' : 'success' }); StatusBadge({ label: `${this.seconds}s`, type: 'normal' }).margin({ left: 8 }) }.width('100%')
              Text('Meeting assistant running / microphone active / earphone mock ready / AI mock ready').width('100%').margin({ top: 10 }).fontSize(13).fontColor(AppTheme.secondaryText)
            }.alignItems(HorizontalAlign.Start).width('100%').padding(14).margin({ top: 14 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
            Row() { Button(this.liveState === 'paused' ? 'Resume' : 'Pause').layoutWeight(1).height(42).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).onClick((): void => { if (this.liveState === 'paused') { this.resume(); } else { this.pause(); } }); Button('End meeting').layoutWeight(1).height(42).backgroundColor('#3A2026').fontColor(AppTheme.errorColor).margin({ left: 10 }).onClick((): void => this.endMeeting()) }.margin({ top: 12 }).width('100%')
            SectionHeader({ title: 'Transcript', subtitle: 'Mock transcript appears step by step.' })
            ForEach(this.visibleTranscripts, (item: TranscriptItem) => { TranscriptBubble({ item: item }).margin({ bottom: 8 }) }, (item: TranscriptItem): string => item.id)
            if (this.liveState === 'question') { Text('Question detected. Waiting for user to request answer.').width('100%').padding(12).fontSize(12).fontColor(AppTheme.warningColor).backgroundColor('#2B2517').borderRadius(AppTheme.radiusMedium) }
            SectionHeader({ title: 'Actions' })
            Button('Help me answer').width('100%').height(42).backgroundColor(AppTheme.accentColor).fontColor('#07110F').onClick((): void => this.generateAnswer())
            Button('Show floating answer').width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).onClick((): void => { this.showFloating = true; })
            if (this.answerParts.length > 0) { SectionHeader({ title: 'AI stream', subtitle: this.liveState }); ForEach(this.answerParts, (part: string) => { Text(part).width('100%').padding(10).margin({ bottom: 7 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusSmall) }, (part: string): string => part) }
            if (this.showPreview) { AnswerPreviewCard({ answer: this.answer }).margin({ top: 12, bottom: 90 }) }
            if (this.playbackText.length > 0) { Text(this.playbackText).width('100%').margin({ bottom: 90 }).fontSize(12).fontColor(AppTheme.accentColor) }
          }.padding(18)
        }
      }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
      FloatingAnswerCard({ answer: this.answer, visible: $showFloating, onPlayback: (text: string): void => { this.playbackText = this.audioService.simulateEarphonePlayback(text); setTimeout((): void => { this.playbackText = ''; }, 2000); } }).margin({ bottom: 18 })
    }
  }
}
