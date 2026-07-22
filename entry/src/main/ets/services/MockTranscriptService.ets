import { mockTranscripts } from '../mock/MockTranscripts';
import { TranscriptItem } from '../model/TranscriptItem';
import { ITranscriptService, TranscriptionState } from './TranscriptService';

export class MockTranscriptService implements ITranscriptService {
  private state: TranscriptionState = 'not_started';
  private cursor: number = 0;
  private meetingId: string = '';
  private visibleItems: TranscriptItem[] = [];

  startTranscription(meetingId: string): void {
    if (this.state === 'transcribing') {
      return;
    }
    if (this.state === 'not_started' || this.state === 'stopped') {
      this.cursor = 0;
      this.visibleItems = [];
    }
    this.meetingId = meetingId;
    this.state = 'transcribing';
    if (this.visibleItems.length === 0) {
      this.getNextTranscript();
    }
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

  stopTranscription(): TranscriptItem[] {
    if (this.state === 'stopped') {
      return this.getVisibleTranscripts();
    }
    this.state = 'stopped';
    this.cursor = mockTranscripts.length;
    return this.getVisibleTranscripts();
  }

  getTranscriptionStream(): TranscriptItem[] {
    return this.getVisibleTranscripts();
  }

  detectQuestion(transcriptItem: TranscriptItem): boolean {
    return transcriptItem.isQuestion || transcriptItem.content.indexOf('?') >= 0;
  }

  detectMention(transcriptItem: TranscriptItem): boolean {
    return transcriptItem.isMentioned;
  }

  getTranscriptionState(): TranscriptionState {
    return this.state;
  }

  getVisibleTranscripts(): TranscriptItem[] {
    return this.visibleItems.slice(0);
  }

  getNextTranscript(): TranscriptItem | undefined {
    if (this.state !== 'transcribing' || this.cursor >= mockTranscripts.length) {
      return undefined;
    }
    const source: TranscriptItem = mockTranscripts[this.cursor];
    const item: TranscriptItem = {
      id: `${this.meetingId}-${source.id}`,
      meetingId: this.meetingId,
      speaker: source.speaker,
      content: source.content,
      timestamp: source.timestamp,
      isQuestion: source.isQuestion,
      isMentioned: source.isMentioned,
      confidence: source.confidence
    };
    this.visibleItems.push(item);
    this.cursor += 1;
    return item;
  }

  hasMoreTranscripts(): boolean {
    return this.state === 'transcribing' && this.cursor < mockTranscripts.length;
  }
}
