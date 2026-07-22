export interface DeviceStatus {
  phone: {
    isAvailable: boolean;
    microphonePermission: boolean;
    batteryLevel: number;
  };
  headphone: {
    isConnected: boolean;
    isAvailable: boolean;
    type?: 'wired' | 'wireless';
  };
  aiService: {
    isAvailable: boolean;
    mode: 'local' | 'cloud' | 'hybrid';
    status: 'idle' | 'processing' | 'error';
  };
}
