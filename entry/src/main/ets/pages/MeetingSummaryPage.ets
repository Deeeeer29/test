import { promptAction, router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { SectionHeader } from '../components/SectionHeader';
import { ActionItem } from '../model/ActionItem';
import { MeetingSummary } from '../model/MeetingSummary';
import { MockAIAnswerService } from '../services/MockAIAnswerService';
import { MockMeetingService } from '../services/MockMeetingService';

@Entry
@Component
struct MeetingSummaryPage {
  private answerService: MockAIAnswerService = new MockAIAnswerService();
  private meetingService: MockMeetingService = new MockMeetingService();
  @State summary: MeetingSummary = this.answerService.generateMeetingSummary('product-review');
  @State saved: boolean = false;

  private save(): void { this.meetingService.saveMeetingSummary(this.summary); this.saved = true; promptAction.showToast({ message: 'Saved to mock history' }); }

  build() {
    Scroll() {
      Column() {
        Row() { Button('Back').height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text('Meeting summary').layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
        Text(`${this.summary.meetingTitle} / ${this.summary.date} / ${this.summary.duration} / AI ${this.summary.aiAssistCount}`).width('100%').padding(16).margin({ top: 16 }).fontSize(16).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        SectionHeader({ title: 'Conclusions' })
        ForEach(this.summary.conclusions, (item: string) => { Text(`- ${item}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (item: string): string => item)
        SectionHeader({ title: 'Decisions' })
        ForEach(this.summary.decisions, (item: string) => { Text(`- ${item}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (item: string): string => item)
        SectionHeader({ title: 'Action items' })
        ForEach(this.summary.actionItems, (item: ActionItem) => { Text(`${item.completed ? 'Done' : 'Todo'} / ${item.title} / ${item.owner} / ${item.deadline} / ${item.priority}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(item.completed ? AppTheme.successColor : AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (item: ActionItem): string => item.id)
        SectionHeader({ title: 'Unresolved' })
        ForEach(this.summary.unresolvedQuestions, (item: string) => { Text(`- ${item}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.warningColor).backgroundColor('#2B2517').borderRadius(AppTheme.radiusMedium) }, (item: string): string => item)
        Button(this.saved ? 'Saved' : 'Save summary').width('100%').height(42).margin({ top: 14 }).fontColor('#07110F').backgroundColor(AppTheme.accentColor).onClick((): void => this.save())
        Button('Mock export text').width('100%').height(42).margin({ top: 8 }).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).onClick((): void => { promptAction.showDialog({ title: 'Export', message: this.summary.conclusions.join('\n') }); })
        Button('Back home').width('100%').height(42).margin({ top: 8, bottom: 20 }).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).onClick((): void => { router.replaceUrl({ url: 'pages/Index' }); })
      }.padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
