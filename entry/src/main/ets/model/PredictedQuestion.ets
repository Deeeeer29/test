export interface PredictedQuestion {
  id: string;
  content: string;
  category: string;
  priority: 'high' | 'medium' | 'low';
  selected: boolean;
  preparedAnswerId: string;
}
