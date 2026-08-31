import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AyahPath'**
  String get appName;

  /// No description provided for @checkingForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// No description provided for @preparingJourney.
  ///
  /// In en, this message translates to:
  /// **'Preparing your journey...'**
  String get preparingJourney;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// No description provided for @downloadUpdate.
  ///
  /// In en, this message translates to:
  /// **'Download Update'**
  String get downloadUpdate;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'An important update is available. Please download and install the latest version to continue using AyahPath.'**
  String get updateRequiredMessage;

  /// No description provided for @skillReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get skillReading;

  /// No description provided for @skillTajweed.
  ///
  /// In en, this message translates to:
  /// **'Tajweed'**
  String get skillTajweed;

  /// No description provided for @skillMemorization.
  ///
  /// In en, this message translates to:
  /// **'Memorization'**
  String get skillMemorization;

  /// No description provided for @skillRevision.
  ///
  /// In en, this message translates to:
  /// **'Revision'**
  String get skillRevision;

  /// No description provided for @skillComprehension.
  ///
  /// In en, this message translates to:
  /// **'Comprehension'**
  String get skillComprehension;

  /// No description provided for @skillFluency.
  ///
  /// In en, this message translates to:
  /// **'Fluency'**
  String get skillFluency;

  /// No description provided for @skillReadingDesc.
  ///
  /// In en, this message translates to:
  /// **'Read Arabic and Quranic text fluently'**
  String get skillReadingDesc;

  /// No description provided for @skillTajweedDesc.
  ///
  /// In en, this message translates to:
  /// **'Apply the rules of correct recitation'**
  String get skillTajweedDesc;

  /// No description provided for @skillMemorizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Commit ayahs and surahs to memory (Hifz)'**
  String get skillMemorizationDesc;

  /// No description provided for @skillRevisionDesc.
  ///
  /// In en, this message translates to:
  /// **'Retain and review memorized Qur’an'**
  String get skillRevisionDesc;

  /// No description provided for @skillComprehensionDesc.
  ///
  /// In en, this message translates to:
  /// **'Understand vocabulary and meaning'**
  String get skillComprehensionDesc;

  /// No description provided for @skillFluencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Read with natural pacing and flow'**
  String get skillFluencyDesc;

  /// No description provided for @stepReadingWarmup.
  ///
  /// In en, this message translates to:
  /// **'Reading warm-up'**
  String get stepReadingWarmup;

  /// No description provided for @stepTajweedPractice.
  ///
  /// In en, this message translates to:
  /// **'Tajweed practice'**
  String get stepTajweedPractice;

  /// No description provided for @stepQuranReading.
  ///
  /// In en, this message translates to:
  /// **'Qur’an reading'**
  String get stepQuranReading;

  /// No description provided for @stepMemorization.
  ///
  /// In en, this message translates to:
  /// **'Memorization'**
  String get stepMemorization;

  /// No description provided for @stepRevision.
  ///
  /// In en, this message translates to:
  /// **'Revision'**
  String get stepRevision;

  /// No description provided for @stepComprehension.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary & meaning'**
  String get stepComprehension;

  /// No description provided for @stepAssessment.
  ///
  /// In en, this message translates to:
  /// **'Short assessment'**
  String get stepAssessment;

  /// No description provided for @phaseListenRepeat.
  ///
  /// In en, this message translates to:
  /// **'Listen & Repeat'**
  String get phaseListenRepeat;

  /// No description provided for @phaseReadAlone.
  ///
  /// In en, this message translates to:
  /// **'Read Alone'**
  String get phaseReadAlone;

  /// No description provided for @phaseAiTest.
  ///
  /// In en, this message translates to:
  /// **'AI Recitation Test'**
  String get phaseAiTest;

  /// No description provided for @phaseTranslationStudy.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get phaseTranslationStudy;

  /// No description provided for @phaseListenRepeatDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen carefully and repeat after each ayah'**
  String get phaseListenRepeatDesc;

  /// No description provided for @phaseReadAloneDesc.
  ///
  /// In en, this message translates to:
  /// **'Read the ayahs from memory'**
  String get phaseReadAloneDesc;

  /// No description provided for @phaseAiTestDesc.
  ///
  /// In en, this message translates to:
  /// **'Recite without looking — AI analyzes your voice'**
  String get phaseAiTestDesc;

  /// No description provided for @phaseTranslationStudyDesc.
  ///
  /// In en, this message translates to:
  /// **'Understand the translation and key words'**
  String get phaseTranslationStudyDesc;

  /// No description provided for @goalReadQuran.
  ///
  /// In en, this message translates to:
  /// **'Learn to read the Qur’an'**
  String get goalReadQuran;

  /// No description provided for @goalImproveReading.
  ///
  /// In en, this message translates to:
  /// **'Improve reading'**
  String get goalImproveReading;

  /// No description provided for @goalTajweed.
  ///
  /// In en, this message translates to:
  /// **'Learn Tajweed'**
  String get goalTajweed;

  /// No description provided for @goalMemorize.
  ///
  /// In en, this message translates to:
  /// **'Memorize the Qur’an'**
  String get goalMemorize;

  /// No description provided for @goalRevise.
  ///
  /// In en, this message translates to:
  /// **'Revise memorized Qur’an'**
  String get goalRevise;

  /// No description provided for @goalVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Understand vocabulary'**
  String get goalVocabulary;

  /// No description provided for @goalSelectedSurahs.
  ///
  /// In en, this message translates to:
  /// **'Learn selected Surahs'**
  String get goalSelectedSurahs;

  /// No description provided for @goalRegularStudy.
  ///
  /// In en, this message translates to:
  /// **'Regular Qur’an study'**
  String get goalRegularStudy;

  /// No description provided for @goalReadQuranSub.
  ///
  /// In en, this message translates to:
  /// **'Start from the Arabic letters'**
  String get goalReadQuranSub;

  /// No description provided for @goalImproveReadingSub.
  ///
  /// In en, this message translates to:
  /// **'Read more fluently'**
  String get goalImproveReadingSub;

  /// No description provided for @goalTajweedSub.
  ///
  /// In en, this message translates to:
  /// **'Master the rules of correct recitation'**
  String get goalTajweedSub;

  /// No description provided for @goalMemorizeSub.
  ///
  /// In en, this message translates to:
  /// **'Begin or advance your Hifz'**
  String get goalMemorizeSub;

  /// No description provided for @goalReviseSub.
  ///
  /// In en, this message translates to:
  /// **'Strengthen what you already know'**
  String get goalReviseSub;

  /// No description provided for @goalVocabularySub.
  ///
  /// In en, this message translates to:
  /// **'Learn meanings and key words'**
  String get goalVocabularySub;

  /// No description provided for @goalSelectedSurahsSub.
  ///
  /// In en, this message translates to:
  /// **'Focus on specific surahs'**
  String get goalSelectedSurahsSub;

  /// No description provided for @goalRegularStudySub.
  ///
  /// In en, this message translates to:
  /// **'Build a daily habit'**
  String get goalRegularStudySub;

  /// No description provided for @readingBeginner.
  ///
  /// In en, this message translates to:
  /// **'I’m a complete beginner'**
  String get readingBeginner;

  /// No description provided for @readingLetters.
  ///
  /// In en, this message translates to:
  /// **'I know the letters'**
  String get readingLetters;

  /// No description provided for @readingWords.
  ///
  /// In en, this message translates to:
  /// **'I can read words'**
  String get readingWords;

  /// No description provided for @readingFluent.
  ///
  /// In en, this message translates to:
  /// **'I can read fluently'**
  String get readingFluent;

  /// No description provided for @readingBeginnerSub.
  ///
  /// In en, this message translates to:
  /// **'I don’t read Arabic yet'**
  String get readingBeginnerSub;

  /// No description provided for @readingLettersSub.
  ///
  /// In en, this message translates to:
  /// **'But can’t read connected words yet'**
  String get readingLettersSub;

  /// No description provided for @readingWordsSub.
  ///
  /// In en, this message translates to:
  /// **'Slowly, with effort'**
  String get readingWordsSub;

  /// No description provided for @readingFluentSub.
  ///
  /// In en, this message translates to:
  /// **'Quranic text, with or without harakat'**
  String get readingFluentSub;

  /// No description provided for @tajweedNone.
  ///
  /// In en, this message translates to:
  /// **'I don’t know it'**
  String get tajweedNone;

  /// No description provided for @tajweedBasics.
  ///
  /// In en, this message translates to:
  /// **'I know the basics'**
  String get tajweedBasics;

  /// No description provided for @tajweedGood.
  ///
  /// In en, this message translates to:
  /// **'I’ve studied it'**
  String get tajweedGood;

  /// No description provided for @tajweedStrong.
  ///
  /// In en, this message translates to:
  /// **'I’m quite strong'**
  String get tajweedStrong;

  /// No description provided for @tajweedBasicsSub.
  ///
  /// In en, this message translates to:
  /// **'Letters, madd, etc.'**
  String get tajweedBasicsSub;

  /// No description provided for @tajweedGoodSub.
  ///
  /// In en, this message translates to:
  /// **'I can apply most rules'**
  String get tajweedGoodSub;

  /// No description provided for @tajweedStrongSub.
  ///
  /// In en, this message translates to:
  /// **'Minor gaps only'**
  String get tajweedStrongSub;

  /// No description provided for @memNone.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get memNone;

  /// No description provided for @memALittle.
  ///
  /// In en, this message translates to:
  /// **'A few surahs'**
  String get memALittle;

  /// No description provided for @memSome.
  ///
  /// In en, this message translates to:
  /// **'Part of the Qur’an'**
  String get memSome;

  /// No description provided for @memSubstantial.
  ///
  /// In en, this message translates to:
  /// **'A substantial amount'**
  String get memSubstantial;

  /// No description provided for @memLots.
  ///
  /// In en, this message translates to:
  /// **'Most or all'**
  String get memLots;

  /// No description provided for @memALittleSub.
  ///
  /// In en, this message translates to:
  /// **'e.g. the short ones'**
  String get memALittleSub;

  /// No description provided for @memSomeSub.
  ///
  /// In en, this message translates to:
  /// **'e.g. some juz'**
  String get memSomeSub;

  /// No description provided for @memSubstantialSub.
  ///
  /// In en, this message translates to:
  /// **'A juz or more'**
  String get memSubstantialSub;

  /// No description provided for @memLotsSub.
  ///
  /// In en, this message translates to:
  /// **'Nearly complete Hifz'**
  String get memLotsSub;

  /// No description provided for @freqDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get freqDaily;

  /// No description provided for @freqFewTimesWeek.
  ///
  /// In en, this message translates to:
  /// **'3–4 times a week'**
  String get freqFewTimesWeek;

  /// No description provided for @freqWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get freqWeekly;

  /// No description provided for @freqOccasional.
  ///
  /// In en, this message translates to:
  /// **'Occasionally'**
  String get freqOccasional;

  /// No description provided for @partLabel.
  ///
  /// In en, this message translates to:
  /// **'Part'**
  String get partLabel;

  /// No description provided for @learnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Quran'**
  String get learnTitle;

  /// No description provided for @learnFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get learnFilterAll;

  /// No description provided for @learnFilterShort.
  ///
  /// In en, this message translates to:
  /// **'Short (1-7)'**
  String get learnFilterShort;

  /// No description provided for @learnFilterMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium (8-30)'**
  String get learnFilterMedium;

  /// No description provided for @learnFilterLong.
  ///
  /// In en, this message translates to:
  /// **'Long (30+)'**
  String get learnFilterLong;

  /// No description provided for @learnNoResults.
  ///
  /// In en, this message translates to:
  /// **'No surahs match this filter.'**
  String get learnNoResults;

  /// No description provided for @learnLessonParts.
  ///
  /// In en, this message translates to:
  /// **'Lesson Parts'**
  String get learnLessonParts;

  /// No description provided for @learnComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get learnComplete;

  /// No description provided for @learnStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get learnStart;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'AyahPath'**
  String get loginTitle;

  /// No description provided for @loginSubtitleCreate.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get loginSubtitleCreate;

  /// No description provided for @loginSubtitleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitleSignIn;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccount;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignIn;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get loginOr;

  /// No description provided for @loginContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginContinueWithGoogle;

  /// No description provided for @loginSwitchToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get loginSwitchToSignIn;

  /// No description provided for @loginSwitchToSignUp.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get loginSwitchToSignUp;

  /// No description provided for @loginPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Your recitation audio is analyzed on-device. Account data (profile & progress) is stored securely online for syncing.'**
  String get loginPrivacyNotice;

  /// No description provided for @loginConsentAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get loginConsentAgree;

  /// No description provided for @loginConsentTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get loginConsentTerms;

  /// No description provided for @loginConsentAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get loginConsentAnd;

  /// No description provided for @loginConsentPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get loginConsentPrivacy;

  /// No description provided for @loginConsentRequired.
  ///
  /// In en, this message translates to:
  /// **' required to use AyahPath.'**
  String get loginConsentRequired;

  /// No description provided for @loginErrorAgreeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms of Service and Privacy Policy to continue.'**
  String get loginErrorAgreeRequired;

  /// No description provided for @loginErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please check your connection and try again.'**
  String get loginErrorGeneric;

  /// No description provided for @loginErrorGoogleFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please check your connection and try again.'**
  String get loginErrorGoogleFailed;

  /// No description provided for @loginErrorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address first.'**
  String get loginErrorEnterEmail;

  /// No description provided for @loginSnackResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent if that account exists.'**
  String get loginSnackResetSent;

  /// No description provided for @loginSnackResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send a reset email. Please try again.'**
  String get loginSnackResetFailed;

  /// No description provided for @loginErrorIncorrectCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get loginErrorIncorrectCredentials;

  /// No description provided for @loginErrorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get loginErrorUserDisabled;

  /// No description provided for @loginErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get loginErrorEmailInUse;

  /// No description provided for @loginErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get loginErrorInvalidEmail;

  /// No description provided for @loginErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get loginErrorWeakPassword;

  /// No description provided for @loginErrorMethodNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not enabled.'**
  String get loginErrorMethodNotAllowed;

  /// No description provided for @loginErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait and try again.'**
  String get loginErrorTooManyRequests;

  /// No description provided for @loginErrorAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get loginErrorAuthFailed;

  /// No description provided for @loginValidatorEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get loginValidatorEmail;

  /// No description provided for @loginValidatorPassword.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get loginValidatorPassword;

  /// No description provided for @modelTitle.
  ///
  /// In en, this message translates to:
  /// **'Model Manager'**
  String get modelTitle;

  /// No description provided for @modelOnDeviceModel.
  ///
  /// In en, this message translates to:
  /// **'On-device recitation model'**
  String get modelOnDeviceModel;

  /// No description provided for @modelOnDeviceBody.
  ///
  /// In en, this message translates to:
  /// **'AyahPath uses the Tarteel AI model — a speech model fine-tuned on Quran recitation — bundled inside the app. It runs fully on-device: your voice never leaves the phone, and no download is required.'**
  String get modelOnDeviceBody;

  /// No description provided for @modelStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get modelStorage;

  /// No description provided for @modelRecitationModel.
  ///
  /// In en, this message translates to:
  /// **'Recitation model'**
  String get modelRecitationModel;

  /// No description provided for @modelIncludedSpace.
  ///
  /// In en, this message translates to:
  /// **'Included in the app — no extra space is downloaded at runtime.'**
  String get modelIncludedSpace;

  /// No description provided for @modelHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get modelHowItWorks;

  /// No description provided for @modelMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get modelMicrophone;

  /// No description provided for @modelCapturedLocally.
  ///
  /// In en, this message translates to:
  /// **'→ captured locally'**
  String get modelCapturedLocally;

  /// No description provided for @modelTarteelModel.
  ///
  /// In en, this message translates to:
  /// **'Tarteel AI model'**
  String get modelTarteelModel;

  /// No description provided for @modelSpeechToText.
  ///
  /// In en, this message translates to:
  /// **'→ speech-to-text on-device'**
  String get modelSpeechToText;

  /// No description provided for @modelAyahMatcher.
  ///
  /// In en, this message translates to:
  /// **'Ayah matcher'**
  String get modelAyahMatcher;

  /// No description provided for @modelCompareRecitation.
  ///
  /// In en, this message translates to:
  /// **'→ compare with the recitation'**
  String get modelCompareRecitation;

  /// No description provided for @modelAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get modelAnalysis;

  /// No description provided for @modelAssistiveFeedback.
  ///
  /// In en, this message translates to:
  /// **'→ assistive feedback'**
  String get modelAssistiveFeedback;

  /// No description provided for @modelCredits.
  ///
  /// In en, this message translates to:
  /// **'Credits: The Tarteel AI model is an Apache-2.0 checkpoint distributed by tarteel-ai on Hugging Face, fine-tuned from OpenAI Whisper on Quran recitation. It is run locally by the whisper.cpp engine (MIT).'**
  String get modelCredits;

  /// No description provided for @modelInstalledTitle.
  ///
  /// In en, this message translates to:
  /// **'Tarteel AI — Quran recitation (Q8_0)'**
  String get modelInstalledTitle;

  /// No description provided for @modelBundledReady.
  ///
  /// In en, this message translates to:
  /// **'✓ Bundled & ready'**
  String get modelBundledReady;

  /// No description provided for @modelFullyOffline.
  ///
  /// In en, this message translates to:
  /// **'✓ Fully offline'**
  String get modelFullyOffline;

  /// No description provided for @modelPrivacyFirst.
  ///
  /// In en, this message translates to:
  /// **'✓ Privacy-first (no upload)'**
  String get modelPrivacyFirst;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navQuran.
  ///
  /// In en, this message translates to:
  /// **'Qur\'an'**
  String get navQuran;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homePeacefulGuidance.
  ///
  /// In en, this message translates to:
  /// **'Peaceful daily guidance'**
  String get homePeacefulGuidance;

  /// No description provided for @homeContinueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue your learning'**
  String get homeContinueLearning;

  /// No description provided for @homeTodayLesson.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Lesson'**
  String get homeTodayLesson;

  /// No description provided for @homeStartLesson.
  ///
  /// In en, this message translates to:
  /// **'Start Lesson'**
  String get homeStartLesson;

  /// No description provided for @homeYourSkills.
  ///
  /// In en, this message translates to:
  /// **'Your skills'**
  String get homeYourSkills;

  /// No description provided for @homeRecommendedPractice.
  ///
  /// In en, this message translates to:
  /// **'Recommended practice'**
  String get homeRecommendedPractice;

  /// No description provided for @homeCurrentJourney.
  ///
  /// In en, this message translates to:
  /// **'Current journey'**
  String get homeCurrentJourney;

  /// No description provided for @homeReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get homeReading;

  /// No description provided for @homeTajweed.
  ///
  /// In en, this message translates to:
  /// **'Tajweed'**
  String get homeTajweed;

  /// No description provided for @homeMemorization.
  ///
  /// In en, this message translates to:
  /// **'Memorization'**
  String get homeMemorization;

  /// No description provided for @homePracticeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A short focused session will help most.'**
  String get homePracticeSubtitle;

  /// No description provided for @homeReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Due for spaced revision today.'**
  String get homeReviewSubtitle;

  /// No description provided for @homeContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue your reading'**
  String get homeContinueReading;

  /// No description provided for @homeContinueReadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick up where you left off at a gentle pace.'**
  String get homeContinueReadingSubtitle;

  /// No description provided for @homeJourneyProgress.
  ///
  /// In en, this message translates to:
  /// **'Journey progress'**
  String get homeJourneyProgress;

  /// No description provided for @obBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get obBack;

  /// No description provided for @obWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AyahPath'**
  String get obWelcomeTitle;

  /// No description provided for @obWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'AyahPath learns how you learn. It will assess where you are, build a personalized plan, listen to your reading on-device, and adapt every lesson to your progress.'**
  String get obWelcomeDesc;

  /// No description provided for @obBeginJourney.
  ///
  /// In en, this message translates to:
  /// **'Begin my journey'**
  String get obBeginJourney;

  /// No description provided for @obLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get obLanguageTitle;

  /// No description provided for @obLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AyahPath will use this language for the interface.'**
  String get obLanguageSubtitle;

  /// No description provided for @obLangEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get obLangEnglish;

  /// No description provided for @obLangEnglishDesc.
  ///
  /// In en, this message translates to:
  /// **'Start with English as the interface language'**
  String get obLangEnglishDesc;

  /// No description provided for @obLangArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get obLangArabic;

  /// No description provided for @obLangArabicDesc.
  ///
  /// In en, this message translates to:
  /// **'الواجهة باللغة العربية'**
  String get obLangArabicDesc;

  /// No description provided for @obGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to achieve?'**
  String get obGoalsTitle;

  /// No description provided for @obGoalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply. AyahPath weaves these into your daily plan.'**
  String get obGoalsSubtitle;

  /// No description provided for @obContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get obContinue;

  /// No description provided for @obReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'How is your Arabic reading?'**
  String get obReadingTitle;

  /// No description provided for @obReadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us start at the right level.'**
  String get obReadingSubtitle;

  /// No description provided for @obTajweedTitle.
  ///
  /// In en, this message translates to:
  /// **'About Tajweed & memorization'**
  String get obTajweedTitle;

  /// No description provided for @obTajweedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Two quick questions about your background.'**
  String get obTajweedSubtitle;

  /// No description provided for @obTajweedQuestion.
  ///
  /// In en, this message translates to:
  /// **'How familiar are you with Tajweed?'**
  String get obTajweedQuestion;

  /// No description provided for @obMemQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much have you memorized?'**
  String get obMemQuestion;

  /// No description provided for @obFrequencyTitle.
  ///
  /// In en, this message translates to:
  /// **'How often will you practice?'**
  String get obFrequencyTitle;

  /// No description provided for @obFrequencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll size each lesson to fit your rhythm.'**
  String get obFrequencySubtitle;

  /// No description provided for @obFreqHabitDesc.
  ///
  /// In en, this message translates to:
  /// **'A consistent habit builds steady progress'**
  String get obFreqHabitDesc;

  /// No description provided for @obCreatePlan.
  ///
  /// In en, this message translates to:
  /// **'Create my personalized plan'**
  String get obCreatePlan;

  /// No description provided for @placeTitle.
  ///
  /// In en, this message translates to:
  /// **'Placement Assessment'**
  String get placeTitle;

  /// No description provided for @placeSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get placeSkip;

  /// No description provided for @placeSelfConfident.
  ///
  /// In en, this message translates to:
  /// **'Confident'**
  String get placeSelfConfident;

  /// No description provided for @placeSelfNeedsWork.
  ///
  /// In en, this message translates to:
  /// **'Needs work'**
  String get placeSelfNeedsWork;

  /// No description provided for @placeSelfNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get placeSelfNotYet;

  /// No description provided for @placeSelfHint.
  ///
  /// In en, this message translates to:
  /// **'Give your best honest self-assessment. AyahPath adapts from here.'**
  String get placeSelfHint;

  /// No description provided for @plReadingLettersPrompt.
  ///
  /// In en, this message translates to:
  /// **'Can you recognize these letters:'**
  String get plReadingLettersPrompt;

  /// No description provided for @plYesRecognize.
  ///
  /// In en, this message translates to:
  /// **'Yes, I recognize them'**
  String get plYesRecognize;

  /// No description provided for @plSomeRecognize.
  ///
  /// In en, this message translates to:
  /// **'Some of them'**
  String get plSomeRecognize;

  /// No description provided for @plNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get plNotYet;

  /// No description provided for @plReadingHarakatPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you read words with harakat comfortably?'**
  String get plReadingHarakatPrompt;

  /// No description provided for @plYesComfortably.
  ///
  /// In en, this message translates to:
  /// **'Yes, comfortably'**
  String get plYesComfortably;

  /// No description provided for @plWithEffort.
  ///
  /// In en, this message translates to:
  /// **'With effort'**
  String get plWithEffort;

  /// No description provided for @plReadingNoTranslitPrompt.
  ///
  /// In en, this message translates to:
  /// **'Can you read Quranic text without transliteration?'**
  String get plReadingNoTranslitPrompt;

  /// No description provided for @plYesFluently.
  ///
  /// In en, this message translates to:
  /// **'Yes, fluently'**
  String get plYesFluently;

  /// No description provided for @plMostly.
  ///
  /// In en, this message translates to:
  /// **'Mostly'**
  String get plMostly;

  /// No description provided for @plTajweedMaddPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you know what madd (elongation) means?'**
  String get plTajweedMaddPrompt;

  /// No description provided for @plYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get plYes;

  /// No description provided for @plHeardOfIt.
  ///
  /// In en, this message translates to:
  /// **'I\'ve heard of it'**
  String get plHeardOfIt;

  /// No description provided for @plNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get plNo;

  /// No description provided for @plTajweedGhunnahPrompt.
  ///
  /// In en, this message translates to:
  /// **'Can you identify ghunnah (nasal sound) in your recitation?'**
  String get plTajweedGhunnahPrompt;

  /// No description provided for @plSomewhat.
  ///
  /// In en, this message translates to:
  /// **'Somewhat'**
  String get plSomewhat;

  /// No description provided for @plTajweedRulesPrompt.
  ///
  /// In en, this message translates to:
  /// **'Have you studied rules like qalqalah and ikhfa\'?'**
  String get plTajweedRulesPrompt;

  /// No description provided for @plYesInDepth.
  ///
  /// In en, this message translates to:
  /// **'Yes, in depth'**
  String get plYesInDepth;

  /// No description provided for @plBriefly.
  ///
  /// In en, this message translates to:
  /// **'Briefly'**
  String get plBriefly;

  /// No description provided for @plMemShortSurahsPrompt.
  ///
  /// In en, this message translates to:
  /// **'How many short surahs can you recite from memory?'**
  String get plMemShortSurahsPrompt;

  /// No description provided for @plManyMost.
  ///
  /// In en, this message translates to:
  /// **'Many / most'**
  String get plManyMost;

  /// No description provided for @plAFew.
  ///
  /// In en, this message translates to:
  /// **'A few'**
  String get plAFew;

  /// No description provided for @plNoneYet.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get plNoneYet;

  /// No description provided for @plMemFatihahPrompt.
  ///
  /// In en, this message translates to:
  /// **'Can you continue Al-Fatihah from memory to completion?'**
  String get plMemFatihahPrompt;

  /// No description provided for @plYesFully.
  ///
  /// In en, this message translates to:
  /// **'Yes, fully'**
  String get plYesFully;

  /// No description provided for @plPartly.
  ///
  /// In en, this message translates to:
  /// **'Partly'**
  String get plPartly;

  /// No description provided for @plCompRabbPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you understand common Quranic words like \"رَبّ\" (Lord)?'**
  String get plCompRabbPrompt;

  /// No description provided for @plCompAlhamduPrompt.
  ///
  /// In en, this message translates to:
  /// **'Can you explain the meaning of \"Alhamdu lillah\"?'**
  String get plCompAlhamduPrompt;

  /// No description provided for @plRoughly.
  ///
  /// In en, this message translates to:
  /// **'Roughly'**
  String get plRoughly;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Today’s Lesson'**
  String get planTitle;

  /// No description provided for @planReadAloud.
  ///
  /// In en, this message translates to:
  /// **'Read aloud slowly and clearly. Listen carefully to each word.'**
  String get planReadAloud;

  /// No description provided for @planTajweedInstr.
  ///
  /// In en, this message translates to:
  /// **'Practice the selected rule gently. If unsure, tap \"Ask the tutor\" for guidance.'**
  String get planTajweedInstr;

  /// No description provided for @planAssessmentInstr.
  ///
  /// In en, this message translates to:
  /// **'Answer a short question to help AyahPath adjust tomorrow’s lesson.'**
  String get planAssessmentInstr;

  /// No description provided for @planWarmupLetters.
  ///
  /// In en, this message translates to:
  /// **'Letter warm-up'**
  String get planWarmupLetters;

  /// No description provided for @planWarmupLettersInstr.
  ///
  /// In en, this message translates to:
  /// **'Review the Arabic letters you find most challenging. Say each one slowly.'**
  String get planWarmupLettersInstr;

  /// No description provided for @planWarmupReading.
  ///
  /// In en, this message translates to:
  /// **'Reading warm-up'**
  String get planWarmupReading;

  /// No description provided for @planWarmupFluency.
  ///
  /// In en, this message translates to:
  /// **'Fluency warm-up'**
  String get planWarmupFluency;

  /// No description provided for @planWarmupInstr.
  ///
  /// In en, this message translates to:
  /// **'Read a short passage from your current surah at a gentle pace, then once a little faster.'**
  String get planWarmupInstr;

  /// No description provided for @planFocusInstr.
  ///
  /// In en, this message translates to:
  /// **'Follow along with the provided exercise. Practice until it feels smooth.'**
  String get planFocusInstr;

  /// No description provided for @planFocusReading1.
  ///
  /// In en, this message translates to:
  /// **'Letters & sounds'**
  String get planFocusReading1;

  /// No description provided for @planFocusReading2.
  ///
  /// In en, this message translates to:
  /// **'Reading words with harakat'**
  String get planFocusReading2;

  /// No description provided for @planFocusReading3.
  ///
  /// In en, this message translates to:
  /// **'Reading Qur’anic phrases'**
  String get planFocusReading3;

  /// No description provided for @planFocusTajweed1.
  ///
  /// In en, this message translates to:
  /// **'Tajweed foundations'**
  String get planFocusTajweed1;

  /// No description provided for @planFocusTajweed2.
  ///
  /// In en, this message translates to:
  /// **'Practicing madd & ghunnah'**
  String get planFocusTajweed2;

  /// No description provided for @planFocusTajweed3.
  ///
  /// In en, this message translates to:
  /// **'Advanced tajweed rules'**
  String get planFocusTajweed3;

  /// No description provided for @planFocusMemo1.
  ///
  /// In en, this message translates to:
  /// **'Introducing a new ayah'**
  String get planFocusMemo1;

  /// No description provided for @planFocusMemo2.
  ///
  /// In en, this message translates to:
  /// **'Building on today’s ayahs'**
  String get planFocusMemo2;

  /// No description provided for @planFocusMemo3.
  ///
  /// In en, this message translates to:
  /// **'Strengthening your Hifz'**
  String get planFocusMemo3;

  /// No description provided for @planFocusRevision1.
  ///
  /// In en, this message translates to:
  /// **'Refreshing what you know'**
  String get planFocusRevision1;

  /// No description provided for @planFocusRevision2.
  ///
  /// In en, this message translates to:
  /// **'Revision & linking ayahs'**
  String get planFocusRevision2;

  /// No description provided for @planFocusRevision3.
  ///
  /// In en, this message translates to:
  /// **'Deep revision session'**
  String get planFocusRevision3;

  /// No description provided for @planFocusCompre1.
  ///
  /// In en, this message translates to:
  /// **'Key words & meaning'**
  String get planFocusCompre1;

  /// No description provided for @planFocusCompre2.
  ///
  /// In en, this message translates to:
  /// **'Understanding phrases'**
  String get planFocusCompre2;

  /// No description provided for @planFocusCompre3.
  ///
  /// In en, this message translates to:
  /// **'Exploring meaning deeply'**
  String get planFocusCompre3;

  /// No description provided for @planFocusFluency1.
  ///
  /// In en, this message translates to:
  /// **'Focused reading practice'**
  String get planFocusFluency1;

  /// No description provided for @planFocusFluency2.
  ///
  /// In en, this message translates to:
  /// **'Pacing & flow practice'**
  String get planFocusFluency2;

  /// No description provided for @planFocusFluency3.
  ///
  /// In en, this message translates to:
  /// **'Advanced fluency practice'**
  String get planFocusFluency3;

  /// No description provided for @planMemoStart.
  ///
  /// In en, this message translates to:
  /// **'Start memorizing'**
  String get planMemoStart;

  /// No description provided for @planMemoStartInstr.
  ///
  /// In en, this message translates to:
  /// **'Hear an ayah, then repeat it 3 times. Try to say it from memory once.'**
  String get planMemoStartInstr;

  /// No description provided for @planMemoReview.
  ///
  /// In en, this message translates to:
  /// **'Memorization & revision'**
  String get planMemoReview;

  /// No description provided for @planMemoReviewInstr.
  ///
  /// In en, this message translates to:
  /// **'Recite your recent ayahs from memory, then add one new line using spaced repetition.'**
  String get planMemoReviewInstr;

  /// No description provided for @planQuranReading.
  ///
  /// In en, this message translates to:
  /// **'Qur’an reading'**
  String get planQuranReading;

  /// No description provided for @planTajweedTopic1.
  ///
  /// In en, this message translates to:
  /// **'basic madd'**
  String get planTajweedTopic1;

  /// No description provided for @planTajweedTopic2.
  ///
  /// In en, this message translates to:
  /// **'madd and ghunnah'**
  String get planTajweedTopic2;

  /// No description provided for @planTajweedTopic3.
  ///
  /// In en, this message translates to:
  /// **'qalqalah and ikhfa'**
  String get planTajweedTopic3;

  /// No description provided for @planTajweedPrompt1.
  ///
  /// In en, this message translates to:
  /// **'Which letter brings a natural elongation (madd)?'**
  String get planTajweedPrompt1;

  /// No description provided for @planTajweedPrompt2.
  ///
  /// In en, this message translates to:
  /// **'Which rule produces a nasal sound (ghunnah)?'**
  String get planTajweedPrompt2;

  /// No description provided for @planTajweedPrompt3.
  ///
  /// In en, this message translates to:
  /// **'Which term refers to a voicing bounce (qalqalah)?'**
  String get planTajweedPrompt3;

  /// No description provided for @planAssessReadingHi.
  ///
  /// In en, this message translates to:
  /// **'How would you rate your smoothness reading today’s ayah?'**
  String get planAssessReadingHi;

  /// No description provided for @planAssessReadingLo.
  ///
  /// In en, this message translates to:
  /// **'Could you read today’s words clearly?'**
  String get planAssessReadingLo;

  /// No description provided for @planAssessTajweed.
  ///
  /// In en, this message translates to:
  /// **'How well did you apply today’s tajweed rule?'**
  String get planAssessTajweed;

  /// No description provided for @planAssessMemo.
  ///
  /// In en, this message translates to:
  /// **'How much of today’s memorization can you recall?'**
  String get planAssessMemo;

  /// No description provided for @planAssessRevision.
  ///
  /// In en, this message translates to:
  /// **'How confidently did you revise today?'**
  String get planAssessRevision;

  /// No description provided for @planAssessCompre.
  ///
  /// In en, this message translates to:
  /// **'Could you explain today’s key words?'**
  String get planAssessCompre;

  /// No description provided for @planAssessFluency.
  ///
  /// In en, this message translates to:
  /// **'How fluent did today’s reading feel?'**
  String get planAssessFluency;

  /// No description provided for @recTitle.
  ///
  /// In en, this message translates to:
  /// **'Recitation Practice'**
  String get recTitle;

  /// No description provided for @recOnDevice.
  ///
  /// In en, this message translates to:
  /// **'On-device'**
  String get recOnDevice;

  /// No description provided for @recCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get recCloud;

  /// No description provided for @recSurahLabel.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get recSurahLabel;

  /// No description provided for @recAyahsLabel.
  ///
  /// In en, this message translates to:
  /// **'Ayahs'**
  String get recAyahsLabel;

  /// No description provided for @recReadyInstruction.
  ///
  /// In en, this message translates to:
  /// **'Recite the passage above, then stop when finished.'**
  String get recReadyInstruction;

  /// No description provided for @recModelNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'Voice model not installed — you\'ll get an assistive preview. Install it in Profile → Model Manager for fuller analysis.'**
  String get recModelNotInstalled;

  /// No description provided for @recStartRecitation.
  ///
  /// In en, this message translates to:
  /// **'Start Recitation'**
  String get recStartRecitation;

  /// No description provided for @recProcessingLocal.
  ///
  /// In en, this message translates to:
  /// **'Processing locally on your device'**
  String get recProcessingLocal;

  /// No description provided for @recFinishedReciting.
  ///
  /// In en, this message translates to:
  /// **'I\'ve finished reciting'**
  String get recFinishedReciting;

  /// No description provided for @recAnalyzingOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your recitation on-device…'**
  String get recAnalyzingOnDevice;

  /// No description provided for @recReadingFeedback.
  ///
  /// In en, this message translates to:
  /// **'Reading feedback'**
  String get recReadingFeedback;

  /// No description provided for @recMissedWords.
  ///
  /// In en, this message translates to:
  /// **'Words that may have been missed'**
  String get recMissedWords;

  /// No description provided for @recPossibleSubstitutions.
  ///
  /// In en, this message translates to:
  /// **'Possible substitutions'**
  String get recPossibleSubstitutions;

  /// No description provided for @recAiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'AI feedback is assistive. For Tajweed and pronunciation accuracy, please consult a qualified Quran teacher when appropriate.'**
  String get recAiDisclaimer;

  /// No description provided for @recTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get recTryAgain;

  /// No description provided for @recDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get recDone;

  /// No description provided for @lessonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get lessonSkip;

  /// No description provided for @lessonTextUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Text not available for this ayah.\n\nConnect to a Quran text source to enable this feature.'**
  String get lessonTextUnavailable;

  /// No description provided for @lessonShowTranslation.
  ///
  /// In en, this message translates to:
  /// **'Show translation'**
  String get lessonShowTranslation;

  /// No description provided for @lessonTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get lessonTranslation;

  /// No description provided for @lessonPlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing...'**
  String get lessonPlaying;

  /// No description provided for @lessonExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent recitation!'**
  String get lessonExcellent;

  /// No description provided for @lessonGoodKeepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Good, keep practicing'**
  String get lessonGoodKeepPracticing;

  /// No description provided for @lessonTryAgainBetter.
  ///
  /// In en, this message translates to:
  /// **'Try again — you can do better'**
  String get lessonTryAgainBetter;

  /// No description provided for @lessonStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get lessonStop;

  /// No description provided for @lessonPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get lessonPlay;

  /// No description provided for @lessonTestMe.
  ///
  /// In en, this message translates to:
  /// **'Test Me'**
  String get lessonTestMe;

  /// No description provided for @lessonRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get lessonRepeat;

  /// No description provided for @lessonListenRepeatFirst.
  ///
  /// In en, this message translates to:
  /// **'Listen carefully to each ayah, then repeat it aloud.\nPractice until it feels natural.'**
  String get lessonListenRepeatFirst;

  /// No description provided for @lessonListenRepeatNext.
  ///
  /// In en, this message translates to:
  /// **'Listen and repeat this ayah. Try to match the recitation.'**
  String get lessonListenRepeatNext;

  /// No description provided for @lessonReadAloneFirst.
  ///
  /// In en, this message translates to:
  /// **'Now read the ayahs from memory without hearing them first.\nTake your time — accuracy over speed.'**
  String get lessonReadAloneFirst;

  /// No description provided for @lessonReadAloneNext.
  ///
  /// In en, this message translates to:
  /// **'Read this ayah from memory. Focus on correct pronunciation.'**
  String get lessonReadAloneNext;

  /// No description provided for @lessonAiTestFirst.
  ///
  /// In en, this message translates to:
  /// **'Recite this ayah without looking at the text.\nAI will analyze your recitation and provide feedback.'**
  String get lessonAiTestFirst;

  /// No description provided for @lessonAiTestNext.
  ///
  /// In en, this message translates to:
  /// **'Recite from memory. AI analyzes pronunciation and accuracy.'**
  String get lessonAiTestNext;

  /// No description provided for @lessonTranslationStudy.
  ///
  /// In en, this message translates to:
  /// **'Read the translation and understand the meaning.\n\nUnderstanding helps memorization.'**
  String get lessonTranslationStudy;

  /// No description provided for @lessonMashaAllah.
  ///
  /// In en, this message translates to:
  /// **'Masha Allah!'**
  String get lessonMashaAllah;

  /// No description provided for @lessonRecitationScore.
  ///
  /// In en, this message translates to:
  /// **'Recitation Score'**
  String get lessonRecitationScore;

  /// No description provided for @lessonReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get lessonReview;

  /// No description provided for @lessonNextLesson.
  ///
  /// In en, this message translates to:
  /// **'Next Lesson'**
  String get lessonNextLesson;

  /// No description provided for @practiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practiceTitle;

  /// No description provided for @practiceQuickAssessment.
  ///
  /// In en, this message translates to:
  /// **'Quick assessment'**
  String get practiceQuickAssessment;

  /// No description provided for @practiceHifzRevision.
  ///
  /// In en, this message translates to:
  /// **'Hifz & revision'**
  String get practiceHifzRevision;

  /// No description provided for @practiceStartRecitation.
  ///
  /// In en, this message translates to:
  /// **'Start Recitation'**
  String get practiceStartRecitation;

  /// No description provided for @practiceAnalyzedOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Analyzed on-device · private'**
  String get practiceAnalyzedOnDevice;

  /// No description provided for @practiceCloudAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Cloud analysis'**
  String get practiceCloudAnalysis;

  /// No description provided for @practiceAssessSkill.
  ///
  /// In en, this message translates to:
  /// **'Assess a skill'**
  String get practiceAssessSkill;

  /// No description provided for @practiceTough.
  ///
  /// In en, this message translates to:
  /// **'Tough'**
  String get practiceTough;

  /// No description provided for @practiceOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get practiceOkay;

  /// No description provided for @practiceGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get practiceGood;

  /// No description provided for @practiceEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get practiceEasy;

  /// No description provided for @practiceNoSurahsDue.
  ///
  /// In en, this message translates to:
  /// **'No surahs due for revision right now. Keep your steady rhythm going.'**
  String get practiceNoSurahsDue;

  /// No description provided for @practiceDueForRevision.
  ///
  /// In en, this message translates to:
  /// **'Due for revision'**
  String get practiceDueForRevision;

  /// No description provided for @practiceReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get practiceReview;

  /// No description provided for @practiceRevise.
  ///
  /// In en, this message translates to:
  /// **'Revise'**
  String get practiceRevise;

  /// No description provided for @practiceNeedsMoreWork.
  ///
  /// In en, this message translates to:
  /// **'Needs more work'**
  String get practiceNeedsMoreWork;

  /// No description provided for @practiceRecitedWell.
  ///
  /// In en, this message translates to:
  /// **'Recited well'**
  String get practiceRecitedWell;

  /// No description provided for @privTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privTitle;

  /// No description provided for @privPrivacyFirst.
  ///
  /// In en, this message translates to:
  /// **'Privacy first'**
  String get privPrivacyFirst;

  /// No description provided for @privIntro.
  ///
  /// In en, this message translates to:
  /// **'AyahPath keeps your learning private. Your recitation is analyzed on-device, and your profile and progress are stored securely online so they stay in sync with your account.'**
  String get privIntro;

  /// No description provided for @privOnYourDevice.
  ///
  /// In en, this message translates to:
  /// **'On your device'**
  String get privOnYourDevice;

  /// No description provided for @privQuranText.
  ///
  /// In en, this message translates to:
  /// **'Qur\'an text & reading'**
  String get privQuranText;

  /// No description provided for @privBundledLocally.
  ///
  /// In en, this message translates to:
  /// **'Bundled locally'**
  String get privBundledLocally;

  /// No description provided for @privVoiceAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Recitation voice analysis'**
  String get privVoiceAnalysis;

  /// No description provided for @privOnDeviceModel.
  ///
  /// In en, this message translates to:
  /// **'On-device model'**
  String get privOnDeviceModel;

  /// No description provided for @privCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get privCloud;

  /// No description provided for @privLoginSession.
  ///
  /// In en, this message translates to:
  /// **'Login session'**
  String get privLoginSession;

  /// No description provided for @privLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get privLocal;

  /// No description provided for @privStoredOnline.
  ///
  /// In en, this message translates to:
  /// **'Stored securely online (your account)'**
  String get privStoredOnline;

  /// No description provided for @privProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress, lessons & memorization'**
  String get privProgress;

  /// No description provided for @privSyncedToAccount.
  ///
  /// In en, this message translates to:
  /// **'Synced to your account'**
  String get privSyncedToAccount;

  /// No description provided for @privLearnerProfile.
  ///
  /// In en, this message translates to:
  /// **'Learner profile'**
  String get privLearnerProfile;

  /// No description provided for @privAiTutorAdvanced.
  ///
  /// In en, this message translates to:
  /// **'AI tutor (advanced cloud)'**
  String get privAiTutorAdvanced;

  /// No description provided for @privOptionalPlanned.
  ///
  /// In en, this message translates to:
  /// **'Optional / planned'**
  String get privOptionalPlanned;

  /// No description provided for @privAdditionalContent.
  ///
  /// In en, this message translates to:
  /// **'Additional content'**
  String get privAdditionalContent;

  /// No description provided for @privOnDemand.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get privOnDemand;

  /// No description provided for @privYourControl.
  ///
  /// In en, this message translates to:
  /// **'Your control'**
  String get privYourControl;

  /// No description provided for @privControlBody.
  ///
  /// In en, this message translates to:
  /// **'AyahPath collects the minimum data needed to work and never sells your information. Your recitation audio is not uploaded. You can review your rights and delete your data at any time.'**
  String get privControlBody;

  /// No description provided for @privTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get privTermsOfService;

  /// No description provided for @privPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privPrivacyPolicy;

  /// No description provided for @privDeleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all learning data'**
  String get privDeleteAllData;

  /// No description provided for @privDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get privDeleteDialogTitle;

  /// No description provided for @privDeleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes your profile, progress, lessons and memorization from your account.'**
  String get privDeleteDialogBody;

  /// No description provided for @privCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get privCancel;

  /// No description provided for @privDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get privDelete;

  /// No description provided for @privDeletedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'All learning data deleted.'**
  String get privDeletedSnackbar;

  /// No description provided for @profTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profTitle;

  /// No description provided for @profAiTutor.
  ///
  /// In en, this message translates to:
  /// **'AI Tutor'**
  String get profAiTutor;

  /// No description provided for @profAiTutorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask about Tajweed, vocabulary or today\'s lesson'**
  String get profAiTutorSubtitle;

  /// No description provided for @profModelManager.
  ///
  /// In en, this message translates to:
  /// **'Model Manager'**
  String get profModelManager;

  /// No description provided for @profModelManagerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download & manage on-device voice models'**
  String get profModelManagerSubtitle;

  /// No description provided for @profPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profPrivacy;

  /// No description provided for @profPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'See how your data is handled'**
  String get profPrivacySubtitle;

  /// No description provided for @profSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profSettings;

  /// No description provided for @profSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme, notifications, language'**
  String get profSettingsSubtitle;

  /// No description provided for @profYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Your learning journey'**
  String get profYourJourney;

  /// No description provided for @profSignedInFallback.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get profSignedInFallback;

  /// No description provided for @profAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profAccount;

  /// No description provided for @profSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profSignOut;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// No description provided for @progressSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get progressSkills;

  /// No description provided for @progressLearningActivity.
  ///
  /// In en, this message translates to:
  /// **'Learning activity'**
  String get progressLearningActivity;

  /// No description provided for @progressLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get progressLessons;

  /// No description provided for @progressPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get progressPractice;

  /// No description provided for @progressStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get progressStreak;

  /// No description provided for @progressMemorization.
  ///
  /// In en, this message translates to:
  /// **'Memorization'**
  String get progressMemorization;

  /// No description provided for @progressOverallLearning.
  ///
  /// In en, this message translates to:
  /// **'Overall learning'**
  String get progressOverallLearning;

  /// No description provided for @progressOverallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A steady, personal journey — not a competition.'**
  String get progressOverallSubtitle;

  /// No description provided for @progressNoMemorized.
  ///
  /// In en, this message translates to:
  /// **'No memorized surahs tracked yet. Mark ayahs in the Qur\'an reader to begin.'**
  String get progressNoMemorized;

  /// No description provided for @progressMastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get progressMastered;

  /// No description provided for @progressStillDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Still developing — every steady session counts.'**
  String get progressStillDeveloping;

  /// No description provided for @progressDeveloping.
  ///
  /// In en, this message translates to:
  /// **'Developing'**
  String get progressDeveloping;

  /// No description provided for @quranTitle.
  ///
  /// In en, this message translates to:
  /// **'Qur’an'**
  String get quranTitle;

  /// No description provided for @quranTrustedTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Trusted text'**
  String get quranTrustedTextTitle;

  /// No description provided for @quranTrustedTextBody.
  ///
  /// In en, this message translates to:
  /// **'Quranic text follows the standard Hafs orthography (Tanzil). It is never modified or generated. More surahs can be added to this verified dataset offline.'**
  String get quranTrustedTextBody;

  /// No description provided for @readerNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get readerNote;

  /// No description provided for @readerNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Reflection, reference or reminder…'**
  String get readerNoteHint;

  /// No description provided for @readerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get readerCancel;

  /// No description provided for @readerSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get readerSave;

  /// No description provided for @readerRecitationPractice.
  ///
  /// In en, this message translates to:
  /// **'Recitation practice'**
  String get readerRecitationPractice;

  /// No description provided for @readerTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get readerTranslation;

  /// No description provided for @readerTransliteration.
  ///
  /// In en, this message translates to:
  /// **'Transliteration'**
  String get readerTransliteration;

  /// No description provided for @readerBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get readerBookmark;

  /// No description provided for @readerAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get readerAddNote;

  /// No description provided for @readerMemorized.
  ///
  /// In en, this message translates to:
  /// **'Memorized'**
  String get readerMemorized;

  /// No description provided for @readerMarkMemorized.
  ///
  /// In en, this message translates to:
  /// **'Mark as memorized'**
  String get readerMarkMemorized;

  /// No description provided for @setTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setTitle;

  /// No description provided for @setAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get setAppearance;

  /// No description provided for @setLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get setLight;

  /// No description provided for @setSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get setSystem;

  /// No description provided for @setDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get setDark;

  /// No description provided for @setNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get setNotifications;

  /// No description provided for @setNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle reminders like \"Your Qur\'an lesson is ready.\" You can turn these off completely.'**
  String get setNotificationsSubtitle;

  /// No description provided for @setInterfaceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get setInterfaceLanguage;

  /// No description provided for @setInterfaceLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English (العربية coming soon)'**
  String get setInterfaceLanguageSubtitle;

  /// No description provided for @setSyncInfo.
  ///
  /// In en, this message translates to:
  /// **'AyahPath syncs your learning data to your account so it stays in sync across reinstalls. Your recitation audio is analyzed on-device and is never uploaded. You can review and delete your data at any time from the Privacy screen.'**
  String get setSyncInfo;

  /// No description provided for @setVersion.
  ///
  /// In en, this message translates to:
  /// **'AyahPath v1.1.0 · Online-first'**
  String get setVersion;

  /// No description provided for @tutorTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Tutor'**
  String get tutorTitle;

  /// No description provided for @tutorInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about Tajweed, vocabulary, revision…'**
  String get tutorInputHint;

  /// No description provided for @tutorEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'A learning companion, not a scholar'**
  String get tutorEmptyTitle;

  /// No description provided for @tutorEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Ask about Tajweed concepts, vocabulary, or what to revise today. AyahPath answers from trusted educational material and will point you to a qualified teacher for anything that needs scholarly authority.'**
  String get tutorEmptyBody;

  /// No description provided for @tutorSugRevise.
  ///
  /// In en, this message translates to:
  /// **'What should I revise today?'**
  String get tutorSugRevise;

  /// No description provided for @tutorSugMadd.
  ///
  /// In en, this message translates to:
  /// **'Explain madd'**
  String get tutorSugMadd;

  /// No description provided for @tutorSugGhunnah.
  ///
  /// In en, this message translates to:
  /// **'What is ghunnah?'**
  String get tutorSugGhunnah;

  /// No description provided for @tutorSugLesson.
  ///
  /// In en, this message translates to:
  /// **'Help me understand today’s lesson'**
  String get tutorSugLesson;

  /// No description provided for @tutorMadd.
  ///
  /// In en, this message translates to:
  /// **'Madd (مد) means to lengthen a vowel. The letters that extend are ا ، و ، ي when they follow a fitting harakat. In its \"natural\" form (madd tabiʿi) a madd letter is held for roughly two counts. Practicing slowly with a teacher or audio helps build steady control.'**
  String get tutorMadd;

  /// No description provided for @tutorGhunnah.
  ///
  /// In en, this message translates to:
  /// **'Ghunnah (غنة) is the nasal resonance produced through the nose, lasting about two counts. It is heard in the letters ن and م when they carry shaddah (e.g. إِنَّ). Holding the nose gently while practicing can help you feel and hear it.'**
  String get tutorGhunnah;

  /// No description provided for @tutorQalqalah.
  ///
  /// In en, this message translates to:
  /// **'Qalqalah (قلقلة) is a slight, crisp bounce heard when pronouncing the letters ق ط ب ج د when they carry a sukun. It gives these letters their distinct clarity.'**
  String get tutorQalqalah;

  /// No description provided for @tutorIkhfa.
  ///
  /// In en, this message translates to:
  /// **'Ikhfa (إخفاء) means to conceal. When the letter ن with sukun (or tanween) precedes certain letters, it is pronounced with partial nasalization (ghunnah) without a full clear ن. It is one of the main rules (ahkam) of noon and tanween.'**
  String get tutorIkhfa;

  /// No description provided for @tutorTajweed.
  ///
  /// In en, this message translates to:
  /// **'Tajweed (تجويد) is the set of rules for correct, beautiful recitation of the Qur’an: proper letter articulation (makharij), qualities (sifaat), and the rules of noon, meem, and madd. It is best learned gradually and with a qualified teacher who can hear and correct your recitation.'**
  String get tutorTajweed;

  /// No description provided for @tutorVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Growing Quranic vocabulary is best learned in context. As you read an ayah, note recurring words and roots — words like \"رَبّ\" (Lord) and \"نَاس\" (people) reappear often. Use the Reader’s translation and meaning notes to build understanding gradually.'**
  String get tutorVocabulary;

  /// No description provided for @tutorTest.
  ///
  /// In en, this message translates to:
  /// **'I can give you a short practice prompt. Read today’s focus surah aloud, then explain the meaning of two key words, and recall one ayah from memory. Your practice screen already offers structured checks to rebuild after each lesson.'**
  String get tutorTest;

  /// No description provided for @tutorSurah.
  ///
  /// In en, this message translates to:
  /// **'Which surah would you like to focus on? I can help you plan reading, memorization or revision for it. Trusted surah text and context are available in the Reader.'**
  String get tutorSurah;

  /// No description provided for @tutorRuling.
  ///
  /// In en, this message translates to:
  /// **'That question involves religious ruling, which requires scholarly authority. AyahPath is a learning companion and does not issue religious rulings. Please consult a qualified scholar or a trusted Islamic reference for authoritative guidance.'**
  String get tutorRuling;

  /// No description provided for @tutorAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get tutorAnd;

  /// No description provided for @tutorGeneric.
  ///
  /// In en, this message translates to:
  /// **'I can help with Tajweed concepts, vocabulary, revision planning, and your daily lesson. Ask something like \"What should I revise today?\" or \"Explain madd.\" For rulings that need scholarly authority, I’ll point you to a qualified teacher.'**
  String get tutorGeneric;

  /// No description provided for @tutorRevisionGood.
  ///
  /// In en, this message translates to:
  /// **'You’re in good shape across your skills. Today is a good day to slightly extend your reading and add one small memorization step.'**
  String get tutorRevisionGood;

  /// No description provided for @learnStatsSummary.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} lessons complete • {surahsStarted} surahs started'**
  String learnStatsSummary(
    String completed,
    String total,
    String surahsStarted,
  );

  /// No description provided for @learnNextLesson.
  ///
  /// In en, this message translates to:
  /// **'Next: {title}'**
  String learnNextLesson(String title);

  /// No description provided for @learnLessonDetail.
  ///
  /// In en, this message translates to:
  /// **'Ayahs {from}-{to} • {ayahCount} ayahs • {phaseCount} phases'**
  String learnLessonDetail(
    String from,
    String to,
    String ayahCount,
    String phaseCount,
  );

  /// No description provided for @learnAyahCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ayahs'**
  String learnAyahCount(String count);

  /// No description provided for @learnPartsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} parts'**
  String learnPartsCount(String count);

  /// No description provided for @learnPartsComplete.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} parts complete'**
  String learnPartsComplete(String completed, String total);

  /// No description provided for @learnFullSurah.
  ///
  /// In en, this message translates to:
  /// **'Full Surah ({count} ayahs)'**
  String learnFullSurah(String count);

  /// No description provided for @learnPartOf.
  ///
  /// In en, this message translates to:
  /// **'Part {part} of {total} (Ayahs {from}-{to})'**
  String learnPartOf(String part, String total, String from, String to);

  /// No description provided for @learnCompleteScore.
  ///
  /// In en, this message translates to:
  /// **'Complete • Score: {score}%'**
  String learnCompleteScore(String score);

  /// No description provided for @modelBundledSize.
  ///
  /// In en, this message translates to:
  /// **'{used} of ~{total} MB bundled'**
  String modelBundledSize(String used, String total);

  /// No description provided for @homeDayStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String homeDayStreak(int count);

  /// No description provided for @homeLessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons completed'**
  String homeLessonsCompleted(int count);

  /// No description provided for @homeLessonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{steps} steps · {minutes} minutes'**
  String homeLessonSubtitle(int steps, int minutes);

  /// No description provided for @homePracticeSkill.
  ///
  /// In en, this message translates to:
  /// **'Practice {skill}'**
  String homePracticeSkill(String skill);

  /// No description provided for @homeReviewSurah.
  ///
  /// In en, this message translates to:
  /// **'Review {surah}'**
  String homeReviewSurah(String surah);

  /// No description provided for @homeJourneyProgressText.
  ///
  /// In en, this message translates to:
  /// **'Moved {percent}% of the way through your current surah.'**
  String homeJourneyProgressText(int percent);

  /// No description provided for @homeAyahRange.
  ///
  /// In en, this message translates to:
  /// **'Ayahs {from}-{to} • {count} ayahs'**
  String homeAyahRange(int from, int to, int count);

  /// No description provided for @obFreqMinutes.
  ///
  /// In en, this message translates to:
  /// **'{label} · ~{minutes} min'**
  String obFreqMinutes(String label, int minutes);

  /// No description provided for @placeQuestionCounter.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String placeQuestionCounter(String current, String total);

  /// No description provided for @placeSurahLabel.
  ///
  /// In en, this message translates to:
  /// **'Surah {name}:{ayah}'**
  String placeSurahLabel(String name, String ayah);

  /// No description provided for @planTajweedFocus.
  ///
  /// In en, this message translates to:
  /// **'Tajweed focus: {topic}'**
  String planTajweedFocus(String topic);

  /// No description provided for @planQuickCheck.
  ///
  /// In en, this message translates to:
  /// **'Quick check: {skill}'**
  String planQuickCheck(String skill);

  /// No description provided for @planReadingSurah.
  ///
  /// In en, this message translates to:
  /// **'Reading {surah}'**
  String planReadingSurah(String surah);

  /// No description provided for @recListening.
  ///
  /// In en, this message translates to:
  /// **'Listening… {seconds}s'**
  String recListening(int seconds);

  /// No description provided for @recPausesDetected.
  ///
  /// In en, this message translates to:
  /// **'Pauses detected: {count}'**
  String recPausesDetected(int count);

  /// No description provided for @lessonAyahCounter.
  ///
  /// In en, this message translates to:
  /// **'Ayah {current} of {total}'**
  String lessonAyahCounter(int current, int total);

  /// No description provided for @lessonScorePct.
  ///
  /// In en, this message translates to:
  /// **'Recitation: {score}%'**
  String lessonScorePct(int score);

  /// No description provided for @lessonPartComplete.
  ///
  /// In en, this message translates to:
  /// **'Part {number} Complete!'**
  String lessonPartComplete(int number);

  /// No description provided for @lessonOfComplete.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons complete'**
  String lessonOfComplete(int completed, int total);

  /// No description provided for @practiceAssessmentRecorded.
  ///
  /// In en, this message translates to:
  /// **'{skill}: {rating} recorded'**
  String practiceAssessmentRecorded(String skill, String rating);

  /// No description provided for @practiceDayInterval.
  ///
  /// In en, this message translates to:
  /// **'{days} day interval'**
  String practiceDayInterval(int days);

  /// No description provided for @practiceReciteFromMemory.
  ///
  /// In en, this message translates to:
  /// **'Recite {surah} from memory, then mark how it went.'**
  String practiceReciteFromMemory(String surah);

  /// No description provided for @profOverallProgress.
  ///
  /// In en, this message translates to:
  /// **'{percent}% overall · {streak}-day streak'**
  String profOverallProgress(int percent, int streak);

  /// No description provided for @quranAyahCount.
  ///
  /// In en, this message translates to:
  /// **'{revelationPlace} · {count} ayahs'**
  String quranAyahCount(String revelationPlace, int count);

  /// No description provided for @quranContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading {surahName}'**
  String quranContinueReading(String surahName);

  /// No description provided for @readerAyahCount.
  ///
  /// In en, this message translates to:
  /// **'{revelationPlace} · {count} ayahs'**
  String readerAyahCount(String revelationPlace, int count);

  /// No description provided for @readerMarkedMemorized.
  ///
  /// In en, this message translates to:
  /// **'Marked ayah {ayahNumber} as memorized'**
  String readerMarkedMemorized(int ayahNumber);

  /// No description provided for @tutorWeakSkills.
  ///
  /// In en, this message translates to:
  /// **'Based on your recent progress, {names} could use gentle, consistent practice. Your daily lesson already adjusts to include it — keep short, regular sessions rather than long irregular ones.'**
  String tutorWeakSkills(String names);

  /// No description provided for @tutorRevisionDueAndWeak.
  ///
  /// In en, this message translates to:
  /// **'Today priorities: revise {dueNames} (it’s due for spaced review), and give {weakNames} a focused 5-minute session. Your lesson already builds these in.'**
  String tutorRevisionDueAndWeak(String dueNames, String weakNames);

  /// No description provided for @tutorRevisionDue.
  ///
  /// In en, this message translates to:
  /// **'Your spaced-revision schedule has {count} section(s) due: {dueNames}. Reviewing these now will strengthen long-term memory.'**
  String tutorRevisionDue(int count, String dueNames);

  /// No description provided for @tutorRevisionWeak.
  ///
  /// In en, this message translates to:
  /// **'Recommend focusing on {weakNames} today — a short targeted practice will help most. Your daily lesson is adapted to include it.'**
  String tutorRevisionWeak(String weakNames);

  /// Tagline on the onboarding welcome screen
  ///
  /// In en, this message translates to:
  /// **'Your Personalized Path to Learning the Quran'**
  String get obTagline;

  /// No description provided for @progressMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{min} min'**
  String progressMinutesShort(int min);

  /// No description provided for @progressHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{h}h {m}m'**
  String progressHoursMinutes(int h, int m);

  /// No description provided for @updateVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String updateVersionLabel(String version);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
