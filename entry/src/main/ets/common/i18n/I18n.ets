import { AnswerBundle, AnswerTone } from '../../model/AnswerBundle';
import { Meeting } from '../../model/Meeting';
import { MeetingDocument } from '../../model/MeetingDocument';
import { MeetingSummary } from '../../model/MeetingSummary';
import { PredictedQuestion } from '../../model/PredictedQuestion';
import { SupportingFact } from '../../model/SupportingFact';
import { TranscriptItem } from '../../model/TranscriptItem';

export type AppLanguage = 'zh' | 'en';

export class I18n {
  static t(key: string, language: AppLanguage): string {
    if (language === 'zh') { return I18n.zh(key); }
    return I18n.en(key);
  }

  private static zh(key: string): string {
    if (key === 'back') { return '返回'; }
    if (key === 'settings') { return '设置'; }
    if (key === 'today') { return '今日'; }
    if (key === 'dashboard') { return '会议助手'; }
    if (key === 'assistant') { return '助手'; }
    if (key === 'history') { return '历史'; }
    if (key === 'mine') { return '我的'; }
    if (key === 'editProfile') { return '编辑个人资料'; }
    if (key === 'displayName') { return '用户名称'; }
    if (key === 'avatarPath') { return '头像路径'; }
    if (key === 'privacySecurity') { return '隐私与安全'; }
    if (key === 'privacySecurityDesc') { return '账号、资料和会议内容通过后端服务统一管理。'; }
    if (key === 'aboutUs') { return '关于我们'; }
    if (key === 'aboutUsDesc') { return '会议助手 V1.0'; }
    if (key === 'logout') { return '退出登录'; }
    if (key === 'save') { return '保存'; }
    if (key === 'cancel') { return '取消'; }
    if (key === 'availableNow') { return '现在可以修改'; }
    if (key === 'nextNameChange') { return '下次可修改名称时间：'; }
    if (key === 'nameRequired') { return '请输入用户名称'; }
    if (key === 'profileSaved') { return '个人资料已保存'; }
    if (key === 'loggedOut') { return '已退出登录'; }
    if (key === 'todayMeetings') { return '今日会议'; }
    if (key === 'mockPhoneEarphoneOnly') { return '当前为 Mock 数据，仅模拟手机与耳机状态。'; }
    if (key === 'startAdHocMeeting') { return '开始新会议'; }
    if (key === 'recentRecords') { return '最近记录'; }
    if (key === 'recentRecordsDesc') { return '保存的会议总结和收藏回答会显示在历史记录中。'; }
    if (key === 'preparation') { return '会前准备'; }
    if (key === 'backgroundSummary') { return '背景摘要'; }
    if (key === 'mockData') { return 'Mock 数据'; }
    if (key === 'keyMetrics') { return '关键指标'; }
    if (key === 'materials') { return '会议材料'; }
    if (key === 'predictedQuestions') { return '预测问题'; }
    if (key === 'enterMeetingMode') { return '进入会议模式'; }
    if (key === 'meetingRunningStatus') { return '会议助手运行中 / 麦克风已启用 / 耳机模拟就绪 / AI Mock 就绪'; }
    if (key === 'resume') { return '恢复'; }
    if (key === 'pause') { return '暂停'; }
    if (key === 'play') { return '播放'; }
    if (key === 'test') { return '测试'; }
    if (key === 'playing') { return '播放中'; }
    if (key === 'ready') { return '就绪'; }
    if (key === 'progress') { return '进度'; }
    if (key === 'headphoneNotConnected') { return '耳机未连接'; }
    if (key === 'playbackCompleted') { return '播放完成'; }
    if (key === 'playbackFailed') { return '播放失败'; }
    if (key === 'testPlaybackText') { return '这是一条耳机模拟播放测试消息。'; }
    if (key === 'transcript') { return '实时转写'; }
    if (key === 'transcriptSubtitle') { return 'Mock 转写内容会逐条出现。'; }
    if (key === 'questionDetected') { return '检测到问题，可请求 AI 辅助回答。'; }
    if (key === 'actions') { return '操作'; }
    if (key === 'helpMeAnswer') { return '帮我回答'; }
    if (key === 'showFloatingAnswer') { return '显示悬浮回答'; }
    if (key === 'aiStream') { return 'AI 生成过程'; }
    if (key === 'preparingAnswer') { return '正在准备回答'; }
    if (key === 'answerDetail') { return '回答详情'; }
    if (key === 'sayNow') { return '现在可以这样说'; }
    if (key === 'duration') { return '回答时长'; }
    if (key === 'tone') { return '回答语气'; }
    if (key === 'keyPointsSection') { return '核心观点'; }
    if (key === 'supportingFacts') { return '支撑依据'; }
    if (key === 'risk') { return '风险提醒'; }
    if (key === 'mockEarphonePlayback') { return '耳机模拟播放'; }
    if (key === 'regenerate') { return '重新生成'; }
    if (key === 'favorite') { return '收藏'; }
    if (key === 'favorited') { return '已收藏'; }
    if (key === 'saved') { return '已保存'; }
    if (key === 'verified') { return '已验证'; }
    if (key === 'check') { return '待核验'; }
    if (key === 'searchPlaceholder') { return '搜索会议、问题、项目或人员'; }
    if (key === 'all') { return '全部'; }
    if (key === 'meetings') { return '会议'; }
    if (key === 'answers') { return '回答'; }
    if (key === 'noHistory') { return '暂无历史记录'; }
    if (key === 'saveSummaryFirst') { return '保存会议总结或收藏回答后会出现在这里。'; }
    if (key === 'meetingHistory') { return '会议历史'; }
    if (key === 'answerHistory') { return '回答历史'; }
    if (key === 'meetingSummary') { return '会后总结'; }
    if (key === 'conclusions') { return '核心结论'; }
    if (key === 'decisions') { return '决策事项'; }
    if (key === 'actionItems') { return '待办事项'; }
    if (key === 'unresolved') { return '待确认事项'; }
    if (key === 'saveSummary') { return '保存总结'; }
    if (key === 'savedToHistory') { return '已保存到历史记录'; }
    if (key === 'mockExportText') { return '导出 Mock 文本'; }
    if (key === 'export') { return '导出'; }
    if (key === 'backHome') { return '返回首页'; }
    if (key === 'mockAnswerPreview') { return 'AI 回答预览'; }
    if (key === 'openFullAnswer') { return '查看完整回答'; }
    if (key === 'more') { return '展开'; }
    if (key === 'fold') { return '收起'; }
    if (key === 'close') { return '关闭'; }
    if (key === 'floatingTags') { return '会议辅助 / 低打扰 / Mock AI'; }
    if (key === 'earphoneMock') { return '耳机模拟'; }
    if (key === 'fullAnswer') { return '完整回答'; }
    if (key === 'prepare') { return '准备'; }
    if (key === 'start') { return '开始'; }
    if (key === 'remind') { return '提醒'; }
    if (key === 'stop') { return '停止'; }
    if (key === 'stopped') { return '已停止'; }
    if (key === 'done') { return '完成'; }
    if (key === 'todo') { return '待办'; }
    if (key === 'deviceStatus') { return '设备状态'; }
    if (key === 'testEarphoneMock') { return '测试耳机模拟'; }
    if (key === 'privacy') { return '隐私'; }
    if (key === 'saveTranscriptText') { return '保存转写文本'; }
    if (key === 'saveRawAudioOff') { return '保存原始音频'; }
    if (key === 'cloudAnalysis') { return '云端分析'; }
    if (key === 'localFirst') { return '本地优先'; }
    if (key === 'autoDeleteCycle') { return '自动删除周期：30 天'; }
    if (key === 'clearMeetingRecords') { return '清空会议记录'; }
    if (key === 'confirm') { return '确认'; }
    if (key === 'mockClearOnly') { return '仅模拟清空，不会删除真实数据。'; }
    if (key === 'answerPreference') { return '回答偏好'; }
    if (key === 'answerPreferenceDesc') { return '默认 30 秒、专业语气，并显示来源与风险。'; }
    if (key === 'autoShowFloating') { return '自动显示悬浮回答卡片'; }
    if (key === 'environmentMode') { return '环境模式'; }
    if (key === 'quiet') { return '安静'; }
    if (key === 'noisy') { return '嘈杂'; }
    if (key === 'speech') { return '演示'; }
    if (key === 'languageSettings') { return '语言设置'; }
    if (key === 'languageSettingsDesc') { return '切换后当前页面会立即刷新，并在下次启动时保留。'; }
    if (key === 'chinese') { return '中文'; }
    if (key === 'english') { return '英文'; }
    if (key === 'languageSaved') { return '语言设置已保存'; }
    if (key === 'on') { return '开'; }
    if (key === 'off') { return '关'; }
    if (key === 'question') { return '问题'; }
    if (key === 'appName') { return '会议助手'; }
    if (key === 'appSubtitle') { return '面向 V1.0 的隐私优先 Mock 会议辅助'; }
    if (key === 'privacyPermissions') { return '隐私权限'; }
    if (key === 'micAfterMeetingMode') { return '只有进入会议模式后才会启用麦克风。'; }
    if (key === 'microphone') { return '麦克风'; }
    if (key === 'microphoneReason') { return '用于采集会议语音并生成实时转写。'; }
    if (key === 'calendar') { return '日历'; }
    if (key === 'calendarReason') { return '读取会议日程用于会前准备。'; }
    if (key === 'notification') { return '通知'; }
    if (key === 'notificationReason') { return '发送会议提醒和状态提示。'; }
    if (key === 'files') { return '文件'; }
    if (key === 'filesReason') { return '读取选定的会议材料。'; }
    if (key === 'rules') { return '使用规则'; }
    if (key === 'rulesDesc') { return 'V1.0 使用 Mock 服务，不上传原始音频。'; }
    if (key === 'finishSetup') { return '完成设置'; }
    if (key === 'loadingDashboard') { return '正在加载首页'; }
    if (key === 'loadingDashboardDesc') { return '正在读取会议和设备状态。'; }
    if (key === 'dashboardError') { return '首页加载失败'; }
    if (key === 'dashboardErrorDesc') { return '今日会议加载失败，请重试。'; }
    if (key === 'retry') { return '重试'; }
    if (key === 'reload') { return '重新加载'; }
    if (key === 'noMeetingsToday') { return '今天暂无会议'; }
    if (key === 'noMeetingsTodayDesc') { return 'Mock 服务当前没有可展示的日程。'; }
    if (key === 'loadingPreparation') { return '正在加载会前准备'; }
    if (key === 'loadingPreparationDesc') { return '正在读取会议材料、指标和预测问题。'; }
    if (key === 'preparationError') { return '会前准备加载失败'; }
    if (key === 'preparationErrorDesc') { return '会议准备数据加载失败，请重试。'; }
    if (key === 'noPreparationData') { return '暂无会前准备数据'; }
    if (key === 'noPreparationDataDesc') { return '该会议还没有材料、指标、背景摘要或预测问题。'; }
    if (key === 'startingTranscription') { return '正在启动实时转写'; }
    if (key === 'startingTranscriptionDesc') { return '正在准备会议和转写数据流。'; }
    if (key === 'transcriptionError') { return '实时转写启动失败'; }
    if (key === 'transcriptionErrorDesc') { return '实时转写启动失败，请重试。'; }
    if (key === 'noTranscriptSource') { return '暂无转写内容'; }
    if (key === 'noTranscriptSourceDesc') { return 'Mock 转写服务没有返回该会议的内容。'; }
    if (key === 'transcriptionStopped') { return '转写已停止'; }
    if (key === 'answerGenerated') { return '回答已生成'; }
    if (key === 'answerGenerateFailed') { return '回答生成失败'; }
    if (key === 'generatingAnswer') { return '正在生成回答'; }
    if (key === 'generatingAnswerDesc') { return '正在准备最新 Mock 回答。'; }
    if (key === 'answerError') { return '回答生成失败'; }
    if (key === 'answerErrorDesc') { return '回答加载失败，请重试。'; }
    if (key === 'noAnswerContent') { return '暂无回答内容'; }
    if (key === 'noAnswerContentDesc') { return '回答服务没有返回可展示的观点或依据。'; }
    if (key === 'answerRegenerated') { return '回答已重新生成'; }
    if (key === 'loadingHistory') { return '正在加载历史记录'; }
    if (key === 'loadingHistoryDesc') { return '正在读取已保存的总结和收藏回答。'; }
    if (key === 'historyError') { return '历史记录加载失败'; }
    if (key === 'historyErrorDesc') { return '历史记录加载失败，请重试。'; }
    if (key === 'noMatchingRecords') { return '没有匹配记录'; }
    if (key === 'noMatchingRecordsDesc') { return '当前筛选条件下没有会议总结或收藏回答。'; }
    if (key === 'generatingSummary') { return '正在生成总结'; }
    if (key === 'generatingSummaryDesc') { return '正在读取会议结果并生成 Mock 总结。'; }
    if (key === 'summaryError') { return '总结生成失败'; }
    if (key === 'summaryErrorDesc') { return '会议总结生成失败，请重试。'; }
    if (key === 'noSummaryContent') { return '暂无总结内容'; }
    if (key === 'noSummaryContentDesc') { return '当前没有可展示的结论、决策、待办或待确认事项。'; }
    if (key === 'saveSummaryFailed') { return '总结保存失败'; }
    if (key === 'checkingLogin') { return '正在检查登录状态'; }
    if (key === 'checkingLoginDesc') { return '正在读取本地凭证并恢复用户信息。'; }
    if (key === 'restoreFailed') { return '登录状态恢复失败'; }
    if (key === 'restoreFailedDesc') { return '无法验证当前登录状态，请检查服务后重试。'; }
    if (key === 'loginSubtitle') { return '请先登录后使用会议助手。V1.0 当前支持游客登录。'; }
    if (key === 'guestLogin') { return '游客登录'; }
    if (key === 'huaweiLogin') { return '华为账号登录'; }
    if (key === 'phoneLogin') { return '手机号登录'; }
    if (key === 'phoneNumber') { return '手机号'; }
    if (key === 'smsCode') { return '验证码'; }
    if (key === 'sendCode') { return '发送验证码'; }
    if (key === 'sendingCode') { return '发送中'; }
    if (key === 'loginLoading') { return '登录中'; }
    if (key === 'loginFailed') { return '登录失败，请重试'; }
    if (key === 'loginSucceeded') { return '登录成功'; }
    if (key === 'huaweiReserved') { return '华为账号登录入口已预留，后续接入真实账号能力。'; }
    if (key === 'loginMethodUnavailable') { return '该登录方式暂未开放'; }
    if (key === 'codeSent') { return '验证码已发送'; }
    if (key === 'codeSendFailed') { return '验证码发送失败'; }
    if (key === 'phoneRequired') { return '请输入有效手机号'; }
    if (key === 'codeRequired') { return '请输入验证码'; }
    if (key === 'agreementPlaceholder') { return '我已了解用户协议和隐私政策入口后续补充。'; }
    if (key === 'agreementReserved') { return '当前版本暂不强制协议勾选，状态已预留以便后续接入。'; }
    if (key === 'sessionExpired') { return '登录已失效，请重新登录'; }
    if (key === 'chooseAvatar') { return '选择头像'; }
    if (key === 'uploadingAvatar') { return '上传头像中'; }
    if (key === 'avatarUploaded') { return '头像已更新'; }
    if (key === 'avatarUploadFailed') { return '头像上传失败，已保留原头像'; }
    if (key === 'avatarPreview') { return '头像将上传到后端，资料中只保存头像地址。'; }
    if (key === 'saving') { return '保存中'; }
    if (key === 'loggingOut') { return '退出中'; }
    if (key === 'logoutFailedLocalCleared') { return '网络异常，已清除本地登录状态'; }
    if (key === 'profileLoadFailed') { return '个人资料加载失败'; }
    if (key === 'profileSaveFailed') { return '个人资料保存失败'; }
    if (key === 'pending') { return '待处理'; }
    if (key === 'inProgress') { return '进行中'; }
    if (key === 'completed') { return '已完成'; }
    return key;
  }

  private static en(key: string): string {
    if (key === 'back') { return 'Back'; }
    if (key === 'settings') { return 'Settings'; }
    if (key === 'today') { return 'Today'; }
    if (key === 'dashboard') { return 'Meeting Assistant'; }
    if (key === 'assistant') { return 'Assistant'; }
    if (key === 'history') { return 'History'; }
    if (key === 'mine') { return 'Mine'; }
    if (key === 'editProfile') { return 'Edit profile'; }
    if (key === 'displayName') { return 'Display name'; }
    if (key === 'avatarPath') { return 'Avatar path'; }
    if (key === 'privacySecurity') { return 'Privacy and security'; }
    if (key === 'privacySecurityDesc') { return 'Account, profile, and meeting content are managed through the backend service.'; }
    if (key === 'aboutUs') { return 'About us'; }
    if (key === 'aboutUsDesc') { return 'Meeting Assistant V1.0'; }
    if (key === 'logout') { return 'Log out'; }
    if (key === 'save') { return 'Save'; }
    if (key === 'cancel') { return 'Cancel'; }
    if (key === 'availableNow') { return 'Available now'; }
    if (key === 'nextNameChange') { return 'Next name change:'; }
    if (key === 'nameRequired') { return 'Enter a display name'; }
    if (key === 'profileSaved') { return 'Profile saved'; }
    if (key === 'loggedOut') { return 'Logged out'; }
    if (key === 'todayMeetings') { return 'Today meetings'; }
    if (key === 'mockPhoneEarphoneOnly') { return 'Mock data, phone and earphone only.'; }
    if (key === 'startAdHocMeeting') { return 'Start meeting'; }
    if (key === 'recentRecords') { return 'Recent records'; }
    if (key === 'recentRecordsDesc') { return 'Saved summaries and favorite answers appear in history.'; }
    if (key === 'preparation') { return 'Preparation'; }
    if (key === 'backgroundSummary') { return 'Background summary'; }
    if (key === 'mockData') { return 'Mock data'; }
    if (key === 'keyMetrics') { return 'Key metrics'; }
    if (key === 'materials') { return 'Materials'; }
    if (key === 'predictedQuestions') { return 'Predicted questions'; }
    if (key === 'enterMeetingMode') { return 'Enter meeting mode'; }
    if (key === 'meetingRunningStatus') { return 'Meeting assistant running / microphone active / earphone mock ready / AI mock ready'; }
    if (key === 'resume') { return 'Resume'; }
    if (key === 'pause') { return 'Pause'; }
    if (key === 'play') { return 'Play'; }
    if (key === 'test') { return 'Test'; }
    if (key === 'playing') { return 'Playing'; }
    if (key === 'ready') { return 'Ready'; }
    if (key === 'progress') { return 'Progress'; }
    if (key === 'headphoneNotConnected') { return 'Headphone not connected'; }
    if (key === 'playbackCompleted') { return 'Playback completed'; }
    if (key === 'playbackFailed') { return 'Playback failed'; }
    if (key === 'testPlaybackText') { return 'This is a test playback message.'; }
    if (key === 'transcript') { return 'Transcript'; }
    if (key === 'transcriptSubtitle') { return 'Mock transcript appears step by step.'; }
    if (key === 'questionDetected') { return 'Question detected. You can request an AI-assisted answer.'; }
    if (key === 'actions') { return 'Actions'; }
    if (key === 'helpMeAnswer') { return 'Help me answer'; }
    if (key === 'showFloatingAnswer') { return 'Show floating answer'; }
    if (key === 'aiStream') { return 'AI stream'; }
    if (key === 'preparingAnswer') { return 'Preparing answer'; }
    if (key === 'answerDetail') { return 'Answer detail'; }
    if (key === 'sayNow') { return 'Say now'; }
    if (key === 'duration') { return 'Duration'; }
    if (key === 'tone') { return 'Tone'; }
    if (key === 'keyPointsSection') { return 'Key points'; }
    if (key === 'supportingFacts') { return 'Supporting facts'; }
    if (key === 'risk') { return 'Risk'; }
    if (key === 'mockEarphonePlayback') { return 'Mock earphone playback'; }
    if (key === 'regenerate') { return 'Regenerate'; }
    if (key === 'favorite') { return 'Favorite'; }
    if (key === 'favorited') { return 'Favorited'; }
    if (key === 'saved') { return 'Saved'; }
    if (key === 'verified') { return 'Verified'; }
    if (key === 'check') { return 'Check'; }
    if (key === 'searchPlaceholder') { return 'Search meetings, questions, projects or people'; }
    if (key === 'all') { return 'All'; }
    if (key === 'meetings') { return 'Meetings'; }
    if (key === 'answers') { return 'Answers'; }
    if (key === 'noHistory') { return 'No history'; }
    if (key === 'saveSummaryFirst') { return 'Save a summary or favorite an answer first.'; }
    if (key === 'meetingHistory') { return 'Meeting history'; }
    if (key === 'answerHistory') { return 'Answer history'; }
    if (key === 'meetingSummary') { return 'Meeting summary'; }
    if (key === 'conclusions') { return 'Conclusions'; }
    if (key === 'decisions') { return 'Decisions'; }
    if (key === 'actionItems') { return 'Action items'; }
    if (key === 'unresolved') { return 'Pending confirmations'; }
    if (key === 'saveSummary') { return 'Save summary'; }
    if (key === 'savedToHistory') { return 'Saved to history'; }
    if (key === 'mockExportText') { return 'Mock export text'; }
    if (key === 'export') { return 'Export'; }
    if (key === 'backHome') { return 'Back home'; }
    if (key === 'mockAnswerPreview') { return 'AI answer preview'; }
    if (key === 'openFullAnswer') { return 'Open full answer'; }
    if (key === 'more') { return 'More'; }
    if (key === 'fold') { return 'Fold'; }
    if (key === 'close') { return 'Close'; }
    if (key === 'floatingTags') { return 'Meeting assist / low interruption / Mock AI'; }
    if (key === 'earphoneMock') { return 'Earphone mock'; }
    if (key === 'fullAnswer') { return 'Full answer'; }
    if (key === 'prepare') { return 'Prepare'; }
    if (key === 'start') { return 'Start'; }
    if (key === 'remind') { return 'Remind'; }
    if (key === 'stop') { return 'Stop'; }
    if (key === 'stopped') { return 'Stopped'; }
    if (key === 'done') { return 'Done'; }
    if (key === 'todo') { return 'Todo'; }
    if (key === 'deviceStatus') { return 'Device status'; }
    if (key === 'testEarphoneMock') { return 'Test earphone mock'; }
    if (key === 'privacy') { return 'Privacy'; }
    if (key === 'saveTranscriptText') { return 'Save transcript text'; }
    if (key === 'saveRawAudioOff') { return 'Save raw audio'; }
    if (key === 'cloudAnalysis') { return 'Cloud analysis'; }
    if (key === 'localFirst') { return 'Local first'; }
    if (key === 'autoDeleteCycle') { return 'Auto delete cycle: 30 days'; }
    if (key === 'clearMeetingRecords') { return 'Clear meeting records'; }
    if (key === 'confirm') { return 'Confirm'; }
    if (key === 'mockClearOnly') { return 'Mock clear only. No real data is deleted.'; }
    if (key === 'answerPreference') { return 'Answer preference'; }
    if (key === 'answerPreferenceDesc') { return 'Default 30s / professional tone / show sources and risks.'; }
    if (key === 'autoShowFloating') { return 'Auto show floating answer card'; }
    if (key === 'environmentMode') { return 'Environment mode'; }
    if (key === 'quiet') { return 'Quiet'; }
    if (key === 'noisy') { return 'Noisy'; }
    if (key === 'speech') { return 'Presentation'; }
    if (key === 'languageSettings') { return 'Language settings'; }
    if (key === 'languageSettingsDesc') { return 'Text updates immediately after switching and persists after restart.'; }
    if (key === 'chinese') { return 'Chinese'; }
    if (key === 'english') { return 'English'; }
    if (key === 'languageSaved') { return 'Language setting saved'; }
    if (key === 'on') { return 'On'; }
    if (key === 'off') { return 'Off'; }
    if (key === 'question') { return 'Question'; }
    if (key === 'appName') { return 'Meeting Assistant'; }
    if (key === 'appSubtitle') { return 'Private, mock-first meeting support for V1.0'; }
    if (key === 'privacyPermissions') { return 'Privacy permissions'; }
    if (key === 'micAfterMeetingMode') { return 'Microphone is enabled only after entering meeting mode.'; }
    if (key === 'microphone') { return 'Microphone'; }
    if (key === 'microphoneReason') { return 'Capture meeting speech for live transcript.'; }
    if (key === 'calendar') { return 'Calendar'; }
    if (key === 'calendarReason') { return 'Read scheduled meetings for preparation.'; }
    if (key === 'notification') { return 'Notification'; }
    if (key === 'notificationReason') { return 'Send meeting reminders and status updates.'; }
    if (key === 'files') { return 'Files'; }
    if (key === 'filesReason') { return 'Read selected meeting materials.'; }
    if (key === 'rules') { return 'Rules'; }
    if (key === 'rulesDesc') { return 'V1.0 uses mock services and does not upload raw audio.'; }
    if (key === 'finishSetup') { return 'Finish setup'; }
    if (key === 'loadingDashboard') { return 'Loading dashboard'; }
    if (key === 'loadingDashboardDesc') { return 'Reading meeting and device status.'; }
    if (key === 'dashboardError') { return 'Unable to load dashboard'; }
    if (key === 'dashboardErrorDesc') { return 'Failed to load today meetings. Please retry.'; }
    if (key === 'retry') { return 'Retry'; }
    if (key === 'reload') { return 'Reload'; }
    if (key === 'noMeetingsToday') { return 'No meetings today'; }
    if (key === 'noMeetingsTodayDesc') { return 'The mock service has no scheduled meetings to show.'; }
    if (key === 'loadingPreparation') { return 'Loading preparation'; }
    if (key === 'loadingPreparationDesc') { return 'Reading meeting documents, metrics, and predicted questions.'; }
    if (key === 'preparationError') { return 'Unable to load preparation'; }
    if (key === 'preparationErrorDesc') { return 'Failed to load meeting preparation. Please retry.'; }
    if (key === 'noPreparationData') { return 'No preparation data'; }
    if (key === 'noPreparationDataDesc') { return 'This meeting has no documents, metrics, background notes, or predicted questions yet.'; }
    if (key === 'startingTranscription') { return 'Starting live transcription'; }
    if (key === 'startingTranscriptionDesc') { return 'Preparing the meeting and transcript stream.'; }
    if (key === 'transcriptionError') { return 'Unable to start transcription'; }
    if (key === 'transcriptionErrorDesc') { return 'Failed to start live transcription. Please retry.'; }
    if (key === 'noTranscriptSource') { return 'No transcript source'; }
    if (key === 'noTranscriptSourceDesc') { return 'The mock transcript service returned no content for this meeting.'; }
    if (key === 'transcriptionStopped') { return 'Transcription stopped'; }
    if (key === 'answerGenerated') { return 'Answer generated'; }
    if (key === 'answerGenerateFailed') { return 'Failed to generate answer'; }
    if (key === 'generatingAnswer') { return 'Generating answer'; }
    if (key === 'generatingAnswerDesc') { return 'Preparing the latest mock answer.'; }
    if (key === 'answerError') { return 'Unable to generate answer'; }
    if (key === 'answerErrorDesc') { return 'Failed to load answer. Please retry.'; }
    if (key === 'noAnswerContent') { return 'No answer content'; }
    if (key === 'noAnswerContentDesc') { return 'The answer service returned no usable key points or supporting facts.'; }
    if (key === 'answerRegenerated') { return 'Answer regenerated'; }
    if (key === 'loadingHistory') { return 'Loading history'; }
    if (key === 'loadingHistoryDesc') { return 'Reading saved summaries and favorite answers.'; }
    if (key === 'historyError') { return 'Unable to load history'; }
    if (key === 'historyErrorDesc') { return 'Failed to load history records. Please retry.'; }
    if (key === 'noMatchingRecords') { return 'No matching records'; }
    if (key === 'noMatchingRecordsDesc') { return 'No saved meeting summaries or favorite answers match the current filter.'; }
    if (key === 'generatingSummary') { return 'Generating summary'; }
    if (key === 'generatingSummaryDesc') { return 'Reading the meeting result and building the mock summary.'; }
    if (key === 'summaryError') { return 'Unable to generate summary'; }
    if (key === 'summaryErrorDesc') { return 'Failed to generate meeting summary. Please retry.'; }
    if (key === 'noSummaryContent') { return 'No summary content'; }
    if (key === 'noSummaryContentDesc') { return 'There are no conclusions, decisions, action items, or unresolved questions to show.'; }
    if (key === 'saveSummaryFailed') { return 'Failed to save summary'; }
    if (key === 'checkingLogin') { return 'Checking sign-in'; }
    if (key === 'checkingLoginDesc') { return 'Reading local credentials and restoring user information.'; }
    if (key === 'restoreFailed') { return 'Unable to restore sign-in'; }
    if (key === 'restoreFailedDesc') { return 'Unable to verify the current session. Check the service and retry.'; }
    if (key === 'loginSubtitle') { return 'Sign in before using Meeting Assistant. V1.0 currently supports guest login.'; }
    if (key === 'guestLogin') { return 'Guest login'; }
    if (key === 'huaweiLogin') { return 'Huawei account'; }
    if (key === 'phoneLogin') { return 'Phone login'; }
    if (key === 'phoneNumber') { return 'Phone number'; }
    if (key === 'smsCode') { return 'SMS code'; }
    if (key === 'sendCode') { return 'Send code'; }
    if (key === 'sendingCode') { return 'Sending'; }
    if (key === 'loginLoading') { return 'Signing in'; }
    if (key === 'loginFailed') { return 'Login failed. Please retry.'; }
    if (key === 'loginSucceeded') { return 'Login successful'; }
    if (key === 'huaweiReserved') { return 'Huawei account login is reserved for a later real integration.'; }
    if (key === 'loginMethodUnavailable') { return 'This login method is not open yet.'; }
    if (key === 'codeSent') { return 'Code sent'; }
    if (key === 'codeSendFailed') { return 'Failed to send code'; }
    if (key === 'phoneRequired') { return 'Enter a valid phone number'; }
    if (key === 'codeRequired') { return 'Enter the SMS code'; }
    if (key === 'agreementPlaceholder') { return 'I understand the user agreement and privacy policy entry will be added later.'; }
    if (key === 'agreementReserved') { return 'Agreement confirmation is not enforced in this version; the state is reserved for later integration.'; }
    if (key === 'sessionExpired') { return 'Session expired. Please sign in again.'; }
    if (key === 'chooseAvatar') { return 'Choose avatar'; }
    if (key === 'uploadingAvatar') { return 'Uploading avatar'; }
    if (key === 'avatarUploaded') { return 'Avatar updated'; }
    if (key === 'avatarUploadFailed') { return 'Avatar upload failed. Original avatar kept.'; }
    if (key === 'avatarPreview') { return 'The avatar is uploaded to the backend; only the returned URL is saved in the profile.'; }
    if (key === 'saving') { return 'Saving'; }
    if (key === 'loggingOut') { return 'Logging out'; }
    if (key === 'logoutFailedLocalCleared') { return 'Network error. Local sign-in state cleared.'; }
    if (key === 'profileLoadFailed') { return 'Failed to load profile'; }
    if (key === 'profileSaveFailed') { return 'Failed to save profile'; }
    if (key === 'pending') { return 'Pending'; }
    if (key === 'inProgress') { return 'In progress'; }
    if (key === 'completed') { return 'Completed'; }
    return key;
  }

  static transcriptionState(state: string, language: AppLanguage): string {
    if (state === 'not_started') { return language === 'zh' ? '未开始' : 'Not started'; }
    if (state === 'transcribing') { return language === 'zh' ? '转写中' : 'Transcribing'; }
    if (state === 'paused') { return language === 'zh' ? '已暂停' : 'Paused'; }
    if (state === 'stopped') { return language === 'zh' ? '已停止' : 'Stopped'; }
    return state;
  }

  static answerState(state: string, language: AppLanguage): string {
    if (state === 'generating') { return language === 'zh' ? '生成中' : 'Generating'; }
    if (state === 'ready') { return language === 'zh' ? '已就绪' : 'Ready'; }
    return language === 'zh' ? '空闲' : 'Idle';
  }

  static mode(mode: string, language: AppLanguage): string {
    if (mode === 'quiet') { return I18n.t('quiet', language); }
    if (mode === 'noisy') { return I18n.t('noisy', language); }
    if (mode === 'presentation') { return I18n.t('speech', language); }
    return mode;
  }

  static currentMode(mode: string, language: AppLanguage): string {
    return language === 'zh' ? `当前模式：${I18n.mode(mode, language)}` : `Current mode: ${I18n.mode(mode, language)}`;
  }

  static phoneStatus(ok: boolean, language: AppLanguage): string {
    return ok ? (language === 'zh' ? '手机正常' : 'Phone OK') : (language === 'zh' ? '手机异常' : 'Phone error');
  }

  static earphoneStatus(ok: boolean, language: AppLanguage): string {
    return ok ? (language === 'zh' ? '耳机已连接' : 'Earphone connected') : (language === 'zh' ? '耳机未连接' : 'Earphone disconnected');
  }

  static aiStatus(ok: boolean, language: AppLanguage): string {
    return ok ? (language === 'zh' ? 'AI 就绪' : 'AI OK') : (language === 'zh' ? 'AI 异常' : 'AI error');
  }

  static micStatus(active: boolean, language: AppLanguage): string {
    return active ? (language === 'zh' ? '麦克风可用' : 'Mic active') : (language === 'zh' ? '麦克风未启用' : 'Mic idle');
  }

  static meetingStatus(status: string, language: AppLanguage): string {
    if (status === 'in_progress') { return language === 'zh' ? '进行中' : 'In progress'; }
    if (status === 'completed') { return language === 'zh' ? '已完成' : 'Completed'; }
    if (status === 'cancelled') { return language === 'zh' ? '已取消' : 'Cancelled'; }
    return language === 'zh' ? '待开始' : 'Pending';
  }

  static meetingTitle(id: string, fallback: string | undefined, language: AppLanguage): string {
    if (id === 'product-review') { return language === 'zh' ? '产品方案评审会' : 'Product Plan Review'; }
    if (id === 'weekly-progress') { return language === 'zh' ? '项目周进度会议' : 'Weekly Project Sync'; }
    if (id === 'architecture-discussion') { return language === 'zh' ? '技术架构讨论会' : 'Architecture Discussion'; }
    if (fallback && fallback.length > 0) { return fallback; }
    return language === 'zh' ? '会议' : 'Meeting';
  }

  static meetingLocation(id: string, fallback: string, language: AppLanguage): string {
    if (id === 'product-review') { return language === 'zh' ? '会议室 A' : 'Meeting Room A'; }
    if (id === 'weekly-progress') { return language === 'zh' ? '线上会议' : 'Online meeting'; }
    if (id === 'architecture-discussion') { return language === 'zh' ? '技术部会议室' : 'Engineering meeting room'; }
    return fallback;
  }

  static meetingMeta(meeting: Meeting, language: AppLanguage): string {
    const count: number = meeting.participants ? meeting.participants.length : 0;
    const goal: string = I18n.meetingGoal(meeting.id, meeting.goal, language);
    return language === 'zh' ? `${count} 位参会人 / ${goal}` : `${count} attendees / ${goal}`;
  }

  static meetingGoal(id: string, fallback: string, language: AppLanguage): string {
    if (id === 'product-review') { return language === 'zh' ? '评审 Q3 产品路线图' : 'Review the Q3 product roadmap'; }
    if (id === 'weekly-progress') { return language === 'zh' ? '同步项目进度和风险' : 'Sync project progress and risks'; }
    if (id === 'architecture-discussion') { return language === 'zh' ? '讨论微服务拆分方案' : 'Discuss the microservice split plan'; }
    return fallback;
  }

  static backgroundSummary(meetingId: string, language: AppLanguage): string[] {
    if (language === 'zh') {
      return [
        '手机端 MVP 闭环是当前 V1 的重点。',
        '真实 ASR 与 LLM 能力保留在服务接口之后。',
        '当前演示版本使用 Mock 数据。'
      ];
    }
    return [
      'The phone-side MVP loop is the current V1 focus.',
      'Real ASR and LLM are reserved behind service interfaces.',
      'Mock data is used for the current demo build.'
    ];
  }

  static keyMetricLine(name: string, value: number, unit: string | undefined, language: AppLanguage): string {
    let label: string = name;
    if (name === 'Completion') { label = language === 'zh' ? '完成率' : 'Completion'; }
    if (name === 'New tasks') { label = language === 'zh' ? '新增任务' : 'New tasks'; }
    if (name === 'Open risks') { label = language === 'zh' ? '开放风险' : 'Open risks'; }
    return `${label}: ${value}${unit || ''}`;
  }

  static documentLine(doc: MeetingDocument, language: AppLanguage): string {
    let title: string = doc.title;
    let source: string = doc.source;
    let summary: string = doc.summary;
    if (doc.id === 'doc-1') {
      title = language === 'zh' ? 'Q3 产品路线图草案' : 'Q3 Product Roadmap Draft';
      source = language === 'zh' ? '内部文档' : 'Internal document';
      summary = language === 'zh' ? '描述 Q3 产品功能规划和时间节点。' : 'Describes Q3 product scope and milestones.';
    }
    if (doc.id === 'doc-2') {
      title = language === 'zh' ? '技术架构设计文档' : 'Technical Architecture Design';
      source = language === 'zh' ? '技术部' : 'Engineering';
      summary = language === 'zh' ? '微服务架构拆分方案和 API 设计。' : 'Microservice split plan and API design.';
    }
    if (doc.id === 'doc-3') {
      title = language === 'zh' ? '项目周报' : 'Project Weekly Report';
      source = language === 'zh' ? '项目管理' : 'Project management';
      summary = language === 'zh' ? '本周开发进度、风险和下周计划。' : 'Progress, risks, and next-week plan.';
    }
    if (doc.id === 'doc-4') {
      title = language === 'zh' ? '架构评审会议纪要' : 'Architecture Review Minutes';
      source = language === 'zh' ? '上次会议' : 'Previous meeting';
      summary = language === 'zh' ? '上次架构讨论的结论和待办。' : 'Conclusions and actions from the last architecture review.';
    }
    return `${title} / ${source} / ${doc.lastUpdated} / ${summary}`;
  }

  static questionLine(question: PredictedQuestion, language: AppLanguage): string {
    let text: string = question.question;
    if (question.id === 'q1') { text = language === 'zh' ? '当前项目进度是否符合预期？' : 'Is the current project progress on track?'; }
    if (question.id === 'q2') { text = language === 'zh' ? '最大的技术风险是什么？' : 'What is the biggest technical risk?'; }
    if (question.id === 'q3') { text = language === 'zh' ? '资源分配是否需要调整？' : 'Does resource allocation need adjustment?'; }
    if (question.id === 'q4') { text = language === 'zh' ? '本周有哪些关键进展？' : 'What were the key updates this week?'; }
    if (question.id === 'q5') { text = language === 'zh' ? '微服务拆分方案是否可行？' : 'Is the microservice split plan feasible?'; }
    return `${question.priority}: ${text}`;
  }

  static transcriptSpeaker(item: TranscriptItem, language: AppLanguage): string {
    if (item.speaker === 'Manager Wang') { return language === 'zh' ? '王经理' : 'Manager Wang'; }
    if (item.speaker === 'Engineer Chen') { return language === 'zh' ? '陈工' : 'Engineer Chen'; }
    if (item.speaker === 'System') { return language === 'zh' ? '系统' : 'System'; }
    if (item.speaker === 'User') { return language === 'zh' ? '我' : 'User'; }
    return item.speaker;
  }

  static transcriptContent(item: TranscriptItem, language: AppLanguage): string {
    if (language === 'en') { return item.content; }
    if (item.id === 't-1') { return '今天需要确认 V1 范围和手机端演示闭环。'; }
    if (item.id === 't-2') { return '会前准备、实时转写和会后总结已经拆成服务接口。'; }
    if (item.id === 't-3') { return '整体开发进度现在处于什么阶段？'; }
    if (item.id === 't-4') { return '已检测到问题，等待用户生成辅助回答。'; }
    if (item.id === 't-5') { return '我们会先完成手机端演示路径，再逐步替换 Mock 服务。'; }
    return item.content;
  }

  static answer(answer: AnswerBundle, language: AppLanguage): AnswerBundle {
    if (answer.id !== 'answer-main' && answer.id !== 'answer-risk' && answer.id !== 'answer-architecture') {
      return answer;
    }
    const facts: SupportingFact[] = [
      {
        id: `${answer.id}-fact-1`,
        content: language === 'zh' ? '当前完成率：85%' : 'Current completion: 85%',
        source: language === 'zh' ? '项目管理系统' : 'Project system',
        updatedAt: '2026-07-22',
        confidence: 'high',
        verified: true
      },
      {
        id: `${answer.id}-fact-2`,
        content: language === 'zh' ? '本周新增任务：12 个' : 'New tasks this week: 12',
        source: language === 'zh' ? '周报' : 'Weekly report',
        updatedAt: '2026-07-22',
        confidence: 'medium',
        verified: true
      },
      {
        id: `${answer.id}-fact-3`,
        content: language === 'zh' ? '高风险事项：2 个' : 'High-risk items: 2',
        source: language === 'zh' ? '风险登记表' : 'Risk register',
        updatedAt: '2026-07-22',
        confidence: 'high',
        verified: true
      }
    ];
    return {
      id: answer.id,
      meetingId: answer.meetingId,
      questionId: answer.questionId,
      transcriptItemId: answer.transcriptItemId,
      question: I18n.answerQuestion(language),
      stages: answer.stages,
      durationMode: answer.durationMode,
      tone: answer.tone,
      createdAt: answer.createdAt,
      isFavorite: answer.isFavorite,
      keyPoints: language === 'zh' ? [
        '项目进度整体符合预期，但需要持续跟进技术风险。',
        '团队协作效率有提升空间。',
        '下周重点关注交付质量和接口替换边界。'
      ] : [
        'The project is broadly on track, with technical risks still requiring attention.',
        'Team collaboration efficiency can still improve.',
        'Next week should focus on delivery quality and service replacement boundaries.'
      ],
      supportingFacts: facts,
      riskWarnings: language === 'zh' ? [
        '第三方依赖可能延期交付，需要提前确认。',
        '测试环境资源紧张，需要协调排期。'
      ] : [
        'Third-party dependencies may slip and need early confirmation.',
        'Test environment capacity is tight and needs scheduling coordination.'
      ],
      immediateAnswer: language === 'zh'
        ? '基于当前数据，我建议这样回答：项目进度整体符合预期，手机端 MVP 闭环已进入收尾阶段；接下来会重点控制服务替换、测试环境和第三方依赖风险。'
        : 'Based on the current data, I would answer: the project is broadly on track, and the phone-side MVP loop is in its final phase. Next, we will focus on service replacement, test environment capacity, and third-party dependency risks.',
      transitionSentence: I18n.answerTransition(answer.tone, language)
    };
  }

  static answerQuestion(language: AppLanguage): string {
    return language === 'zh' ? '当前开发进度如何？' : 'What is the current development progress?';
  }

  static toneLabel(tone: AnswerTone, language: AppLanguage): string {
    if (tone === 'concise') { return language === 'zh' ? '简洁' : 'Concise'; }
    if (tone === 'polite') { return language === 'zh' ? '委婉' : 'Polite'; }
    if (tone === 'assertive') { return language === 'zh' ? '强势' : 'Assertive'; }
    return language === 'zh' ? '专业' : 'Professional';
  }

  static answerStreamParts(answer: AnswerBundle, language: AppLanguage): string[] {
    const display: AnswerBundle = I18n.answer(answer, language);
    const parts: string[] = [I18n.t('preparingAnswer', language), display.transitionSentence || '', display.immediateAnswer];
    display.keyPoints.forEach((point: string): void => {
      parts.push(point);
    });
    if (display.supportingFacts.length > 0) { parts.push(display.supportingFacts[0].content); }
    if (display.riskWarnings.length > 0) { parts.push(display.riskWarnings[0]); }
    return parts;
  }

  static summary(summary: MeetingSummary, language: AppLanguage): MeetingSummary {
    return {
      id: summary.id,
      meetingId: summary.meetingId,
      meetingTitle: I18n.meetingTitle(summary.meetingId, summary.meetingTitle, language),
      date: summary.date,
      startTime: summary.startTime,
      endTime: summary.endTime,
      duration: language === 'zh' ? '60 分钟' : '60 minutes',
      attendees: language === 'zh' ? ['王经理', '陈工', '我'] : ['Manager Wang', 'Engineer Chen', 'User'],
      coreConclusions: language === 'zh' ? [
        'V1 优先完成手机端演示闭环。',
        '真实能力继续保留在可替换的服务接口之后。',
        'Mock 数据需要在界面中明确表达。'
      ] : [
        'V1 prioritizes a complete phone-side demo loop.',
        'Real capabilities remain behind replaceable service interfaces.',
        'Mock data must be presented clearly in the UI.'
      ],
      conclusions: language === 'zh' ? [
        'V1 优先完成手机端演示闭环。',
        '真实能力继续保留在可替换的服务接口之后。'
      ] : [
        'V1 prioritizes a complete phone-side demo loop.',
        'Real capabilities remain behind replaceable service interfaces.'
      ],
      decisions: language === 'zh' ? [
        { item: 'V1 范围聚焦手机端文字提示闭环。', owner: '产品', deadline: '2026-07-29' },
        { item: '在服务层保留 ASR 与 LLM 替换点。', owner: '研发', deadline: '2026-08-05' }
      ] : [
        { item: 'Keep V1 scope focused on the phone-side text prompt loop.', owner: 'Product', deadline: '2026-07-29' },
        { item: 'Reserve ASR and LLM replacement points in services.', owner: 'Engineering', deadline: '2026-08-05' }
      ],
      todoItems: language === 'zh' ? [
        { task: '验证实时转写暂停和恢复流程。', assignee: '研发', priority: 'high', status: 'pending' },
        { task: '复核回答详情页文案。', assignee: '产品', priority: 'medium', status: 'pending' }
      ] : [
        { task: 'Verify live transcript pause and resume flow.', assignee: 'Engineering', priority: 'high', status: 'pending' },
        { task: 'Review answer detail copy.', assignee: 'Product', priority: 'medium', status: 'pending' }
      ],
      pendingConfirmations: language === 'zh' ? [
        '真实 ASR SDK API',
        'LLM 服务集成边界'
      ] : [
        'Real ASR SDK API',
        'LLM service integration boundary'
      ],
      aiAssistedRecords: language === 'zh' ? [
        { question: '当前开发进度如何？', answer: '手机端 MVP 闭环是当前优先级。', timestamp: '2026-07-23T09:45:00' }
      ] : [
        { question: 'What is the current development progress?', answer: 'The phone-side MVP loop is the current priority.', timestamp: '2026-07-23T09:45:00' }
      ],
      createdAt: summary.createdAt,
      aiAssistCount: summary.aiAssistCount,
      answers: summary.answers,
      actionItems: summary.actionItems
    };
  }

  static summaryMeta(summary: MeetingSummary, language: AppLanguage): string {
    const title: string = I18n.meetingTitle(summary.meetingId, summary.meetingTitle, language);
    const date: string = summary.date || summary.createdAt;
    const duration: string = summary.duration || '';
    const count: number = summary.aiAssistCount || summary.aiAssistedRecords.length;
    return language === 'zh' ? `${title} / ${date} / ${duration} / AI ${count} 次` : `${title} / ${date} / ${duration} / AI ${count}`;
  }

  static historySummaryLine(summary: MeetingSummary, language: AppLanguage): string {
    const title: string = I18n.meetingTitle(summary.meetingId, summary.meetingTitle, language);
    const count: number = I18n.summary(summary, language).coreConclusions.length;
    return language === 'zh' ? `${title} / ${summary.createdAt} / ${count} 条结论` : `${title} / ${summary.createdAt} / ${count} conclusions`;
  }

  static actionPriority(priority: string, language: AppLanguage): string {
    if (priority === 'high') { return language === 'zh' ? '高' : 'High'; }
    if (priority === 'medium') { return language === 'zh' ? '中' : 'Medium'; }
    if (priority === 'low') { return language === 'zh' ? '低' : 'Low'; }
    return priority;
  }

  static todoStatus(status: string, language: AppLanguage): string {
    if (status === 'in_progress') { return I18n.t('inProgress', language); }
    if (status === 'completed') { return I18n.t('completed', language); }
    return I18n.t('pending', language);
  }

  static riskPrefix(language: AppLanguage): string {
    return language === 'zh' ? '风险：' : 'Risk: ';
  }

  static playbackMessage(text: string, language: AppLanguage): string {
    return language === 'zh' ? `模拟播放：${text}` : `Mock playback: ${text}`;
  }

  static testPlaybackMessage(language: AppLanguage): string {
    return language === 'zh' ? '耳机模拟播放测试完成' : 'Earphone mock playback test complete';
  }

  private static answerTransition(tone: AnswerTone, language: AppLanguage): string {
    if (tone === 'concise') { return language === 'zh' ? '简短结论：先完成闭环，再推进集成。' : 'Short answer: close the loop first, then integrate.'; }
    if (tone === 'polite') { return language === 'zh' ? '我建议先说明当前范围，再补充后续计划。' : 'I suggest explaining the current scope first, then the next steps.'; }
    if (tone === 'assertive') { return language === 'zh' ? '结论很明确：优先稳定手机端闭环。' : 'The conclusion is clear: stabilize the phone-side loop first.'; }
    return language === 'zh' ? '可以从闭环进度、服务边界和风险控制三点回答。' : 'Answer from closed-loop progress, service boundaries, and risk control.';
  }
}
