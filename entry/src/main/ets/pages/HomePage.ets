/**
 * HomePage — 商品导入页 "把心动交出来"
 * Reference: stitch_reference/_1/code.html
 * Three import methods: screenshot upload, link paste, manual entry
 */
import { C, Shadow, Font, BW, FlowProduct } from '../common/Theme';

@Component
export struct HomePage {
  onStartFlow: (product: FlowProduct) => void = (_p: FlowProduct) => {};
  @State linkInput: string = '';

  startWithScreenshot(): void {
    // Simulate: user uploaded a screenshot → recognized product
    this.onStartFlow(new FlowProduct());
  }

  startWithLink(): void {
    if (this.linkInput.trim()) {
      // Simulate: user pasted link → parsed product
      const p = new FlowProduct();
      p.name = '无线降噪耳机';
      p.price = '¥1,899';
      p.category = '数码产品';
      this.onStartFlow(p);
    }
  }

  startManual(): void {
    const p = new FlowProduct();
    p.name = '';
    p.price = '';
    p.category = '';
    p.params = '';
    this.onStartFlow(p);
  }

  build() {
    Scroll() {
      Column() {
        // ── Header section ─────────────────────
        Column() {
          Text('把心动交出来')
            .fontSize(Font.headlineLg.size)
            .fontWeight(Font.headlineLg.weight)
            .fontColor(C.onBackground)
          Text('截图、链接，或者你脑子里挥之不去的那件东西。')
            .fontSize(Font.bodyLg.size)
            .fontWeight(Font.bodyLg.weight)
            .fontColor(C.onSurfaceVariant)
            .maxLines(2)
            .margin({ top: 8 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .rotate({ angle: -1 })
        .padding({ left: 20, right: 20, top: 32 })

        // ── Import Methods ─────────────────────

        // 1. Upload Screenshot (Primary, with RECOMMENDED stamp)
        Stack({ alignContent: Alignment.TopEnd }) {
          Column() {
            // Camera icon circle
            Column() {
              Text('📷')
                .fontSize(32)
            }
            .width(64)
            .height(64)
            .borderRadius(32)
            .backgroundColor(C.primaryContainer)
            .border(BW.full)
            .shadow(Shadow.hardSm)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)

            Text('上传商品截图')
              .fontSize(Font.headlineMd.size)
              .fontWeight(Font.headlineMd.weight)
              .fontColor(C.onBackground)
              .margin({ top: 16 })

            Text('相册 / 拍照')
              .fontSize(Font.bodyMd.size)
              .fontWeight(Font.bodyMd.weight)
              .fontColor(C.outline)
              .margin({ top: 4 })
          }
          .width('100%')
          .padding({ top: 32, bottom: 24 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(C.surfaceContainerLowest)
          .border(BW.full)
          .borderRadius(4)
          .shadow(Shadow.hard)
          .rotate({ angle: 1 })
          .onClick(() => this.startWithScreenshot())

          // RECOMMENDED stamp
          Text('RECOMMENDED')
            .fontSize(10)
            .fontWeight(Font.labelCaps.weight)
            .fontColor(C.onSecondaryContainer)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor(C.secondaryContainer)
            .border(BW.full)
            .rotate({ angle: 6 })
            .shadow(Shadow.hardSm)
            .margin({ top: -6, right: -6 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 32 })

        // Handwritten note
        Text('✏️ 商品名和价格拍清楚一点。')
          .fontSize(Font.noteHandwritten.size)
          .fontWeight(Font.noteHandwritten.weight)
          .fontColor(C.secondaryContainer)
          .rotate({ angle: -3 })
          .width('100%')
          .padding({ left: 40, top: 4 })

        // 2. Paste Link
        Row() {
          // Link icon
          Row() {
            Text('🔗')
              .fontSize(20)
          }
          .width(48)
          .height(48)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(C.surfaceVariant)
          .border({ width: { right: '2vp' }, color: C.onBackground })

          // Input
          TextInput({ placeholder: '粘贴商品链接', text: this.linkInput })
            .fontSize(Font.bodyMd.size)
            .fontColor(C.onBackground)
            .backgroundColor(Color.Transparent)
            .height(48)
            .layoutWeight(1)
            .padding({ left: 12 })
            .onChange((v: string) => { this.linkInput = v })

          // PARSE button
          Button() {
            Text('PARSE')
              .fontSize(Font.labelCaps.size)
              .fontWeight(Font.labelCaps.weight)
              .fontColor(C.onPrimaryContainer)
          }
          .height(48)
          .padding({ left: 16, right: 16 })
          .backgroundColor(C.primaryContainer)
          .border({ width: { left: '2vp' }, color: C.onBackground })
          .borderRadius(0)
          .onClick(() => this.startWithLink())
        }
        .width('100%')
        .height(48)
        .backgroundColor(C.surfaceContainer)
        .border(BW.full)
        .shadow(Shadow.hard)
        .rotate({ angle: -0.5 })
        .margin({ left: 20, right: 20, top: 24 })

        // 3. Manual Entry
        Button() {
          Row() {
            Text('✍️')
              .fontSize(20)
              .margin({ right: 8 })
            Text('手动输入商品信息')
              .fontSize(Font.bodyLg.size)
              .fontWeight(Font.bodyLg.weight)
              .fontColor(C.onSurfaceVariant)
          }
        }
        .width('100%')
        .height(56)
        .backgroundColor(C.surfaceContainerLow)
        .border({ width: '2vp', color: C.onBackground, style: BorderStyle.Dashed })
        .borderRadius(4)
        .rotate({ angle: 0.5 })
        .margin({ left: 20, right: 20, top: 16 })
        .onClick(() => this.startManual())

        // ── Privacy notice ────────────────────
        Row() {
          Text('🔒')
            .fontSize(14)
            .margin({ right: 6 })
          Text('图片只用于识别商品信息，不会读取你的购物账户。')
            .fontSize(10)
            .fontWeight(Font.labelCaps.weight)
            .fontColor(C.onSurfaceVariant)
            .maxLines(2)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .opacity(0.7)
        .margin({ top: 48, bottom: 40 })

      }
      .width('100%')
    }
    .width('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(C.background)
  }
}
