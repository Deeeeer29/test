import { AnswerBundle, AnswerDurationMode, AnswerTone } from '../model/AnswerBundle';
import { MeetingSummary } from '../model/MeetingSummary';
import { mockAnswer } from '../mock/MockAnswers';
import { mockSummary } from '../mock/MockSummaries';
import { AIAnswerService } from './AIAnswerService';

export class MockAIAnswerService implements AIAnswerService {
  generateAnswer(question: string): AnswerBundle { return this.cloneAnswer(question); }

  regenerateAnswer(question: string): AnswerBundle {
    const answer: AnswerBundle = this.cloneAnswer(question);
    answer.createdAt = 'Regenerated just now';
    return answer;
  }

  changeAnswerDuration(answer: AnswerBundle, duration: AnswerDurationMode): AnswerBundle {
    const next: AnswerBundle = this.copyAnswer(answer);
    next.durationMode = duration;
    if (duration === '15s') {
      next.immediateAnswer = 'Finish the phone-side loop first, then replace mock ASR and AI services.';
      next.keyPoints = next.keyPoints.slice(0, 2);
    } else if (duration === '60s') {
      next.immediateAnswer = 'The current plan has three layers: first, stabilize the phone-side meeting loop; second, keep ASR, LLM, calendar, mail, and earphone playback behind service interfaces; third, mark uncertain system abilities as mock or TODO until the SDK APIs are confirmed.';
      next.keyPoints = [...answer.keyPoints, 'Every key fact keeps source, update time, and confidence state.'];
    }
    return next;
  }

  changeAnswerTone(answer: AnswerBundle, tone: AnswerTone): AnswerBundle {
    const next: AnswerBundle = this.copyAnswer(answer);
    next.tone = tone;
    if (tone === 'short') { next.transitionSentence = 'Short answer: close the loop first, integrate later.'; }
    else if (tone === 'soft') { next.transitionSentence = 'I suggest explaining the scope and next integration steps first.'; }
    else if (tone === 'firm') { next.transitionSentence = 'The conclusion is clear: the phone-side loop must be stable first.'; }
    else { next.transitionSentence = 'Answer from three angles: closed loop, service seams, and risk control.'; }
    return next;
  }

  generateMeetingSummary(meetingId: string): MeetingSummary { return mockSummary; }

  private cloneAnswer(question: string): AnswerBundle {
    const answer: AnswerBundle = this.copyAnswer(mockAnswer);
    answer.question = question;
    answer.createdAt = 'Just now';
    return answer;
  }

  private copyAnswer(answer: AnswerBundle): AnswerBundle {
    return { id: answer.id, question: answer.question, transitionSentence: answer.transitionSentence, immediateAnswer: answer.immediateAnswer, keyPoints: [...answer.keyPoints], supportingFacts: [...answer.supportingFacts], riskWarnings: [...answer.riskWarnings], durationMode: answer.durationMode, tone: answer.tone, createdAt: answer.createdAt, isFavorite: answer.isFavorite };
  }
}
