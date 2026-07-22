import { DeviceStatus } from '../model/DeviceStatus';

export interface AudioOutputService {
  getEarphoneStatus(): DeviceStatus;
  simulateEarphonePlayback(text: string): string;
  stopSimulatedPlayback(): void;
  testEarphonePlayback(): string;
}
