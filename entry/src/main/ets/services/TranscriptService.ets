import { TranscriptItem } from '../model/TranscriptItem';

export interface ITranscriptService {
  // 开始转写
  startTranscription(meetingId: string): Promise<void>;
  
  // 暂停转写
  pauseTranscription(): Promise<void>;
  
  // 停止转写
  stopTranscription(): Promise<TranscriptItem[]>;
  
  // 获取实时转写流
  getTranscriptionStream(): AsyncGenerator<TranscriptItem>;
  
  // 检测问题
  detectQuestion(transcriptItem: TranscriptItem): Promise<boolean>;
  
  // 检测点名
  detectMention(transcriptItem: TranscriptItem): Promise<boolean>;
}