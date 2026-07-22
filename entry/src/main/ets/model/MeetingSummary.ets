import { ActionItem } from './ActionItem';
import { AnswerBundle } from './AnswerBundle';

export interface MeetingSummary {
  id: string;
  meetingId: string;
  meetingTitle: string;
  date: string;
  startTime: string;
  endTime: string;
  duration: string;
  attendees: string[];
  conclusions: string[];
  decisions: string[];
  actionItems: ActionItem[];
  unresolvedQuestions: string[];
  aiAssistCount: number;
  answers: AnswerBundle[];
}
