import { ActionItem } from './ActionItem';
import { AnswerBundle } from './AnswerBundle';

export interface DecisionItem {
  item: string;
  owner: string;
  deadline?: string;
}

export interface TodoItem {
  task: string;
  assignee: string;
  priority: 'high' | 'medium' | 'low';
  status: 'pending' | 'in_progress' | 'completed';
}

export interface AIAssistedRecord {
  question: string;
  answer: string;
  timestamp: string;
}

export interface MeetingSummary {
  id: string;
  meetingId: string;
  meetingTitle?: string;
  date?: string;
  startTime?: string;
  endTime?: string;
  duration?: string;
  attendees?: string[];
  coreConclusions: string[];
  conclusions?: string[];
  decisions: DecisionItem[];
  todoItems: TodoItem[];
  pendingConfirmations: string[];
  aiAssistedRecords: AIAssistedRecord[];
  createdAt: string;
  answers?: AnswerBundle[];
  aiAssistCount?: number;
  actionItems?: ActionItem[];
}
