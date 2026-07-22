export interface TranscriptItem {
  id: string;
  speaker: string;
  content: string;
  timestamp: string;
  isQuestion: boolean;
  mentionsUser: boolean;
  confidence: number;
}
