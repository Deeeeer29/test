import { PredictedQuestion } from '../model/PredictedQuestion';

export const mockQuestions: PredictedQuestion[] = [
  { id: 'q-1', content: '当前开发进度是否符合计划？', category: '进度', priority: 'high', selected: true, preparedAnswerId: 'answer-main' },
  { id: 'q-2', content: '为什么采用当前技术方案？', category: '方案', priority: 'high', selected: true, preparedAnswerId: 'answer-main' },
  { id: 'q-3', content: '手机端的核心价值是什么？', category: '价值', priority: 'medium', selected: true, preparedAnswerId: 'answer-main' },
  { id: 'q-4', content: '预计什么时候交付第一版？', category: '交付', priority: 'medium', selected: true, preparedAnswerId: 'answer-main' },
  { id: 'q-5', content: '当前最大的技术风险是什么？', category: '风险', priority: 'high', selected: true, preparedAnswerId: 'answer-main' }
];
