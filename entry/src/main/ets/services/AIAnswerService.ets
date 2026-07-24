import { AnswerStage, AnswerBundle, AnswerDurationMode, AnswerTone } from '../model/AnswerBundle';
import { AppLanguage } from '../common/i18n/I18n';
import { Meeting } from '../model/Meeting';
import { MeetingDocument } from '../model/MeetingDocument';
import { PredictedQuestion } from '../model/PredictedQuestion';
import { TranscriptItem } from '../model/TranscriptItem';
import { MeetingSummary } from '../model/MeetingSummary';

export interface AnswerGenerationContext {
  transcript?: TranscriptItem[];
  documents?: MeetingDocument[];
  meeting?: Meeting;
}

export interface AnswerGenerationParams {
  meetingId: string;
  question: string;
  context: AnswerGenerationContext;
  duration: 15 | 30 | 60;
  tone: AnswerTone;
  language?: AppLanguage;
}

export interface IAIAnswerService {
  // 生成回答
  generateAnswer(params: AnswerGenerationParams): Promise<AnswerBundle>;
  
  // 重新生成回答
  regenerateAnswer(answerId: string, tone?: AnswerTone, duration?: AnswerDurationMode): Promise<AnswerBundle>;
  
  // 修改回答时长
  changeAnswerDuration(answer: AnswerBundle, duration: AnswerDurationMode): AnswerBundle;
  
  // 修改回答语气
  changeAnswerTone(answer: AnswerBundle, tone: AnswerTone): AnswerBundle;
  
  // 生成会议总结
  generateSummary(meetingId: string): Promise<MeetingSummary>;
  
  // 预测问题
  predictQuestions(meetingId: string): Promise<PredictedQuestion[]>;
}
