import { promptAction, router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { AppTheme } from '../common/theme/AppTheme';
import { BottomNavigationBar } from '../components/BottomNavigationBar';
import { TopTitleBar } from '../components/TopTitleBar';
import { ProfileUpdateResult, UserProfile } from '../model/UserProfile';
import { MockStorageService } from '../services/MockStorageService';
import { UserProfileService } from '../services/UserProfileService';

@Entry
@Component
struct MinePage {
  @State profile: UserProfile = UserProfileService.getLocalProfile();
  @State editing: boolean = false;
  @State draftName: string = '';
  @State draftAvatarPath: string = '';
  @StorageLink('language') language: AppLanguage = MockStorageService.getLanguage();

  aboutToAppear(): void {
    this.loadProfile();
  }

  private loadProfile(): void {
    UserProfileService.getProfile().then((profile: UserProfile): void => {
      this.profile = profile;
      this.draftName = profile.name;
      this.draftAvatarPath = profile.avatarPath;
    });
  }

  private openEditor(): void {
    this.draftName = this.profile.name;
    this.draftAvatarPath = this.profile.avatarPath;
    this.editing = true;
  }

  private canChangeName(): boolean {
    if (this.profile.nextNameChangeAllowedAt.length === 0) {
      return true;
    }
    return new Date(this.profile.nextNameChangeAllowedAt).getTime() <= Date.now();
  }

  private nextChangeDate(): string {
    if (this.profile.nextNameChangeAllowedAt.length === 0) {
      return I18n.t('availableNow', this.language);
    }
    return this.profile.nextNameChangeAllowedAt.substring(0, 10);
  }

  private saveProfile(): void {
    const normalizedName: string = this.draftName.trim();
    if (normalizedName.length === 0) {
      promptAction.showToast({ message: I18n.t('nameRequired', this.language) });
      return;
    }
    if (normalizedName !== this.profile.name && !this.canChangeName()) {
      promptAction.showToast({ message: `${I18n.t('nextNameChange', this.language)} ${this.nextChangeDate()}` });
      return;
    }
    if (this.draftAvatarPath !== this.profile.avatarPath) {
      UserProfileService.updateAvatar(this.draftAvatarPath).then((profile: UserProfile): void => {
        this.profile = profile;
      });
    }
    if (normalizedName !== this.profile.name) {
      UserProfileService.updateProfileName(normalizedName).then((result: ProfileUpdateResult): void => {
        this.profile = result.profile;
        if (result.success) {
          this.editing = false;
          promptAction.showToast({ message: I18n.t('profileSaved', this.language) });
        } else {
          promptAction.showToast({ message: `${I18n.t('nextNameChange', this.language)} ${result.message}` });
        }
      });
      return;
    }
    this.editing = false;
    promptAction.showToast({ message: I18n.t('profileSaved', this.language) });
  }

  private logout(): void {
    this.profile = UserProfileService.logout();
    promptAction.showToast({ message: I18n.t('loggedOut', this.language) });
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          TopTitleBar({ title: I18n.t('mine', this.language), showBack: false })
          Column() {
            Text(this.profile.name.substring(0, 1).toUpperCase())
              .width(72)
              .height(72)
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppTheme.primaryButtonText)
              .textAlign(TextAlign.Center)
              .backgroundColor(AppTheme.accentColor)
              .borderRadius(36)
            Text(this.profile.name).margin({ top: 12 }).fontSize(20).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
            Text(this.profile.title).margin({ top: 4 }).fontSize(13).fontColor(AppTheme.secondaryText)
            Text(I18n.t('editProfile', this.language)).margin({ top: 12 }).padding({ left: 14, right: 14, top: 6, bottom: 6 }).fontSize(13).fontColor(AppTheme.accentColor).backgroundColor(AppTheme.accentSoft).borderRadius(AppTheme.radiusMedium)
          }
          .width('100%')
          .padding(20)
          .margin({ top: 14 })
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(AppTheme.cardBackground)
          .borderRadius(AppTheme.radiusMedium)
          .onClick((): void => this.openEditor())
          if (this.editing) {
            Column() {
              Text(I18n.t('editProfile', this.language)).width('100%').fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
              TextInput({ placeholder: I18n.t('displayName', this.language), text: this.draftName }).margin({ top: 12 }).height(40).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).onChange((value: string): void => { this.draftName = value; })
              Text(`${I18n.t('nextNameChange', this.language)} ${this.nextChangeDate()}`).width('100%').margin({ top: 6 }).fontSize(12).fontColor(this.canChangeName() ? AppTheme.successColor : AppTheme.warningColor)
              TextInput({ placeholder: I18n.t('avatarPath', this.language), text: this.draftAvatarPath }).margin({ top: 10 }).height(40).fontColor(AppTheme.primaryText).backgroundColor(AppTheme.elevatedBackground).onChange((value: string): void => { this.draftAvatarPath = value; })
              Row() {
                Button(I18n.t('cancel', this.language)).layoutWeight(1).height(38).fontColor(AppTheme.secondaryText).backgroundColor(AppTheme.elevatedBackground).onClick((): void => { this.editing = false; })
                Button(I18n.t('save', this.language)).layoutWeight(1).height(38).margin({ left: 10 }).fontColor(AppTheme.primaryButtonText).backgroundColor(AppTheme.accentColor).onClick((): void => this.saveProfile())
              }.margin({ top: 12 }).width('100%')
            }.width('100%').padding(14).margin({ top: 12 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
          }
          Column() {
            this.MenuRow(I18n.t('editProfile', this.language), '>', (): void => this.openEditor())
            this.MenuRow(I18n.t('settings', this.language), '>', (): void => { router.pushUrl({ url: 'pages/SettingsPage' }, router.RouterMode.Single); })
            this.MenuRow(I18n.t('privacySecurity', this.language), '>', (): void => { promptAction.showDialog({ title: I18n.t('privacySecurity', this.language), message: I18n.t('privacySecurityDesc', this.language) }); })
            this.MenuRow(I18n.t('aboutUs', this.language), '>', (): void => { promptAction.showDialog({ title: I18n.t('aboutUs', this.language), message: I18n.t('aboutUsDesc', this.language) }); })
            this.MenuRow(I18n.t('logout', this.language), '', (): void => this.logout())
          }.width('100%').margin({ top: 12, bottom: 18 }).backgroundColor(AppTheme.cardBackground).borderRadius(AppTheme.radiusMedium)
        }.padding({ left: 18, right: 18, top: 14, bottom: 18 })
      }.layoutWeight(1)
      BottomNavigationBar({ current: 'mine', language: this.language })
    }.width('100%').height('100%').backgroundColor(AppTheme.pageBackground)
  }

  @Builder
  MenuRow(label: string, suffix: string, action: () => void) {
    Row() {
      Text(label).layoutWeight(1).fontSize(15).fontColor(label === I18n.t('logout', this.language) ? AppTheme.errorColor : AppTheme.primaryText)
      Text(suffix).fontSize(18).fontColor(AppTheme.mutedText)
    }
    .width('100%')
    .height(48)
    .padding({ left: 14, right: 14 })
    .border({ width: { bottom: 1 }, color: AppTheme.dividerColor })
    .onClick((): void => action())
  }
}
