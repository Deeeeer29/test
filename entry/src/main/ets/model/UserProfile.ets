export interface UserProfile {
  id: string;
  name: string;
  title: string;
  avatarPath: string;
  lastNameChangedAt: string;
  nextNameChangeAllowedAt: string;
  isLoggedIn: boolean;
}

export interface ProfileUpdateResult {
  success: boolean;
  profile: UserProfile;
  message: string;
}
