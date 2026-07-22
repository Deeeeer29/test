import { AnswerBundle } from '../model/AnswerBundle';

export const mockAnswer: AnswerBundle = {
  id: 'answer-main',
  question: 'What is the current development progress?',
  transitionSentence: 'Answer from three angles: closed loop, service seams, and risk control.',
  immediateAnswer: 'We are prioritizing a complete phone-side MVP loop first, then replacing mock ASR and LLM services step by step.',
  keyPoints: [
    'Phone side owns preparation, live transcript, answer detail, and summary views.',
    'AI answer generation is mocked as a stream now and can be replaced by a real LLM service later.',
    'Earphone output is a low-interruption short prompt and is mocked in this version.'
  ],
  supportingFacts: [
    { id: 'f-1', content: 'The first version scope is limited to a phone-side demo loop.', source: 'Mock product scope', updatedAt: 'Today 08:20', confidence: 'High', verified: true },
    { id: 'f-2', content: 'Real ASR, LLM, calendar, mail, and audio routing are reserved behind services.', source: 'Mock tech list', updatedAt: 'Today 09:05', confidence: 'Medium', verified: false }
  ],
  riskWarnings: ['Delay and confidence data are mock values and need validation before external reporting.'],
  durationMode: '30s',
  tone: '专业',
  createdAt: 'Just now',
  isFavorite: false
};
