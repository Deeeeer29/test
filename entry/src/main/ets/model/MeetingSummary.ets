import { ActionItem } from './ActionItem';
import { AnswerBundle } from './AnswerBundle';

export interface MeetingSummary {
  id: string;
  meetingId: string;
  coreConclusions: string[];
  decisions: Array<{
    item: string;
    owner: string;
    deadline?: string;
  }>;
  todoItems: Array<{
    task: string;
    assignee: string;
    priority: 'high' | 'medium' | 'low';
    status: 'pending' | 'in_progress' | 'completed';
  }>;
  pendingConfirmations: string[];
  aiAssistedRecords: Array<{
    question: string;
    answer: string;
    timestamp: string;
  }>;
  createdAt: string;
}
