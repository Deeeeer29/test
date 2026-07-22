import { AnswerBundle, AnswerDurationMode, AnswerTone } from '../model/AnswerBundle';
import { MeetingSummary } from '../model/MeetingSummary';
import { mockAnswer } from '../mock/MockAnswers';
import { mockSummary } from '../mock/MockSummaries';
import { AIAnswerService } from './AIAnswerService';

interface ToneAnswerContent {
  transitionSentence: string;
  immediateAnswer: string;
  keyPoints: string[];
  riskWarnings: string[];
}

export class MockAIAnswerService implements AIAnswerService {
  generateAnswer(question: string, tone: AnswerTone = '专业', duration: AnswerDurationMode = '30s'): AnswerBundle {
    const answer: AnswerBundle = this.cloneAnswer(question, tone, duration);
    answer.createdAt = 'Just now';
    return answer;
  }

  regenerateAnswer(question: string, tone: AnswerTone = '专业', duration: AnswerDurationMode = '30s'): AnswerBundle {
    const answer: AnswerBundle = this.cloneAnswer(question, tone, duration);
    answer.createdAt = 'Regenerated just now';
    return answer;
  }

  changeAnswerDuration(answer: AnswerBundle, duration: AnswerDurationMode): AnswerBundle {
    return this.buildAnswer(answer, answer.tone, duration);
  }

  changeAnswerTone(answer: AnswerBundle, tone: AnswerTone): AnswerBundle {
    return this.buildAnswer(answer, tone, answer.durationMode);
  }

  generateMeetingSummary(meetingId: string): MeetingSummary { return mockSummary; }

  private cloneAnswer(question: string, tone: AnswerTone, duration: AnswerDurationMode): AnswerBundle {
    const answer: AnswerBundle = this.copyAnswer(mockAnswer);
    answer.question = question;
    return this.buildAnswer(answer, tone, duration);
  }

  private buildAnswer(answer: AnswerBundle, tone: AnswerTone, duration: AnswerDurationMode): AnswerBundle {
    const next: AnswerBundle = this.copyAnswer(answer);
    const content: ToneAnswerContent = this.getToneContent(tone);
    next.tone = tone;
    next.durationMode = duration;
    next.transitionSentence = content.transitionSentence;
    next.immediateAnswer = content.immediateAnswer;
    next.keyPoints = [...content.keyPoints];
    next.riskWarnings = [...content.riskWarnings];
    this.applyDuration(next, content);
    return next;
  }

  private applyDuration(answer: AnswerBundle, content: ToneAnswerContent): void {
    if (answer.durationMode === '15s') {
      answer.immediateAnswer = this.getShortImmediateAnswer(answer.tone);
      answer.keyPoints = content.keyPoints.slice(0, 2);
    } else if (answer.durationMode === '60s') {
      answer.immediateAnswer = `${content.immediateAnswer} At the same time, keep unverified SDK abilities behind mock services until the real APIs are confirmed.`;
      answer.keyPoints = [...content.keyPoints, 'Every key fact keeps source, update time, and confidence state.'];
    }
  }

  private getToneContent(tone: AnswerTone): ToneAnswerContent {
    if (tone === '简洁') {
      return {
        transitionSentence: 'Short answer: close the phone-side loop first, then integrate real AI services.',
        immediateAnswer: 'Finish the phone-side MVP loop first, then replace mock ASR and AI services step by step.',
        keyPoints: [
          'Keep the demo path complete on the phone.',
          'Replace mock ASR and LLM only after the flow is stable.',
          'Keep earphone playback as a short prompt in V1.0.'
        ],
        riskWarnings: ['Mock delay and confidence data must be validated before external reporting.']
      };
    } else if (tone === '委婉') {
      return {
        transitionSentence: 'I suggest explaining the current scope first, then describing the next integration steps.',
        immediateAnswer: 'At this stage, it may be more appropriate to stabilize the phone-side meeting loop first, while keeping ASR, LLM, calendar, mail, and earphone output behind replaceable services.',
        keyPoints: [
          'The phone side can first prove the preparation, live transcript, answer detail, and summary flow.',
          'Mock AI generation gives the team room to verify product timing before connecting real services.',
          'For uncertain SDK abilities, mark the limits clearly and leave replacement points in the service layer.'
        ],
        riskWarnings: ['Some capability assumptions are still mock values, so present them as pending validation.']
      };
    } else if (tone === '强势') {
      return {
        transitionSentence: 'The conclusion is clear: stabilize the phone-side loop before expanding integrations.',
        immediateAnswer: 'We should lock the phone-side MVP loop first. Real ASR, LLM, calendar, mail, and audio routing must wait until the current service contracts and UI flow are stable.',
        keyPoints: [
          'The phone-side path is the delivery baseline for V1.0.',
          'Mock AI output is acceptable only as a temporary service replacement.',
          'Unconfirmed SDK abilities must stay outside the committed scope.'
        ],
        riskWarnings: ['Do not report mock confidence, delay, or SDK behavior as production-ready facts.']
      };
    }
    return {
      transitionSentence: 'Answer from three angles: closed loop, service boundaries, and risk control.',
      immediateAnswer: 'We are prioritizing a complete phone-side MVP loop first, then replacing mock ASR and LLM services step by step through stable service interfaces.',
      keyPoints: [
        'Phone side owns preparation, live transcript, answer detail, and summary views.',
        'AI answer generation is mocked as a stream now and can be replaced by a real LLM service later.',
        'Earphone output is a low-interruption short prompt and is mocked in this version.'
      ],
      riskWarnings: ['Delay and confidence data are mock values and need validation before external reporting.']
    };
  }

  private getShortImmediateAnswer(tone: AnswerTone): string {
    if (tone === '简洁') {
      return 'Finish the phone-side loop first, then replace mock AI services.';
    } else if (tone === '委婉') {
      return 'I suggest stabilizing the phone-side loop first, then connecting real AI services.';
    } else if (tone === '强势') {
      return 'Lock the phone-side MVP loop first; integrations come after stability.';
    }
    return 'Prioritize the complete phone-side MVP loop, then replace mock services step by step.';
  }

  private copyAnswer(answer: AnswerBundle): AnswerBundle {
    return { id: answer.id, question: answer.question, transitionSentence: answer.transitionSentence, immediateAnswer: answer.immediateAnswer, keyPoints: [...answer.keyPoints], supportingFacts: [...answer.supportingFacts], riskWarnings: [...answer.riskWarnings], durationMode: answer.durationMode, tone: answer.tone, createdAt: answer.createdAt, isFavorite: answer.isFavorite };
  }
}
