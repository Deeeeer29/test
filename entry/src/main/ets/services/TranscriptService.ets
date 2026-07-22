import { TranscriptItem } from '../model/TranscriptItem';

export type TranscriptionState = 'not_started' | 'transcribing' | 'paused' | 'stopped';

export interface ITranscriptService {
  startTranscription(meetingId: string): void;
  pauseTranscription(): void;
  resumeTranscription(): void;
  stopTranscription(): TranscriptItem[];
  getTranscriptionStream(): TranscriptItem[];
  detectQuestion(transcriptItem: TranscriptItem): boolean;
  detectMention(transcriptItem: TranscriptItem): boolean;
  getTranscriptionState(): TranscriptionState;
  getVisibleTranscripts(): TranscriptItem[];
  getNextTranscript(): TranscriptItem | undefined;
  hasMoreTranscripts(): boolean;
}
