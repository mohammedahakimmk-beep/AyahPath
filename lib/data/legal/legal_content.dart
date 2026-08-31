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
  version: '2.0',
  effectiveDate: 'September 1, 2026',
  intro:
      'These Terms of Service ("Terms") govern your access to and use of the '
      'AyahPath mobile application, its related website, and all associated '
      'features, content, and services (collectively, the "Service"), operated '
      'by AyahPath ("we", "us", or "our"). These Terms form a legally binding '
      'agreement between you and AyahPath. {b}Please read these Terms carefully '
      'before using the Service.{/b} By downloading, accessing, using, or '
      'registering an account with the Service, you acknowledge that you have '
      'read, understood, and agree to be bound by these Terms. If you do not '
      'agree to these Terms, you may not access or use the Service. {b}AyahPath '
      'welcomes users of all ages.{/b} If you are under the age of majority in '
      'your country, we recommend that you review these Terms together with a '
      'parent or legal guardian.',
  sections: [
    LegalSection(title: '1. Introduction & Purpose', paragraphs: [
      LegalParagraph(
          'AyahPath is an educational mobile application created to help people '
          'of all backgrounds, ages, and levels of experience learn to read, '
          'recite, and memorize the Holy Qur’an. The Service provides structured '
          'lessons, a built-in Qur’an reader, recitation practice with on-device '
          'analysis, and progress tracking.'),
      LegalParagraph(
          '{b}Our mission is to make learning the Qur’an accessible, respectful, '
          'and effective for everyone, from complete beginners to advanced '
          'students.{/b} The Service is offered free of charge, and we are '
          'committed to keeping it private, accurate, and free from exploitation.'),
      LegalParagraph(
          'These Terms describe the rules that apply to your use of the Service. '
          'They cover your responsibilities, our responsibilities, the nature of '
          'the content provided, and the limits of our liability.'),
    ]),
    LegalSection(title: '2. Acceptance of the Terms', paragraphs: [
      LegalParagraph(
          'By creating an account, downloading the Service, or otherwise using '
          'the Service, you confirm that you have read, understood, and agreed '
          'to be bound by these Terms and by our Privacy Policy, which is '
          'incorporated into these Terms by reference. {b}Your continued use of '
          'the Service constitutes acceptance of any updates to these Terms.{/b}'),
      LegalParagraph(
          'If you are using the Service on behalf of a family, an educational '
          'institution, or another organization, you represent that you are '
          'authorized to accept these Terms on that entity’s behalf, and that '
          'the entity will be responsible for any use of the Service under your '
          'account.'),
      LegalParagraph(
          'We may revise, amend, or replace these Terms at any time. Where '
          'changes are material, we will make reasonable efforts to notify you, '
          'such as by updating the effective date, posting a notice within the '
          'Service, or sending a notification to the email address associated '
          'with your account. {b}The most current version of these Terms will '
          'always be available within the Service and on our website.{/b} Your '
          'continued use of the Service after any changes take effect means that '
          'you accept those changes.'),
      LegalParagraph(
          'If you do not agree with any revised Terms, your only remedy is to '
          'stop using the Service and, if you wish, delete your account.'),
    ]),
    LegalSection(title: '3. Eligibility & Users of All Ages', paragraphs: [
      LegalParagraph(
          '{b}AyahPath is open to users of all ages. There is no minimum age '
          'requirement to use the Service, and we welcome learners who are '
          'young, old, and everything in between.{/b} Our goal is to support '
          'Qur’anic learning for everyone in the family.'),
      LegalParagraph(
          'If you are under the age of majority in your country of residence, we '
          'strongly encourage you to use the Service with the knowledge and '
          'guidance of a parent or legal guardian. {b}We recommend that parents '
          'and guardians review these Terms and our Privacy Policy together with '
          'their children so that everyone understands how the Service works '
          'and how data is handled.{/b}'),
      LegalParagraph(
          'Because we welcome users of all ages, we are especially careful about '
          'privacy and safety. Please see our Privacy Policy for details on how '
          'we handle the personal information of all users, including minors. '
          '{b}We never sell personal information, and we do not show any '
          'advertising or inappropriate content within the Service.{/b}'),
      LegalParagraph(
          'By using the Service you represent that the information you provide '
          'during account registration is accurate and that, if you are a minor, '
          'you are using the Service with the awareness of a parent or guardian. '
          'We may, in our sole discretion, decline or suspend accounts that '
          'appear to be created fraudulently or in violation of these Terms.'),
    ]),
    LegalSection(title: '4. Account Registration & Security', paragraphs: [
      LegalParagraph(
          'To access all features of the Service you must create an account '
          'using a valid email address and a password, or through an authorized '
          'sign-in provider such as Google. You agree to provide accurate, '
          'current, and complete information during registration and to keep '
          'your account information up to date.'),
      LegalParagraph(
          '{b}You are solely responsible for safeguarding your login credentials '
          'and for all activity that occurs under your account.{/b} You agree '
          'not to share your password with anyone, to create only one account '
          'per person, and to notify us promptly if you suspect any unauthorized '
          'access to your account.'),
      LegalParagraph(
          'We are not liable for any loss or damage that may arise from your '
          'failure to comply with these security obligations. If you believe '
          'your account has been compromised, please contact us as soon as '
          'possible so that we can help secure it.'),
      LegalParagraph(
          'Your account data, including your learning profile and progress, is '
          'stored online and linked to your account so that it can be kept in '
          'sync across devices and after reinstalls. You may delete your account '
          'and associated data at any time from within the Service.'),
    ]),
    LegalSection(title: '5. License to Use the Service', paragraphs: [
      LegalParagraph(
          'Subject to your compliance with these Terms, we grant you a limited, '
          'non-exclusive, non-transferable, revocable license to download, '
          'install, and use the Service on devices that you own or control, for '
          'your personal, non-commercial learning and study of the Qur’an. '
          '{b}You may not resell, sublicense, rent, lease, or commercially '
          'exploit the Service, or any part of it, without our prior written '
          'consent.{/b}'),
      LegalParagraph(
          'Unless we have granted you a separate written agreement, you may not '
          '(a) copy, modify, or create derivative works based on the Service; '
          '(b) distribute, publish, or publicly display the Service or its '
          'materials; (c) reverse engineer, decompile, or attempt to extract the '
          'source code of any part of the Service; or (d) remove, alter, or '
          'obscure any copyright, trademark, or other proprietary notices '
          'contained in the Service. These restrictions do not limit rights '
          'expressly permitted under applicable law.'),
      LegalParagraph(
          'We may update the Service from time to time, and the license above '
          'extends to all updates that we make available to you, unless '
          'additional terms accompany a particular update.'),
    ]),
    LegalSection(title: '6. Acceptable Use & Community Standards', paragraphs: [
      LegalParagraph(
          'You agree to use the Service only for lawful purposes and in a manner '
          'that does not infringe the rights of, or restrict or inhibit the use '
          'and enjoyment of the Service by, any third party.'),
      LegalParagraph(
          'You agree not to, and not to permit anyone else to: (a) use the '
          'Service to violate any law, regulation, or governmental order; '
          '(b) transmit any harmful, threatening, abusive, harassing, defamatory, '
          'obscene, or otherwise objectionable content; (c) attempt to breach '
          'the security of the Service or access data that you are not '
          'authorized to access; (d) interfere with, disrupt, or overload the '
          'Service or any servers or networks connected to it; (e) impersonate '
          'any person or entity or misrepresent your affiliation with any person '
          'or entity; (f) collect or harvest any personally identifiable '
          'information about other users; or (g) use any automated or manual '
          'means to scrape, extract, or download data from the Service except '
          'for your own personal, non-commercial use.'),
      LegalParagraph(
          '{b}We expect every user to treat others with respect, kindness, and '
          'courtesy. The Qur’an teaches us to speak well and to every person, '
          'and we ask that this spirit be reflected in how our community uses '
          'the Service.{/b}'),
      LegalParagraph(
          '{b}The Service is a learning aid. It is not a substitute for the '
          'guidance of a qualified teacher, scholar, or imam.{/b} You are '
          'responsible for how you apply what you learn and for seeking '
          'qualified guidance when you need it.'),
    ]),
    LegalSection(title: '7. Accounts, Suspensions, & Termination', paragraphs: [
      LegalParagraph(
          'We reserve the right to suspend or terminate your access to the '
          'Service, in whole or in part, at any time, with or without cause, '
          'and with or without notice, if we determine in our sole discretion '
          'that you have violated these Terms or otherwise engaged in conduct '
          'that we consider harmful to the Service or its users.'),
      LegalParagraph(
          '{b}You may stop using the Service at any time, and you may delete '
          'your account and associated data whenever you wish.{/b} Upon '
          'termination of your access, your right to use the Service ceases '
          'immediately.'),
      LegalParagraph(
          'The provisions of these Terms that by their nature should survive '
          'termination will survive, including, without limitation, the '
          'sections on intellectual property, disclaimer of warranties, '
          'limitation of liability, and indemnification.'),
    ]),
    LegalSection(title: '8. Qur’anic Content & Non-Derivation', paragraphs: [
      LegalParagraph(
          'The Qur’anic Arabic text presented in the Service is the sacred '
          'text of the Holy Qur’an. It is provided to you from trusted, fixed '
          'sources and is reproduced faithfully, character for character. '
          '{b}We never generate, alter, fabricate, or "rewrite" the Qur’anic '
          'text under any circumstances.{/b} The Qur’an is the word of God and '
          'is treated by us with the utmost reverence.'),
      LegalParagraph(
          'Any AI features included in the Service are strictly assistive in '
          'nature. {b}Their purpose is limited to analyzing your recitation and '
          'answering learning questions — they are never used to create, '
          'modify, or reinterpret the revealed text.{/b}'),
      LegalParagraph(
          'You may use the Qur’anic text within the Service for your personal '
          'study and memorization. Commercial redistribution or republication '
          'of the Qur’anic text is governed by the licenses of the underlying '
          'sources and by applicable law, and you may not engage in such '
          'activities without appropriate authorization.'),
    ]),
    LegalSection(title: '9. AI Features & On-Device Recitation Analysis', paragraphs: [
      LegalParagraph(
          'AyahPath includes a recitation analysis feature powered by an '
          'on-device AI model (the Tarteel-style Whisper engine) that listens '
          'to your voice and provides feedback on pronunciation, intonation, '
          'and accuracy. {b}Recitation audio is processed entirely on your '
          'device and is never uploaded to, transmitted to, or stored on our '
          'servers.{/b}'),
      LegalParagraph(
          'The on-device model files are bundled with the application and are '
          'updated through normal app updates. No audio is recorded for, or '
          'sent to, us at any time. This design protects both your privacy and '
          'the sanctity of your recitation.'),
      LegalParagraph(
          'AI feedback is provided solely to help you learn and is not '
          'guaranteed to be perfectly accurate in every case. Tajweed rules '
          'and correct recitation are subtle and will always require the '
          'guidance of a qualified teacher. {b}We are not liable for any '
          'learning outcomes that are based on AI-generated feedback.{/b}'),
    ]),
    LegalSection(title: '10. Data, Privacy, & Your Consent', paragraphs: [
      LegalParagraph(
          'Your use of the Service is also governed by our Privacy Policy, '
          'which is a binding part of these Terms and is incorporated into '
          'them by reference. {b}Please read the Privacy Policy carefully '
          'before using the Service.{/b}'),
      LegalParagraph(
          '{b}By using the Service you consent to the collection, use, and '
          'processing of data as described in the Privacy Policy.{/b} Your '
          'official consent is also confirmed when you check the required '
          'consent box during account creation or sign-in.'),
      LegalParagraph(
          'We store your learning progress and profile online, tied to your '
          'account, so that your experience can be kept in sync. You may '
          'request the deletion of your data at any time, and we will honor '
          'such requests in accordance with the Privacy Policy and applicable '
          'law.'),
      LegalParagraph(
          '{b}We do not sell your personal information, and we do not use your '
          'personal information for advertising or for building profiles of '
          'you for unrelated purposes.{/b}'),
    ]),
    LegalSection(title: '11. Third-Party Services', paragraphs: [
      LegalParagraph(
          'The Service relies on and integrates with certain third-party '
          'services to operate, including Google Firebase for authentication '
          'and data storage, and Google Sign-In for one of our sign-in '
          'options. Your use of those third-party services, and Google’s '
          'processing of your data in connection with them, is subject to '
          'their own terms of service and privacy policies.'),
      LegalParagraph(
          '{b}We are not responsible for the content, operations, privacy '
          'practices, or policies of any third-party service, and you use '
          'them at your own discretion.{/b} We encourage you to review the '
          'terms and privacy policies of any third-party service before using '
          'it.'),
      LegalParagraph(
          'We will make reasonable efforts to inform you of the material '
          'third-party services used by the Service, but our ability to '
          'control those services is limited.'),
    ]),
    LegalSection(title: '12. Intellectual Property Rights', paragraphs: [
      LegalParagraph(
          'All trademarks, service marks, logos, trade names, software, '
          'graphics, user interfaces, and original content (other than the '
          'Qur’anic text, which comes from its own sources) made available '
          'through the Service are owned by us or our licensors and are '
          'protected by copyright, trademark, patent, trade secret, and other '
          'intellectual property laws. We reserve all rights not expressly '
          'granted in these Terms.'),
      LegalParagraph(
          '{b}You may not use our name, logos, or other branding for any '
          'purpose without our prior written consent.{/b} Any feedback, '
          'suggestions, or ideas you submit to us concerning the Service are '
          'voluntary and may be used by us without compensation or obligation '
          'to you.'),
      LegalParagraph(
          'Nothing in these Terms grants you any right to use any of our '
          'trademarks or the trademarks of any third party.'),
    ]),
    LegalSection(title: '13. Content You Provide', paragraphs: [
      LegalParagraph(
          'The Service does not currently support user-generated content such '
          'as public posts or shared uploads, and we do not solicit public '
          'content from users. The learning data you create (your profile, '
          'progress, and memorization records) belongs to you and remains '
          'under your control.'),
      LegalParagraph(
          'You grant us a limited, non-exclusive license to store and process '
          'your learning data solely for the purpose of operating the Service '
          'and keeping it synchronized across your devices. {b}This license '
          'does not give us any right to sell, publicly display, or otherwise '
          'exploit your personal learning data.{/b}'),
      LegalParagraph(
          'If you ever contact us with feedback or questions, we will use your '
          'message only to respond to you and to improve the Service.'),
    ]),
    LegalSection(title: '14. Disclaimer of Warranties', paragraphs: [
      LegalParagraph(
          'YOUR USE OF THE SERVICE IS AT YOUR SOLE RISK. THE SERVICE IS '
          'PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS, WITHOUT WARRANTIES '
          'OR CONDITIONS OF ANY KIND, WHETHER EXPRESS, IMPLIED, STATUTORY, OR '
          'OTHERWISE, INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF '
          'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND '
          'NON-INFRINGEMENT. {b}TO THE FULLEST EXTENT PERMITTED BY LAW, WE '
          'DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED.{/b}'),
      LegalParagraph(
          'We do not warrant that the Service will be uninterrupted, timely, '
          'secure, error-free, or free of viruses or other harmful components. '
          'We do not warrant that the results that may be obtained from the '
          'use of the Service will be accurate or reliable.'),
      LegalParagraph(
          'WE DO NOT WARRANT OR GUARANTEE THAT THE AI-BASED RECITATION '
          'FEEDBACK OR ANY OTHER LEARNING FEATURES WILL MEET YOUR '
          'REQUIREMENTS OR WILL BE FREE FROM ERRORS. ANY CONTENT DOWNLOADED '
          'OR OTHERWISE OBTAINED THROUGH THE USE OF THE SERVICE IS USED AT '
          'YOUR OWN RISK.'),
      LegalParagraph(
          'Some jurisdictions do not allow the exclusion of certain '
          'warranties or the limitation or exclusion of liability for '
          'incidental or consequential damages. Accordingly, some of the '
          'above limitations may not apply to you.'),
    ]),
    LegalSection(title: '15. Limitation of Liability', paragraphs: [
      LegalParagraph(
          'TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT '
          'SHALL WE, OUR DIRECTORS, OFFICERS, EMPLOYEES, AGENTS, OR LICENSORS '
          'BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, '
          'OR PUNITIVE DAMAGES, OR FOR ANY LOSS OF PROFITS, REVENUES, DATA, '
          'OR GOODWILL, WHETHER ARISING IN TORT (INCLUDING NEGLIGENCE), '
          'CONTRACT, OR OTHERWISE, ARISING OUT OF OR IN CONNECTION WITH YOUR '
          'USE OF, OR INABILITY TO USE, THE SERVICE.'),
      LegalParagraph(
          '{b}OUR TOTAL AGGREGATE LIABILITY FOR ANY AND ALL CLAIMS ARISING '
          'FROM OR RELATING TO THE SERVICE SHALL NOT EXCEED THE AMOUNT, IF '
          'ANY, THAT YOU PAID TO US TO USE THE SERVICE DURING THE TWELVE (12) '
          'MONTHS PRECEDING THE DATE OF THE CLAIM.{/b} Because the Service is '
          'currently offered free of charge, in many cases our total liability '
          'will be zero.'),
      LegalParagraph(
          'Some jurisdictions do not allow the exclusion or limitation of '
          'liability for certain types of damages, so portions of this section '
          'may not apply to you. The limitations set forth in this section '
          'shall apply notwithstanding any failure of essential purpose of any '
          'limited remedy, and to the fullest extent permitted by law.'),
    ]),
    LegalSection(title: '16. Indemnification', paragraphs: [
      LegalParagraph(
          'You agree to indemnify, defend, and hold harmless AyahPath and its '
          'affiliates, officers, directors, employees, agents, and licensors '
          'from and against any and all claims, damages, obligations, losses, '
          'liabilities, costs, and expenses (including reasonable attorneys’ '
          'fees) arising out of or related to: (a) your use of the Service; '
          '(b) your violation of these Terms; (c) your violation of any rights '
          'of a third party, including intellectual property rights; or '
          '(d) any violation of applicable law by you.'),
      LegalParagraph(
          'We reserve the right to assume the exclusive defense and control of '
          'any matter otherwise subject to indemnification by you, in which '
          'event you agree to cooperate with us in asserting any available '
          'defenses.'),
    ]),
    LegalSection(title: '17. Changes to the Service & These Terms', paragraphs: [
      LegalParagraph(
          'We may update, change, add, remove, or discontinue any part of the '
          'Service at any time, including features, content, system '
          'requirements, or availability of the Service. {b}We are not '
          'obligated to maintain any particular feature, version, or payment '
          'model, and the Service is provided "as available."{/b}'),
      LegalParagraph(
          'We will make reasonable efforts to notify you of material changes '
          'to the Service or to these Terms, but you acknowledge that the '
          'Service and these Terms may evolve without prior notice. It is '
          'your responsibility to review these Terms periodically.'),
      LegalParagraph(
          'If any provision of these Terms is found to be unenforceable or '
          'invalid, that provision will be limited or eliminated to the '
          'minimum extent necessary so that these Terms otherwise remain in '
          'full force and effect.'),
    ]),
    LegalSection(title: '18. Fees, Payments, & Free Access', paragraphs: [
      LegalParagraph(
          'AyahPath is currently offered to all users free of charge. We have '
          'no subscription fees, no in-app purchases, and no paid tiers at '
          'this time. {b}If we ever introduce paid features, we will provide '
          'clear and transparent information about pricing before you commit '
          'to any payment.{/b}'),
      LegalParagraph(
          'Because the Service is free, you acknowledge that our limitation of '
          'liability (Section 15) means that in most cases our total '
          'liability to you will be zero. We reserve the right to change our '
          'pricing model in the future, but any such change will be '
          'communicated clearly and will apply only prospectively.'),
    ]),
    LegalSection(title: '19. Governing Law & Dispute Resolution', paragraphs: [
      LegalParagraph(
          'These Terms, and your use of the Service, are governed by and '
          'construed in accordance with the laws of the jurisdiction in which '
          'we are established, without regard to its conflict-of-law '
          'principles. Any dispute arising out of or relating to these Terms '
          'or the Service will be resolved in the competent courts of that '
          'jurisdiction.'),
      LegalParagraph(
          '{b}Before initiating any formal proceedings, you agree to first '
          'attempt to resolve any dispute informally by contacting us in '
          'writing and allowing a reasonable period for a response.{/b} We '
          'will likewise make a good-faith effort to resolve any dispute '
          'informally before taking legal action.'),
      LegalParagraph(
          'If you are a consumer in a jurisdiction that provides mandatory '
          'statutory rights, nothing in these Terms limits those rights, and '
          'you retain any such rights to the extent they cannot be lawfully '
          'waived.'),
    ]),
    LegalSection(title: '20. Contact & Support', paragraphs: [
      LegalParagraph(
          'If you have any questions, comments, concerns, or complaints about '
          'these Terms or the Service, please contact us through the support '
          'contact details made available through our website or the app. '
          '{b}We value your feedback and will do our best to respond in a '
          'timely and helpful manner.{/b}'),
      LegalParagraph(
          'When you contact us, please describe your issue as clearly and '
          'fully as you can so that we may assist you effectively.'),
    ]),
    LegalSection(title: '21. Miscellaneous Provisions', paragraphs: [
      LegalParagraph(
          'Entire Agreement: These Terms, together with our Privacy Policy and '
          'any other terms expressly incorporated by reference, constitute the '
          'entire agreement between you and AyahPath regarding your use of the '
          'Service, and supersede any prior agreements or understandings.'),
      LegalParagraph(
          'Severability: If any provision of these Terms is held to be '
          'invalid or unenforceable, that provision will be enforced to the '
          'maximum extent permissible, and the remaining provisions will '
          'remain in full force and effect.'),
      LegalParagraph(
          'No Waiver: Our failure to enforce any provision of these Terms '
          'will not constitute a waiver of that provision or of our right to '
          'enforce it later, and a waiver of any provision will not operate as '
          'a waiver of any other provision.'),
      LegalParagraph(
          'Assignability: You may not assign or transfer your rights or '
          'obligations under these Terms without our prior written consent. '
          'We may assign our rights and obligations under these Terms, in '
          'whole or in part, without restriction.'),
      LegalParagraph(
          'Notices: Any notices required under these Terms may be provided to '
          'you through the Service, by email, or through our website. You '
          'agree to receive notices from us electronically.'),
    ]),
    LegalSection(title: '22. Our Commitment to Users of All Ages', paragraphs: [
      LegalParagraph(
          '{b}AyahPath is fundamentally committed to being a safe, respectful, '
          'and appropriate experience for users of all ages, including children '
          'and families.{/b} This commitment is reflected throughout the '
          'Service: it contains no advertising, no in-app purchases linking to '
          'real-world payments, no public social features, and no content that '
          'is adult, violent, or age-inappropriate.'),
      LegalParagraph(
          'We review our content and features to ensure they remain appropriate '
          'for a general and family audience. If you ever encounter content or '
          'behavior that you believe is inappropriate, we encourage you to '
          'report it to us through the contact details in these Terms so that '
          'we can review and address it.'),
      LegalParagraph(
          '{b}Because we welcome users of all ages, we apply special care to '
          'privacy and safety, and we never permit advertising or third-party '
          'tracking that would exploit or profile young users.{/b}'),
    ]),
    LegalSection(title: '23. Copyright, Trademarks, & DMCA', paragraphs: [
      LegalParagraph(
          'We respect the intellectual property rights of others and expect our '
          'users to do the same. If you believe that any content available '
          'through the Service infringes your copyright, you may notify us with '
          'the following information: (a) a description of the copyrighted '
          'work that you claim has been infringed; (b) a description of where '
          'the allegedly infringing material is located; (c) your contact '
          'information; and (d) a statement that you have a good-faith belief '
          'that the use is not authorized and that the information you provide '
          'is accurate. We will review and respond to valid notices promptly.'),
      LegalParagraph(
          '{b}The Qur’anic text is sacred and is presented from fixed, trusted '
          'sources; it is not our proprietary material and is reproduced '
          'faithfully under the terms of its own sources.{/b} Our trademarks, '
          'logos, and original application assets remain our property.'),
      LegalParagraph(
          'We may remove or disable access to any content that we believe '
          'infringes the rights of others, and we reserve the right to '
          'terminate, in appropriate circumstances, accounts we believe are '
          'repeat infringers.'),
    ]),
    LegalSection(title: '24. Force Majeure', paragraphs: [
      LegalParagraph(
          'We will not be liable or responsible for any failure to perform, '
          'or delay in performance of, any of our obligations under these '
          'Terms where that failure or delay is caused by an event outside '
          'our reasonable control, including but not limited to natural '
          'disasters, war, terrorism, civil unrest, public-health emergencies, '
          'pandemics, power failures, telecommunications or internet outages, '
          'and failures or delays of third-party services upon which we rely.'),
      LegalParagraph(
          '{b}Our obligation to perform is suspended for the duration of any '
          'such event, and we will use reasonable efforts to resume performance '
          'as soon as reasonably practicable.{/b}'),
    ]),
    LegalSection(title: '25. Export Control & Foreign Use', paragraphs: [
      LegalParagraph(
          'The Service may be subject to applicable export-control and economic-'
          'sanctions laws and regulations. You agree to comply with all such '
          'laws and regulations, and you represent that you are not located in '
          'a country that is subject to a trade or economic embargo or '
          'sanctions, and that you are not a person or entity prohibited from '
          'receiving the Service under applicable law.'),
      LegalParagraph(
          '{b}You are solely responsible for ensuring that your use of the '
          'Service complies with the laws of the jurisdiction from which you '
          'access it.{/b} The Service is intended for lawful private study of '
          'the Qur’an, and you are responsible for ensuring such study is '
          'lawful where you live.'),
    ]),
    LegalSection(title: '26. Availability, Support, & Updates', paragraphs: [
      LegalParagraph(
          'We work hard to keep the Service available and reliable, but the '
          'Service is provided on an "as available" basis and we do not '
          'guarantee uninterrupted or error-free operation. We may from time '
          'to time perform maintenance, release updates, or make changes that '
          'require the Service, or certain features, to be temporarily '
          'unavailable.'),
      LegalParagraph(
          '{b}Support is provided on a best-efforts basis.{/b} If you '
          'encounter a problem, we encourage you to report it through the '
          'contact details provided in these Terms, and we will do our best to '
          'assist you. We are not obligated to provide a particular level of '
          'support, to support particular devices or operating systems '
          'indefinitely, or to accept all change requests.'),
      LegalParagraph(
          'We may discontinue support for an older operating system or device '
          'as technology evolves, and we may require you to update the '
          'application in order to continue using it.'),
    ]),
    LegalSection(title: '27. Accessibility & Inclusivity', paragraphs: [
      LegalParagraph(
          '{b}We are committed to making the Service as accessible and '
          'inclusive as possible for users of all abilities and backgrounds.'
          '{/b} We will make reasonable efforts to design the interface to be '
          'clear, readable, and usable, including support for large text, '
          'screen readers, high-contrast styling, and localization for '
          'different languages, including full right-to-left (Arabic) '
          'localization.'),
      LegalParagraph(
          'If you have a disability and encounter difficulty using the '
          'Service, please contact us so that we can work to address the '
          'issue, to the extent it is within our technical ability.'),
    ]),
    LegalSection(title: '28. Your Feedback & Suggestions', paragraphs: [
      LegalParagraph(
          'We welcome your feedback, ideas, and suggestions for improving the '
          'Service. {b}By submitting feedback, you grant us a non-exclusive, '
          'royalty-free, worldwide, perpetual license to use, modify, and '
          'incorporate that feedback into the Service without any '
          'compensation to you.{/b}'),
      LegalParagraph(
          'You agree that you will not submit feedback that contains '
          'confidential information of a third party, or any content that '
          'violates these Terms or applicable law.'),
    ]),
    LegalSection(title: '29. Third-Party Content & No Endorsement', paragraphs: [
      LegalParagraph(
          'The Service may reference, link to, or describe third-party '
          'translations, tafsir (interpretation) materials, educational '
          'resources, or websites for the user’s convenience. '
          '{b}References to third parties are provided for information only '
          'and do not constitute an endorsement of, or affiliation with, those '
          'parties unless expressly stated.{/b}'),
      LegalParagraph(
          '{b}We do not control, and are not responsible for, the accuracy or '
          'content of any third-party material. Users are responsible for '
          'exercising their own judgment and, where appropriate, seeking '
          'qualified religious or scholarly guidance.{/b}'),
    ]),
    LegalSection(title: '30. Your Representations & Responsibilities', paragraphs: [
      LegalParagraph(
          'You represent and warrant that: (a) you will provide accurate '
          'information when using the Service; (b) you will use the Service '
          'only for lawful, personal, non-commercial purposes consistent with '
          'these Terms; (c) you will not attempt to impair, circumventing, or '
          'undermine the security or integrity of the Service; and '
          '(d) you will not use the Service in any manner that violates '
          'applicable law.'),
      LegalParagraph(
          '{b}You are responsible for how you apply what you learn through the '
          'Service, and for ensuring that your use of the Service respect the '
          'rights of others.{/b}'),
    ]),
    LegalSection(title: '31. Consumer Rights & Statutory Protections', paragraphs: [
      LegalParagraph(
          'Nothing in these Terms is intended to exclude, limit, or restrict '
          'any rights or remedies that you may have under applicable consumer '
          'protection or other laws, which cannot be lawfully excluded or '
          'restricted. Where such mandatory rights apply, they prevail over '
          'any conflicting provision in these Terms.'),
      LegalParagraph(
          '{b}We encourage every user to understand their legal rights.{/b} '
          'If you believe that a provision of these Terms is inconsistent with '
          'your statutory rights, or if you have any question about them, '
          'please contact us so that we can address your concern.'),
    ]),
    LegalSection(title: '32. Closing & Acknowledgment', paragraphs: [
      LegalParagraph(
          '{b}These Terms represent a respectful and transparent agreement '
          'between you and AyahPath.{/b} By using the Service, you acknowledge '
          'that you have read these Terms in their entirety, that they are '
          'fair and reasonable in the context of the Service being offered '
          'free of charge and with a strong commitment to privacy, and that '
          'you are capable of entering into this agreement.'),
      LegalParagraph(
          'Thank you for using AyahPath. We are honored to support you on your '
          'journey of learning and connecting with the Qur’an. If you have any '
          'questions about these Terms or the Service, please reach out to us '
          'using the contact details in these Terms — we would love to hear '
          'from you.'),
    ]),
  ],
);

/// Privacy Policy for AyahPath.
const LegalDocument privacyPolicy = LegalDocument(
  title: 'Privacy Policy',
  version: '2.0',
  effectiveDate: 'September 1, 2026',
  intro:
      'At AyahPath, your privacy and trust matter deeply to us. This Privacy '
      'Policy explains in clear and simple language what information we '
      'collect, why we collect it, how we use and protect it, and the choices '
      'you have regarding your information. {b}Our design goal is privacy-first: '
      'your recitation is analyzed entirely on your device, and we collect only '
      'the minimum amount of personal data needed to operate the Service.{/b} '
      'This Policy applies to all users of the Service, and {b}AyahPath '
      'welcomes users of all ages.{/b} By using the Service, you agree to the '
      'practices described in this Policy. If you have any questions, please '
      'contact us using the details in Section 16.',
  sections: [
    LegalSection(title: '1. Introduction & Scope', paragraphs: [
      LegalParagraph(
          'This Privacy Policy describes how AyahPath ("we", "us", or "our") '
          'collects, uses, discloses, retains, and protects information when '
          'you use our mobile application and related services (collectively, '
          'the "Service"). {b}We are committed to protecting the privacy of '
          'every user, including users who are minors, and to being open and '
          'honest about our data practices.{/b}'),
      LegalParagraph(
          'This Policy applies to all information collected through the '
          'Service, whether from adults or from children of any age. Please '
          'read this Policy carefully. It explains the important choices you '
          'have and how you can control your information.'),
      LegalParagraph(
          '{b}Throughout this Policy, "personal information" means information '
          'that relates to you and can be used to identify you, either alone or '
          'in combination with other information.{/b}'),
    ]),
    LegalSection(title: '2. Information We Collect', paragraphs: [
      LegalParagraph(
          'We collect only the minimum information needed to operate the '
          'Service. Specifically, we collect: (a) account credentials, namely '
          'the email address you use to register and either a password (hashed '
          'and stored securely by our authentication provider) or the identity '
          'information provided by your chosen sign-in provider (such as '
          'Google); and (b) the learning data you generate while using the '
          'Service, including your learner profile, your progress through '
          'lessons, your completed lessons, your mastery scores, and your '
          'memorization records.'),
      LegalParagraph(
          '{b}We do not collect your name, phone number, physical postal '
          'address, precise location, or any other sensitive personal data '
          'unless you choose to provide it to us voluntarily.{/b}'),
      LegalParagraph(
          '{b}We do not sell your personal information, and we have never sold '
          'personal information.{/b} We do not use your personal information '
          'for advertising.'),
    ]),
    LegalSection(title: '3. On-Device Recitation Analysis & Audio', paragraphs: [
      LegalParagraph(
          'When you use the recitation practice feature, the Service captures '
          'audio from your device’s microphone for the purpose of analyzing '
          'your recitation. {b}This audio is processed by an AI model that runs '
          'entirely on your device, and it is never uploaded to, transmitted '
          'to, or stored on our servers or on the servers of any third '
          'party.{/b}'),
      LegalParagraph(
          'The on-device AI model files (the Tarteel-style Whisper engine) are '
          'bundled with the application and are updated through normal app '
          'updates. No audio is ever recorded for analysis by us, and no audio '
          'is transmitted to us at any time.'),
      LegalParagraph(
          '{b}Because recitation audio never leaves your device, your '
          'recitation and voice are fully private and are not part of your '
          'online data.{/b} This design also means that your recitation cannot '
          'be intercepted or accessed by us or anyone else.'),
    ]),
    LegalSection(title: '4. Online Account Data & Storage', paragraphs: [
      LegalParagraph(
          'To provide an online, synchronized experience and to keep your '
          'progress safe across reinstalls and across devices, we store '
          'certain data associated with your account on secure servers via '
          'Google Firebase Realtime Database. This includes your learner '
          'profile, your learning progress, your completed lessons, your '
          'mastery scores, and your memorization records.'),
      LegalParagraph(
          '{b}Your learning data is tied to your private account and is never '
          'shared with other users, other applications, or third parties for '
          'advertising or any commercial purpose.{/b}'),
      LegalParagraph(
          'Access to your account data is protected by Firebase security rules '
          'that ensure only you, while signed in to your own account, can read '
          'or modify your own records. We use industry-standard encryption for '
          'data in transit, and your data is stored securely by Firebase.'),
    ]),
    LegalSection(title: '5. Authentication & Sign-In Data', paragraphs: [
      LegalParagraph(
          'Account creation and sign-in are handled by Firebase Authentication, '
          'a service provided by Google. When you register or sign in with an '
          'email address and password, that information is processed by '
          'Firebase, which securely hashes and stores your credentials.'),
      LegalParagraph(
          'When you choose to sign in with your Google account, Google shares '
          'only the minimum identity information needed to authenticate you '
          '(such as your email address and Google account identifier). '
          '{b}We never receive or store your raw password on our own '
          'servers.{/b}'),
      LegalParagraph(
          'Your login session is stored locally on your device using secure '
          'methods so that you can remain signed in between sessions. This '
          'local session is not synchronized to any other location.'),
    ]),
    LegalSection(title: '6. How We Use Information', paragraphs: [
      LegalParagraph(
          'We use the information we collect for the following purposes: '
          '(a) to operate, maintain, and improve the Service; (b) to '
          'personalize your learning plan and deliver lessons adapted to your '
          'progress; (c) to keep your data synchronized across your devices; '
          '(d) to authenticate you and protect the security of your account; '
          '(e) to respond to your questions and provide support; and (f) to '
          'comply with applicable law.'),
      LegalParagraph(
          '{b}We do not use your personal information for targeted advertising, '
          'and we do not build profiles of you for unrelated purposes.{/b}'),
      LegalParagraph(
          'We may use aggregated and de-identified data (data that cannot '
          'reasonably be used to identify you) for analytics, product '
          'improvement, and research. Such data is not personal information.'),
    ]),
    LegalSection(title: '7. Children’s & All-Ages Privacy', paragraphs: [
      LegalParagraph(
          '{b}AyahPath welcomes users of all ages, including children.{/b} We '
          'have designed the Service to be appropriate and safe for users of '
          'all ages, and we apply our privacy protections to every user '
          'regardless of age.'),
      LegalParagraph(
          '{b}We do not collect more information from children than we collect '
          'from any other user, and we never use personal information to '
          'target advertising at children.{/b} The Service contains no '
          'advertising, no third-party tracking for marketing, and no '
          'public-facing social features that would expose a child’s '
          'information to others.'),
      LegalParagraph(
          'We encourage parents and guardians to review this Privacy Policy '
          'and our Terms of Service together with their children so that '
          'everyone understands how the Service works and how data is '
          'handled. If you are a parent or guardian and you have questions '
          'about your child’s use of the Service, please contact us using the '
          'details in Section 16.'),
      LegalParagraph(
          'If we ever become aware that we have collected personal '
          'information in a way that is inconsistent with the laws of a '
          'jurisdiction in which a user resides, we will take prompt steps to '
          'delete that information, and we comply with all applicable laws '
          'and regulations regarding children’s privacy.'),
    ]),
    LegalSection(title: '8. Protecting Your Data & Security', paragraphs: [
      LegalParagraph(
          'We take the security of your information seriously and use '
          'reasonable technical, administrative, and organizational measures '
          'to protect it. These measures include secure, encrypted '
          'transmission of data, access controls that restrict who is able to '
          'view user data, and security rules that ensure only the account '
          'owner can access their own records.'),
      LegalParagraph(
          '{b}No method of transmission over the Internet or method of '
          'electronic storage is 100% secure, and we cannot guarantee the '
          'absolute security of your information.{/b} However, we continually '
          'work to protect our infrastructure and your data.'),
      LegalParagraph(
          'You also play a role in protecting your data. {b}You are '
          'responsible for keeping your password and login credentials '
          'private and secure.{/b} Please do not share your password or '
          'account credentials with anyone.'),
    ]),
    LegalSection(title: '9. Data Retention', paragraphs: [
      LegalParagraph(
          'We retain your account data for as long as your account is active, '
          'or for as long as is reasonably necessary to provide the Service '
          'and to comply with our legal obligations. You may delete your '
          'learning data, or your entire account, at any time from within the '
          'Service.'),
      LegalParagraph(
          '{b}When you delete your data or your account, we take reasonable '
          'steps to remove your personal information from the Service.{/b} '
          'However, some residual copies may remain for a limited period for '
          'technical, legal, or security reasons, and we will dispose of them '
          'in accordance with this Policy and applicable law.'),
    ]),
    LegalSection(title: '10. Your Rights & Choices', paragraphs: [
      LegalParagraph(
          'Depending on where you live, you may have the following rights '
          'regarding your personal information: the right to access, correct, '
          'or update your information; the right to delete your information; '
          'the right to restrict or object to certain processing; the right '
          'to data portability; and the right to lodge a complaint with a '
          'competent supervisory authority.'),
      LegalParagraph(
          'Within the Service, you can often exercise these rights directly, '
          'such as by deleting your learning data or your account. You may '
          'also contact us to request access to, corrections of, or deletion '
          'of your personal information. {b}We will respond to verifiable '
          'requests promptly and within the timeframes required by applicable '
          'law.{/b}'),
      LegalParagraph(
          '{b}You may withdraw your consent to our data practices at any time '
          'by ceasing to use the Service and deleting your data and '
          'account.{/b} Please note that some data may need to be retained '
          'for legal or security reasons as described in this Policy.'),
    ]),
    LegalSection(title: '11. Sharing & Disclosure of Information', paragraphs: [
      LegalParagraph(
          '{b}We do not sell your personal information, and we do not share '
          'your personal information with third parties for their own '
          'marketing or advertising purposes.{/b}'),
      LegalParagraph(
          'We may share your information only in the limited circumstances '
          'described below: (a) with service providers who help us operate '
          'the Service (such as Firebase), who are bound by confidentiality '
          'and may only process your data on our behalf; (b) to comply with '
          'a legal obligation, court order, or other lawful government or '
          'judicial request; (c) to protect our rights, privacy, safety, or '
          'property, or those of our users or the public; or (d) in '
          'connection with a merger, sale, or transfer of all or part of our '
          'business, in which case your information would remain subject to '
          'this Policy.'),
      LegalParagraph(
          '{b}We will never rent, sell, or trade your personal information to '
          'any third party.{/b}'),
    ]),
    LegalSection(title: '12. Third-Party Services & Links', paragraphs: [
      LegalParagraph(
          'The Service relies on certain third-party services to function, '
          'most notably Google Firebase (for authentication and data storage) '
          'and Google Sign-In (for one of our sign-in options). These '
          'third-party services have their own privacy policies, and their '
          'processing of data is governed by those policies.'),
      LegalParagraph(
          '{b}Where we rely on a third-party service, we share only the minimum '
          'information necessary for that service to function.{/b} We '
          'encourage you to review the privacy policies of any third-party '
          'services with which you interact.'),
      LegalParagraph(
          'The Service or our website may contain links to other websites or '
          'services that are not operated by us. {b}We are not responsible for '
          'the privacy practices or the content of any such third-party '
          'sites, and this Policy does not apply to them.{/b}'),
    ]),
    LegalSection(title: '13. International Data Transfers', paragraphs: [
      LegalParagraph(
          'Your data may be processed and stored on servers that are located '
          'outside the country in which you reside, including data centers '
          'operated by our service providers (such as Google Firebase). By '
          'using the Service, you consent to the transfer, processing, and '
          'storage of your information in these locations.'),
      LegalParagraph(
          'Where required by applicable law, we will take appropriate steps to '
          'ensure that suitable safeguards are in place for such transfers so '
          'that your information remains protected to a standard consistent '
          'with this Policy.'),
    ]),
    LegalSection(title: '14. Cookies, Analytics, & Tracking', paragraphs: [
      LegalParagraph(
          'The mobile application itself does not use cookies. Our website may '
          'use basic analytics to understand general, anonymous traffic '
          'patterns (such as how many visitors the page receives), but we do '
          'not use advertising cookies or track users for advertising '
          'purposes.'),
      LegalParagraph(
          '{b}We do not engage in the kind of cross-site or cross-app tracking '
          'used to build advertising profiles, and we do not use tracking '
          'technologies on users of the mobile app.{/b}'),
    ]),
    LegalSection(title: '15. Changes to This Privacy Policy', paragraphs: [
      LegalParagraph(
          'We may update this Privacy Policy from time to time to reflect '
          'changes in our practices, the law, or the Service. When we make '
          'material changes, we will update the effective date of this Policy '
          'and, where appropriate, provide notice within the Service or by '
          'other reasonable means.'),
      LegalParagraph(
          '{b}Your continued use of the Service after any changes take effect '
          'constitutes acceptance of the updated Privacy Policy.{/b} We '
          'encourage you to review this page periodically to stay informed '
          'about how we protect your information.'),
    ]),
    LegalSection(title: '16. Contact Us', paragraphs: [
      LegalParagraph(
          'If you have any questions, comments, or concerns about this Privacy '
          'Policy, our data practices, or your personal information, please '
          'contact us through the support contact details provided on our '
          'website. {b}We take your privacy questions seriously and will '
          'respond as promptly as we can.{/b}'),
      LegalParagraph(
          'When contacting us, please describe your question or concern as '
          'clearly as possible so that we can assist you effectively. If you '
          'are requesting access to or deletion of your personal information, '
          'please let us know so that we can handle your request correctly.'),
    ]),
    LegalSection(title: '17. Legal Bases for Processing', paragraphs: [
      LegalParagraph(
          'Where data-protection laws such as the EU General Data Protection '
          'Regulation (GDPR) or the UK GDPR apply, we rely on one or more of '
          'the following lawful bases for processing your personal information: '
          'legitimate interest (in operating and securing the Service and '
          'improving it for users); performance of a contract (in providing '
          'the Service you have requested); compliance with a legal obligation; '
          'and, where appropriate, your consent.'),
      LegalParagraph(
          '{b}We process the minimum personal information necessary, and we use '
          'privacy-friendly measures wherever possible, such as processing '
          'recitation audio entirely on-device.{/b} If you have questions about '
          'the legal basis on which we rely, please contact us.'),
    ]),
    LegalSection(title: '18. Automated Decision-Making & AI', paragraphs: [
      LegalParagraph(
          'The Service includes an on-device AI feature that analyzes your '
          'recitation and provides feedback, as well as an AI tutor that '
          'answers your learning questions. {b}These features are assistive '
          'only: they do not make automated decisions that produce legal '
          'effects or similarly significant effects about you.{/b}'),
      LegalParagraph(
          '{b}Recitation audio is processed entirely on your device and never '
          'leaves it, and any conversation with the AI tutor is limited to '
          'learning-related questions.{/b} The AI never creates, alters, or '
          'reinterprets the revealed Qur’anic text. AI feedback is educational '
          'advice only and is not guaranteed to be perfectly accurate.'),
      LegalParagraph(
          'If you prefer not to use these AI features, you are free not to do '
          'so; they are optional components of the Service and do not prevent '
          'you from using the core reading, listening, and memorization '
          'features.'),
    ]),
    LegalSection(title: '19. What We Do NOT Collect', paragraphs: [
      LegalParagraph(
          '{b}To be fully transparent, we do NOT collect: your name, phone '
          'number, physical postal address, precise device location, biometric '
          'identifiers, browsing history, or any sensitive categories of '
          'personal data.{/b} We do not collect audio recordings of your '
          'recitation (these are processed on-device only). We do not require '
          'your full legal name to use the Service.'),
      LegalParagraph(
          '{b}We do not engage in targeted advertising, cross-app or cross-site '
          'tracking for profiling, or the sale of personal information in any '
          'form.{/b} If you ever discover the Service collecting something not '
          'described here, please contact us so we can investigate.'),
    ]),
    LegalSection(title: '20. Security Breach & Incident Response', paragraphs: [
      LegalParagraph(
          'We maintain reasonable security practices to protect your '
          'information, including access controls and encryption in transit. '
          'In the unlikely event of a security incident that affects your '
          'personal information, we will take prompt steps to respond, '
          'mitigate, and, where required by applicable law, notify the '
          'relevant authorities and affected users.'),
      LegalParagraph(
          '{b}If you believe you have discovered a security vulnerability, '
          'please disclose it to us responsibly through our contact details '
          'rather than exploiting it, so that we can address it and protect '
          'all users.{/b}'),
    ]),
    LegalSection(title: '21. Regional Legal Notices', paragraphs: [
      LegalParagraph(
          'California (CCPA/CPRA): If you are a California resident, you have '
          'the right to know what personal information we collect, to request '
          'its deletion, to correct inaccuracies, and to be free from '
          'discrimination for exercising your privacy rights. We do not "sell" '
          'or "share" personal information as those terms are defined under '
          'the California Consumer Privacy Act (CCPA), and we do not have any '
          'actual knowledge of selling or sharing, or using, personal '
          'information of minors under 16 in a way that would require us to '
          'provide opt-out rights. You may submit a verifiable request to '
          'exercise your rights using the contact details in this Policy.'),
      LegalParagraph(
          'European Economic Area & UK (GDPR/UK GDPR): If you are located in '
          'the EEA or the UK, you may have rights to access, rectify, erase, '
          'restrict, and object to the processing of your personal '
          'information, and to data portability, as described in Section 10. '
          'You also have the right to lodge a complaint with your local '
          'supervisory authority. Section 17 describes the legal bases we rely '
          'on.'),
      LegalParagraph(
          'Children (COPPA & Similar Laws): Because AyahPath welcomes users of '
          'all ages, and because we collect no advertising, tracking, or '
          'profiling data and play no marketing to children, we do not collect '
          'the kind of information governed by laws such as the U.S. Children’s '
          'Online Privacy Protection Act (COPPA). We recommend that a parent '
          'or guardian review the Service, these Terms, and this Policy with '
          'any child who uses it, and parents and guardians may contact us '
          'with any questions.'),
      LegalParagraph(
          'Other Jurisdictions: Residents of other jurisdictions may contact '
          'us with privacy questions and we will address them in accordance '
          'with this Policy and applicable law.'),
    ]),
    LegalSection(title: '22. Your Consent & How to Change Your Mind', paragraphs: [
      LegalParagraph(
          'By using the Service, you consent to the collection, use, '
          'processing, transfer, and storage of information as described in '
          'this Privacy Policy. {b}Your official consent is also confirmed '
          'when you check the required consent box during account creation or '
          'sign-in.{/b}'),
      LegalParagraph(
          'You may change your mind at any time. You can delete your learning '
          'data or your entire account from within the Service, or contact us '
          'to exercise any of your privacy rights. {b}Withdrawing consent will '
          'not affect the lawfulness of processing that occurred before your '
          'withdrawal.{/b}'),
    ]),
    LegalSection(title: '23. Our Commitment & Closing', paragraphs: [
      LegalParagraph(
          '{b}Your privacy is a core value of AyahPath, not an afterthought.'
          '{/b} We have built the Service to collect as little personal '
          'information as possible, to process your recitation privately on '
          'your own device, to show no advertising, and to give you control '
          'over your data.'),
      LegalParagraph(
          'Thank you for trusting us to support your journey of learning and '
          'connecting with the Qur’an. If you ever have any questions, '
          'comments, or concerns about how your information is handled, please '
          'do not hesitate to contact us — we will be glad to help.'),
    ]),
  ],
);
