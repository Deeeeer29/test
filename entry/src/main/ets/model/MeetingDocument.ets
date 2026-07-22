export type DocumentSourceType = 'email' | 'document' | 'history' | 'user_upload';
export type Reliability = 'verified' | 'needsCheck' | 'mock';

export interface MeetingDocument {
  id: string;
  meetingId: string;
  title: string;
  type: DocumentSourceType;
  source: string;
  summary: string;
  lastUpdated: string;
  includedInContext: boolean;
  reliability?: Reliability;
}
