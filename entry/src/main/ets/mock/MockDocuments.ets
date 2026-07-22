import { MeetingDocument } from '../model/MeetingDocument';

export const mockDocuments: MeetingDocument[] = [
  {
    id: 'doc-1',
    title: '第一版产品范围说明',
    sourceType: 'document',
    sourceName: 'Mock文档',
    summary: '聚焦手机端信息展示、AI 回答生成和会后总结，第一版只保留手机端与耳机提示。',
    updatedAt: '今天 08:20',
    selected: true,
    reliability: 'mock'
  },
  {
    id: 'doc-2',
    title: '上次评审会议纪要',
    sourceType: 'history',
    sourceName: 'Mock历史会议',
    summary: '团队同意先完成可演示闭环，再逐步接入真实 ASR、LLM、日历和邮件。',
    updatedAt: '昨天 18:10',
    selected: true,
    reliability: 'verified'
  },
  {
    id: 'doc-3',
    title: '风险清单邮件',
    sourceType: 'mail',
    sourceName: 'Mock邮件',
    summary: '当前主要风险是实时转写准确率、回答延迟和数据来源可信度。',
    updatedAt: '今天 07:45',
    selected: true,
    reliability: 'needsCheck'
  },
  {
    id: 'doc-4',
    title: '用户上传背景材料',
    sourceType: 'upload',
    sourceName: 'Mock上传',
    summary: '希望会议中能快速获得可直接说出口的过渡句和要点。',
    updatedAt: '今天 09:00',
    selected: false,
    reliability: 'mock'
  }
];
