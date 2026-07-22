import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { StatusBadge } from '../components/StatusBadge';
import { mockAnswer } from '../mock/MockAnswers';
import { AnswerBundle, AnswerDurationMode, AnswerTone, AnswerToneOption } from '../model/AnswerBundle';
import { SupportingFact } from '../model/SupportingFact';
import { MockAIAnswerService } from '../services/MockAIAnswerService';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockStorageService } from '../services/MockStorageService';

@Entry
@Component
struct AnswerDetailPage {
  private answerService: MockAIAnswerService = new MockAIAnswerService();
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  private loadTimer: number = 0;
  private isLoading: boolean = false;
  private toneOptions: AnswerToneOption[] = [
    { label: '简洁', tone: '简洁' },
    { label: '专业', tone: '专业' },
    { label: '委婉', tone: '委婉' },
    { label: '强势', tone: '强势' }
  ];
  @State answer: AnswerBundle = mockAnswer;
  @State currentTone: AnswerTone = mockAnswer.tone;
  @State pageState: PageLoadState = 'loading';
  @State errorText: string = '';
  @State playbackText: string = '';
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    this.loadAnswer(false);
  }

  aboutToDisappear(): void {
    this.clearLoadTimer();
  }

  private clearLoadTimer(): void {
    if (this.loadTimer > 0) { clearTimeout(this.loadTimer); this.loadTimer = 0; }
  }

  private loadAnswer(isRegenerate: boolean): void {
    if (this.isLoading) {
      return;
    }
    this.clearLoadTimer();
    this.isLoading = true;
    this.pageState = 'loading';
    this.errorText = '';
    this.loadTimer = setTimeout((): void => {
      try {
        const nextAnswer: AnswerBundle = isRegenerate
          ? this.answerService.regenerateAnswer(I18n.answerQuestion(this.language), this.currentTone, this.answer.durationMode)
          : this.answerService.generateAnswer(I18n.answerQuestion(this.language), this.currentTone, this.answer.durationMode);
        this.answer = nextAnswer;
        this.currentTone = nextAnswer.tone;
        const contentCount: number = nextAnswer.keyPoints.length + nextAnswer.supportingFacts.length + nextAnswer.riskWarnings.length;
        this.pageState = contentCount > 0 && nextAnswer.immediateAnswer.length > 0 ? 'success' : 'empty';
        if (this.pageState === 'success' && isRegenerate) {
          promptAction.showToast({ message: 'Answer regenerated' });
        }
      } catch (error) {
        this.errorText = 'Failed to generate answer.';
        this.pageState = 'error';
      }
      this.isLoading = false;
      this.loadTimer = 0;
    }, 120);
  }

  private setDuration(duration: AnswerDurationMode): void {
    if (this.pageState !== 'success' || this.isLoading) {
      return;
    }
    this.answer = this.answerService.changeAnswerDuration(this.answer, duration);
    this.currentTone = this.answer.tone;
  }

  private changeTone(tone: AnswerTone): void {
    if (this.pageState !== 'success' || this.isLoading) {
      return;
    }
    if (this.currentTone === tone) {
      return;
    }
    this.answer = this.answerService.changeAnswerTone(this.answer, tone);
    this.currentTone = this.answer.tone;
  }

  private isCurrentTone(tone: AnswerTone): boolean { return this.currentTone === tone; }
  private play(): void {
    if (this.pageState !== 'success' || this.isLoading) {
      return;
    }
    this.playbackText = this.audioService.simulateEarphonePlayback(I18n.answer(this.answer, this.language).transitionSentence);
    setTimeout((): void => { this.playbackText = ''; }, 2000);
  }

  build() {
    Scroll() {
      Column() {
        Row() { Button(I18n.t('back', this.language)).height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text(I18n.t('answerDetail', this.language)).layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
        if (this.pageState === 'loading') {
          PageStateView({ state: 'loading', title: 'Generating answer', description: 'Preparing the latest mock answer.' }).margin({ top: 16 })
        } else if (this.pageState === 'error') {
          PageStateView({ state: 'error', title: 'Unable to generate answer', description: this.errorText, actionLabel: 'Retry', actionEnabled: !this.isLoading, onAction: (): void => this.loadAnswer(false) }).margin({ top: 16 })
        } else if (this.pageState === 'empty') {
          PageStateView({ state: 'empty', title: 'No answer content', description: 'The answer service returned no usable key points or supporting facts.', actionLabel: I18n.t('backHome', this.language), onAction: (): void => { router.replaceUrl({ url: 'pages/Index' }); } }).margin({ top: 16 })
        } else {
          SectionHeader({ title: I18n.t('sayNow', this.language) })
          Text(I18n.answer(this.answer, this.language).immediateAnswer).width('100%').padding(16).fontSize(18).lineHeight(28).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).backgroundColor('#162E2D').borderRadius(AppTheme.radiusMedium)
          SectionHeader({ title: I18n.t('duration', this.language) })
          Row() { Button('15s').layoutWeight(1).height(36).enabled(!this.isLoading).onClick((): void => this.setDuration('15s')); Button('30s').layoutWeight(1).height(36).enabled(!this.isLoading).margin({ left: 8 }).onClick((): void => this.setDuration('30s')); Button('60s').layoutWeight(1).height(36).enabled(!this.isLoading).margin({ left: 8 }).onClick((): void => this.setDuration('60s')) }.width('100%')
          SectionHeader({ title: I18n.t('tone', this.language) })
          Row() {
            ForEach(this.toneOptions, (option: AnswerToneOption, index: number) => {
              Button(I18n.toneLabel(option.tone, this.language))
                .layoutWeight(1)
                .height(36)
                .enabled(!this.isLoading)
                .margin({ left: index === 0 ? 0 : 8 })
                .backgroundColor(this.isCurrentTone(option.tone) ? AppTheme.accentColor : AppTheme.elevatedBackground)
                .fontColor(this.isCurrentTone(option.tone) ? '#07110F' : AppTheme.secondaryText)
                .fontWeight(this.isCurrentTone(option.tone) ? FontWeight.Bold : FontWeight.Regular)
                .border({ width: this.isCurrentTone(option.tone) ? 1 : 0, color: this.isCurrentTone(option.tone) ? AppTheme.accentColor : AppTheme.dividerColor })
                .onClick((): void => this.changeTone(option.tone))
            }, (option: AnswerToneOption): string => option.tone)
          }.width('100%')
          SectionHeader({ title: I18n.t('keyPointsSection', this.language) })
          ForEach(I18n.answer(this.answer, this.language).keyPoints, (point: string) => { Text(`- ${point}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(14).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusSmall) }, (point: string): string => point)
          SectionHeader({ title: I18n.t('supportingFacts', this.language) })
          ForEach(I18n.answer(this.answer, this.language).supportingFacts, (fact: SupportingFact) => { Row() { Text(fact.content).layoutWeight(1).fontSize(13).fontColor(AppTheme.primaryText); StatusBadge({ label: fact.verified ? I18n.t('verified', this.language) : I18n.t('check', this.language), type: fact.verified ? 'success' : 'warning' }) }.width('100%').padding(12).margin({ bottom: 8 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (fact: SupportingFact): string => fact.id)
          SectionHeader({ title: I18n.t('risk', this.language) })
          Text(I18n.answer(this.answer, this.language).riskWarnings[0]).width('100%').padding(12).fontSize(13).fontColor(AppTheme.warningColor).backgroundColor('#2B2517').borderRadius(AppTheme.radiusMedium)
          SectionHeader({ title: I18n.t('actions', this.language) })
          Button(I18n.t('mockEarphonePlayback', this.language)).width('100%').height(40).backgroundColor(AppTheme.accentColor).fontColor('#07110F').enabled(!this.isLoading).onClick((): void => this.play())
          Button(I18n.t('regenerate', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(!this.isLoading).onClick((): void => this.loadAnswer(true))
          Button(I18n.t('favorite', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(!this.isLoading).onClick((): void => { MockStorageService.saveFavorite(I18n.answer(this.answer, this.language)); promptAction.showToast({ message: I18n.t('saved', this.language) }); })
          if (this.playbackText.length > 0) { Text(this.playbackText).width('100%').margin({ top: 12, bottom: 20 }).padding(10).fontSize(13).fontColor(AppTheme.accentColor).backgroundColor(AppTheme.accentSoft).borderRadius(AppTheme.radiusMedium) }
        }
      }.padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
