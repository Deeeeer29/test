import { AnswerBundle } from '../model/AnswerBundle';
import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { MeetingSummary } from '../model/MeetingSummary';
import { UserPreferences } from '../model/UserPreferences';
import { UserProfile } from '../model/UserProfile';
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

const UI_PREF_NAME: string = 'meeting_assistant_ui';
const PREF_LANGUAGE_KEY: string = 'language';
const PREF_PREFERENCES_KEY: string = 'preferences';
const PREF_ONBOARDING_KEY: string = 'onboardingCompleted';

export class MockStorageService implements IStorageService {
  private static meetingHistory: MeetingSummary[] = [];
  private static favoriteAnswers: AnswerBundle[] = [];
  private static appContext: common.Context | undefined = undefined;

  static initializeLanguageStorage(context?: common.Context): void {
    if (context) {
      MockStorageService.appContext = context;
    }
    const storedLanguage: AppLanguage | undefined = AppStorage.Get<AppLanguage>('language');
    if (!storedLanguage) {
      AppStorage.SetOrCreate<AppLanguage>('language', DEFAULT_PREFERENCES.language);
    }
    const language: AppLanguage = MockStorageService.getLanguage();
    const preferences: UserPreferences = MockStorageService.getPreferences();
    preferences.language = language;
    MockStorageService.savePreferences(preferences);
    MockStorageService.restorePersistedState();
  }

  static async restorePersistedState(): Promise<void> {
    const prefs: preferences.Preferences | undefined = await MockStorageService.getPreferencesOrUndefined();
    if (!prefs) {
      return;
    }
    const languageText: string = await prefs.get(PREF_LANGUAGE_KEY, '') as string;
    if (languageText === 'zh' || languageText === 'en') {
      AppStorage.SetOrCreate<AppLanguage>('language', languageText);
    }
    const preferencesText: string = await prefs.get(PREF_PREFERENCES_KEY, '') as string;
    if (preferencesText.length > 0) {
      try {
        AppStorage.SetOrCreate<UserPreferences>('preferences', JSON.parse(preferencesText) as UserPreferences);
      } catch (error) {
      }
    }
    const completed: boolean = await prefs.get(PREF_ONBOARDING_KEY, false) as boolean;
    AppStorage.SetOrCreate<boolean>('onboardingCompleted', completed);
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
    MockStorageService.persistPreferences(preferences);
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
    MockStorageService.persistOnboardingStatus(completed);
  }

  static getFavorites(): AnswerBundle[] {
    const key: string = MockStorageService.userScopedKey('favoriteAnswers');
    const stored: AnswerBundle[] | undefined = AppStorage.Get<AnswerBundle[]>(key);
    const legacy: AnswerBundle[] | undefined = AppStorage.Get<AnswerBundle[]>('favoriteAnswers');
    return stored || legacy || [];
  }

  static saveFavorites(favorites: AnswerBundle[]): void {
    AppStorage.SetOrCreate<AnswerBundle[]>(MockStorageService.userScopedKey('favoriteAnswers'), favorites);
  }

  static saveFavorite(answer: AnswerBundle): void {
    const favorites: AnswerBundle[] = MockStorageService.getFavorites();
    const nextFavorites: AnswerBundle[] = favorites.filter((item: AnswerBundle): boolean => item.id !== answer.id);
    nextFavorites.unshift(answer);
    MockStorageService.saveFavorites(nextFavorites);
  }

  static getMeetingHistory(): MeetingSummary[] {
    const key: string = MockStorageService.userScopedKey('meetingHistory');
    const stored: MeetingSummary[] | undefined = AppStorage.Get<MeetingSummary[]>(key);
    const legacy: MeetingSummary[] | undefined = AppStorage.Get<MeetingSummary[]>('meetingHistory');
    return stored || legacy || [];
  }

  static saveMeetingHistory(history: MeetingSummary[]): void {
    AppStorage.SetOrCreate<MeetingSummary[]>(MockStorageService.userScopedKey('meetingHistory'), history);
  }

  private static userScopedKey(baseKey: string): string {
    const profile: UserProfile | undefined = AppStorage.Get<UserProfile>('userProfile');
    if (profile && profile.id.length > 0) {
      return `${baseKey}:${profile.id}`;
    }
    return `${baseKey}:anonymous`;
  }

  private static getDefaultPreferences(language: AppLanguage): UserPreferences {
    return {
      language: language,
      privacy: DEFAULT_PREFERENCES.privacy,
      answer: DEFAULT_PREFERENCES.answer,
      environment: DEFAULT_PREFERENCES.environment
    };
  }

  private static async getPreferencesOrUndefined(): Promise<preferences.Preferences | undefined> {
    if (!MockStorageService.appContext) {
      return undefined;
    }
    return preferences.getPreferences(MockStorageService.appContext, UI_PREF_NAME);
  }

  private static persistPreferences(userPreferences: UserPreferences): void {
    MockStorageService.getPreferencesOrUndefined()
      .then((prefs: preferences.Preferences | undefined): void => {
        if (!prefs) {
          return;
        }
        prefs.put(PREF_LANGUAGE_KEY, userPreferences.language);
        prefs.put(PREF_PREFERENCES_KEY, JSON.stringify(userPreferences));
        prefs.flush();
      })
      .catch((): void => {});
  }

  private static persistOnboardingStatus(completed: boolean): void {
    MockStorageService.getPreferencesOrUndefined()
      .then((prefs: preferences.Preferences | undefined): void => {
        if (!prefs) {
          return;
        }
        prefs.put(PREF_ONBOARDING_KEY, completed);
        prefs.flush();
      })
      .catch((): void => {});
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
