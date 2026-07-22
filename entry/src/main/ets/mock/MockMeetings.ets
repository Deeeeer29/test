import { Meeting } from '../model/Meeting';

export const mockMeetings: Meeting[] = [
  {
    id: 'product-review',
    title: '产品方案评审会',
    startTime: '09:30',
    endTime: '10:30',
    location: 'A座 12F 望海会议室',
    attendees: ['王经理', '陈工', '李娜', '用户'],
    objective: '确认手机端 AI 会议应答助手第一版范围与交付节奏。',
    status: 'ready',
    preparedDocumentCount: 6,
    predictedQuestionCount: 5,
    preparationProgress: 92
  },
  {
    id: 'weekly-progress',
    title: '项目周进度会议',
    startTime: '14:00',
    endTime: '14:45',
    location: '线上会议',
    attendees: ['项目组', '测试组', '产品组'],
    objective: '同步本周开发进度、风险和下周计划。',
    status: 'preparing',
    preparedDocumentCount: 4,
    predictedQuestionCount: 3,
    preparationProgress: 74
  },
  {
    id: 'architecture-discussion',
    title: '技术架构讨论会',
    startTime: '16:00',
    endTime: '17:00',
    location: 'B座 8F 技术评审室',
    attendees: ['架构师', '移动端', 'AI平台'],
    objective: '评估 ASR、LLM 和本地存储的服务边界。',
    status: 'waiting',
    preparedDocumentCount: 5,
    predictedQuestionCount: 4,
    preparationProgress: 81
  }
];
