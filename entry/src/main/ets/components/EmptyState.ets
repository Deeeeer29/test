import { AppTheme } from '../common/theme/AppTheme';

@Component
export struct EmptyState {
  @Prop title: string = 'No data';
  @Prop description: string = 'Nothing to show yet';

  build() {
    Column() {
      Text('-').fontSize(28).fontColor(AppTheme.mutedText)
      Text(this.title).margin({ top: 8 }).fontSize(16).fontColor(AppTheme.primaryText)
      Text(this.description).margin({ top: 6 }).fontSize(12).fontColor(AppTheme.secondaryText)
    }
    .width('100%')
    .padding(24)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
