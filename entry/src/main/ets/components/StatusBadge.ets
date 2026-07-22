import { AppTheme } from '../common/theme/AppTheme';

@Component
export struct StatusBadge {
  @Prop label: string;
  @Prop type: string = 'normal';

  private color(): string {
    if (this.type === 'success') { return AppTheme.successColor; }
    if (this.type === 'warning') { return AppTheme.warningColor; }
    if (this.type === 'error') { return AppTheme.errorColor; }
    return AppTheme.accentColor;
  }

  private badgeBackground(): string {
    if (this.type === 'success') { return AppTheme.successSoft; }
    if (this.type === 'warning') { return AppTheme.warningSoft; }
    if (this.type === 'error') { return AppTheme.errorSoft; }
    return AppTheme.accentSoft;
  }

  build() {
    Row() {
      Blank().width(7).height(7).backgroundColor(this.color()).borderRadius(4)
      Text(this.label).fontSize(12).fontColor(this.color()).margin({ left: 6 })
    }
    .padding({ left: 9, right: 9, top: 5, bottom: 5 })
    .backgroundColor(this.badgeBackground())
    .borderRadius(AppTheme.radiusSmall)
  }
}
