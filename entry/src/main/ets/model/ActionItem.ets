export interface ActionItem {
  id: string;
  title: string;
  owner: string;
  deadline: string;
  priority: '高' | '中' | '低';
  completed: boolean;
}
