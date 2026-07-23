import { ProfileUpdateResult, UserProfile } from '../model/UserProfile';
import { AuthService } from './AuthService';

export class UserProfileService {
  static getProfile(): Promise<UserProfile> {
    return AuthService.getProfile();
  }

  static updateProfileName(name: string): Promise<ProfileUpdateResult> {
    return AuthService.updateProfileName(name);
  }

  static updateAvatar(imageUri: string): Promise<UserProfile> {
    return AuthService.uploadAvatar(imageUri);
  }

  static logout(): Promise<void> {
    return AuthService.logout();
  }

  static getLocalProfile(): UserProfile {
    return AuthService.getLocalProfile();
  }
}
