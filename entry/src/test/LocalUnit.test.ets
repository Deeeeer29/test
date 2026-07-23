import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { AnswerBundle, AnswerTone } from '../main/ets/model/AnswerBundle';
import { MeetingSummary } from '../main/ets/model/MeetingSummary';
import { TranscriptItem } from '../main/ets/model/TranscriptItem';
import { I18n } from '../main/ets/common/i18n/I18n';
import { mockAnswer } from '../main/ets/mock/MockAnswers';
import { MockAIAnswerService } from '../main/ets/services/MockAIAnswerService';
import { MockMeetingService } from '../main/ets/services/MockMeetingService';
import { MockStorageService } from '../main/ets/services/MockStorageService';
import { MockTranscriptService } from '../main/ets/services/MockTranscriptService';

export default function localUnitTest() {
  describe('localUnitTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    });
    it('answerToneVariants', 0, () => {
      const service: MockAIAnswerService = new MockAIAnswerService();
      const tones: AnswerTone[] = ['concise', 'professional', 'polite', 'assertive'];
      const answers: AnswerBundle[] = tones.map((tone: AnswerTone): AnswerBundle => service.changeAnswerTone(mockAnswer, tone));

      expect(answers[0].tone).assertEqual('concise');
      expect(answers[1].tone).assertEqual('professional');
      expect(answers[2].tone).assertEqual('polite');
      expect(answers[3].tone).assertEqual('assertive');
      expect(answers[0].transitionSentence === answers[1].transitionSentence).assertEqual(false);
      expect(answers[1].transitionSentence === answers[2].transitionSentence).assertEqual(false);
      expect(answers[2].transitionSentence === answers[3].transitionSentence).assertEqual(false);
    });
    it('answerToneChangeKeepsDuration', 0, () => {
      const service: MockAIAnswerService = new MockAIAnswerService();
      const longAnswer: AnswerBundle = service.changeAnswerDuration(service.changeAnswerTone(mockAnswer, 'professional'), '60s');
      const softLongAnswer: AnswerBundle = service.changeAnswerTone(longAnswer, 'polite');

      expect(softLongAnswer.tone).assertEqual('polite');
      expect(softLongAnswer.durationMode).assertEqual('60s');
      expect(softLongAnswer.transitionSentence === longAnswer.transitionSentence).assertEqual(false);
    });
    it('languageTextSwitchesBetweenChineseAndEnglish', 0, () => {
      const service: MockAIAnswerService = new MockAIAnswerService();
      const answer: AnswerBundle = service.changeAnswerTone(mockAnswer, 'professional');

      expect(I18n.t('settings', 'zh').length > 0).assertEqual(true);
      expect(I18n.t('settings', 'en')).assertEqual('Settings');
      expect(I18n.answer(answer, 'zh').question.length > 0).assertEqual(true);
      expect(I18n.answer(answer, 'en').question).assertEqual('What is the current development progress?');
      expect(I18n.toneLabel('assertive', 'en')).assertEqual('Assertive');
    });
    it('mockTranscriptPauseResumeStopFlow', 0, () => {
      const service: MockTranscriptService = new MockTranscriptService();

      expect(service.getTranscriptionState()).assertEqual('not_started');
      service.startTranscription('product-review');
      expect(service.getTranscriptionState()).assertEqual('transcribing');

      const first: TranscriptItem | undefined = service.getNextTranscript();
      expect(first !== undefined && first.id === 'product-review-t-2').assertEqual(true);

      service.pauseTranscription();
      expect(service.getTranscriptionState()).assertEqual('paused');
      expect(service.getNextTranscript() === undefined).assertEqual(true);

      service.resumeTranscription();
      expect(service.getTranscriptionState()).assertEqual('transcribing');
      const second: TranscriptItem | undefined = service.getNextTranscript();
      expect(second !== undefined && second.id === 'product-review-t-3').assertEqual(true);

      service.pauseTranscription();
      service.pauseTranscription();
      expect(service.getTranscriptionState()).assertEqual('paused');
      expect(service.getNextTranscript() === undefined).assertEqual(true);

      service.resumeTranscription();
      service.resumeTranscription();
      expect(service.getTranscriptionState()).assertEqual('transcribing');
      const third: TranscriptItem | undefined = service.getNextTranscript();
      expect(third !== undefined && third.id === 'product-review-t-4').assertEqual(true);

      service.stopTranscription();
      service.stopTranscription();
      expect(service.getTranscriptionState()).assertEqual('stopped');
      expect(service.getNextTranscript() === undefined).assertEqual(true);

      service.resumeTranscription();
      expect(service.getTranscriptionState()).assertEqual('stopped');
      expect(service.getNextTranscript() === undefined).assertEqual(true);
    });
    it('mockPageDataStatesUseServiceResults', 0, () => {
      AppStorage.SetOrCreate<MeetingSummary[]>('meetingHistory', []);
      AppStorage.SetOrCreate<AnswerBundle[]>('favoriteAnswers', []);

      const meetingService: MockMeetingService = new MockMeetingService();
      const answerService: MockAIAnswerService = new MockAIAnswerService();

      expect(meetingService.getMeetingHistory().length).assertEqual(0);
      expect(MockStorageService.getFavorites().length).assertEqual(0);

      let failed: boolean = false;
      try {
        meetingService.getMeetingById('missing-meeting');
      } catch (error) {
        failed = true;
      }
      expect(failed).assertEqual(true);
      expect(meetingService.getTodayMeetings().length > 0).assertEqual(true);

      const summary: MeetingSummary = answerService.generateMeetingSummary('product-review');
      meetingService.saveMeetingSummary(summary);
      MockStorageService.saveFavorite(answerService.changeAnswerTone(mockAnswer, 'professional'));

      expect(meetingService.getMeetingHistory().length > 0).assertEqual(true);
      expect(MockStorageService.getFavorites().length > 0).assertEqual(true);
    });
  });
}
