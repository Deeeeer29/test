import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';
import { PageStateView } from '../components/PageStateView';
import { SectionHeader } from '../components/SectionHeader';
import { StatusBadge } from '../components/StatusBadge';
import { TopTitleBar } from '../components/TopTitleBar';
import { AnswerBundle, AnswerDurationMode, AnswerTone, AnswerToneOption } from '../model/AnswerBundle';
import { SupportingFact } from '../model/SupportingFact';
import { AuthService } from '../services/AuthService';
import { ApiAIAnswerService } from '../services/ApiAIAnswerService';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockStorageService } from '../services/MockStorageService';

interface PageParams {
  answerId?: string;
  answer?: AnswerBundle;
  questionId?: string;
  from?: string;
}

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
struct AnswerDetailPage {
  private answerService: ApiAIAnswerService = new ApiAIAnswerService();
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  private answerId: string = '';
  private routeAnswer: AnswerBundle | undefined = undefined;
  private from: string = '';
  private toneOptions: AnswerToneOption[] = [
    { label: 'concise', tone: 'concise' },
    { label: 'professional', tone: 'professional' },
    { label: 'polite', tone: 'polite' },
    { label: 'assertive', tone: 'assertive' }
  ];
  @State answer: AnswerBundle = EMPTY_ANSWER;
  @State currentTone: AnswerTone = EMPTY_ANSWER.tone;
  @State pageState: PageLoadState = 'loading';
  @State errorText: string = '';
  @State playbackText: string = '';
  @State isLoading: boolean = false;
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    AuthService.ensureAuthenticated().then((authenticated: boolean): void => {
      if (!authenticated) {
        return;
      }
      const params = router.getParams() as PageParams;
      if (params) {
        this.answerId = params.answerId || params.questionId || '';
        this.routeAnswer = params.answer;
        this.from = params.from || '';
      }
      this.loadAnswer(false);
    });
  }

  private async loadAnswer(isRegenerate: boolean): Promise<void> {
    if (this.isLoading) {
      return;
    }
    this.isLoading = true;
    this.errorText = '';
    if (!isRegenerate) {
      this.pageState = 'loading';
    }
    try {
      let nextAnswer: AnswerBundle;
      if (isRegenerate) {
        nextAnswer = await this.answerService.regenerateAnswer(
          this.answer.id,
          this.currentTone,
          this.answer.durationMode
        );
      } else if (this.routeAnswer) {
        nextAnswer = this.routeAnswer;
        this.routeAnswer = undefined;
      } else if (this.answerId.length > 0) {
        nextAnswer = await this.answerService.getAnswer(this.answerId);
      } else {
        this.answer = EMPTY_ANSWER;
        this.pageState = 'empty';
        return;
      }
      this.applyAnswer(nextAnswer);
      if (this.pageState === 'success' && isRegenerate) {
        promptAction.showToast({ message: I18n.t('answerRegenerated', this.language) });
      }
    } catch (error) {
      this.errorText = error instanceof Error && error.message.length > 0
        ? error.message
        : I18n.t('answerErrorDesc', this.language);
      if (this.answer.id.length === 0) {
        this.pageState = 'error';
      }
      promptAction.showToast({ message: I18n.t('answerGenerateFailed', this.language) });
    } finally {
      this.isLoading = false;
    }
  }

  private setDuration(duration: AnswerDurationMode): void {
    if (this.pageState !== 'success' || this.isLoading) {
      return;
    }
    if (this.answer.durationMode === duration) {
      return;
    }
    this.switchAnswer(this.currentTone, duration);
  }

  private changeTone(tone: AnswerTone): void {
    if (this.pageState !== 'success' || this.isLoading) {
      return;
    }
    if (this.currentTone === tone) {
      return;
    }
    this.switchAnswer(tone, this.answer.durationMode);
  }

  private isCurrentTone(tone: AnswerTone): boolean { return this.currentTone === tone; }

  private async switchAnswer(tone: AnswerTone, duration: AnswerDurationMode): Promise<void> {
    if (this.isLoading || this.answer.id.length === 0) {
      return;
    }
    this.isLoading = true;
    this.errorText = '';
    try {
      const nextAnswer: AnswerBundle =
        await this.answerService.regenerateAnswer(this.answer.id, tone, duration);
      this.applyAnswer(nextAnswer);
    } catch (error) {
      this.errorText = error instanceof Error && error.message.length > 0
        ? error.message
        : I18n.t('answerErrorDesc', this.language);
      promptAction.showToast({ message: I18n.t('answerGenerateFailed', this.language) });
    } finally {
      this.isLoading = false;
    }
  }

  private applyAnswer(nextAnswer: AnswerBundle): void {
    this.answer = nextAnswer;
    this.answerId = nextAnswer.id;
    this.currentTone = nextAnswer.tone;
    const answerData: AnswerBundle = I18n.answer(nextAnswer, this.language);
    const contentCount: number =
      answerData.keyPoints.length + answerData.supportingFacts.length + answerData.riskWarnings.length;
    this.pageState =
      contentCount > 0 && answerData.immediateAnswer.length > 0 ? 'success' : 'empty';
  }

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
        TopTitleBar({ title: I18n.t('answerDetail', this.language), showBack: true })
        if (this.pageState === 'loading') {
          PageStateView({ state: 'loading', title: I18n.t('generatingAnswer', this.language), description: I18n.t('generatingAnswerDesc', this.language) }).margin({ top: 16 })
        } else if (this.pageState === 'error') {
          PageStateView({ state: 'error', title: I18n.t('answerError', this.language), description: this.errorText, actionLabel: I18n.t('retry', this.language), actionEnabled: !this.isLoading, onAction: (): void => { this.loadAnswer(false); } }).margin({ top: 16 })
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
          if (this.errorText.length > 0) {
            Text(this.errorText).width('100%').margin({ top: 10 }).padding(10).fontSize(12).fontColor(AppTheme.errorColor).backgroundColor(AppTheme.errorSoft).borderRadius(AppTheme.radiusSmall)
          }
          SectionHeader({ title: I18n.t('keyPointsSection', this.language) })
          ForEach(I18n.answer(this.answer, this.language).keyPoints, (point: string) => { Text(`- ${point}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(14).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusSmall) }, (point: string): string => point)
          SectionHeader({ title: I18n.t('supportingFacts', this.language) })
          ForEach(I18n.answer(this.answer, this.language).supportingFacts, (fact: SupportingFact) => { Row() { Text(fact.content).layoutWeight(1).fontSize(13).fontColor(AppTheme.primaryText); StatusBadge({ label: fact.verified ? I18n.t('verified', this.language) : I18n.t('check', this.language), type: fact.verified ? 'success' : 'warning' }) }.width('100%').padding(12).margin({ bottom: 8 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (fact: SupportingFact): string => fact.id)
          SectionHeader({ title: I18n.t('risk', this.language) })
          Text(I18n.answer(this.answer, this.language).riskWarnings[0]).width('100%').padding(12).fontSize(13).fontColor(AppTheme.warningColor).backgroundColor(AppTheme.warningSoft).borderRadius(AppTheme.radiusMedium)
          SectionHeader({ title: I18n.t('actions', this.language) })
          Button(I18n.t('mockEarphonePlayback', this.language)).width('100%').height(40).backgroundColor(AppTheme.accentColor).fontColor(AppTheme.primaryButtonText).enabled(!this.isLoading).onClick((): void => this.play())
          Button(I18n.t('regenerate', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(!this.isLoading).onClick((): void => { this.loadAnswer(true); })
          Button(I18n.t('favorite', this.language)).width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).enabled(!this.isLoading).onClick((): void => { MockStorageService.saveFavorite(I18n.answer(this.answer, this.language)); promptAction.showToast({ message: I18n.t('saved', this.language) }); })
          if (this.playbackText.length > 0) { Text(this.playbackText).width('100%').margin({ top: 12, bottom: 20 }).padding(10).fontSize(13).fontColor(AppTheme.accentColor).backgroundColor(AppTheme.accentSoft).borderRadius(AppTheme.radiusMedium) }
        }
      }.padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
