import { AnswerStage, AnswerBundle } from '../model/AnswerBundle';
import { Meeting } from '../model/Meeting';
import { MeetingDocument } from '../model/MeetingDocument';
import { PredictedQuestion } from '../model/PredictedQuestion';
import { TranscriptItem } from '../model/TranscriptItem';
import { MeetingSummary } from '../model/MeetingSummary';

export interface IAIAnswerService {
  // 生成回答
  generateAnswer(params: {
    meetingId: string;
    question: string;
    context: {
      transcript?: TranscriptItem[];
      documents?: MeetingDocument[];
      meeting?: Meeting;
    };
    duration: 15 | 30 | 60;
    tone: 'concise' | 'professional' | 'polite' | 'assertive';
  }): AsyncGenerator<AnswerStage>;
  
  // 重新生成回答
  regenerateAnswer(answerId: string): AsyncGenerator<AnswerStage>;
  
  // 生成会议总结
  generateSummary(meetingId: string): Promise<MeetingSummary>;
  
  // 预测问题
  predictQuestions(meetingId: string): Promise<PredictedQuestion[]>;
}