import { Meeting } from '../model/Meeting';
import { MeetingDocument } from '../model/MeetingDocument';
import { PredictedQuestion } from '../model/PredictedQuestion';
import { MeetingSummary } from '../model/MeetingSummary';

export interface MeetingPreparation {
  documents: MeetingDocument[];
  questions: PredictedQuestion[];
  backgroundSummary: string[];
  keyMetrics: string[];
}

export interface MeetingService {
  getTodayMeetings(): Meeting[];
  getMeetingById(id: string): Meeting;
  getMeetingPreparation(id: string): MeetingPreparation;
  saveMeetingSummary(summary: MeetingSummary): void;
  getMeetingHistory(): MeetingSummary[];
}
