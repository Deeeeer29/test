import { MeetingSummary } from '../model/MeetingSummary';
import { mockAnswer } from './MockAnswers';

export const mockSummary: MeetingSummary = {
  id: 'summary-product-review',
  meetingId: 'product-review',
  meetingTitle: 'Product review',
  date: '2026-07-22',
  startTime: '09:30',
  endTime: '10:30',
  duration: '60 minutes',
  attendees: ['PM', 'Engineer', 'Designer', 'User'],
  coreConclusions: [
    'The first version focuses on a complete phone-side demo loop.',
    'Real integrations remain behind service boundaries and use mock data for V1.0.',
    'Meeting mode keeps microphone status visible and provides pause and stop controls.'
  ],
  conclusions: [
    'The first version focuses on a complete phone-side demo loop.',
    'Real integrations remain behind service boundaries and use mock data for V1.0.',
    'Meeting mode keeps microphone status visible and provides pause and stop controls.'
  ],
  decisions: [
    { item: 'Finish phone-side text prompts first.', owner: 'PM', deadline: '2026-07-24' },
    { item: 'Add real ASR in the next phase.', owner: 'Engineer', deadline: '2026-07-31' },
    { item: 'Keep earphone playback as a short mock prompt.', owner: 'Designer', deadline: '2026-07-25' }
  ],
  todoItems: [
    { task: 'Prepare ASR integration checklist.', assignee: 'Engineer', priority: 'high', status: 'pending' },
    { task: 'Add reliability labels for data sources.', assignee: 'Designer', priority: 'medium', status: 'pending' },
    { task: 'Prepare the first demo script.', assignee: 'User', priority: 'high', status: 'completed' }
  ],
  pendingConfirmations: [
    'Confirm SDK support for real earphone playback APIs.',
    'Confirm authorization scope for calendar and mail integration.'
  ],
  aiAssistedRecords: [
    {
      question: mockAnswer.question,
      answer: mockAnswer.immediateAnswer,
      timestamp: mockAnswer.createdAt
    }
  ],
  createdAt: '2026-07-22T10:30:00',
  answers: [mockAnswer],
  aiAssistCount: 2
};
