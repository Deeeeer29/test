import { MeetingDocument } from '../model/MeetingDocument';

export const mockDocuments: MeetingDocument[] = [
  {
    id: 'doc-1',
    meetingId: 'product-review',
    title: 'Q3 Product Roadmap Draft',
    type: 'document',
    source: 'Internal document',
    summary: 'Describes Q3 product scope and milestones.',
    lastUpdated: '2026-07-20T10:30:00',
    includedInContext: true,
    reliability: 'verified'
  },
  {
    id: 'doc-2',
    meetingId: 'product-review',
    title: 'Technical Architecture Design',
    type: 'document',
    source: 'Engineering',
    summary: 'Microservice split plan and API design.',
    lastUpdated: '2026-07-21T14:15:00',
    includedInContext: true,
    reliability: 'verified'
  },
  {
    id: 'doc-3',
    meetingId: 'weekly-progress',
    title: 'Project Weekly Report',
    type: 'document',
    source: 'Project management',
    summary: 'Progress, risks, and next-week plan.',
    lastUpdated: '2026-07-21T16:45:00',
    includedInContext: true,
    reliability: 'verified'
  },
  {
    id: 'doc-4',
    meetingId: 'architecture-discussion',
    title: 'Architecture Review Minutes',
    type: 'history',
    source: 'Previous meeting',
    summary: 'Conclusions and actions from the last architecture review.',
    lastUpdated: '2026-07-19T11:20:00',
    includedInContext: true,
    reliability: 'verified'
  }
];
