import { AnswerBundle, AnswerStage } from '../model/AnswerBundle';

const baseStages: AnswerStage[] = [
  {
    type: 'transition',
    content: 'This is a good question. I will summarize the current situation first.',
    generatedAt: '2026-07-22T14:30:00'
  },
  {
    type: 'core_points',
    content: 'The project is broadly on track, but service replacement and delivery quality still need attention.',
    generatedAt: '2026-07-22T14:30:05'
  },
  {
    type: 'supporting_data',
    content: 'Current completion is 85%, with 12 new tasks this week and 2 high-risk items.',
    generatedAt: '2026-07-22T14:30:10'
  },
  {
    type: 'risk_reminder',
    content: 'Third-party dependencies and test environment capacity need early confirmation.',
    generatedAt: '2026-07-22T14:30:15'
  }
];

export const mockAnswer: AnswerBundle = {
  id: 'answer-main',
  meetingId: 'product-review',
  question: 'What is the current development progress?',
  stages: baseStages,
  durationMode: '30s',
  tone: 'professional',
  createdAt: '2026-07-22T14:30:00',
  isFavorite: true,
  keyPoints: [
    'The project is broadly on track.',
    'Team collaboration efficiency can still improve.',
    'Next week should focus on delivery quality.'
  ],
  supportingFacts: [
    { id: 'fact-1', content: 'Current completion: 85%', source: 'Project system', updatedAt: '2026-07-22', confidence: 'high', verified: true },
    { id: 'fact-2', content: 'New tasks this week: 12', source: 'Weekly report', updatedAt: '2026-07-22', confidence: 'medium', verified: true },
    { id: 'fact-3', content: 'High-risk items: 2', source: 'Risk register', updatedAt: '2026-07-22', confidence: 'high', verified: true }
  ],
  riskWarnings: [
    'Third-party dependencies may slip and need early confirmation.',
    'Test environment capacity is tight and needs scheduling coordination.'
  ],
  immediateAnswer: 'The project is broadly on track, and the phone-side MVP loop is in its final phase.'
};

export const mockAnswers: AnswerBundle[] = [
  mockAnswer,
  {
    id: 'answer-risk',
    meetingId: 'product-review',
    question: 'What is the risk control strategy?',
    stages: baseStages,
    durationMode: '30s',
    tone: 'professional',
    createdAt: '2026-07-22T14:35:00',
    isFavorite: false,
    keyPoints: [
      'Replace mock services in phases.',
      'Keep rollback points for each phase.',
      'Track technical risks before integration.'
    ],
    supportingFacts: [
      { id: 'fact-risk-1', content: 'Phase 1: phone-side MVP demo completed', source: 'Project plan', updatedAt: '2026-07-22', confidence: 'high', verified: true },
      { id: 'fact-risk-2', content: 'Phase 2: real ASR integration in progress', source: 'Technical plan', updatedAt: '2026-07-22', confidence: 'medium', verified: true }
    ],
    riskWarnings: [
      'Third-party API compatibility may require extra validation.',
      'Real service integration needs additional testing time.'
    ],
    immediateAnswer: 'Use phased replacement, rollback points, and explicit risk tracking for real service integration.'
  },
  {
    id: 'answer-architecture',
    meetingId: 'architecture-discussion',
    question: 'What is the basis for the architecture choice?',
    stages: baseStages,
    durationMode: '30s',
    tone: 'professional',
    createdAt: '2026-07-23T10:15:00',
    isFavorite: true,
    keyPoints: [
      'Microservices support independent deployment and extension.',
      'The selected stack is mature enough for the demo.',
      'The plan balances delivery speed and maintainability.'
    ],
    supportingFacts: [
      { id: 'fact-arch-1', content: 'Microservices support independent deployment', source: 'Architecture design', updatedAt: '2026-07-23', confidence: 'high', verified: true },
      { id: 'fact-arch-2', content: 'HarmonyOS + ArkTS is the current client stack', source: 'Technical selection report', updatedAt: '2026-07-23', confidence: 'high', verified: true }
    ],
    riskWarnings: [
      'Microservices add operational complexity.',
      'More monitoring support will be needed later.'
    ],
    immediateAnswer: 'The architecture choice is based on scalability, stack maturity, and delivery efficiency.'
  }
];
