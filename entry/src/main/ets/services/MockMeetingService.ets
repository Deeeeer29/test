import { Meeting } from '../model/Meeting';
import { MeetingSummary } from '../model/MeetingSummary';
import { mockDocuments } from '../mock/MockDocuments';
import { mockMeetings } from '../mock/MockMeetings';
import { mockQuestions } from '../mock/MockQuestions';
import { mockSummary } from '../mock/MockSummaries';
import { MeetingPreparation, MeetingService } from './MeetingService';
import { MockStorageService } from './MockStorageService';

export class MockMeetingService implements MeetingService {
  getTodayMeetings(): Meeting[] {
    return mockMeetings;
  }

  getMeetingById(id: string): Meeting {
    const matched: Meeting | undefined = mockMeetings.find((item: Meeting) => item.id === id);
    return matched || mockMeetings[0];
  }

  getMeetingPreparation(id: string): MeetingPreparation {
    return {
      documents: mockDocuments,
      questions: mockQuestions,
      backgroundSummary: [
        '当前项目处于手机端 MVP 演示闭环实现阶段。',
        '最近进展集中在页面导航、Mock 数据、流式回答和会后总结。',
        '主要风险是真实 ASR、LLM、日历和耳机播报尚未接入。',
        '本次会议重点确认第一版范围、演示路径和后续接入边界。'
      ],
      keyMetrics: ['完成率 78%', '本周新增任务 12 项', '待处理风险 3 项', '预计交付 2026-07-26']
    };
  }

  saveMeetingSummary(summary: MeetingSummary): void {
    MockStorageService.saveMeetingHistory(summary);
  }

  getMeetingHistory(): MeetingSummary[] {
    const history: MeetingSummary[] = MockStorageService.getMeetingHistory();
    if (history.length === 0) {
      return [mockSummary];
    }
    return history;
  }
}
