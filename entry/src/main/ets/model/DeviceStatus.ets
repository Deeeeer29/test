export interface PhoneStatus {
  isAvailable: boolean;
  microphonePermission: boolean;
  batteryLevel: number;
}

export interface HeadphoneStatus {
  isConnected: boolean;
  isAvailable: boolean;
  type?: 'wired' | 'wireless';
}

export interface AIServiceStatus {
  isAvailable: boolean;
  mode: 'local' | 'cloud' | 'hybrid';
  status: 'idle' | 'processing' | 'error';
}

export interface DeviceStatus {
  phone: PhoneStatus;
  headphone: HeadphoneStatus;
  aiService: AIServiceStatus;
}
