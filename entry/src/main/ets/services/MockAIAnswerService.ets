import { AnswerBundle, AnswerDurationMode, AnswerStage, AnswerTone } from '../model/AnswerBundle';
import { MeetingSummary } from '../model/MeetingSummary';
import { PredictedQuestion } from '../model/PredictedQuestion';
import { mockAnswer } from '../mock/MockAnswers';
import { AnswerGenerationParams, IAIAnswerService } from './AIAnswerService';

export class MockAIAnswerService implements IAIAnswerService {
  async generateAnswer(params: AnswerGenerationParams): Promise<AnswerBundle> {
    return this.buildAnswer(params.meetingId, params.question, this.toDurationMode(params.duration), params.tone, false);
  }

  async regenerateAnswer(answerId: string): Promise<AnswerBundle> {
    return this.buildAnswer('product-review', 'Regenerated answer', '30s', 'professional', true);
  }

  generateMeetingSummary(meetingId: string): MeetingSummary {
    return this.buildSummary(meetingId);
  }

  async generateSummary(meetingId: string): Promise<MeetingSummary> {
    return this.buildSummary(meetingId);
  }

  async predictQuestions(meetingId: string): Promise<PredictedQuestion[]> {
    return [];
  }

  changeAnswerDuration(answer: AnswerBundle, duration: AnswerDurationMode): AnswerBundle {
    return this.copyAnswer(answer, duration, answer.tone);
  }

  changeAnswerTone(answer: AnswerBundle, tone: AnswerTone): AnswerBundle {
    return this.copyAnswer(answer, answer.durationMode, tone);
  }

  private toDurationMode(duration: 15 | 30 | 60): AnswerDurationMode {
    if (duration === 15) { return '15s'; }
    if (duration === 60) { return '60s'; }
    return '30s';
  }

  private buildAnswer(meetingId: string, question: string, duration: AnswerDurationMode, tone: AnswerTone, regenerated: boolean): AnswerBundle {
    const transition: string = this.transitionForTone(tone);
    const stages: AnswerStage[] = [
      { type: 'transition', content: transition, generatedAt: '2026-07-23T09:40:00' },
      { type: 'core_points', content: 'Close the phone-side loop first, then replace mock services step by step.', generatedAt: '2026-07-23T09:40:03' },
      { type: 'supporting_data', content: 'The current mock completion value is 85%.', generatedAt: '2026-07-23T09:40:06' },
      { type: 'risk_reminder', content: 'Do not present mock confidence or latency as production data.', generatedAt: '2026-07-23T09:40:09' }
    ];
    return {
      id: regenerated ? `answer-regenerated-${Date.now()}` : `answer-${Date.now()}`,
      meetingId: meetingId,
      question: question,
      stages: stages,
      durationMode: duration,
      tone: tone,
      createdAt: regenerated ? 'Regenerated just now' : 'Just now',
      isFavorite: false,
      keyPoints: [
        'Phone side owns preparation, live transcript, answer detail, and summary views.',
        'AI output is mocked now and can be replaced by a real LLM service later.',
        'Earphone output remains a low-interruption short prompt in V1.'
      ],
      supportingFacts: [
        { id: 'fact-1', content: 'V1 scope is limited to the phone-side demo loop.', source: 'Mock product scope', updatedAt: '2026-07-23', confidence: 'high', verified: true },
        { id: 'fact-2', content: 'Real ASR and LLM are reserved behind service interfaces.', source: 'Mock tech plan', updatedAt: '2026-07-23', confidence: 'medium', verified: false }
      ],
      riskWarnings: [
        'Mock delay and confidence values need validation before external reporting.'
      ],
      immediateAnswer: 'We should stabilize the complete phone-side MVP loop first, then replace mock ASR and LLM services through stable interfaces.',
      transitionSentence: transition
    };
  }

  private copyAnswer(answer: AnswerBundle, duration: AnswerDurationMode, tone: AnswerTone): AnswerBundle {
    const copiedStages: AnswerStage[] = answer.stages.map((stage: AnswerStage): AnswerStage => {
      return {
        type: stage.type,
        content: stage.content,
        generatedAt: stage.generatedAt
      };
    });
    return {
      id: answer.id,
      meetingId: answer.meetingId,
      questionId: answer.questionId,
      transcriptItemId: answer.transcriptItemId,
      question: answer.question,
      stages: copiedStages,
      durationMode: duration,
      tone: tone,
      createdAt: answer.createdAt,
      isFavorite: answer.isFavorite,
      keyPoints: answer.keyPoints.slice(0),
      supportingFacts: answer.supportingFacts.slice(0),
      riskWarnings: answer.riskWarnings.slice(0),
      immediateAnswer: answer.immediateAnswer,
      transitionSentence: this.transitionForTone(tone)
    };
  }

  private transitionForTone(tone: AnswerTone): string {
    if (tone === 'concise') { return 'Short answer: close the loop first, then integrate.'; }
    if (tone === 'polite') { return 'I suggest explaining the current scope first, then the next steps.'; }
    if (tone === 'assertive') { return 'The conclusion is clear: stabilize the phone-side loop first.'; }
    return 'Answer from closed loop, service boundary, and risk control.';
  }

  private buildSummary(meetingId: string): MeetingSummary {
    return {
      id: `summary-${meetingId}`,
      meetingId: meetingId,
      meetingTitle: 'Product Plan Review',
      date: '2026-07-23',
      startTime: '09:30',
      endTime: '10:30',
      duration: '60 minutes',
      attendees: ['Manager Wang', 'Engineer Chen', 'User'],
      coreConclusions: [
        'V1 prioritizes a complete phone-side demo loop.',
        'Mock services are kept replaceable behind interfaces.'
      ],
      conclusions: [
        'V1 prioritizes a complete phone-side demo loop.',
        'Mock services are kept replaceable behind interfaces.'
      ],
      decisions: [
        { item: 'Keep V1 focused on the phone-side demo.', owner: 'Product', deadline: '2026-07-29' },
        { item: 'Reserve ASR and LLM replacement points.', owner: 'Engineering', deadline: '2026-08-05' }
      ],
      todoItems: [
        { task: 'Validate transcript pause and resume.', assignee: 'Engineering', priority: 'high', status: 'pending' }
      ],
      pendingConfirmations: [
        'Real ASR SDK API',
        'LLM service boundary'
      ],
      aiAssistedRecords: [
        { question: 'What is the current development progress?', answer: 'The phone-side MVP loop is the current priority.', timestamp: '2026-07-23T09:45:00' }
      ],
      createdAt: '2026-07-23T10:30:00',
      aiAssistCount: 1,
      answers: [mockAnswer]
    };
  }
}
