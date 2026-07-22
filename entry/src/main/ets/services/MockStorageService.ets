import { AnswerBundle } from '../model/AnswerBundle';
import { MeetingSummary } from '../model/MeetingSummary';
import { UserPreferences } from '../model/UserPreferences';
import { mockSummary } from '../mock/MockSummaries';

const DEFAULT_PREFERENCES: UserPreferences = {
  saveTranscript: true,
  saveAudio: false,
  cloudAnalysis: true,
  localFirst: false,
  autoDeleteDays: 30,
  defaultAnswerDuration: '30s',
  defaultTone: 'pro',
  showSources: true,
  showRiskWarnings: true,
  autoShowFloatingCard: true,
  environmentMode: 'quiet'
};

export class MockStorageService {
  static getPreferences(): UserPreferences { const stored: UserPreferences | undefined = AppStorage.Get<UserPreferences>('preferences'); return stored || DEFAULT_PREFERENCES; }
  static savePreferences(preferences: UserPreferences): void { AppStorage.SetOrCreate<UserPreferences>('preferences', preferences); }
  static getOnboardingStatus(): boolean { const completed: boolean | undefined = AppStorage.Get<boolean>('onboardingCompleted'); return completed || false; }
  static saveOnboardingStatus(completed: boolean): void { AppStorage.SetOrCreate<boolean>('onboardingCompleted', completed); }
  static getFavorites(): AnswerBundle[] { const favorites: AnswerBundle[] | undefined = AppStorage.Get<AnswerBundle[]>('favorites'); return favorites || []; }
  static saveFavorite(answer: AnswerBundle): void { const favorites: AnswerBundle[] = MockStorageService.getFavorites(); favorites.push(answer); AppStorage.SetOrCreate<AnswerBundle[]>('favorites', favorites); }
  static saveMeetingHistory(summary: MeetingSummary): void { const history: MeetingSummary[] = MockStorageService.getMeetingHistory(); const exists: boolean = history.some((item: MeetingSummary): boolean => item.id === summary.id); if (!exists) { history.unshift(summary); } AppStorage.SetOrCreate<MeetingSummary[]>('meetingHistory', history); }
  static getMeetingHistory(): MeetingSummary[] { const history: MeetingSummary[] | undefined = AppStorage.Get<MeetingSummary[]>('meetingHistory'); return history || [mockSummary]; }
}
