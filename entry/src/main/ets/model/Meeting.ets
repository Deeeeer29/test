export type MeetingStatus = 'pending' | 'in_progress' | 'completed' | 'cancelled';
export type PreparationStatus = 'not_started' | 'preparing' | 'ready';

export interface Meeting {
  id: string;
  title: string;
  startTime: string;
  endTime: string;
  location: string;
  participants: string[];
  goal: string;
  status: MeetingStatus;
  preparationStatus: PreparationStatus;
  aiAssistedCount: number;
}
