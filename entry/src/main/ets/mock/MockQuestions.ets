import { PredictedQuestion } from '../model/PredictedQuestion';

export const mockQuestions: PredictedQuestion[] = [
  {
    id: 'q1',
    meetingId: 'product-review',
    question: 'Is the current project progress on track?',
    priority: 'high',
    category: 'Progress',
    preGeneratedAnswer: 'The project is on track, with current completion at 85%.'
  },
  {
    id: 'q2',
    meetingId: 'product-review',
    question: 'What is the biggest technical risk?',
    priority: 'high',
    category: 'Risk',
    preGeneratedAnswer: 'The main technical risks are third-party API integration and live transcription accuracy.'
  },
  {
    id: 'q3',
    meetingId: 'product-review',
    question: 'Does resource allocation need adjustment?',
    priority: 'medium',
    category: 'Resource'
  },
  {
    id: 'q4',
    meetingId: 'weekly-progress',
    question: 'What were the key updates this week?',
    priority: 'high',
    category: 'Progress',
    preGeneratedAnswer: 'Core pages, mock data flow, and basic UI interactions were completed this week.'
  },
  {
    id: 'q5',
    meetingId: 'architecture-discussion',
    question: 'Is the microservice split plan feasible?',
    priority: 'high',
    category: 'Technology'
  }
];
