import { router } from '@kit.ArkUI';
import { AppTheme } from '../common/theme/AppTheme';

@Component
export struct TopTitleBar {
  @Prop title: string = '';
  @Prop showBack: boolean = false;

  build() {
    Row() {
      if (this.showBack) {
        Button('<')
          .width(40)
          .height(40)
          .fontSize(20)
          .fontColor(AppTheme.primaryText)
          .backgroundColor(AppTheme.elevatedBackground)
          .borderRadius(20)
          .onClick((): void => { router.back(); })
      } else {
        Blank().width(40).height(40)
      }
      Text(this.title)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppTheme.primaryText)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Blank().width(40).height(40)
    }
    .width('100%')
    .height(44)
  }
}
