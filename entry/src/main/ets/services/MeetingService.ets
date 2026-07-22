import { Meeting } from '../model/Meeting';
import { MeetingDocument } from '../model/MeetingDocument';
import { PredictedQuestion } from '../model/PredictedQuestion';
import { MeetingSummary } from '../model/MeetingSummary';

export interface MeetingPreparation {
  meeting: Meeting;
  documents: MeetingDocument[];
  predictedQuestions: PredictedQuestion[];
  keyMetrics: Record<string, any>;
  backgroundSummary: string[];
}

export interface MeetingService {
  getTodayMeetings(): Promise<Meeting[]>;
  getMeetingById(id: string): Promise<Meeting>;
  startMeeting(meetingId: string): Promise<void>;
  endMeeting(meetingId: string): Promise<MeetingSummary>;
  getMeetingPreparation(meetingId: string): Promise<MeetingPreparation>;
  saveMeetingSummary(summary: MeetingSummary): Promise<void>;
  getMeetingHistory(): Promise<MeetingSummary[]>;
}
