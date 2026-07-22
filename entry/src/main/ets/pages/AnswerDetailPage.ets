import { promptAction, router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { SectionHeader } from '../components/SectionHeader';
import { StatusBadge } from '../components/StatusBadge';
import { mockAnswer } from '../mock/MockAnswers';
import { AnswerBundle, AnswerDurationMode, AnswerTone } from '../model/AnswerBundle';
import { SupportingFact } from '../model/SupportingFact';
import { MockAIAnswerService } from '../services/MockAIAnswerService';
import { MockAudioOutputService } from '../services/MockAudioOutputService';
import { MockStorageService } from '../services/MockStorageService';

@Entry
@Component
struct AnswerDetailPage {
  private answerService: MockAIAnswerService = new MockAIAnswerService();
  private audioService: MockAudioOutputService = new MockAudioOutputService();
  @State answer: AnswerBundle = mockAnswer;
  @State playbackText: string = '';

  private setDuration(duration: AnswerDurationMode): void { this.answer = this.answerService.changeAnswerDuration(this.answer, duration); }
  private setTone(tone: AnswerTone): void { this.answer = this.answerService.changeAnswerTone(this.answer, tone); }
  private play(): void { this.playbackText = this.audioService.simulateEarphonePlayback(this.answer.transitionSentence); setTimeout((): void => { this.playbackText = ''; }, 2000); }

  build() {
    Scroll() {
      Column() {
        Row() { Button('Back').height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text('Answer detail').layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
        SectionHeader({ title: 'Say now' })
        Text(this.answer.immediateAnswer).width('100%').padding(16).fontSize(18).lineHeight(28).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).backgroundColor('#162E2D').borderRadius(AppTheme.radiusMedium)
        SectionHeader({ title: 'Duration' })
        Row() { Button('15s').layoutWeight(1).height(36).onClick((): void => this.setDuration('15s')); Button('30s').layoutWeight(1).height(36).margin({ left: 8 }).onClick((): void => this.setDuration('30s')); Button('60s').layoutWeight(1).height(36).margin({ left: 8 }).onClick((): void => this.setDuration('60s')) }.width('100%')
        SectionHeader({ title: 'Tone' })
        Row() { Button('Short').layoutWeight(1).height(36).onClick((): void => this.setTone('short')); Button('Pro').layoutWeight(1).height(36).margin({ left: 8 }).onClick((): void => this.setTone('short')); Button('Soft').layoutWeight(1).height(36).margin({ left: 8 }).onClick((): void => this.setTone('short')); Button('Firm').layoutWeight(1).height(36).margin({ left: 8 }).onClick((): void => this.setTone('short')) }.width('100%')
        SectionHeader({ title: 'Key points' })
        ForEach(this.answer.keyPoints, (point: string) => { Text(`- ${point}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(14).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusSmall) }, (point: string): string => point)
        SectionHeader({ title: 'Supporting facts' })
        ForEach(this.answer.supportingFacts, (fact: SupportingFact) => { Row() { Text(fact.content).layoutWeight(1).fontSize(13).fontColor(AppTheme.primaryText); StatusBadge({ label: fact.verified ? 'Verified' : 'Check', type: fact.verified ? 'success' : 'warning' }) }.width('100%').padding(12).margin({ bottom: 8 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (fact: SupportingFact): string => fact.id)
        SectionHeader({ title: 'Risk' })
        Text(this.answer.riskWarnings[0]).width('100%').padding(12).fontSize(13).fontColor(AppTheme.warningColor).backgroundColor('#2B2517').borderRadius(AppTheme.radiusMedium)
        SectionHeader({ title: 'Actions' })
        Button('Mock earphone playback').width('100%').height(40).backgroundColor(AppTheme.accentColor).fontColor('#07110F').onClick((): void => this.play())
        Button('Regenerate').width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).onClick((): void => { this.answer = this.answerService.regenerateAnswer(this.answer.question); })
        Button('Favorite').width('100%').height(40).margin({ top: 8 }).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.primaryText).onClick((): void => { MockStorageService.saveFavorite(this.answer); promptAction.showToast({ message: 'Saved' }); })
        if (this.playbackText.length > 0) { Text(this.playbackText).width('100%').margin({ top: 12, bottom: 20 }).padding(10).fontSize(13).fontColor(AppTheme.accentColor).backgroundColor(AppTheme.accentSoft).borderRadius(AppTheme.radiusMedium) }
      }.padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
