import { AnswerDurationMode, AnswerTone } from './AnswerBundle';
import { AppLanguage } from '../common/i18n/I18n';

export type EnvironmentMode = 'quiet' | 'noisy' | 'presentation';

export interface PrivacySettings {
  saveTranscript: boolean;
  saveAudio: boolean;
  cloudAnalysis: boolean;
  localFirst: boolean;
  autoDeletePeriod: 7 | 30 | 90 | 365;
}

export interface AnswerSettings {
  defaultDuration: AnswerDurationMode;
  defaultTone: AnswerTone;
  autoGenerate: boolean;
  headphoneOutput: boolean;
}

export interface EnvironmentSettings {
  mode: EnvironmentMode;
  autoSwitch: boolean;
}

export interface UserPreferences {
  language: AppLanguage;
  privacy: PrivacySettings;
  answer: AnswerSettings;
  environment: EnvironmentSettings;
}
