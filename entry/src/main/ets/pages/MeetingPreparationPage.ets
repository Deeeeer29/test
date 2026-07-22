import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';
import { SectionHeader } from '../components/SectionHeader';
import { Meeting } from '../model/Meeting';
import { MeetingDocument } from '../model/MeetingDocument';
import { PredictedQuestion } from '../model/PredictedQuestion';
import { MeetingPreparation } from '../services/MeetingService';
import { MockMeetingService } from '../services/MockMeetingService';

interface PageParams { meetingId?: string; }

@Entry
@Component
struct MeetingPreparationPage {
  private meetingService: MockMeetingService = new MockMeetingService();
  @State meetingId: string = 'product-review';
  @State meeting: Meeting = this.meetingService.getMeetingById('product-review');
  @State preparation: MeetingPreparation = this.meetingService.getMeetingPreparation('product-review');

  aboutToAppear(): void {
    const params = router.getParams() as PageParams;
    if (params && params.meetingId) { this.meetingId = params.meetingId; this.meeting = this.meetingService.getMeetingById(this.meetingId); this.preparation = this.meetingService.getMeetingPreparation(this.meetingId); }
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() { Button('Back').height(34).backgroundColor(AppTheme.elevatedBackground).fontColor(AppTheme.secondaryText).onClick((): void => { router.back(); }); Text('Preparation').layoutWeight(1).textAlign(TextAlign.Center).fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText) }.width('100%')
          Text(this.meeting.title).width('100%').margin({ top: 16 }).padding(16).fontSize(22).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
          SectionHeader({ title: 'Background summary', subtitle: 'Mock data' })
          ForEach(this.preparation.backgroundSummary, (item: string) => { Text(`- ${item}`).width('100%').padding(10).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusSmall) }, (item: string): string => item)
          SectionHeader({ title: 'Key metrics' })
          ForEach(this.preparation.keyMetrics, (item: string) => { Text(item).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).borderRadius(AppTheme.radiusMedium) }, (item: string): string => item)
          SectionHeader({ title: 'Materials' })
          ForEach(this.preparation.documents, (doc: MeetingDocument) => { Text(`${doc.title} / ${doc.sourceName} / ${doc.updatedAt} / ${doc.summary}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium) }, (doc: MeetingDocument): string => doc.id)
          SectionHeader({ title: 'Predicted questions' })
          ForEach(this.preparation.questions, (question: PredictedQuestion) => { Text(`${question.priority}: ${question.content}`).width('100%').padding(12).margin({ bottom: 8 }).fontSize(13).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium).onClick((): void => { router.pushUrl({ url: 'pages/AnswerDetailPage', params: { questionId: question.id } }); }) }, (question: PredictedQuestion): string => question.id)
        }.padding(18)
      }.layoutWeight(1)
      Button('Enter meeting mode').width('100%').height(50).fontColor('#07110F').backgroundColor(AppTheme.accentColor).onClick((): void => { router.pushUrl({ url: 'pages/LiveMeetingPage', params: { meetingId: this.meetingId } }); })
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }
}
