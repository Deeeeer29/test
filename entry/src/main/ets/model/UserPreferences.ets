import { AnswerDurationMode, AnswerTone } from './AnswerBundle';
import { AppLanguage } from '../common/i18n/I18n';

export type EnvironmentMode = 'quiet' | 'noisy' | 'presentation';

export interface UserPreferences {
  language: AppLanguage;
  privacy: {
    saveTranscript: boolean;
    saveAudio: boolean;
    cloudAnalysis: boolean;
    localFirst: boolean;
    autoDeletePeriod: 7 | 30 | 90 | 365;
  };
  answer: {
    defaultDuration: AnswerDurationMode;
    defaultTone: AnswerTone;
    autoGenerate: boolean;
    headphoneOutput: boolean;
  };
  environment: {
    mode: EnvironmentMode;
    autoSwitch: boolean;
  };
}
