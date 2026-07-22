import { promptAction } from '@kit.ArkUI';
import { AppLanguage, I18n } from '../common/i18n/I18n';
import { AppTheme } from '../common/theme/AppTheme';
import { MockDeviceService } from '../services/MockDeviceService';

@Component
export struct HeadphoneOutputSimulator {
  @Prop language: AppLanguage = 'zh';
  @Prop text: string = '';
  @State isPlaying: boolean = false;
  @State progress: number = 0;
  private deviceService: MockDeviceService = new MockDeviceService();
  private playbackInterval: number = 0;

  aboutToDisappear(): void {
    this.stopPlayback();
  }

  private async startPlayback(): Promise<void> {
    if (this.isPlaying) {
      return;
    }

    this.isPlaying = true;
    this.progress = 0;

    const isConnected: boolean = await this.deviceService.checkHeadphoneConnection();
    if (!isConnected) {
      promptAction.showToast({
        message: I18n.t('headphoneNotConnected', this.language),
        duration: 2000
      });
      this.isPlaying = false;
      return;
    }

    this.playbackInterval = setInterval((): void => {
      this.progress += 5;
      if (this.progress >= 100) {
        this.stopPlayback();
      }
    }, 100);

    try {
      await this.deviceService.simulateHeadphoneOutput(this.text);
      promptAction.showToast({
        message: I18n.t('playbackCompleted', this.language),
        duration: 1500
      });
    } catch (error) {
      promptAction.showToast({
        message: I18n.t('playbackFailed', this.language),
        duration: 2000
      });
    } finally {
      this.stopPlayback();
    }
  }

  private stopPlayback(): void {
    if (this.playbackInterval > 0) {
      clearInterval(this.playbackInterval);
      this.playbackInterval = 0;
    }
    this.isPlaying = false;
    this.progress = 0;
  }

  private async testPlayback(): Promise<void> {
    this.text = I18n.t('testPlaybackText', this.language);
    await this.startPlayback();
  }

  build() {
    Column() {
      Row() {
        Button(this.isPlaying ? I18n.t('pause', this.language) : I18n.t('play', this.language))
          .width(80)
          .height(40)
          .fontSize(14)
          .fontColor(this.isPlaying ? AppTheme.primaryText : AppTheme.primaryButtonText)
          .backgroundColor(this.isPlaying ? AppTheme.warningColor : AppTheme.accentColor)
          .onClick((): void => {
            if (this.isPlaying) {
              this.stopPlayback();
            } else {
              this.startPlayback();
            }
          })

        Progress({
          value: this.progress,
          total: 100,
          type: ProgressType.Linear
        })
          .width('60%')
          .height(8)
          .margin({ left: 16 })
          .color({
            gradient: {
              angle: 90,
              colors: [AppTheme.accentColor, AppTheme.successColor]
            }
          })

        Button(I18n.t('test', this.language))
          .width(60)
          .height(40)
          .fontSize(12)
          .fontColor(AppTheme.primaryText)
          .backgroundColor(AppTheme.elevatedBackground)
          .margin({ left: 8 })
          .onClick((): void => {
            this.testPlayback();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding(12)

      Row() {
        Text(this.isPlaying ? I18n.t('playing', this.language) : I18n.t('ready', this.language))
          .fontSize(12)
          .fontColor(this.isPlaying ? AppTheme.successColor : AppTheme.secondaryText)

        Text(`${I18n.t('progress', this.language)}: ${this.progress}%`)
          .fontSize(12)
          .fontColor(AppTheme.secondaryText)
          .margin({ left: 8 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 8 })

      if (this.text) {
        Text(this.text)
          .fontSize(12)
          .fontColor(AppTheme.secondaryText)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .margin({ top: 12 })
          .padding(8)
          .backgroundColor(AppTheme.cardBackground)
          .borderRadius(AppTheme.radiusSmall)
          .width('100%')
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.pageBackground)
    .borderRadius(AppTheme.radiusMedium)
    .border({
      width: 1,
      color: AppTheme.dividerColor,
      style: BorderStyle.Solid
    })
  }
}
