import { DeviceStatus } from '../model/DeviceStatus';
import { AudioOutputService } from './AudioOutputService';

export class MockAudioOutputService implements AudioOutputService {
  getEarphoneStatus(): DeviceStatus {
    return {
      phoneAvailable: true,
      earphoneConnected: true,
      aiServiceAvailable: true,
      microphoneActive: false,
      lastCheckTime: '刚刚'
    };
  }

  simulateEarphonePlayback(text: string): string {
    return `正在模拟播报：${text}`;
  }

  stopSimulatedPlayback(): void {}

  testEarphonePlayback(): string {
    return '耳机模拟播报测试完成';
  }
}
