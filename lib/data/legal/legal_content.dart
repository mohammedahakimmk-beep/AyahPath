import 'package:flutter/material.dart';

/// A run of bold/un-bold text within a paragraph.
class LegalRun {
  const LegalRun(this.text, {this.bold = false});
  final String text;
  final bool bold;
}

/// One paragraph, whose text may include `{b}...{/b}` markers to bold a phrase.
class LegalParagraph {
  const LegalParagraph(this.text);
  final String text;

  List<LegalRun> get runs => _buildRuns(text);

  static List<LegalRun> _buildRuns(String text) {
    const open = '{b}';
    const close = '{/b}';
    final runs = <LegalRun>[];
    var remaining = text;
    while (true) {
      final start = remaining.indexOf(open);
      if (start < 0) {
        if (remaining.isNotEmpty) runs.add(LegalRun(remaining));
        break;
      }
      if (start > 0) runs.add(LegalRun(remaining.substring(0, start)));
      final end = remaining.indexOf(close, start);
      if (end < 0) {
        runs.add(LegalRun(remaining.substring(start + open.length), bold: true));
        break;
      }
      runs.add(LegalRun(
        remaining.substring(start + open.length, end),
        bold: true,
      ));
      remaining = remaining.substring(end + close.length);
    }
    return runs;
  }
}

/// A numbered section within a legal document.
class LegalSection {
  const LegalSection({required this.title, required this.paragraphs});
  final String title;
  final List<LegalParagraph> paragraphs;

  TextSpan toSpan({
    required TextStyle base,
    required TextStyle bold,
  }) {
    return TextSpan(
      children: paragraphs
          .map((p) => TextSpan(
                children: p.runs
                    .map((r) => (TextSpan(
                          text: r.text,
                          style: r.bold ? bold : base,
                        )))
                    .toList(),
              ))
          .toList(),
    );
  }
}

/// A legal document (Terms of Service or Privacy Policy).
class LegalDocument {
  const LegalDocument({
    required this.title,
    required this.version,
    required this.effectiveDate,
    required this.intro,
    required this.sections,
  });
  final String title;
  final String version;
  final String effectiveDate;
  final String intro;
  final List<LegalSection> sections;
}

/// Terms of Service for AyahPath.
const LegalDocument termsOfService = LegalDocument(
  title: 'Terms of Service',
  version: '1.0',
  effectiveDate: 'September 1, 2026',
  intro:
      'These Terms of Service ("Terms") govern your use of the AyahPath mobile '
      'application and related services (collectively, the "Service"), operated '
      'by AyahPath ("we", "us", or "our"). By downloading, accessing, or using '
      'the Service, you agree to be bound by these Terms. If you do not agree, '
      'please do not use the Service. You must also be at least the legal age '
      'of consent in your jurisdiction, or have permission from a parent or '
      'guardian.',
  sections: [
    LegalSection(title: '1. Acceptance of Terms', paragraphs: [
      LegalParagraph(
          'By creating an account or using the Service, you confirm that you have '
          'read, understood, and agreed to be bound by these Terms and our Privacy '
          'Policy. {b}Your continued use of the Service constitutes acceptance of '
          'any updates to these Terms.{/b}'),
      LegalParagraph(
          'We may revise these Terms from time to time. Where changes are '
          'material, we will make reasonable efforts to notify you. The most '
          'current version will always be made available within the Service and '
          'on our website.'),
    ]),
    LegalSection(title: '2. Eligibility', paragraphs: [
      LegalParagraph(
          'The Service is intended for users who are at least 13 years old, or the '
          'minimum age required under the laws of your country, whichever is higher. '
          '{b}If you are under the age of majority, you may use the Service only '
          'with the involvement of a parent or legal guardian.{/b}'),
      LegalParagraph(
          'By using the Service you represent that you meet these requirements. '
          'We may suspend or terminate accounts that violate this provision.'),
    ]),
    LegalSection(title: '3. Account Registration & Security', paragraphs: [
      LegalParagraph(
          'To use the Service you must create an account using a valid email '
          'address and password, or an authorized sign-in provider such as Google. '
          'You agree to provide accurate and complete information and to keep it '
          'up to date.'),
      LegalParagraph(
          '{b}You are responsible for safeguarding your login credentials and for '
          'all activity that occurs under your account.{/b} Notify us promptly if '
          'you suspect unauthorized access. We are not liable for losses arising '
          'from your failure to protect your credentials.'),
      LegalParagraph(
          'Your account data, including your learning profile and progress, is '
          'stored online and linked to your account so that it may be kept in sync. '
          'You may delete your account data at any time from within the app.'),
    ]),
    LegalSection(title: '4. License to Use the Service', paragraphs: [
      LegalParagraph(
          'Subject to these Terms, we grant you a limited, non-exclusive, '
          'non-transferable, revocable license to access and use the Service for '
          'your personal, non-commercial learning and study of the Qur’an. '
          '{b}You may not resell, sublicense, or commercially exploit the Service '
          'or any part of it without our prior written consent.{/b}'),
      LegalParagraph(
          'You may not copy, modify, distribute, reverse engineer, or extract the '
          'source code of the Service, except where expressly permitted by '
          'applicable law.'),
    ]),
    LegalSection(title: '5. Acceptable Use', paragraphs: [
      LegalParagraph(
          'You agree not to use the Service to violate any law, or to infringe the '
          'rights of others. Prohibited conduct includes uploading harmful '
          'content, attempting to breach security, interfering with the Service, '
          'or using it to impersonate any person.'),
      LegalParagraph(
          '{b}The Service is a learning aid. It is not a substitute for the '
          'guidance of a qualified teacher, scholar, or imam.{/b} You are '
          'responsible for how you apply what you learn.'),
    ]),
    LegalSection(title: '6. Qur’anic Content & Non-Derivation', paragraphs: [
      LegalParagraph(
          'The Qur’anic text presented in the Service is provided from trusted, '
          'fixed sources and is reproduced faithfully. {b}We never generate, '
          'alter, or "rewrite" the Qur’anic text.{/b} Any AI features are strictly '
          'assistive and are limited to analyzing your recitation and answering '
          'learning questions.'),
      LegalParagraph(
          'You may use the Qur’anic text within the Service for personal study. '
          'Commercial redistribution or republication of the Qur’anic text is '
          'governed by the licenses of the underlying sources.'),
    ]),
    LegalSection(title: '7. AI Features & Recitation Analysis', paragraphs: [
      LegalParagraph(
          'AyahPath includes an on-device recitation analysis feature powered by an '
          'AI model that listens to your voice and provides feedback on '
          'pronunciation and accuracy. {b}Recitation audio is processed on your '
          'device and is not uploaded to our servers.{/b}'),
      LegalParagraph(
          'AI feedback is provided to help you learn and is not guaranteed to be '
          'perfectly accurate. Final judgment on correct recitation should always '
          'be sought from a qualified teacher. {b}We are not liable for learning '
          'outcomes based on AI feedback.{/b}'),
    ]),
    LegalSection(title: '8. Data & Privacy', paragraphs: [
      LegalParagraph(
          'Your use of the Service is also governed by our Privacy Policy, which '
          'is incorporated into these Terms by reference. Please read it '
          'carefully. {b}By using the Service you consent to the collection and '
          'processing of data as described in the Privacy Policy.{/b}'),
      LegalParagraph(
          'We store your learning progress and profile online so that it can be '
          'kept in sync with your account. You can request deletion of your data '
          'at any time.'),
    ]),
    LegalSection(title: '9. Third-Party Services', paragraphs: [
      LegalParagraph(
          'The Service may rely on and integrate with third-party services, '
          'including Firebase (authentication and data storage) and Google '
          'Sign-In. Your use of those third-party services is subject to their '
          'own terms and privacy policies.'),
      LegalParagraph(
          '{b}We are not responsible for the content, privacy practices, or '
          'policies of third-party services.{/b} We encourage you to review them '
          'before use.'),
    ]),
    LegalSection(title: '10. Intellectual Property', paragraphs: [
      LegalParagraph(
          'All trademarks, logos, software, and original content (other than '
          'Qur’anic text from its sources) made available through the Service are '
          'owned by us or our licensors and are protected by copyright, '
          'trademark, and other intellectual property laws.'),
      LegalParagraph(
          '{b}You may not use our name, logo, or branding for any purpose without '
          'our prior written consent.{/b}'),
    ]),
    LegalSection(title: '11. Disclaimer of Warranties', paragraphs: [
      LegalParagraph(
          'THE SERVICE IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES '
          'OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO '
          'IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR '
          'PURPOSE, AND NON-INFRINGEMENT. {b}TO THE FULLEST EXTENT PERMITTED BY '
          'LAW, WE DISCLAIM ALL WARRANTIES.{/b}'),
      LegalParagraph(
          'We do not warrant that the Service will be uninterrupted, secure, '
          'error-free, or free of viruses or other harmful components.'),
    ]),
    LegalSection(title: '12. Limitation of Liability', paragraphs: [
      LegalParagraph(
          'TO THE MAXIMUM EXTENT PERMITTED BY LAW, IN NO EVENT SHALL WE, OUR '
          'OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS BE LIABLE FOR ANY INDIRECT, '
          'INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, OR FOR ANY '
          'LOSS OF PROFITS, DATA, OR GOODWILL, ARISING OUT OF OR IN CONNECTION '
          'WITH YOUR USE OF THE SERVICE.'),
      LegalParagraph(
          '{b}Our total aggregate liability for any claim arising from or '
          'relating to the Service shall not exceed the amount you paid us to use '
          'the Service during the twelve (12) months preceding the claim.{/b} Some '
          'jurisdictions do not allow the exclusion or limitation of certain '
          'damages, so parts of this section may not apply to you.'),
    ]),
    LegalSection(title: '13. Indemnification', paragraphs: [
      LegalParagraph(
          'You agree to indemnify and hold harmless AyahPath and its affiliates '
          'from any claims, damages, liabilities, costs, and expenses (including '
          'reasonable attorneys’ fees) arising out of or related to your use of '
          'the Service, your violation of these Terms, or your violation of any '
          'rights of a third party.'),
    ]),
    LegalSection(title: '14. Termination', paragraphs: [
      LegalParagraph(
          'We may suspend or terminate your access to the Service at any time, '
          'with or without cause, and with or without notice. You may stop using '
          'the Service at any time. {b}Upon termination, your right to use the '
          'Service ceases immediately.{/b}'),
      LegalParagraph(
          'You may delete your account and associated data at any time from '
          'within the Service. Provisions of these Terms that by their nature '
          'should survive termination will survive, including sections on '
          'intellectual property, disclaimers, limitation of liability, and '
          'indemnification.'),
    ]),
    LegalSection(title: '15. Changes to the Service', paragraphs: [
      LegalParagraph(
          'We may update, change, or discontinue any part of the Service from '
          'time to time, including features, content, or requirements. '
          '{b}We are not obligated to maintain any particular feature or '
          'version of the Service.{/b}'),
      LegalParagraph(
          'We will make reasonable efforts to notify you of material changes, but '
          'you acknowledge that the Service may evolve without prior notice.'),
    ]),
    LegalSection(title: '16. Governing Law & Disputes', paragraphs: [
      LegalParagraph(
          'These Terms are governed by the laws of the jurisdiction in which we '
          'are established, without regard to its conflict-of-law principles. '
          'Any dispute arising out of these Terms or the Service will be '
          'resolved in the competent courts of that jurisdiction.'),
      LegalParagraph(
          '{b}You agree to first attempt to resolve any dispute informally by '
          'contacting us before initiating any formal proceedings.{/b}'),
    ]),
    LegalSection(title: '17. Contact & Questions', paragraphs: [
      LegalParagraph(
          'If you have any questions about these Terms, please contact us at the '
          'support email made available through our website or app. We will do '
          'our best to respond in a timely manner.'),
    ]),
  ],
);

/// Privacy Policy for AyahPath.
const LegalDocument privacyPolicy = LegalDocument(
  title: 'Privacy Policy',
  version: '1.0',
  effectiveDate: 'September 1, 2026',
  intro:
      'At AyahPath, your privacy and trust matter deeply. This Privacy Policy '
      'explains what information we collect, why we collect it, how we use and '
      'protect it, and the choices you have. {b}Our design goal is privacy-first: '
      'your recitation is analyzed on your device, and we minimize the personal '
      'data we collect.{/b} By using the Service you agree to this policy.',
  sections: [
    LegalSection(title: '1. Information We Collect', paragraphs: [
      LegalParagraph(
          'We collect the minimum information needed to operate the Service: '
          'account credentials (email address and password, or identity provided '
          'by your chosen sign-in provider), and the learning data you generate '
          '(your profile, progress, completed lessons, mastery scores, and '
          'memorization records).'),
      LegalParagraph(
          '{b}We do not collect your real name, phone number, or precise '
          'location unless you choose to provide them.{/b} We do not sell your '
          'personal information.'),
    ]),
    LegalSection(title: '2. On-Device Recitation Analysis', paragraphs: [
      LegalParagraph(
          'When you use the recitation practice feature, audio is captured and '
          'analyzed by an AI model that runs entirely on your device. '
          '{b}Your recitation audio is processed locally and is never uploaded '
          'to or stored on our servers.{/b}'),
      LegalParagraph(
          'The on-device model files are bundled with the application and may be '
          'updated through normal app updates. No audio is transmitted to us at '
          'any time.'),
    ]),
    LegalSection(title: '3. Online Account Data', paragraphs: [
      LegalParagraph(
          'To provide an online-first experience and to keep your progress in '
          'sync across reinstalls and devices, we store certain data associated '
          'with your account on secure servers via Firebase Realtime Database. '
          'This includes your learning profile, progress, and memorization '
          'records.'),
      LegalParagraph(
          '{b}Your learning data is tied to your account and is never shared with '
          'other users or third parties for advertising.{/b}'),
    ]),
    LegalSection(title: '4. Authentication Data', paragraphs: [
      LegalParagraph(
          'Account creation and sign-in are handled by Firebase Authentication, '
          'a service provided by Google. When you sign in with email and '
          'password, that data is processed by Firebase. When you sign in with '
          'Google, Google shares the minimum identity information needed to '
          'authenticate you.'),
      LegalParagraph(
          'Your login session is stored locally on your device so you can remain '
          'signed in. {b}We never receive or store your raw password on our own '
          'servers.{/b}'),
    ]),
    LegalSection(title: '5. How We Use Information', paragraphs: [
      LegalParagraph(
          'We use the information we collect to operate and improve the Service, '
          'to personalize your learning plan, to keep your data synchronized, and '
          'to provide support. {b}We do not use your data for targeted advertising '
          'or to build profiles of you for unrelated purposes.{/b}'),
      LegalParagraph(
          'We may use aggregated, de-identified data for analytics and product '
          'improvement. Such data cannot reasonably be used to identify you.'),
    ]),
    LegalSection(title: '6. Protecting Your Data', paragraphs: [
      LegalParagraph(
          'We take reasonable technical and organizational measures to protect '
          'your data, including secure transmission and access controls on our '
          'data storage. {b}No method of transmission over the Internet or '
          'electronic storage is 100% secure, and we cannot guarantee absolute '
          'security.{/b}'),
      LegalParagraph(
          'Access to your account data is protected by Firebase security rules so '
          'that only you (while signed in) can read or modify your own records.'),
    ]),
    LegalSection(title: '7. Data Retention', paragraphs: [
      LegalParagraph(
          'We retain your account data for as long as your account is active or '
          'as needed to provide the Service. You may delete your learning data at '
          'any time from within the app.'),
      LegalParagraph(
          '{b}When you delete your data or account, we take reasonable steps to '
          'remove your personal information; however, some copies may remain for '
          'a limited period for technical or legal reasons.{/b}'),
    ]),
    LegalSection(title: '8. Your Rights & Choices', paragraphs: [
      LegalParagraph(
          'You have the right to access, correct, and delete the personal '
          'information we hold about you. You may also object to or restrict '
          'certain processing where applicable. To exercise these rights, use the '
          'controls in the app or contact us.'),
      LegalParagraph(
          'You may sign out, delete your learning data, or delete your account at '
          'any time. {b}You may withdraw consent by ceasing to use the Service and '
          'deleting your data.{/b}'),
    ]),
    LegalSection(title: '9. Children’s Privacy', paragraphs: [
      LegalParagraph(
          'The Service is not directed to children under 13, and we do not '
          'knowingly collect personal information from children under 13. '
          '{b}If you believe a child under 13 has provided us personal '
          'information, please contact us and we will take steps to remove it.{/b}'),
    ]),
    LegalSection(title: '10. Third-Party Links & Services', paragraphs: [
      LegalParagraph(
          'The Service may contain links to third-party websites or use '
          'third-party services. We are not responsible for the privacy practices '
          'of those third parties, and this policy does not apply to them.'),
      LegalParagraph(
          '{b}We encourage you to review the privacy policies of any third-party '
          'services you use.{/b}'),
    ]),
    LegalSection(title: '11. International Data Transfers', paragraphs: [
      LegalParagraph(
          'Your data may be processed and stored on servers that may be located '
          'outside your country of residence, including through Firebase data '
          'centers. By using the Service you consent to such processing and '
          'transfers.'),
      LegalParagraph(
          'Where required by applicable law, we will take steps to ensure that '
          'appropriate safeguards are in place for such transfers.'),
    ]),
    LegalSection(title: '12. Changes to This Policy', paragraphs: [
      LegalParagraph(
          'We may update this Privacy Policy from time to time. When we make '
          'material changes, we will notify you by updating the effective date '
          'and, where appropriate, by providing notice within the Service.'),
      LegalParagraph(
          '{b}Your continued use of the Service after changes take effect '
          'constitutes acceptance of the updated Policy.{/b} We encourage you to '
          'review this page periodically.'),
    ]),
    LegalSection(title: '13. Contact Us', paragraphs: [
      LegalParagraph(
          'If you have any questions or concerns about this Privacy Policy or our '
          'data practices, please contact us through the support details provided '
          'on our website. We will respond as promptly as we can.'),
    ]),
  ],
);
