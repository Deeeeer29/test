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
        StatusBadge({ label: I18n.phoneStatus(this.status.phone.isAvailable, this.language), type: this.status.phone.isAvailable ? 'success' : 'error' })
        StatusBadge({ label: I18n.micStatus(this.status.phone.microphonePermission, this.language), type: this.status.phone.microphonePermission ? 'success' : 'warning' }).margin({ left: 8 })
      }.width('100%')
      Row() {
        StatusBadge({ label: I18n.earphoneStatus(this.status.headphone.isConnected, this.language), type: this.status.headphone.isConnected ? 'success' : 'warning' })
        StatusBadge({ label: I18n.aiStatus(this.status.aiService.isAvailable, this.language), type: this.status.aiService.isAvailable ? 'success' : 'error' }).margin({ left: 8 })
      }.width('100%').margin({ top: 8 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
