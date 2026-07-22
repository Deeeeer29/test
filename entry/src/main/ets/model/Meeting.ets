export type MeetingStatus = 'ready' | 'preparing' | 'waiting' | 'completed';

export interface Meeting {
  id: string;
  title: string;
  startTime: string;
  endTime: string;
  location: string;
  attendees: string[];
  objective: string;
  status: MeetingStatus;
  preparedDocumentCount: number;
  predictedQuestionCount: number;
  preparationProgress: number;
}
