export interface PredictedQuestion {
  id: string;
  meetingId: string;
  question: string;
  priority: 'high' | 'medium' | 'low';
  preGeneratedAnswer?: string;
  category: string;
  selected?: boolean;
}
