import { AnswerBundle, AnswerDurationMode, AnswerTone } from '../model/AnswerBundle';
import { MeetingSummary } from '../model/MeetingSummary';

export type AIStreamState = 'idle' | 'preparing' | 'transitionReady' | 'keyPointsReady' | 'factsReady' | 'completed' | 'failed';

export interface AIAnswerService {
  generateAnswer(question: string): AnswerBundle;
  regenerateAnswer(question: string): AnswerBundle;
  changeAnswerDuration(answer: AnswerBundle, duration: AnswerDurationMode): AnswerBundle;
  changeAnswerTone(answer: AnswerBundle, tone: AnswerTone): AnswerBundle;
  generateMeetingSummary(meetingId: string): MeetingSummary;
}
