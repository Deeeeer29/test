import { router } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { AppTheme } from '../common/theme/AppTheme';

export type MainTab = 'today' | 'assistant' | 'history' | 'mine';

interface MainTabItem {
  key: MainTab;
  labelKey: string;
  icon: string;
  url: string;
}

@Component
export struct BottomNavigationBar {
  @Prop current: MainTab = 'today';
  @Prop language: AppLanguage = 'zh';
  private tabs: MainTabItem[] = [
    { key: 'today', labelKey: 'today', icon: '□', url: 'pages/Index' },
    { key: 'assistant', labelKey: 'assistant', icon: '◇', url: 'pages/LiveMeetingPage' },
    { key: 'history', labelKey: 'history', icon: '◷', url: 'pages/HistoryPage' },
    { key: 'mine', labelKey: 'mine', icon: '○', url: 'pages/MinePage' }
  ];

  private activeColor(tab: MainTab): string {
    return tab === this.current ? AppTheme.accentColor : AppTheme.mutedText;
  }

  private activeWeight(tab: MainTab): FontWeight {
    return tab === this.current ? FontWeight.Bold : FontWeight.Regular;
  }

  private go(tab: MainTabItem): void {
    if (tab.key === this.current) {
      return;
    }
    if (tab.key === 'assistant') {
      router.replaceUrl({ url: tab.url, params: { meetingId: 'product-review' } }, router.RouterMode.Single);
      return;
    }
    router.replaceUrl({ url: tab.url }, router.RouterMode.Single);
  }

  build() {
    Row() {
      ForEach(this.tabs, (tab: MainTabItem) => {
        Column() {
          Text(tab.icon)
            .height(22)
            .fontSize(20)
            .fontColor(this.activeColor(tab.key))
            .textAlign(TextAlign.Center)
          Text(I18n.t(tab.labelKey, this.language))
            .margin({ top: 2 })
            .fontSize(11)
            .fontWeight(this.activeWeight(tab.key))
            .fontColor(this.activeColor(tab.key))
            .textAlign(TextAlign.Center)
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .height(58)
        .onClick((): void => this.go(tab))
      }, (tab: MainTabItem): string => tab.key)
    }
    .width('100%')
    .height(62)
    .padding({ top: 4, bottom: 4 })
    .backgroundColor(AppTheme.cardBackground)
    .border({ width: { top: 1 }, color: AppTheme.dividerColor })
  }
}
