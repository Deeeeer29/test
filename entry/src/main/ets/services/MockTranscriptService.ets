import { mockTranscripts } from '../mock/MockTranscripts';
import { TranscriptItem } from '../model/TranscriptItem';
import { TranscriptService, TranscriptionState } from './TranscriptService';

export class MockTranscriptService implements TranscriptService {
  private state: TranscriptionState = 'not_started';
  private cursor: number = 0;
  private visibleTranscripts: TranscriptItem[] = [];
  private sourceTranscripts: TranscriptItem[] = mockTranscripts;

  startMockTranscription(): TranscriptItem[] {
    if (this.state === 'not_started') {
      this.cursor = 0;
      this.visibleTranscripts = [];
      this.state = 'transcribing';
    }
    return this.sourceTranscripts;
  }

  getTranscriptionState(): TranscriptionState {
    return this.state;
  }

  getVisibleTranscripts(): TranscriptItem[] {
    return [...this.visibleTranscripts];
  }

  getNextTranscript(): TranscriptItem | undefined {
    if (this.state !== 'transcribing' || this.cursor >= this.sourceTranscripts.length) {
      return undefined;
    }
    const next: TranscriptItem = this.sourceTranscripts[this.cursor];
    this.visibleTranscripts = [...this.visibleTranscripts, next];
    this.cursor += 1;
    return next;
  }

  hasMoreTranscripts(): boolean {
    return this.cursor < this.sourceTranscripts.length;
  }

  pauseTranscription(): void {
    if (this.state !== 'transcribing') {
      return;
    }
    this.state = 'paused';
  }

  resumeTranscription(): void {
    if (this.state !== 'paused') {
      return;
    }
    this.state = 'transcribing';
  }

  stopTranscription(): void {
    if (this.state === 'stopped') {
      return;
    }
    this.state = 'stopped';
    this.cursor = this.sourceTranscripts.length;
  }
}
