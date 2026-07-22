import { AnswerBundle } from '../model/AnswerBundle';
import { MeetingSummary } from '../model/MeetingSummary';
import { UserPreferences } from '../model/UserPreferences';

export interface StorageService {
  getPreferences(): UserPreferences;
  savePreferences(preferences: UserPreferences): void;
  getOnboardingStatus(): boolean;
  saveOnboardingStatus(completed: boolean): void;
  getFavorites(): AnswerBundle[];
  saveFavorite(answer: AnswerBundle): void;
  saveMeetingHistory(summary: MeetingSummary): void;
  getMeetingHistory(): MeetingSummary[];
}
