import { AppTheme } from '../common/theme/AppTheme';
import { DeviceStatus } from '../model/DeviceStatus';
import { StatusBadge } from './StatusBadge';

@Component
export struct DeviceStatusBar {
  @Prop status: DeviceStatus;

  build() {
    Column() {
      Row() {
        StatusBadge({ label: 'Phone OK', type: this.status.phoneAvailable ? 'success' : 'error' })
        StatusBadge({ label: this.status.earphoneConnected ? 'Earphone OK' : 'Earphone Off', type: this.status.earphoneConnected ? 'success' : 'warning' }).margin({ left: 8 })
      }.width('100%')
      Row() {
        StatusBadge({ label: this.status.aiServiceAvailable ? 'AI OK' : 'AI Error', type: this.status.aiServiceAvailable ? 'success' : 'error' })
        StatusBadge({ label: this.status.microphoneActive ? 'Mic Active' : 'Mic Idle', type: this.status.microphoneActive ? 'warning' : 'normal' }).margin({ left: 8 })
      }.width('100%').margin({ top: 8 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
