import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:see_vee/app/viewmodel/home_viewmodel.dart';
import 'package:see_vee/app/widgets/app_badge.dart';
import 'package:see_vee/app/widgets/app_title.dart';
import 'package:see_vee/model/cv_model.dart';

import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Consumer<HomeViewModel>(builder: (context, viewmodel, child) {
      final model = viewmodel.model;
      final workExperience = model?.work;
      final education = model?.education;
      final projects = model?.projects;
      if (model != null) {
        return SelectionArea(
          child: Scaffold(
              body: Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: deviceWidth * (deviceWidth >= 800 ? 0.25 : 0.05),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 75),
                    headerCard(
                      name: model.name ?? '',
                      description: model.quote,
                      location: model.location,
                      contacts: model.contact,
                    ),
                    const SizedBox(height: 30),
                    aboutMeCard(description: model.aboutMe ?? ''),
                    const SizedBox(height: 30),
                    if (workExperience != null && workExperience.isNotEmpty)
                      experienceCard(
                        title: 'Work Experience',
                        cardItem: workExperience
                            .map((exp) => experienceCardItem(
                                title: exp.company ?? '',
                                position: exp.position,
                                description: exp.description,
                                startDate: exp.startDate ?? '',
                                endDate: exp.endDate,
                                badges: exp.badges))
                            .toList(),
                      ),
                    const SizedBox(height: 30),
                    if (education != null && education.isNotEmpty)
                      experienceCard(
                        title: 'Education',
                        cardItem: education
                            .map((details) => experienceCardItem(
                                title: details.school ?? '',
                                position: details.degree,
                                description: details.description,
                                startDate: details.start ?? '',
                                endDate: details.end))
                            .toList(),
                      ),
                    const SizedBox(height: 30),
                    if (model.skills != null) skillsCard(model.skills!),
                    const SizedBox(height: 30),
                    // if (projects != null)
                    //   GridView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: _calculateCrossAxisCount(context),
                    //       crossAxisSpacing: 10,
                    //       mainAxisSpacing: 10,
                    //       // childAspectRatio: 4 / 3,
                    //     ),
                    //     itemCount: projects.length,
                    //     itemBuilder: (context, index) {
                    //       final project = projects[index];
                    //       return projectCard(
                    //         title: project.title ?? '',
                    //         description: project.description ?? '',
                    //         techStack: project.badges ?? [],
                    //       );
                    //     },
                    //   ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          )),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    if (deviceWidth >= 1024) {
      return 3;
    } else if (deviceWidth >= 768) {
      return 2;
    } else {
      return 1;
    }
  }

  Widget headerCard({
    required String name,
    String? description,
    String? location,
    List<Contact>? contacts,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTitle(title: name, fontSize: 24),
              const SizedBox(height: 8),
              Text(
                description ?? '',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              locationItem(location),
              const SizedBox(height: 12),
              if (contacts != null) contactList(contacts),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/IMG_1191_1.jpg',
                width: 120,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget locationItem(String? location) {
    return Row(
      children: [
        const FaIcon(
          FontAwesomeIcons.locationDot,
          size: 20,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            location != null && location.isNotEmpty
                ? location
                : 'Around the Globe.',
          ),
        ),
      ],
    );
  }

  Widget contactList(List<Contact> contactList) {
    return Row(
      children: [
        ...contactList
            .map(
              (contact) => contactListItem(
                ContactType.fromContactType(contact.id),
                url: contact.url,
              ),
            )
            .toList(),
      ],
    );
  }

  Widget contactListItem(ContactType type, {String? url}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          if (url != null && url.isNotEmpty) {
            switch (type) {
              case ContactType.unknown:
                break;
              case ContactType.email:
                launchUrlString('mailto:$url');
              case ContactType.phone:
                launchUrlString('tel:$url');
              case ContactType.github:
              case ContactType.twitter:
                launchUrlString(url);
            }
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            FaIcon(
              type.toGetIcons(),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget aboutMeCard({required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitle(title: 'About Me'),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget experienceCard({
    required String title,
    required List<Widget> cardItem,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTitle(title: title),
        ...cardItem,
      ],
    );
  }

  Widget experienceCardItem({
    required String title,
    String? position,
    String? description,
    required String startDate,
    String? endDate,
    List<String>? badges,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          experienceItemTitle(title, startDate, endDate, badges),
          if (position != null) experienceItemPosition(position),
          if (description != null) experienceItemDescription(description),
        ],
      ),
    );
  }

  Widget experienceItemTitle(
    String title,
    String startDate,
    String? endDate,
    List<String>? badges,
  ) {
    return Row(
      children: [
        AppTitle(
          title: title,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(width: 6),
        if (badges != null && badges.isNotEmpty)
          ...badges
              .map((badge) => AppBadge(
                    title: badge,
                    backgroundColor: Colors.greenAccent,
                  ))
              .toList(),
        const Spacer(flex: 1),
        Expanded(
          flex: 1,
          child: Text(
            '$startDate${endDate != null ? " - $endDate" : ""}',
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }

  Widget experienceItemPosition(String position) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(position),
    );
  }

  Widget experienceItemDescription(String description) {
    return Text(
      description,
      textAlign: TextAlign.justify,
    );
  }

  Widget skillsCard(List<String> skillList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTitle(title: 'Skills'),
        const SizedBox(height: 14),
        Wrap(
          spacing: 6,
          runSpacing: 10,
          children: skillList.map((skill) => AppBadge(title: skill)).toList(),
        )
      ],
    );
  }
}

Widget projectCard({
  required String title,
  required String description,
  List<String>? techStack,
}) {
  return Container(
    color: Colors.amber,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitle(
            title: title,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}

enum ContactType {
  unknown(0),
  email(1),
  phone(2),
  github(3),
  twitter(4);

  const ContactType(this.id);
  final int id;

  static ContactType fromContactType(int? id) {
    return ContactType.values.firstWhere(
      (element) => element.id == id,
      orElse: () => ContactType.unknown,
    );
  }

  IconData? toGetIcons() {
    switch (this) {
      case ContactType.email:
        return FontAwesomeIcons.envelope;
      case ContactType.phone:
        return FontAwesomeIcons.phone;
      case ContactType.github:
        return FontAwesomeIcons.github;
      case ContactType.twitter:
        return FontAwesomeIcons.xTwitter;
      case ContactType.unknown:
        return null;
    }
  }
}
