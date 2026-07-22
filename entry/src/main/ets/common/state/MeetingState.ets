import { AppStorage } from '@kit.ArkUI';
import { AnswerBundle, AnswerStage } from '../../model/AnswerBundle';
import { DeviceStatus } from '../../model/DeviceStatus';
import { Meeting } from '../../model/Meeting';
import { MeetingSummary } from '../../model/MeetingSummary';
import { TranscriptItem } from '../../model/TranscriptItem';
import { UserPreferences } from '../../model/UserPreferences';

export class MeetingState {
  currentMeeting: Meeting | null = null;
  meetings: Meeting[] = [];
  transcript: TranscriptItem[] = [];
  isTranscribing: boolean = false;
  currentAnswer: AnswerBundle | null = null;
  isGeneratingAnswer: boolean = false;
  answerGenerationStage: 'idle' | 'transition' | 'core_points' | 'supporting_data' | 'risk_reminder' | 'complete' = 'idle';
  deviceStatus: DeviceStatus = {
    phone: {
      isAvailable: true,
      microphonePermission: false,
      batteryLevel: 85
    },
    headphone: {
      isConnected: false,
      isAvailable: false
    },
    aiService: {
      isAvailable: true,
      mode: 'local',
      status: 'idle'
    }
  };
  preferences: UserPreferences = {
    language: 'zh',
    privacy: {
      saveTranscript: true,
      saveAudio: false,
      cloudAnalysis: false,
      localFirst: true,
      autoDeletePeriod: 30
    },
    answer: {
      defaultDuration: '30s',
      defaultTone: 'professional',
      autoGenerate: false,
      headphoneOutput: true
    },
    environment: {
      mode: 'quiet',
      autoSwitch: true
    }
  };
  currentSummary: MeetingSummary | null = null;
  history: MeetingSummary[] = [];
  onboardingCompleted: boolean = false;
  currentAnswerStages: AnswerStage[] = [];
  meetingTimer: number = 0;
  isMeetingActive: boolean = false;
  transcriptionStatus: 'idle' | 'listening' | 'processing' | 'error' = 'idle';
  aiServiceStatus: 'idle' | 'generating' | 'ready' | 'error' = 'idle';
  headphoneOutputStatus: 'idle' | 'playing' | 'paused' | 'error' = 'idle';

  setCurrentMeeting(meeting: Meeting | null): void {
    this.currentMeeting = meeting;
    if (meeting) {
      this.isMeetingActive = meeting.status === 'in_progress';
    } else {
      this.isMeetingActive = false;
      this.meetingTimer = 0;
    }
  }

  startMeeting(meeting: Meeting): void {
    this.currentMeeting = meeting;
    this.currentMeeting.status = 'in_progress';
    this.isMeetingActive = true;
    this.meetingTimer = 0;
    this.transcript = [];
    this.isTranscribing = true;
    this.transcriptionStatus = 'listening';
  }

  endMeeting(): void {
    if (this.currentMeeting) {
      this.currentMeeting.status = 'completed';
    }
    this.isMeetingActive = false;
    this.isTranscribing = false;
    this.transcriptionStatus = 'idle';
    this.currentMeeting = null;
  }

  addTranscriptItem(item: TranscriptItem): void {
    this.transcript.push(item);
  }

  startAnswerGeneration(): void {
    this.isGeneratingAnswer = true;
    this.answerGenerationStage = 'transition';
    this.currentAnswerStages = [];
    this.aiServiceStatus = 'generating';
  }

  addAnswerStage(stage: AnswerStage): void {
    this.currentAnswerStages.push(stage);
    if (stage.type === 'transition') {
      this.answerGenerationStage = 'transition';
    } else if (stage.type === 'core_points') {
      this.answerGenerationStage = 'core_points';
    } else if (stage.type === 'supporting_data') {
      this.answerGenerationStage = 'supporting_data';
    } else if (stage.type === 'risk_reminder') {
      this.answerGenerationStage = 'risk_reminder';
    }
  }

  completeAnswerGeneration(answer: AnswerBundle): void {
    this.currentAnswer = answer;
    this.isGeneratingAnswer = false;
    this.answerGenerationStage = 'complete';
    this.aiServiceStatus = 'ready';
  }

  updateDeviceStatus(status: DeviceStatus): void {
    this.deviceStatus = {
      phone: {
        isAvailable: status.phone.isAvailable,
        microphonePermission: status.phone.microphonePermission,
        batteryLevel: status.phone.batteryLevel
      },
      headphone: {
        isConnected: status.headphone.isConnected,
        isAvailable: status.headphone.isAvailable,
        type: status.headphone.type
      },
      aiService: {
        isAvailable: status.aiService.isAvailable,
        mode: status.aiService.mode,
        status: status.aiService.status
      }
    };
  }

  updatePreferences(preferences: UserPreferences): void {
    this.preferences = {
      language: preferences.language,
      privacy: {
        saveTranscript: preferences.privacy.saveTranscript,
        saveAudio: preferences.privacy.saveAudio,
        cloudAnalysis: preferences.privacy.cloudAnalysis,
        localFirst: preferences.privacy.localFirst,
        autoDeletePeriod: preferences.privacy.autoDeletePeriod
      },
      answer: {
        defaultDuration: preferences.answer.defaultDuration,
        defaultTone: preferences.answer.defaultTone,
        autoGenerate: preferences.answer.autoGenerate,
        headphoneOutput: preferences.answer.headphoneOutput
      },
      environment: {
        mode: preferences.environment.mode,
        autoSwitch: preferences.environment.autoSwitch
      }
    };
  }

  saveMeetingSummary(summary: MeetingSummary): void {
    this.currentSummary = summary;
    this.history.unshift(summary);
  }

  startHeadphoneOutput(): void {
    this.headphoneOutputStatus = 'playing';
  }

  pauseHeadphoneOutput(): void {
    this.headphoneOutputStatus = 'paused';
  }

  stopHeadphoneOutput(): void {
    this.headphoneOutputStatus = 'idle';
  }

  reset(): void {
    this.currentMeeting = null;
    this.transcript = [];
    this.isTranscribing = false;
    this.currentAnswer = null;
    this.isGeneratingAnswer = false;
    this.answerGenerationStage = 'idle';
    this.currentAnswerStages = [];
    this.meetingTimer = 0;
    this.isMeetingActive = false;
    this.transcriptionStatus = 'idle';
    this.aiServiceStatus = 'idle';
    this.headphoneOutputStatus = 'idle';
    this.currentSummary = null;
  }
}

export class GlobalStateManager {
  private static instance: GlobalStateManager;
  private meetingState: MeetingState = new MeetingState();

  static getInstance(): GlobalStateManager {
    if (!GlobalStateManager.instance) {
      GlobalStateManager.instance = new GlobalStateManager();
    }
    return GlobalStateManager.instance;
  }

  getMeetingState(): MeetingState {
    return this.meetingState;
  }

  saveToStorage(): void {
    AppStorage.SetOrCreate('meetingState', this.meetingState);
  }

  loadFromStorage(): void {
    const stored: MeetingState | undefined = AppStorage.Get<MeetingState>('meetingState');
    if (stored) {
      this.meetingState = stored;
    }
  }

  resetState(): void {
    this.meetingState = new MeetingState();
    this.saveToStorage();
  }
}
