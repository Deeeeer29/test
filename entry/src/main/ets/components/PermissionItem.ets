import { AppTheme } from '../common/theme/AppTheme';
import { StatusBadge } from './StatusBadge';

@Component
export struct PermissionItem {
  @Prop icon: string;
  @Prop title: string;
  @Prop reason: string;
  @Prop isEnabled: boolean;
  onToggle: (title: string) => void = (title: string): void => {};

  build() {
    Row() {
      Text(this.icon).fontSize(18).width(36)
      Column() {
        Text(this.title).fontSize(15).fontWeight(FontWeight.Medium).fontColor(AppTheme.primaryText)
        Text(this.reason).margin({ top: 4 }).fontSize(12).fontColor(AppTheme.secondaryText)
      }.alignItems(HorizontalAlign.Start).layoutWeight(1)
      StatusBadge({ label: this.isEnabled ? 'On' : 'Off', type: this.isEnabled ? 'success' : 'warning' })
      Toggle({ type: ToggleType.Switch, isOn: this.isEnabled }).margin({ left: 8 }).onChange((): void => this.onToggle(this.title))
    }
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
