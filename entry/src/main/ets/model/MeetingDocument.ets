export type DocumentSourceType = 'mail' | 'document' | 'history' | 'upload';
export type Reliability = 'verified' | 'needsCheck' | 'mock';

export interface MeetingDocument {
  id: string;
  title: string;
  sourceType: DocumentSourceType;
  sourceName: string;
  summary: string;
  updatedAt: string;
  selected: boolean;
  reliability: Reliability;
}
