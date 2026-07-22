export interface ActionItem {
  id: string;
  title: string;
  owner: string;
  deadline: string;
  priority: 'high' | 'medium' | 'low';
  completed: boolean;
}
