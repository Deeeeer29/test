import { DeviceStatus } from '../model/DeviceStatus';
import { IDeviceService } from './DeviceService';

export class MockDeviceService implements IDeviceService {
  private deviceStatus: DeviceStatus = {
    phone: {
      isAvailable: true,
      microphonePermission: false,
      batteryLevel: 85
    },
    headphone: {
      isConnected: false,
      isAvailable: false,
      type: 'wireless'
    },
    aiService: {
      isAvailable: true,
      mode: 'local',
      status: 'idle'
    }
  };

  async checkDeviceStatus(): Promise<DeviceStatus> {
    await new Promise<void>((resolve: () => void): void => {
      setTimeout(resolve, 300);
    });

    this.deviceStatus.headphone.isConnected = Math.random() > 0.5;
    this.deviceStatus.headphone.isAvailable = this.deviceStatus.headphone.isConnected;
    this.deviceStatus.phone.batteryLevel = Math.max(10, Math.min(100, this.deviceStatus.phone.batteryLevel + (Math.random() * 10 - 5)));

    return this.copyDeviceStatus();
  }

  async checkPermissions(): Promise<{
    microphone: boolean;
    calendar: boolean;
    notifications: boolean;
    storage: boolean;
  }> {
    await new Promise<void>((resolve: () => void): void => {
      setTimeout(resolve, 200);
    });

    return {
      microphone: this.deviceStatus.phone.microphonePermission,
      calendar: true,
      notifications: true,
      storage: true
    };
  }

  async requestPermissions(): Promise<void> {
    await new Promise<void>((resolve: () => void): void => {
      setTimeout(resolve, 500);
    });

    this.deviceStatus.phone.microphonePermission = true;
    this.deviceStatus.headphone.isConnected = Math.random() > 0.3;
    this.deviceStatus.headphone.isAvailable = this.deviceStatus.headphone.isConnected;
  }

  async simulateHeadphoneOutput(text: string): Promise<void> {
    await new Promise<void>((resolve: () => void): void => {
      setTimeout(resolve, 800);
    });

    console.log(`[Mock headphone playback] ${text}`);
    this.deviceStatus.aiService.status = 'processing';
    setTimeout((): void => {
      this.deviceStatus.aiService.status = 'idle';
    }, 1000);
  }

  async checkHeadphoneConnection(): Promise<boolean> {
    await new Promise<void>((resolve: () => void): void => {
      setTimeout(resolve, 150);
    });

    this.deviceStatus.headphone.isConnected = Math.random() > 0.4;
    this.deviceStatus.headphone.isAvailable = this.deviceStatus.headphone.isConnected;

    return this.deviceStatus.headphone.isConnected;
  }

  updateAIServiceStatus(status: 'idle' | 'processing' | 'error'): void {
    this.deviceStatus.aiService.status = status;
  }

  updateMicrophonePermission(granted: boolean): void {
    this.deviceStatus.phone.microphonePermission = granted;
  }

  private copyDeviceStatus(): DeviceStatus {
    return {
      phone: {
        isAvailable: this.deviceStatus.phone.isAvailable,
        microphonePermission: this.deviceStatus.phone.microphonePermission,
        batteryLevel: this.deviceStatus.phone.batteryLevel
      },
      headphone: {
        isConnected: this.deviceStatus.headphone.isConnected,
        isAvailable: this.deviceStatus.headphone.isAvailable,
        type: this.deviceStatus.headphone.type
      },
      aiService: {
        isAvailable: this.deviceStatus.aiService.isAvailable,
        mode: this.deviceStatus.aiService.mode,
        status: this.deviceStatus.aiService.status
      }
    };
  }
}
