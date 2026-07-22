import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { EmptyState } from '../components/EmptyState';
import { SectionHeader } from '../components/SectionHeader';
import { mockAnswer } from '../mock/MockAnswers';
import { MeetingSummary } from '../model/MeetingSummary';
import { MockMeetingService } from '../services/MockMeetingService';

@Entry
@Component
struct HistoryPage {
  private meetingService: MockMeetingService = new MockMeetingService();
  @State active: string = 'All';
  @State keyword: string = '';
  @State history: MeetingSummary[] = this.meetingService.getMeetingHistory();
  @State favorite: boolean = false;

  build() {
    Scroll() {
      Column() {
        Row() { Button('Back').height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text('History').layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
        Row() { Button('All').layoutWeight(1).height(34).onClick((): void => { this.active = 'All'; }); Button('Meetings').layoutWeight(1).height(34).margin({ left: 6 }).onClick((): void => { this.active = 'Meetings'; }); Button('Answers').layoutWeight(1).height(34).margin({ left: 6 }).onClick((): void => { this.active = 'Answers'; }) }.margin({ top: 16 }).width('100%')
        TextInput({ placeholder: 'Search meetings, questions, projects or people', text: this.keyword }).margin({ top: 12 }).height(42).fontColor(AppTheme.primaryText).placeholderColor(AppTheme.mutedText).backgroundColor(AppTheme.cardBackground).onChange((value: string): void => { this.keyword = value; })
        if (this.history.length === 0) { EmptyState({ title: 'No history', description: 'Save a summary first.' }).margin({ top: 16 }) }
        else {
          SectionHeader({ title: 'Meeting history' })
          ForEach(this.history, (summary: MeetingSummary) => { Text(`${summary.meetingTitle} / ${summary.date} / ${summary.duration} / ${summary.conclusions.length} conclusions / ${summary.actionItems.length} tasks`).width('100%').padding(14).margin({ bottom: 10 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium).onClick((): void => { router.pushUrl({ url: 'pages/MeetingSummaryPage', params: { meetingId: summary.meetingId } }); }) }, (summary: MeetingSummary): string => summary.id)
          SectionHeader({ title: 'Answer history' })
          Column() { Text(mockAnswer.question).width('100%').fontSize(15).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText); Text(`${mockAnswer.transitionSentence} / ${mockAnswer.durationMode} / ${mockAnswer.tone}`).width('100%').margin({ top: 8 }).fontSize(12).fontColor(AppTheme.secondaryText); Button(this.favorite ? 'Favorited' : 'Favorite').width('100%').height(34).margin({ top: 8 }).onClick((): void => { this.favorite = !this.favorite; }) }.alignItems(HorizontalAlign.Start).width('100%').padding(14).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium).onClick((): void => { router.pushUrl({ url: 'pages/AnswerDetailPage' }); })
        }
      }.padding(18)
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
