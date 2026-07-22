import { AnswerBundle } from '../model/AnswerBundle';
import { MeetingSummary } from '../model/MeetingSummary';
import { UserPreferences } from '../model/UserPreferences';
import { AppLanguage } from '../common/i18n/I18n';

const DEFAULT_PREFERENCES: UserPreferences = {
  language: 'zh',
  saveTranscript: true,
  saveAudio: false,
  cloudAnalysis: true,
  localFirst: false,
  autoDeleteDays: 30,
  defaultAnswerDuration: '30s',
  defaultTone: '专业',
  showSources: true,
  showRiskWarnings: true,
  autoShowFloatingCard: true,
  environmentMode: 'quiet'
};

export class MockStorageService {
  static initializeLanguageStorage(): void {
    PersistentStorage.PersistProp<AppLanguage>('language', DEFAULT_PREFERENCES.language);
    const language: AppLanguage = MockStorageService.getLanguage();
    const preferences: UserPreferences = MockStorageService.getPreferences();
    preferences.language = language;
    MockStorageService.savePreferences(preferences);
  }

  static getPreferences(): UserPreferences {
    const stored: UserPreferences | undefined = AppStorage.Get<UserPreferences>('preferences');
    const language: AppLanguage | undefined = AppStorage.Get<AppLanguage>('language');
    if (stored) {
      return {
        language: language || stored.language,
        saveTranscript: stored.saveTranscript,
        saveAudio: stored.saveAudio,
        cloudAnalysis: stored.cloudAnalysis,
        localFirst: stored.localFirst,
        autoDeleteDays: stored.autoDeleteDays,
        defaultAnswerDuration: stored.defaultAnswerDuration,
        defaultTone: stored.defaultTone,
        showSources: stored.showSources,
        showRiskWarnings: stored.showRiskWarnings,
        autoShowFloatingCard: stored.autoShowFloatingCard,
        environmentMode: stored.environmentMode
      };
    }
    return MockStorageService.getDefaultPreferences(language || DEFAULT_PREFERENCES.language);
  }

  static savePreferences(preferences: UserPreferences): void {
    AppStorage.SetOrCreate<UserPreferences>('preferences', preferences);
    AppStorage.SetOrCreate<AppLanguage>('language', preferences.language);
  }

  static getLanguage(): AppLanguage {
    const stored: AppLanguage | undefined = AppStorage.Get<AppLanguage>('language');
    return stored || DEFAULT_PREFERENCES.language;
  }

  static saveLanguage(language: AppLanguage): void {
    const preferences: UserPreferences = MockStorageService.getPreferences();
    preferences.language = language;
    MockStorageService.savePreferences(preferences);
  }

  static getOnboardingStatus(): boolean { const completed: boolean | undefined = AppStorage.Get<boolean>('onboardingCompleted'); return completed || false; }
  static saveOnboardingStatus(completed: boolean): void { AppStorage.SetOrCreate<boolean>('onboardingCompleted', completed); }
  static getFavorites(): AnswerBundle[] { const favorites: AnswerBundle[] | undefined = AppStorage.Get<AnswerBundle[]>('favorites'); return favorites || []; }
  static saveFavorite(answer: AnswerBundle): void { const favorites: AnswerBundle[] = MockStorageService.getFavorites(); const nextFavorites: AnswerBundle[] = favorites.filter((item: AnswerBundle): boolean => item.id !== answer.id); nextFavorites.unshift(answer); AppStorage.SetOrCreate<AnswerBundle[]>('favorites', nextFavorites); }
  static saveMeetingHistory(summary: MeetingSummary): void { const history: MeetingSummary[] = MockStorageService.getMeetingHistory(); const exists: boolean = history.some((item: MeetingSummary): boolean => item.id === summary.id); if (!exists) { history.unshift(summary); } AppStorage.SetOrCreate<MeetingSummary[]>('meetingHistory', history); }
  static getMeetingHistory(): MeetingSummary[] { const history: MeetingSummary[] | undefined = AppStorage.Get<MeetingSummary[]>('meetingHistory'); return history || []; }

  private static getDefaultPreferences(language: AppLanguage): UserPreferences {
    return {
      language: language,
      saveTranscript: DEFAULT_PREFERENCES.saveTranscript,
      saveAudio: DEFAULT_PREFERENCES.saveAudio,
      cloudAnalysis: DEFAULT_PREFERENCES.cloudAnalysis,
      localFirst: DEFAULT_PREFERENCES.localFirst,
      autoDeleteDays: DEFAULT_PREFERENCES.autoDeleteDays,
      defaultAnswerDuration: DEFAULT_PREFERENCES.defaultAnswerDuration,
      defaultTone: DEFAULT_PREFERENCES.defaultTone,
      showSources: DEFAULT_PREFERENCES.showSources,
      showRiskWarnings: DEFAULT_PREFERENCES.showRiskWarnings,
      autoShowFloatingCard: DEFAULT_PREFERENCES.autoShowFloatingCard,
      environmentMode: DEFAULT_PREFERENCES.environmentMode
    };
  }
}
