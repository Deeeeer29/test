import { TranscriptItem } from '../model/TranscriptItem';

export const mockTranscripts: TranscriptItem[] = [
  { id: 't-1', meetingId: 'product-review', speaker: 'Manager Wang', content: 'Today we should confirm the V1 scope and the phone-side demo loop.', timestamp: '00:20', isQuestion: false, isMentioned: false, confidence: 0.92 },
  { id: 't-2', meetingId: 'product-review', speaker: 'Engineer Chen', content: 'Preparation, live transcript, and summary are split into service interfaces.', timestamp: '00:45', isQuestion: false, isMentioned: false, confidence: 0.89 },
  { id: 't-3', meetingId: 'product-review', speaker: 'Manager Wang', content: 'What stage is the overall development progress at?', timestamp: '01:10', isQuestion: true, isMentioned: true, confidence: 0.94 },
  { id: 't-4', meetingId: 'product-review', speaker: 'System', content: 'Question detected. Waiting for the user to generate an assisted answer.', timestamp: '01:12', isQuestion: false, isMentioned: true, confidence: 0.96 },
  { id: 't-5', meetingId: 'product-review', speaker: 'User', content: 'We are finishing the phone-side demo path first, then replacing mock services step by step.', timestamp: '01:45', isQuestion: false, isMentioned: false, confidence: 0.9 }
];
