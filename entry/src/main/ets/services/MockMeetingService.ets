import { mockDocuments } from '../mock/MockDocuments';
import { mockMeetings } from '../mock/MockMeetings';
import { mockQuestions } from '../mock/MockQuestions';
import { Meeting } from '../model/Meeting';
import { MeetingSummary } from '../model/MeetingSummary';
import { KeyMetric, MeetingPreparation, MeetingService } from './MeetingService';
import { MockStorageService } from './MockStorageService';

export class MockMeetingService implements MeetingService {
  getTodayMeetings(): Meeting[] {
    return mockMeetings;
  }

  getMeetingById(id: string): Meeting {
    const meeting: Meeting | undefined = mockMeetings.find((item: Meeting): boolean => item.id === id);
    if (!meeting) {
      throw new Error(`Meeting not found: ${id}`);
    }
    return meeting;
  }

  startMeeting(meetingId: string): void {
    const meeting: Meeting | undefined = mockMeetings.find((item: Meeting): boolean => item.id === meetingId);
    if (meeting) {
      meeting.status = 'in_progress';
    }
  }

  endMeeting(meetingId: string): MeetingSummary {
    return this.buildSummary(meetingId);
  }

  getMeetingPreparation(meetingId: string): MeetingPreparation {
    const meeting: Meeting = this.getMeetingById(meetingId);
    const keyMetrics: KeyMetric[] = [
      { name: 'Completion', value: 85, unit: '%' },
      { name: 'New tasks', value: 12 },
      { name: 'Open risks', value: 2 }
    ];
    return {
      meeting: meeting,
      documents: mockDocuments.filter((doc): boolean => doc.meetingId === meetingId),
      predictedQuestions: mockQuestions.filter((question): boolean => question.meetingId === meetingId),
      keyMetrics: keyMetrics,
      backgroundSummary: [
        'Phone-side MVP loop is the current V1 focus.',
        'Real ASR and LLM are reserved behind service interfaces.',
        'Mock data is used for the current demo build.'
      ]
    };
  }

  saveMeetingSummary(summary: MeetingSummary): void {
    const history: MeetingSummary[] = MockStorageService.getMeetingHistory();
    const nextHistory: MeetingSummary[] = history.filter((item: MeetingSummary): boolean => item.id !== summary.id);
    nextHistory.unshift(summary);
    MockStorageService.saveMeetingHistory(nextHistory);
  }

  getMeetingHistory(): MeetingSummary[] {
    return MockStorageService.getMeetingHistory();
  }

  private buildSummary(meetingId: string): MeetingSummary {
    return {
      id: `summary-${meetingId}`,
      meetingId: meetingId,
      meetingTitle: 'Product Plan Review',
      date: '2026-07-23',
      startTime: '09:30',
      endTime: '10:30',
      duration: '60 minutes',
      attendees: ['Manager Wang', 'Engineer Chen', 'User'],
      coreConclusions: [
        'V1 prioritizes a complete phone-side demo loop.',
        'Real capabilities remain behind replaceable service interfaces.',
        'Mock data must be presented as mock data.'
      ],
      conclusions: [
        'V1 prioritizes a complete phone-side demo loop.',
        'Real capabilities remain behind replaceable service interfaces.'
      ],
      decisions: [
        { item: 'Keep V1 scope focused on phone-side text prompts.', owner: 'Product', deadline: '2026-07-29' },
        { item: 'Reserve ASR and LLM replacement points in services.', owner: 'Engineering', deadline: '2026-08-05' }
      ],
      todoItems: [
        { task: 'Verify live transcript pause and resume flow.', assignee: 'Engineering', priority: 'high', status: 'pending' },
        { task: 'Review answer detail copy.', assignee: 'Product', priority: 'medium', status: 'pending' }
      ],
      pendingConfirmations: [
        'Real ASR SDK API',
        'LLM service integration boundary'
      ],
      aiAssistedRecords: [
        {
          question: 'What is the current development progress?',
          answer: 'The phone-side MVP loop is the current priority.',
          timestamp: '2026-07-23T09:45:00'
        }
      ],
      createdAt: '2026-07-23T10:30:00',
      aiAssistCount: 1,
      answers: []
    };
  }
}
