import { MeetingSummary } from '../model/MeetingSummary';
import { UserPreferences } from '../model/UserPreferences';
import { AnswerBundle } from '../model/AnswerBundle';

export interface IStorageService {
  // 保存会议总结
  saveMeetingSummary(summary: MeetingSummary): Promise<void>;
  
  // 获取历史记录
  getMeetingHistory(): Promise<MeetingSummary[]>;
  
  // 保存用户偏好
  saveUserPreferences(preferences: UserPreferences): Promise<void>;
  
  // 获取用户偏好
  getUserPreferences(): Promise<UserPreferences>;
  
  // 保存收藏的回答
  saveFavoriteAnswer(answer: AnswerBundle): Promise<void>;
  
  // 获取收藏的回答
  getFavoriteAnswers(): Promise<AnswerBundle[]>;
  
  // 获取首次使用状态
  getOnboardingStatus(): Promise<boolean>;
  
  // 保存首次使用状态
  saveOnboardingStatus(completed: boolean): Promise<void>;
}