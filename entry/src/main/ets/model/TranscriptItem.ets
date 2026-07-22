export interface TranscriptItem {
  id: string;
  meetingId: string;
  speaker: string;
  content: string;
  timestamp: string;
  isQuestion: boolean;
  isMentioned: boolean;
  confidence: number;
}
