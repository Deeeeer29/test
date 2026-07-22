import { Meeting } from '../model/Meeting';

export const mockMeetings: Meeting[] = [
  {
    id: 'product-review',
    title: 'Product Plan Review',
    startTime: '2026-07-22T14:00:00',
    endTime: '2026-07-22T15:30:00',
    location: 'Meeting Room A',
    participants: ['Manager Wang', 'Engineer Chen', 'Designer Li', 'User'],
    goal: 'Review the Q3 product roadmap',
    status: 'pending',
    preparationStatus: 'ready',
    aiAssistedCount: 0
  },
  {
    id: 'weekly-progress',
    title: 'Weekly Project Sync',
    startTime: '2026-07-22T10:00:00',
    endTime: '2026-07-22T11:00:00',
    location: 'Online meeting',
    participants: ['Project team'],
    goal: 'Sync project progress and risks',
    status: 'completed',
    preparationStatus: 'ready',
    aiAssistedCount: 3
  },
  {
    id: 'architecture-discussion',
    title: 'Architecture Discussion',
    startTime: '2026-07-23T09:30:00',
    endTime: '2026-07-23T11:00:00',
    location: 'Engineering meeting room',
    participants: ['Architecture team', 'Development lead'],
    goal: 'Discuss the microservice split plan',
    status: 'pending',
    preparationStatus: 'preparing',
    aiAssistedCount: 0
  }
];
