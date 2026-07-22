import { mockTranscripts } from '../mock/MockTranscripts';
import { TranscriptItem } from '../model/TranscriptItem';
import { TranscriptService } from './TranscriptService';

export class MockTranscriptService implements TranscriptService {
  startMockTranscription(): TranscriptItem[] {
    return mockTranscripts;
  }

  pauseTranscription(): void {}

  resumeTranscription(): void {}

  stopTranscription(): void {}
}
