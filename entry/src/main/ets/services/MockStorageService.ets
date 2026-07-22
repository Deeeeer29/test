import { AnswerBundle } from '../model/AnswerBundle';
import { MeetingSummary } from '../model/MeetingSummary';
import { UserPreferences } from '../model/UserPreferences';
import { AppLanguage } from '../common/i18n/I18n';
import { IStorageService } from './StorageService';

const DEFAULT_PREFERENCES: UserPreferences = {
  language: 'zh',
  privacy: {
    saveTranscript: true,
    saveAudio: false,
    cloudAnalysis: true,
    localFirst: false,
    autoDeletePeriod: 30
  },
  answer: {
    defaultDuration: '30s',
    defaultTone: 'professional',
    autoGenerate: false,
    headphoneOutput: true
  },
  environment: {
    mode: 'quiet',
    autoSwitch: true
  }
};

export class MockStorageService implements IStorageService {
  private static meetingHistory: MeetingSummary[] = [];
  private static favoriteAnswers: AnswerBundle[] = [];

  static initializeLanguageStorage(): void {
    AppStorage.SetOrCreate<AppLanguage>('language', DEFAULT_PREFERENCES.language);
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
        language: language || stored.language || DEFAULT_PREFERENCES.language,
        privacy: stored.privacy || DEFAULT_PREFERENCES.privacy,
        answer: stored.answer || DEFAULT_PREFERENCES.answer,
        environment: stored.environment || DEFAULT_PREFERENCES.environment
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

  static getOnboardingStatus(): boolean {
    const completed: boolean | undefined = AppStorage.Get<boolean>('onboardingCompleted');
    return completed || false;
  }

  static saveOnboardingStatus(completed: boolean): void {
    AppStorage.SetOrCreate<boolean>('onboardingCompleted', completed);
  }

  static getFavorites(): AnswerBundle[] {
    const stored: AnswerBundle[] | undefined = AppStorage.Get<AnswerBundle[]>('favoriteAnswers');
    return stored || [];
  }

  static saveFavorites(favorites: AnswerBundle[]): void {
    AppStorage.SetOrCreate<AnswerBundle[]>('favoriteAnswers', favorites);
  }

  static saveFavorite(answer: AnswerBundle): void {
    const favorites: AnswerBundle[] = MockStorageService.getFavorites();
    const nextFavorites: AnswerBundle[] = favorites.filter((item: AnswerBundle): boolean => item.id !== answer.id);
    nextFavorites.unshift(answer);
    MockStorageService.saveFavorites(nextFavorites);
  }

  static getMeetingHistory(): MeetingSummary[] {
    const stored: MeetingSummary[] | undefined = AppStorage.Get<MeetingSummary[]>('meetingHistory');
    return stored || [];
  }

  static saveMeetingHistory(history: MeetingSummary[]): void {
    AppStorage.SetOrCreate<MeetingSummary[]>('meetingHistory', history);
  }

  private static getDefaultPreferences(language: AppLanguage): UserPreferences {
    return {
      language: language,
      privacy: DEFAULT_PREFERENCES.privacy,
      answer: DEFAULT_PREFERENCES.answer,
      environment: DEFAULT_PREFERENCES.environment
    };
  }

  async saveMeetingSummary(summary: MeetingSummary): Promise<void> {
    await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 300); });
    const history: MeetingSummary[] = MockStorageService.getMeetingHistory();
    history.unshift(summary);
    MockStorageService.saveMeetingHistory(history);
  }

  async getMeetingHistory(): Promise<MeetingSummary[]> {
    await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 200); });
    return MockStorageService.getMeetingHistory();
  }

  async saveUserPreferences(preferences: UserPreferences): Promise<void> {
    await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 250); });
    MockStorageService.savePreferences(preferences);
  }

  async getUserPreferences(): Promise<UserPreferences> {
    await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 150); });
    return MockStorageService.getPreferences();
  }

  async saveFavoriteAnswer(answer: AnswerBundle): Promise<void> {
    await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 200); });
    const favorites: AnswerBundle[] = MockStorageService.getFavorites();
    favorites.push(answer);
    MockStorageService.saveFavorites(favorites);
  }

  async getFavoriteAnswers(): Promise<AnswerBundle[]> {
    await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 180); });
    return MockStorageService.getFavorites();
  }

  async getOnboardingStatus(): Promise<boolean> {
    await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 100); });
    return MockStorageService.getOnboardingStatus();
  }

  async saveOnboardingStatus(completed: boolean): Promise<void> {
    await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 150); });
    MockStorageService.saveOnboardingStatus(completed);
  }
}
