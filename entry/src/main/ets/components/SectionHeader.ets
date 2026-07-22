import { AppTheme } from '../common/theme/AppTheme';

@Component
export struct SectionHeader {
  @Prop title: string;
  @Prop subtitle: string = '';

  build() {
    Column() {
      Text(this.title).width('100%').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.primaryText)
      if (this.subtitle.length > 0) {
        Text(this.subtitle).width('100%').margin({ top: 4 }).fontSize(12).fontColor(AppTheme.secondaryText)
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 18, bottom: 8 })
  }
}
