import { TranscriptItem } from '../model/TranscriptItem';

export interface TranscriptService {
  startMockTranscription(): TranscriptItem[];
  pauseTranscription(): void;
  resumeTranscription(): void;
  stopTranscription(): void;
}
