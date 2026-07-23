import { DeviceStatus } from '../model/DeviceStatus';

export interface IDeviceService {
  // 检查设备状态
  checkDeviceStatus(): Promise<DeviceStatus>;
  
  // 检查权限
  checkPermissions(): Promise<{
    microphone: boolean;
    calendar: boolean;
    notifications: boolean;
    storage: boolean;
  }>;
  
  // 请求权限
  requestPermissions(): Promise<void>;
  
  // 模拟耳机播报
  simulateHeadphoneOutput(text: string): Promise<void>;
  
  // 检查耳机连接
  checkHeadphoneConnection(): Promise<boolean>;
}