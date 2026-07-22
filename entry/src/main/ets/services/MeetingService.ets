import { Meeting } from '../model/Meeting';
import { MeetingDocument } from '../model/MeetingDocument';
import { PredictedQuestion } from '../model/PredictedQuestion';
import { MeetingSummary } from '../model/MeetingSummary';

export interface KeyMetric {
  name: string;
  value: number;
  unit?: string;
}

export interface MeetingPreparation {
  meeting: Meeting;
  documents: MeetingDocument[];
  predictedQuestions: PredictedQuestion[];
  keyMetrics: KeyMetric[];
  backgroundSummary: string[];
}

export interface MeetingService {
  getTodayMeetings(): Meeting[];
  getMeetingById(id: string): Meeting;
  startMeeting(meetingId: string): void;
  endMeeting(meetingId: string): MeetingSummary;
  getMeetingPreparation(meetingId: string): MeetingPreparation;
  saveMeetingSummary(summary: MeetingSummary): void;
  getMeetingHistory(): MeetingSummary[];
}
