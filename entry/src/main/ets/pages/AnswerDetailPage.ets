import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { StatusBadge } from '../components/StatusBadge';
import { mockAnswer, mockAnswers } from '../mock/MockAnswers';
import { AnswerBundle, AnswerDurationMode, AnswerTone, AnswerToneOption } from '../model/AnswerBundle';
import { SupportingFact } from '../model/SupportingFact';
import { MockAIAnswerService } from '../services/MockAIAnswerService';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockStorageService } from '../services/MockStorageService';

interface PageParams {
  questionId?: string;
  from?: string;
}

@Entry
@Component
struct AnswerDetailPage {
  private answerService: MockAIAnswerService = new MockAIAnswerService();
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  private loadTimer: number = 0;
  private isLoading: boolean = false;
  private questionId: string = '';
  private from: string = '';
  private toneOptions: AnswerToneOption[] = [
    { label: 'concise', tone: 'concise' },
    { label: 'professional', tone: 'professional' },
    { label: 'polite', tone: 'polite' },
    { label: 'assertive', tone: 'assertive' }
  ];
  @State answer: AnswerBundle = mockAnswer;
  @State currentTone: AnswerTone = mockAnswer.tone;
  @State pageState: PageLoadState = 'loading';
  @State errorText: string = '';
  @State playbackText: string = '';
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    const params = router.getParams() as PageParams;
    if (params) {
      this.questionId = params.questionId || '';
      this.from = params.from || '';
    }
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
        let nextAnswer: AnswerBundle = mockAnswer;
        if (this.questionId.length > 0) {
          const foundAnswer: AnswerBundle | undefined = mockAnswers.find((answer: AnswerBundle): boolean => answer.id === this.questionId);
          if (foundAnswer) {
            nextAnswer = foundAnswer;
          }
        }
        if (isRegenerate) {
          nextAnswer = this.answerService.changeAnswerTone(nextAnswer, this.currentTone);
          nextAnswer = this.answerService.changeAnswerDuration(nextAnswer, this.answer.durationMode);
        }
        this.answer = nextAnswer;
        this.currentTone = nextAnswer.tone;
        const answerData: AnswerBundle = I18n.answer(nextAnswer, this.language);
        const contentCount: number = answerData.keyPoints.length + answerData.supportingFacts.length + answerData.riskWarnings.length;
        this.pageState = contentCount > 0 && answerData.immediateAnswer.length > 0 ? 'success' : 'empty';
        if (this.pageState === 'success' && isRegenerate) {
          promptAction.showToast({ message: I18n.t('answerRegenerated', this.language) });
        }
      } catch (error) {
        this.errorText = I18n.t('answerErrorDesc', this.language);
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
    this.playbackText = this.audioService.simulateEarphonePlayback(I18n.answer(this.answer, this.language).transitionSentence || '');
    setTimeout((): void => { this.playbackText = ''; }, 2000);
  }

  build() {
    Scroll() {
      Column() {
        Row() { Button(I18n.t('back', this.language)).height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text(I18n.t('answerDetail', this.language)).layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
        if (this.pageState === 'loading') {
          PageStateView({ state: 'loading', title: I18n.t('generatingAnswer', this.language), description: I18n.t('generatingAnswerDesc', this.language) }).margin({ top: 16 })
        } else if (this.pageState === 'error') {
          PageStateView({ state: 'error', title: I18n.t('answerError', this.language), description: this.errorText, actionLabel: I18n.t('retry', this.language), actionEnabled: !this.isLoading, onAction: (): void => this.loadAnswer(false) }).margin({ top: 16 })
        } else if (this.pageState === 'empty') {
          PageStateView({ state: 'empty', title: I18n.t('noAnswerContent', this.language), description: I18n.t('noAnswerContentDesc', this.language), actionLabel: I18n.t('backHome', this.language), onAction: (): void => { router.replaceUrl({ url: 'pages/Index' }, router.RouterMode.Single); } }).margin({ top: 16 })
        } else {
          SectionHeader({ title: I18n.t('sayNow', this.language) })
          Text(I18n.answer(this.answer, this.language).immediateAnswer).width('100%').padding(16).fontSize(18).lineHeight(28).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.accentSoft).borderRadius(AppTheme.radiusMedium)
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
                .fontColor(this.isCurrentTone(option.tone) ? AppTheme.primaryButtonText : AppTheme.secondaryText)
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
          Text(I18n.answer(this.answer, this.language).riskWarnings[0]).width('100%').padding(12).fontSize(13).fontColor(AppTheme.warningColor).backgroundColor(AppTheme.warningSoft).borderRadius(AppTheme.radiusMedium)
          SectionHeader({ title: I18n.t('actions', this.language) })
          Button(I18n.t('mockEarphonePlayback', this.language)).width('100%').height(40).backgroundColor(AppTheme.accentColor).fontColor(AppTheme.primaryButtonText).enabled(!this.isLoading).onClick((): void => this.play())
          Button(I18n.t('regenerate', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(!this.isLoading).onClick((): void => this.loadAnswer(true))
          Button(I18n.t('favorite', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(!this.isLoading).onClick((): void => { MockStorageService.saveFavorite(I18n.answer(this.answer, this.language)); promptAction.showToast({ message: I18n.t('saved', this.language) }); })
          if (this.playbackText.length > 0) { Text(this.playbackText).width('100%').margin({ top: 12, bottom: 20 }).padding(10).fontSize(13).fontColor(AppTheme.accentColor).backgroundColor(AppTheme.accentSoft).borderRadius(AppTheme.radiusMedium) }
        }
      }.padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
