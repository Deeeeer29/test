import { PageLoadState } from '../common/state/PageLoadState';
import { AppTheme } from '../common/theme/AppTheme';

@Component
export struct PageStateView {
  @Prop state: PageLoadState = 'loading';
  @Prop title: string = '';
  @Prop description: string = '';
  @Prop actionLabel: string = '';
  @Prop actionEnabled: boolean = true;
  onAction: () => void = (): void => {};

  private marker(): string {
    if (this.state === 'loading') { return '...'; }
    if (this.state === 'error') { return '!'; }
    if (this.state === 'empty') { return '-'; }
    return '+';
  }

  private markerColor(): string {
    if (this.state === 'error') { return AppTheme.errorColor; }
    if (this.state === 'empty') { return AppTheme.mutedText; }
    if (this.state === 'success') { return AppTheme.successColor; }
    return AppTheme.accentColor;
  }

  build() {
    Column() {
      Text(this.marker()).fontSize(26).fontWeight(FontWeight.Bold).fontColor(this.markerColor())
      Text(this.title).margin({ top: 8 }).fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText).textAlign(TextAlign.Center)
      Text(this.description).margin({ top: 6 }).fontSize(12).fontColor(AppTheme.secondaryText).textAlign(TextAlign.Center).lineHeight(18)
      if (this.actionLabel.length > 0) {
        Button(this.actionLabel)
          .height(38)
          .margin({ top: 14 })
          .padding({ left: 18, right: 18 })
          .fontColor(AppTheme.primaryButtonText)
          .backgroundColor(AppTheme.accentColor)
          .enabled(this.actionEnabled)
          .onClick((): void => this.onAction())
      }
    }
    .width('100%')
    .padding(24)
    .backgroundColor(AppTheme.cardBackground)
    .borderRadius(AppTheme.radiusMedium)
  }
}
