import { TranscriptItem } from '../model/TranscriptItem';

export const mockTranscripts: TranscriptItem[] = [
  { id: 't-1', speaker: '王经理', content: '今天先确认第一版范围，重点看手机端闭环是否能演示清楚。', timestamp: '00:20', isQuestion: false, mentionsUser: false, confidence: 0.92 },
  { id: 't-2', speaker: '陈工', content: '我们已经把会前资料、实时会议和会后总结拆成独立服务接口。', timestamp: '00:45', isQuestion: false, mentionsUser: false, confidence: 0.89 },
  { id: 't-3', speaker: '王经理', content: '目前整体开发进度到什么阶段了？用户这边可以先回答一下吗？', timestamp: '01:10', isQuestion: true, mentionsUser: true, confidence: 0.94 },
  { id: 't-4', speaker: '系统提示', content: '检测到提问和短暂停顿，等待用户确认是否生成辅助回答。', timestamp: '01:12', isQuestion: false, mentionsUser: true, confidence: 0.96 },
  { id: 't-5', speaker: '用户', content: '目前我们先完成手机端核心演示链路，真实服务会按接口逐步替换。', timestamp: '01:45', isQuestion: false, mentionsUser: false, confidence: 0.9 }
];
