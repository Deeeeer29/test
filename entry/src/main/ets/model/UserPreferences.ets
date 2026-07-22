import { AnswerDurationMode, AnswerTone } from './AnswerBundle';

export type EnvironmentMode = 'quiet' | 'noisy' | 'speech';

export interface UserPreferences {
  saveTranscript: boolean;
  saveAudio: boolean;
  cloudAnalysis: boolean;
  localFirst: boolean;
  autoDeleteDays: number;
  defaultAnswerDuration: AnswerDurationMode;
  defaultTone: AnswerTone;
  showSources: boolean;
  showRiskWarnings: boolean;
  autoShowFloatingCard: boolean;
  environmentMode: EnvironmentMode;
}
