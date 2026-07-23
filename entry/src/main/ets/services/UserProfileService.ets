import http from '@ohos.net.http';
import { UserProfile, ProfileUpdateResult } from '../model/UserProfile';

const PROFILE_API_BASE_URL: string = 'http://127.0.0.1:8787/api';
const DEFAULT_PROFILE: UserProfile = {
  id: 'local-user',
  name: 'User',
  title: 'Meeting Assistant User',
  avatarPath: '',
  lastNameChangedAt: '',
  nextNameChangeAllowedAt: '',
  isLoggedIn: true
};

export class UserProfileService {
  static getProfile(): Promise<UserProfile> {
    return new Promise<UserProfile>((resolve: (profile: UserProfile) => void): void => {
      UserProfileService.requestProfile()
        .then((profile: UserProfile): void => {
          UserProfileService.saveLocalProfile(profile);
          resolve(profile);
        })
        .catch((): void => {
          resolve(UserProfileService.getLocalProfile());
        });
    });
  }

  static updateProfileName(name: string): Promise<ProfileUpdateResult> {
    return new Promise<ProfileUpdateResult>((resolve: (result: ProfileUpdateResult) => void): void => {
      const profile: UserProfile = UserProfileService.getLocalProfile();
      const now: number = Date.now();
      const nextAllowed: number = UserProfileService.parseTime(profile.nextNameChangeAllowedAt);
      if (nextAllowed > now) {
        resolve({
          success: false,
          profile: profile,
          message: UserProfileService.formatNextAllowed(profile.nextNameChangeAllowedAt)
        });
        return;
      }
      UserProfileService.requestUpdateName(name)
        .then((nextProfile: UserProfile): void => {
          UserProfileService.saveLocalProfile(nextProfile);
          resolve({ success: true, profile: nextProfile, message: '' });
        })
        .catch((): void => {
          const nextLocal: UserProfile = UserProfileService.buildUpdatedProfile(profile, name, profile.avatarPath);
          UserProfileService.saveLocalProfile(nextLocal);
          resolve({ success: true, profile: nextLocal, message: '' });
        });
    });
  }

  static updateAvatar(avatarPath: string): Promise<UserProfile> {
    return new Promise<UserProfile>((resolve: (profile: UserProfile) => void): void => {
      const profile: UserProfile = UserProfileService.getLocalProfile();
      UserProfileService.requestUpdateAvatar(avatarPath)
        .then((nextProfile: UserProfile): void => {
          UserProfileService.saveLocalProfile(nextProfile);
          resolve(nextProfile);
        })
        .catch((): void => {
          const nextLocal: UserProfile = UserProfileService.buildUpdatedProfile(profile, profile.name, avatarPath);
          UserProfileService.saveLocalProfile(nextLocal);
          resolve(nextLocal);
        });
    });
  }

  static logout(): UserProfile {
    const profile: UserProfile = UserProfileService.getLocalProfile();
    const nextProfile: UserProfile = {
      id: profile.id,
      name: profile.name,
      title: profile.title,
      avatarPath: profile.avatarPath,
      lastNameChangedAt: profile.lastNameChangedAt,
      nextNameChangeAllowedAt: profile.nextNameChangeAllowedAt,
      isLoggedIn: false
    };
    UserProfileService.saveLocalProfile(nextProfile);
    return nextProfile;
  }

  static getLocalProfile(): UserProfile {
    const stored: UserProfile | undefined = AppStorage.Get<UserProfile>('userProfile');
    if (stored) {
      return stored;
    }
    return UserProfileService.copyProfile(DEFAULT_PROFILE);
  }

  private static saveLocalProfile(profile: UserProfile): void {
    AppStorage.SetOrCreate<UserProfile>('userProfile', profile);
  }

  private static buildUpdatedProfile(profile: UserProfile, name: string, avatarPath: string): UserProfile {
    const now: Date = new Date();
    const nextAllowed: Date = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);
    return {
      id: profile.id,
      name: name,
      title: profile.title,
      avatarPath: avatarPath,
      lastNameChangedAt: now.toISOString(),
      nextNameChangeAllowedAt: nextAllowed.toISOString(),
      isLoggedIn: profile.isLoggedIn
    };
  }

  private static copyProfile(profile: UserProfile): UserProfile {
    return {
      id: profile.id,
      name: profile.name,
      title: profile.title,
      avatarPath: profile.avatarPath,
      lastNameChangedAt: profile.lastNameChangedAt,
      nextNameChangeAllowedAt: profile.nextNameChangeAllowedAt,
      isLoggedIn: profile.isLoggedIn
    };
  }

  private static parseTime(value: string): number {
    if (value.length === 0) {
      return 0;
    }
    const timestamp: number = new Date(value).getTime();
    if (Number.isNaN(timestamp)) {
      return 0;
    }
    return timestamp;
  }

  private static formatNextAllowed(value: string): string {
    if (value.length === 0) {
      return '';
    }
    return value.substring(0, 10);
  }

  private static requestProfile(): Promise<UserProfile> {
    return UserProfileService.request('GET', '/profile', '');
  }

  private static requestUpdateName(name: string): Promise<UserProfile> {
    return UserProfileService.request('PUT', '/profile/name', JSON.stringify({ name: name }));
  }

  private static requestUpdateAvatar(avatarPath: string): Promise<UserProfile> {
    return UserProfileService.request('PUT', '/profile/avatar', JSON.stringify({ avatarPath: avatarPath }));
  }

  private static request(method: string, path: string, body: string): Promise<UserProfile> {
    return new Promise<UserProfile>((resolve: (profile: UserProfile) => void, reject: (reason?: Object) => void): void => {
      const request = http.createHttp();
      request.request(
        `${PROFILE_API_BASE_URL}${path}`,
        {
          method: method === 'GET' ? http.RequestMethod.GET : http.RequestMethod.PUT,
          header: { 'Content-Type': 'application/json' },
          extraData: body,
          connectTimeout: 3000,
          readTimeout: 3000
        },
        (error, data): void => {
          request.destroy();
          if (error) {
            reject(error);
            return;
          }
          try {
            const responseText: string = data.result.toString();
            const parsed = JSON.parse(responseText) as UserProfile;
            resolve(parsed);
          } catch (parseError) {
            reject(parseError as Object);
          }
        }
      );
    });
  }
}
