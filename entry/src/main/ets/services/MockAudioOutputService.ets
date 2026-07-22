import { I18n } from '../common/i18n/I18n';
import { AIServiceStatus, DeviceStatus, HeadphoneStatus, PhoneStatus } from '../model/DeviceStatus';
import { AudioOutputService } from './AudioOutputService';
import { MockStorageService } from './MockStorageService';

export class MockAudioOutputService implements AudioOutputService {
  getEarphoneStatus(): DeviceStatus {
    const phoneStatus: PhoneStatus = {
      isAvailable: true,
      microphonePermission: true,
      batteryLevel: 85
    };
    const headphoneStatus: HeadphoneStatus = {
      isConnected: true,
      isAvailable: true,
      type: 'wireless'
    };
    const aiServiceStatus: AIServiceStatus = {
      isAvailable: true,
      mode: 'local',
      status: 'idle'
    };
    return {
      phone: phoneStatus,
      headphone: headphoneStatus,
      aiService: aiServiceStatus
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
