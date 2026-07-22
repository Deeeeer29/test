import { SupportingFact } from './SupportingFact';

export type AnswerDurationMode = '15s' | '30s' | '60s';
export type AnswerTone = 'short' | 'pro' | 'soft' | 'firm';

export interface AnswerBundle {
  id: string;
  question: string;
  transitionSentence: string;
  immediateAnswer: string;
  keyPoints: string[];
  supportingFacts: SupportingFact[];
  riskWarnings: string[];
  durationMode: AnswerDurationMode;
  tone: AnswerTone;
  createdAt: string;
  isFavorite: boolean;
}
