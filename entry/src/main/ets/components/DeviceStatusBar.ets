import { AppTheme } from '../common/theme/AppTheme';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { DeviceStatus } from '../model/DeviceStatus';
import { StatusBadge } from './StatusBadge';

@Component
export struct DeviceStatusBar {
  @Prop status: DeviceStatus;
  @Prop language: AppLanguage = 'zh';

  build() {
    Column() {
      Row() {
        StatusBadge({ label: I18n.phoneStatus(this.status.phoneAvailable, this.language), type: this.status.phoneAvailable ? 'success' : 'error' })
        StatusBadge({ label: I18n.earphoneStatus(this.status.earphoneConnected, this.language), type: this.status.earphoneConnected ? 'success' : 'warning' }).margin({ left: 8 })
      }.width('100%')
      Row() {
        StatusBadge({ label: I18n.aiStatus(this.status.aiServiceAvailable, this.language), type: this.status.aiServiceAvailable ? 'success' : 'error' })
        StatusBadge({ label: I18n.micStatus(this.status.microphoneActive, this.language), type: this.status.microphoneActive ? 'warning' : 'normal' }).margin({ left: 8 })
      }.width('100%').margin({ top: 8 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
