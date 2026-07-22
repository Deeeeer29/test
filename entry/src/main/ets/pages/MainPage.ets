/**
 * MainPage — App Shell
 * Contains: TopAppBar, Content Router (tabs + flow), BottomNavBar
 * Design: Neobrutalism / Editorial Collage
 */
import { C, Shadow, BW, Font, NavTabs, TabItem, FlowStep, FlowProduct } from '../common/Theme';
import { HomePage } from './HomePage';
import { ProductConfirmPage } from './ProductConfirmPage';
import { AIAnalysisPage } from './AIAnalysisPage';
import { InterrogationPage } from './InterrogationPage';
import { VerdictPage } from './VerdictPage';
import { CoolingPoolPage } from './CoolingPoolPage';
import { ReportPage } from './ReportPage';
import { ProfilePage } from './ProfilePage';

@Entry
@Component
struct MainPage {
  @State currentTab: number = 0;
  @State flowStep: FlowStep = FlowStep.HOME;
  @State flowProduct: FlowProduct = new FlowProduct();
  @State showBottomNav: boolean = true;

  // ── Navigation Helpers ──────────────────────────────
  goToConfirm(product: FlowProduct): void {
    this.flowProduct = product;
    this.flowStep = FlowStep.CONFIRM;
    this.showBottomNav = false;
  }

  goToAI(): void {
    this.flowStep = FlowStep.AI_ANALYSIS;
  }

  goToInterrogation(): void {
    this.flowStep = FlowStep.INTERROGATION;
  }

  goToVerdict(): void {
    this.flowStep = FlowStep.VERDICT;
  }

  goToCoolingPool(): void {
    this.flowStep = FlowStep.HOME;
    this.currentTab = 1;
    this.showBottomNav = true;
  }

  goHome(): void {
    this.flowStep = FlowStep.HOME;
    this.currentTab = 0;
    this.showBottomNav = true;
  }

  goToProfile(): void {
    this.flowStep = FlowStep.HOME;
    this.currentTab = 3;
    this.showBottomNav = true;
  }

  // ── TopAppBar (shared) ─────────────────────────────
  @Builder
  TopAppBar() {
    Row() {
      // Leading: notebook icon
      Row() {
        Text('✎')
          .fontSize(22)
          .fontColor(C.outline)
      }
      .width(40)
      .height(40)
      .justifyContent(FlexAlign.Center)
      .border({ width: '2vp', color: Color.Transparent })
      .borderRadius(8)
      .onClick(() => this.goHome())

      // Brand title (rotated -2deg)
      Text('先别买')
        .fontSize(28)
        .fontWeight(Font.displayLg.weight)
        .fontColor(C.primaryContainer)
        .rotate({ angle: -2 })
        .letterSpacing(-0.5)

      // Trailing: profile icon
      Row() {
        Text('👤')
          .fontSize(22)
      }
      .width(40)
      .height(40)
      .justifyContent(FlexAlign.Center)
      .border({ width: '2vp', color: Color.Transparent })
      .borderRadius(8)
      .onClick(() => this.goToProfile())
    }
    .width('100%')
    .height(56)
    .padding({ left: 20, right: 20 })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor(C.background)
    .border({ width: { bottom: '2vp' }, color: C.onBackground })
    .shadow(Shadow.hard)
  }

  // ── BottomNavBar (shared, hidden on transactional pages) ──
  @Builder
  BottomNavBar() {
    Row() {
      ForEach(NavTabs, (tab: TabItem) => {
        Column() {
          Text(tab.icon)
            .fontSize(22)
            .fontColor(this.currentTab === tab.index ? C.onPrimaryContainer : C.onSurfaceVariant)
          Text(tab.label)
            .fontSize(10)
            .fontWeight(Font.labelCaps.weight)
            .fontColor(this.currentTab === tab.index ? C.onPrimaryContainer : C.onSurfaceVariant)
            .margin({ top: 2 })
        }
        .width('25%')
        .padding({ top: 8, bottom: 8 })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(this.currentTab === tab.index ? C.primaryContainer : Color.Transparent)
        .border(
          this.currentTab === tab.index ? BW.full : { width: '2vp', color: Color.Transparent }
        )
        .borderRadius(4)
        .shadow(this.currentTab === tab.index ? Shadow.hardSm : Shadow.none)
        .rotate(this.currentTab === tab.index ? { angle: 1 } : { angle: -1 })
        .onClick(() => {
          this.currentTab = tab.index;
          this.flowStep = FlowStep.HOME;
          this.showBottomNav = true;
        })
      })
    }
    .width('100%')
    .height(64)
    .padding({ left: 16, right: 16, bottom: 12, top: 4 })
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Bottom)
    .backgroundColor(C.background)
    .border({ width: { top: '2vp' }, color: C.onBackground })
    .shadow(Shadow.navTop)
  }

  // ── Content Router ─────────────────────────────────
  @Builder
  ContentRouter() {
    if (this.flowStep === FlowStep.CONFIRM) {
      ProductConfirmPage({
        productName: this.flowProduct.name,
        productBrand: this.flowProduct.brand,
        productPrice: this.flowProduct.price,
        productCategory: this.flowProduct.category,
        productParams: this.flowProduct.params,
        onConfirm: (p: FlowProduct) => {
          this.flowProduct = p;
          this.goToAI();
        },
        onBack: () => this.goHome()
      })

    } else if (this.flowStep === FlowStep.AI_ANALYSIS) {
      AIAnalysisPage({
        productName: this.flowProduct.name,
        productPrice: this.flowProduct.price,
        onComplete: () => this.goToInterrogation()
      })

    } else if (this.flowStep === FlowStep.INTERROGATION) {
      InterrogationPage({
        onComplete: () => this.goToVerdict()
      })

    } else if (this.flowStep === FlowStep.VERDICT) {
      VerdictPage({
        productName: this.flowProduct.name,
        productPrice: this.flowProduct.price,
        onCoolingPool: () => this.goToCoolingPool(),
        onHome: () => this.goHome()
      })

    } else {
      // Tab pages
      if (this.currentTab === 0) {
        HomePage({ onStartFlow: (p: FlowProduct) => this.goToConfirm(p) })
      } else if (this.currentTab === 1) {
        CoolingPoolPage()
      } else if (this.currentTab === 2) {
        ReportPage()
      } else if (this.currentTab === 3) {
        ProfilePage()
      }
    }
  }

  build() {
    Column() {
      // TopAppBar
      this.TopAppBar()

      // Content (scrollable)
      Scroll() {
        this.ContentRouter()
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)

      // BottomNavBar (hidden on transactional pages)
      if (this.showBottomNav) {
        this.BottomNavBar()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(C.background)
  }
}
