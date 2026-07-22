import { DeviceStatus } from '../model/DeviceStatus';
import { AudioOutputService } from './AudioOutputService';
import { I18n } from '../common/i18n/I18n';
import { MockStorageService } from './MockStorageService';

export class MockAudioOutputService implements AudioOutputService {
  getEarphoneStatus(): DeviceStatus {
    return {
      phoneAvailable: true,
      earphoneConnected: true,
      aiServiceAvailable: true,
      microphoneActive: false,
      lastCheckTime: MockStorageService.getLanguage() === 'zh' ? '刚刚' : 'Just now'
    };
  }

  simulateEarphonePlayback(text: string): string {
    return I18n.playbackMessage(text, MockStorageService.getLanguage());
  }

  stopSimulatedPlayback(): void {}

  testEarphonePlayback(): string {
    return I18n.testPlaybackMessage(MockStorageService.getLanguage());
  }
}
