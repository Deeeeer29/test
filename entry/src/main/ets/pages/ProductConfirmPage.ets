/**
 * ProductConfirmPage — 商品确认页
 * Reference: stitch_reference/_2/code.html
 * NO BottomNavBar (transactional flow page)
 */
import { C, Shadow, Font, BW, FlowProduct } from '../common/Theme';

@Component
export struct ProductConfirmPage {
  @Prop productName: string = '无线降噪耳机';
  @Prop productBrand: string = '示例型号 X1';
  @Prop productPrice: string = '¥1,899';
  @Prop productCategory: string = '数码产品';
  @Prop productParams: string = '主动降噪、蓝牙连接、约 30 小时续航';
  onConfirm: (p: FlowProduct) => void = (_p: FlowProduct) => {};
  onBack: () => void = () => {};

  @State editName: string = '';
  @State editBrand: string = '';
  @State editPrice: string = '';
  @State editCategory: string = '';
  @State editParams: string = '';

  aboutToAppear(): void {
    this.editName = this.productName;
    this.editBrand = this.productBrand;
    this.editPrice = this.productPrice;
    this.editCategory = this.productCategory;
    this.editParams = this.productParams;
  }

  build() {
    Column() {
      // Headline (teal highlight)
      Text('先确认一下，\n别劝错东西了。')
        .fontSize(Font.headlineLg.size)
        .fontWeight(Font.headlineLg.weight)
        .fontColor(C.onBackground)
        .lineHeight(36)
        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .backgroundColor(C.tertiaryContainer)
        .border(BW.full)
        .shadow(Shadow.hardSm)
        .rotate({ angle: -1 })
        .width('100%')
        .margin({ left: 20, top: 24, bottom: 16 })

      // Product Card (Polaroid style)
      Stack({ alignContent: Alignment.TopEnd }) {
        Column() {
          // Product image placeholder
          Column() {
            Text('📦')
              .fontSize(64)
          }
          .width('100%')
          .aspectRatio(1)
          .backgroundColor(C.surfaceVariant)
          .border(BW.full)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          // Edit form
          Column() {
            // Name
            Column() {
              Text('名称')
                .fontSize(Font.labelCaps.size)
                .fontWeight(Font.labelCaps.weight)
                .fontColor(C.outline)
                .margin({ bottom: 4 })
              TextInput({ text: this.editName })
                .fontSize(Font.bodyMd.size)
                .fontColor(C.onBackground)
                .backgroundColor(Color.Transparent)
                .border({ width: { bottom: '2vp' }, color: C.onBackground })
                .padding({ bottom: 4 })
                .width('100%')
                .onChange((v: string) => { this.editName = v })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 12 })

            // Brand + Price row
            Row() {
              Column() {
                Text('品牌型号')
                  .fontSize(Font.labelCaps.size)
                  .fontWeight(Font.labelCaps.weight)
                  .fontColor(C.outline)
                  .margin({ bottom: 4 })
                TextInput({ text: this.editBrand })
                  .fontSize(Font.bodyMd.size)
                  .fontColor(C.onBackground)
                  .backgroundColor(Color.Transparent)
                  .border({ width: { bottom: '2vp' }, color: C.onBackground })
                  .padding({ bottom: 4 })
                  .width('100%')
                  .onChange((v: string) => { this.editBrand = v })
              }
              .alignItems(HorizontalAlign.Start)
              .width('48%')

              Column() {
                Text('价格')
                  .fontSize(Font.labelCaps.size)
                  .fontWeight(Font.labelCaps.weight)
                  .fontColor(C.outline)
                  .margin({ bottom: 4 })
                TextInput({ text: this.editPrice })
                  .fontSize(Font.bodyMd.size)
                  .fontColor(C.onBackground)
                  .backgroundColor(Color.Transparent)
                  .border({ width: { bottom: '2vp' }, color: C.onBackground })
                  .padding({ bottom: 4 })
                  .width('100%')
                  .onChange((v: string) => { this.editPrice = v })
              }
              .alignItems(HorizontalAlign.Start)
              .width('48%')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            // Category
            Column() {
              Text('分类')
                .fontSize(Font.labelCaps.size)
                .fontWeight(Font.labelCaps.weight)
                .fontColor(C.outline)
                .margin({ bottom: 4 })
              TextInput({ text: this.editCategory })
                .fontSize(Font.bodyMd.size)
                .fontColor(C.onBackground)
                .backgroundColor(Color.Transparent)
                .border({ width: { bottom: '2vp' }, color: C.onBackground })
                .padding({ bottom: 4 })
                .width('100%')
                .onChange((v: string) => { this.editCategory = v })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 12 })

            // Params
            Column() {
              Text('核心参数')
                .fontSize(Font.labelCaps.size)
                .fontWeight(Font.labelCaps.weight)
                .fontColor(C.outline)
                .margin({ bottom: 4 })
              TextInput({ text: this.editParams })
                .fontSize(Font.bodyMd.size)
                .fontColor(C.onBackground)
                .backgroundColor(Color.Transparent)
                .border({ width: { bottom: '2vp' }, color: C.onBackground })
                .padding({ bottom: 4 })
                .width('100%')
                .onChange((v: string) => { this.editParams = v })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ top: 12 })
          }
          .width('100%')
          .padding({ top: 12 })
        }
        .width('100%')
        .backgroundColor(C.background)
        .border(BW.full)
        .shadow(Shadow.hard)
        .padding(16)
        .rotate({ angle: 1 })

        // Stamp overlay
        Text('等你确认')
          .fontSize(Font.noteHandwritten.size)
          .fontWeight(700)
          .fontColor(C.secondaryContainer)
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor(C.background)
          .border({ width: '2vp', color: C.secondaryContainer, style: BorderStyle.Dashed })
          .rotate({ angle: -10 })
          .position({ x: 0, y: 0 })
          .translate({ x: '-20vp', y: '-12vp' })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })

      // Receipt notice strip
      Row() {
        Text('ℹ️')
          .fontSize(18)
          .fontColor(C.secondaryContainer)
        Text('没有确认的信息，不会被当作判断依据。')
          .fontSize(Font.noteHandwritten.size)
          .fontWeight(Font.noteHandwritten.weight)
          .fontColor(C.onSurfaceVariant)
          .margin({ left: 8 })
      }
      .width('100%')
      .padding(16)
      .backgroundColor(C.surfaceContainerLow)
      .border({ width: { top: '1vp', bottom: '1vp' }, color: C.onBackground, style: BorderStyle.Dashed })
      .margin({ top: 32, bottom: 24, left: 20, right: 20 })
      .rotate({ angle: -1 })

      // Actions
      Column() {
        Button() {
          Text('信息没问题，开始审问')
            .fontSize(Font.headlineMd.size)
            .fontWeight(Font.headlineMd.weight)
            .fontColor(C.onPrimaryContainer)
        }
        .width('100%')
        .height(56)
        .backgroundColor(C.primaryContainer)
        .border(BW.full)
        .borderRadius(4)
        .shadow(Shadow.hard)
        .onClick(() => {
          const p = new FlowProduct();
          p.name = this.editName;
          p.brand = this.editBrand;
          p.price = this.editPrice;
          p.category = this.editCategory;
          p.params = this.editParams;
          this.onConfirm(p);
        })

        Button() {
          Text('重新识别')
            .fontSize(Font.bodyLg.size)
            .fontWeight(Font.bodyLg.weight)
            .fontColor(C.onBackground)
        }
        .width('100%')
        .height(48)
        .backgroundColor(Color.Transparent)
        .border(BW.full)
        .borderRadius(4)
        .margin({ top: 16 })
        .onClick(() => this.onBack())
      }
      .width('100%')
      .padding({ left: 20, right: 20, bottom: 40 })
    }
    .width('100%')
    .backgroundColor(C.background)
  }

}
