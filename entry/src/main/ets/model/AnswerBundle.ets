import { SupportingFact } from './SupportingFact';

export type AnswerDurationMode = '15s' | '30s' | '60s';
export type AnswerTone = 'concise' | 'professional' | 'polite' | 'assertive';

export interface AnswerToneOption {
  label: string;
  tone: AnswerTone;
}

export interface AnswerStage {
  type: 'transition' | 'core_points' | 'supporting_data' | 'risk_reminder';
  content: string;
  generatedAt: string;
}

export interface AnswerBundle {
  id: string;
  meetingId: string;
  questionId?: string;
  transcriptItemId?: string;
  question: string;
  stages: AnswerStage[];
  durationMode: AnswerDurationMode;
  tone: AnswerTone;
  createdAt: string;
  isFavorite: boolean;
  keyPoints: string[];
  supportingFacts: SupportingFact[];
  riskWarnings: string[];
  immediateAnswer: string;
  transitionSentence?: string;
}
