import { MeetingSummary } from '../model/MeetingSummary';
import { mockAnswer } from './MockAnswers';

export const mockSummary: MeetingSummary = {
  id: 'summary-product-review',
  meetingId: 'product-review',
  meetingTitle: '产品方案评审会',
  date: '2026-07-22',
  startTime: '09:30',
  endTime: '10:30',
  duration: '60分钟',
  attendees: ['王经理', '陈工', '李娜', '用户'],
  conclusions: [
    '第一版优先完成手机端完整演示闭环。',
    '所有真实能力先通过服务接口预留，当前使用 Mock 数据。',
    '会议中必须持续显示麦克风状态，并提供暂停与结束入口。'
  ],
  decisions: [
    '第一版先完成手机端文字提示。',
    '第二阶段接入真实语音转写。',
    '耳机播报作为增强能力，仅模拟短句提示。',
    '自动问题识别在核心闭环稳定后再接入真实算法。'
  ],
  actionItems: [
    { id: 'a-1', title: '整理 ASR 服务接入清单', owner: '陈工', deadline: '2026-07-24', priority: '高', completed: false },
    { id: 'a-2', title: '补充数据来源可信度标记', owner: '李娜', deadline: '2026-07-25', priority: '中', completed: false },
    { id: 'a-3', title: '准备第一版演示脚本', owner: '用户', deadline: '2026-07-23', priority: '高', completed: true }
  ],
  unresolvedQuestions: [
    '真实耳机播报 API 需要等待 SDK 能力确认。',
    '日历与邮件接入需要确认授权范围。'
  ],
  aiAssistCount: 2,
  answers: [mockAnswer]
};
