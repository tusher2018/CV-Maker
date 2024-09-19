// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:camscanner/CV%20templets/cv_models.dart';
import 'package:camscanner/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

class CvTemplate5 extends StatefulWidget {
  String name, sumarryText, email, address, aboutMe, profession;

  List<String> numbers, skills, hobboys, languages;

  List<Experience> experence;

  List<CertificationsAndTraining> training;

  List<Project> projects;

  List<Volunteer> volenteer;

  List<Reference> references;

  List<Education> education;
  File? imageFile;
  List<Color> theamColor = [
    Colors.black,
    Colors.amber,
    Colors.blue,
    Colors.grey
  ];

  CvTemplate5(
      {super.key,
      required this.imageFile,
      required this.aboutMe,
      required this.address,
      required this.education,
      required this.email,
      required this.experence,
      required this.hobboys,
      required this.languages,
      required this.name,
      required this.numbers,
      required this.profession,
      required this.projects,
      required this.references,
      required this.skills,
      required this.sumarryText,
      required this.training,
      required this.volenteer});

  @override
  State<CvTemplate5> createState() => _CvTemplate5State();
}

class _CvTemplate5State extends State<CvTemplate5> {
  double fontSize = 12.0;
  double rightSideSpace = 50.0;
  double leftSideSpace = 30.0;
  TextEditingController fontSizeController = TextEditingController();
  TextEditingController rightSideSpaceController = TextEditingController();
  TextEditingController leftSideSpaceController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController aboutMe = TextEditingController(text: "About Me");
  TextEditingController education = TextEditingController(text: "Education");
  TextEditingController exprience = TextEditingController(text: "Experence");
  TextEditingController project = TextEditingController(text: "Projects");
  TextEditingController certificationsAndTraining =
      TextEditingController(text: "Certifications and Training");
  TextEditingController volenteer = TextEditingController(text: "Volunteer");
  TextEditingController refarence = TextEditingController(text: "References");
  TextEditingController skills = TextEditingController(text: "Skills");
  TextEditingController hobby = TextEditingController(text: "Hobbies");
  TextEditingController languages = TextEditingController(text: "Languages");
  TextEditingController contact = TextEditingController(text: "Contact");
  bool isJustify = false;
  bool contactInfoIcon = true;
  bool titleOutline = true, titleTrail = true;
  double titleBorderRadious = 10;
  TextEditingController titleBorderRadiousController = TextEditingController();
  List<Widget> RightSideContentList = [];
  List<Widget> LeftSideContentList = [];
  int rightSideSelectedIndex = -1;
  int leftSideSelectedIndex = -1;
  bool skillsRatting = false;
  List<TextEditingController> skillsRattingsController = [];
  List<TextEditingController> languageRattingsController = [];

  @override
  void initState() {
    super.initState();
    fontSizeController.text = fontSize.toString();
    rightSideSpaceController.text = rightSideSpace.toString();
    leftSideSpaceController.text = leftSideSpace.toString();

    titleBorderRadiousController.text = titleBorderRadious.toString();
    for (int i = 0; i < widget.skills.length; i++) {
      skillsRattingsController.add(TextEditingController());
    }
    for (int i = 0; i < widget.languages.length; i++) {
      languageRattingsController.add(TextEditingController());
    }
    initializedList();
  }

  void moveUp() {
    if (rightSideSelectedIndex > 0) {
      setState(() {
        final temp = RightSideContentList[rightSideSelectedIndex];
        RightSideContentList[rightSideSelectedIndex] =
            RightSideContentList[rightSideSelectedIndex - 1];
        RightSideContentList[rightSideSelectedIndex - 1] = temp;
        rightSideSelectedIndex = -1;
      });
    }
    if (leftSideSelectedIndex > 0) {
      setState(() {
        final temp = LeftSideContentList[leftSideSelectedIndex];
        LeftSideContentList[leftSideSelectedIndex] =
            LeftSideContentList[leftSideSelectedIndex - 1];
        LeftSideContentList[leftSideSelectedIndex - 1] = temp;
        leftSideSelectedIndex = -1;
      });
    }
  }

  void moveDown() {
    if (rightSideSelectedIndex < RightSideContentList.length - 1 &&
        rightSideSelectedIndex != -1) {
      setState(() {
        final temp = RightSideContentList[rightSideSelectedIndex];
        RightSideContentList[rightSideSelectedIndex] =
            RightSideContentList[rightSideSelectedIndex + 1];
        RightSideContentList[rightSideSelectedIndex + 1] = temp;
        rightSideSelectedIndex = -1;
      });
    }
    if (leftSideSelectedIndex < LeftSideContentList.length - 1 &&
        leftSideSelectedIndex != -1) {
      setState(() {
        final temp = LeftSideContentList[leftSideSelectedIndex];
        LeftSideContentList[leftSideSelectedIndex] =
            LeftSideContentList[leftSideSelectedIndex + 1];
        LeftSideContentList[leftSideSelectedIndex + 1] = temp;
        leftSideSelectedIndex = -1;
      });
    }
  }

  void initializedList() {
    RightSideContentList = [
      Container(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            commonText(capitalizeFirstLetterOfEachWord(widget.name),
                isBold: true, color: Colors.white, size: fontSize + 21),
            commonText(capitalizeFirstLetterOfEachWord(widget.profession),
                color: Colors.white, size: fontSize + 12),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleBuilder(aboutMe.text),
          commonText(
              capitalizeFirstLetterOfEachSentence(
                widget.aboutMe,
              ),
              alignment: (isJustify) ? TextAlign.justify : TextAlign.left,
              size: fontSize),
          SizedBox(
            height: rightSideSpace,
          ),
        ],
      ),
      if (widget.experence.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleBuilder(exprience.text),
            SizedBox(
              height: rightSideSpace * 0.2,
            ),
            Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.experence.length ~/ 2,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:
                                  experienceItem(widget.experence[index * 2]),
                            )),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: experienceItem(
                                  widget.experence[1 + index * 2]),
                            )),
                          ]),
                      SizedBox(
                        height: rightSideSpace * 0.2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.experence.length.isOdd)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: experienceItem(
                      widget.experence[widget.experence.length - 1]),
                )),
              ]),
            SizedBox(
              height: rightSideSpace,
            ),
          ],
        ),
      if (widget.education.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleBuilder(education.text),
            SizedBox(
              height: rightSideSpace * 0.2,
            ),
            Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.education.length ~/ 2,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: educationItem(widget.education[index * 2]),
                            )),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: educationItem(
                                  widget.education[1 + index * 2]),
                            )),
                          ]),
                      SizedBox(
                        height: rightSideSpace * 0.2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.education.length.isOdd)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: educationItem(
                      widget.education[widget.education.length - 1]),
                )),
              ]),
            SizedBox(
              height: rightSideSpace,
            ),
          ],
        ),
      if (widget.projects.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleBuilder(project.text),
            Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.projects.length ~/ 2,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: projectItem(
                                capitalizeFirstLetterOfEachWord(
                                    widget.projects[index].title ?? ""),
                                capitalizeFirstLetterOfEachWord(
                                    widget.projects[index].roleResponsibility ??
                                        ""),
                                widget.projects[index].linking ?? "",
                                capitalizeFirstLetterOfEachSentence(
                                    widget.projects[index].description ?? ""),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: projectItem(
                                capitalizeFirstLetterOfEachWord(
                                    widget.projects[index * 2].title ?? ""),
                                capitalizeFirstLetterOfEachWord(
                                    widget.projects[index].roleResponsibility ??
                                        ""),
                                widget.projects[1 + index * 2].linking ?? "",
                                capitalizeFirstLetterOfEachSentence(
                                    widget.projects[index].description ?? ""),
                              ),
                            )),
                          ]),
                      SizedBox(
                        height: rightSideSpace * 0.2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.projects.length.isOdd)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: projectItem(
                    capitalizeFirstLetterOfEachWord(
                        widget.projects[widget.projects.length - 1].title ??
                            ""),
                    capitalizeFirstLetterOfEachWord(widget
                            .projects[widget.projects.length - 1]
                            .roleResponsibility ??
                        ""),
                    widget.projects[widget.projects.length - 1].linking ?? "",
                    capitalizeFirstLetterOfEachSentence(widget
                            .projects[widget.projects.length - 1].description ??
                        ""),
                  ),
                )),
              ]),
            SizedBox(height: rightSideSpace),
          ],
        ),
      if (widget.training.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleBuilder(certificationsAndTraining.text),
            Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.training.length ~/ 2,
                  itemBuilder: (context, index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: trainingItem(
                            capitalizeFirstLetterOfEachWord(
                                widget.training[index].certificationName ?? ""),
                            capitalizeFirstLetterOfEachWord(
                                widget.training[index].organizationName ?? ""),
                            widget.training[index].issueDate ?? "",
                            capitalizeFirstLetterOfEachSentence(
                                widget.training[index].expiryDate ?? ""),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: trainingItem(
                            capitalizeFirstLetterOfEachWord(
                                widget.training[index * 2].certificationName ??
                                    ""),
                            capitalizeFirstLetterOfEachWord(
                                widget.training[index].organizationName ?? ""),
                            widget.training[1 + index * 2].issueDate ?? "",
                            capitalizeFirstLetterOfEachSentence(
                                widget.training[index].expiryDate ?? ""),
                          ),
                        )),
                      ]),
                ),
              ],
            ),
            if (widget.training.length.isOdd)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: trainingItem(
                    capitalizeFirstLetterOfEachWord(widget
                            .training[widget.training.length - 1]
                            .certificationName ??
                        ""),
                    capitalizeFirstLetterOfEachWord(widget
                            .training[widget.training.length - 1]
                            .organizationName ??
                        ""),
                    widget.training[widget.training.length - 1].issueDate ?? "",
                    capitalizeFirstLetterOfEachSentence(widget
                            .training[widget.training.length - 1].expiryDate ??
                        ""),
                  ),
                )),
              ]),
            SizedBox(
              height: rightSideSpace,
            ),
          ],
        ),
      if (widget.volenteer.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleBuilder(volenteer.text),
            Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.volenteer.length ~/ 2,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: volunteerItem(
                                capitalizeFirstLetterOfEachWord(
                                    widget.volenteer[index].role ?? ""),
                                capitalizeFirstLetterOfEachWord(
                                    widget.volenteer[index].organization ?? ""),
                                widget.volenteer[index].dateService ?? "",
                                capitalizeFirstLetterOfEachSentence(
                                    widget.volenteer[index].location ?? ""),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: volunteerItem(
                                capitalizeFirstLetterOfEachWord(
                                    widget.volenteer[index * 2].role ?? ""),
                                capitalizeFirstLetterOfEachWord(
                                    widget.volenteer[index].organization ?? ""),
                                widget.volenteer[1 + index * 2].dateService ??
                                    "",
                                capitalizeFirstLetterOfEachSentence(
                                    widget.volenteer[index].location ?? ""),
                              ),
                            )),
                          ]),
                      SizedBox(
                        height: rightSideSpace * 0.2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.volenteer.length.isOdd)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: volunteerItem(
                    capitalizeFirstLetterOfEachWord(
                        widget.volenteer[widget.volenteer.length - 1].role ??
                            ""),
                    capitalizeFirstLetterOfEachWord(widget
                            .volenteer[widget.volenteer.length - 1]
                            .organization ??
                        ""),
                    widget.volenteer[widget.volenteer.length - 1].dateService ??
                        "",
                    capitalizeFirstLetterOfEachSentence(widget
                            .volenteer[widget.volenteer.length - 1].location ??
                        ""),
                  ),
                )),
              ]),
            SizedBox(
              height: rightSideSpace,
            ),
          ],
        ),
      if (widget.references.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleBuilder(refarence.text),
            Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.references.length ~/ 2,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: ReferenceItem(
                                capitalizeFirstLetterOfEachWord(
                                    widget.references[index].name ?? ""),
                                capitalizeFirstLetterOfEachWord(
                                    widget.references[index].title ?? ""),
                                widget.references[index].phone ?? "",
                                widget.references[index].email ?? "",
                                capitalizeFirstLetterOfEachWord(
                                    widget.references[index].relation ?? ""),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: ReferenceItem(
                                capitalizeFirstLetterOfEachWord(
                                    widget.references[index * 2].name ?? ""),
                                capitalizeFirstLetterOfEachWord(
                                    widget.references[index].title ?? ""),
                                widget.references[1 + index * 2].phone ?? "",
                                widget.references[index].email ?? "",
                                capitalizeFirstLetterOfEachWord(
                                    widget.references[index].relation ?? ""),
                              ),
                            )),
                          ]),
                      SizedBox(
                        height: rightSideSpace * 0.2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.references.length.isOdd)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ReferenceItem(
                    capitalizeFirstLetterOfEachWord(
                        widget.references[widget.references.length - 1].name ??
                            ""),
                    capitalizeFirstLetterOfEachWord(
                        widget.references[widget.references.length - 1].title ??
                            ""),
                    widget.references[widget.references.length - 1].phone ?? "",
                    widget.references[widget.references.length - 1].email ?? "",
                    capitalizeFirstLetterOfEachWord(widget
                            .references[widget.references.length - 1]
                            .relation ??
                        ""),
                  ),
                )),
              ]),
            SizedBox(
              height: rightSideSpace,
            ),
          ],
        ),
    ];
    LeftSideContentList = [
      Visibility(
        visible: widget.imageFile != null,
        child: Container(
          margin: const EdgeInsets.only(top: 30.0, left: 20, bottom: 30),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                border:
                    Border.all(width: 5, color: Color.fromRGBO(21, 84, 128, 1)),
                color: Colors.black87,
                image: (widget.imageFile != null)
                    ? DecorationImage(image: FileImage(widget.imageFile!))
                    : null),
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          titleBuilder(contact.text,
              backgroundColor: Colors.white, foregroundColor: Colors.black),
          const SizedBox(
            height: 2,
          ),
          Visibility(
              visible: !contactInfoIcon,
              child: commonText('Phone: ',
                  color: Colors.white, size: fontSize + 2)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: contactInfoIcon,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(
                      Icons.phone,
                      size: fontSize + 2,
                      color: Colors.white,
                    ),
                  )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.numbers.length,
                    (index) {
                      return commonText(widget.numbers[index],
                          size: fontSize, color: Colors.white70);
                    },
                  ),
                ),
              ),
            ],
          ),
          Visibility(
              visible: !contactInfoIcon,
              child: commonText('Email: ',
                  color: Colors.white, size: fontSize + 2)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: contactInfoIcon,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(
                      Icons.email_outlined,
                      size: fontSize + 2,
                      color: Colors.white,
                    ),
                  )),
              Expanded(
                  child: commonText(widget.email,
                      size: fontSize, color: Colors.white70)),
            ],
          ),
          Visibility(
              visible: !contactInfoIcon,
              child: commonText('Address: ',
                  color: Colors.white, size: fontSize + 2)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: contactInfoIcon,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(
                      Icons.location_on_outlined,
                      size: fontSize + 2,
                      color: Colors.white,
                    ),
                  )),
              Expanded(
                  child: commonText(widget.address,
                      size: fontSize, color: Colors.white70)),
            ],
          ),
        ],
      ),
      SizedBox(
        height: leftSideSpace,
      ),
      if (widget.skills.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            titleBuilder(skills.text,
                foregroundColor: Colors.black, backgroundColor: Colors.white),
            (skillsRatting && widget.skills.isNotEmpty)
                ? Column(
                    children: List.generate(
                    widget.skills.length,
                    (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText(widget.skills[index], color: Colors.white),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: List.generate(
                                5,
                                (index2) {
                                  return Icon(
                                    (int.tryParse(skillsRattingsController[
                                                        index]
                                                    .text) !=
                                                null &&
                                            int.parse(skillsRattingsController[
                                                        index]
                                                    .text) <
                                                index2 + 1)
                                        ? Icons.star_border
                                        : Icons.star,
                                    size: fontSize,
                                    color: Colors.yellow,
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ))
                : leftSideContentBody(widget.skills)
          ],
        ),
      SizedBox(
        height: leftSideSpace,
      ),
      if (widget.hobboys.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            titleBuilder(hobby.text,
                foregroundColor: Colors.black, backgroundColor: Colors.white),
            leftSideContentBody(widget.hobboys)
          ],
        ),
      SizedBox(
        height: leftSideSpace,
      ),
      if (widget.languages.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            titleBuilder(languages.text,
                backgroundColor: Colors.white, foregroundColor: Colors.black),
            (skillsRatting && widget.languages.isNotEmpty)
                ? Column(
                    children: List.generate(
                    widget.languages.length,
                    (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonText(widget.languages[index],
                              color: Colors.white),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: List.generate(
                                5,
                                (index2) {
                                  return Icon(
                                    (int.tryParse(languageRattingsController[
                                                        index]
                                                    .text) !=
                                                null &&
                                            int.parse(
                                                    languageRattingsController[
                                                            index]
                                                        .text) <
                                                index2 + 1)
                                        ? Icons.star_border
                                        : Icons.star,
                                    size: fontSize,
                                    color: Colors.yellow,
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ))
                : leftSideContentBody(widget.languages)
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                initializedList();
                if (double.tryParse(fontSizeController.text.toString()) !=
                    null) {
                  fontSize = double.parse(fontSizeController.text.toString());
                }
                if (double.tryParse(rightSideSpaceController.text.toString()) !=
                    null) {
                  rightSideSpace =
                      double.parse(rightSideSpaceController.text.toString());
                }
                if (double.tryParse(leftSideSpaceController.text.toString()) !=
                    null) {
                  leftSideSpace =
                      double.parse(leftSideSpaceController.text.toString());
                }
                if (double.tryParse(
                        titleBorderRadiousController.text.toString()) !=
                    null) {
                  titleBorderRadious = double.parse(
                      titleBorderRadiousController.text.toString());
                }
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: commonTextField(
                        context: context,
                        text: "Font Size",
                        controller: fontSizeController,
                        keyboardType: TextInputType.number)),
                Expanded(
                    flex: 2,
                    child: commonTextField(
                        context: context,
                        text: "Space Size (Right)",
                        keyboardType: TextInputType.number,
                        controller: rightSideSpaceController)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: commonTextField(
                        context: context,
                        text: "Space Size (Left)",
                        keyboardType: TextInputType.number,
                        controller: leftSideSpaceController)),
                Expanded(
                  child: Container(),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Checkbox(
                  value: isJustify,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      isJustify = value;
                    });
                  },
                ),
                commonText("About Me center Alignment"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: contactInfoIcon,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      contactInfoIcon = value;
                    });
                  },
                ),
                commonText("Contact Field as icon"),
              ],
            ),
            ExpansionTile(
              title: commonText("Advanced Customization", size: 16),
              children: [
                ExpansionTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: commonText("Placeholders for titles", size: 14),
                      ),
                    ],
                  ),
                  children: [
                    commonTextField(
                        context: context,
                        text: "About Me",
                        controller: aboutMe),
                    commonTextField(
                        context: context,
                        text: "Education",
                        controller: education),
                    commonTextField(
                        context: context,
                        text: "Experence",
                        controller: exprience),
                    commonTextField(
                        context: context,
                        text: "Projects",
                        controller: project),
                    commonTextField(
                        context: context,
                        text: "Certifications and Training",
                        controller: certificationsAndTraining),
                    commonTextField(
                        context: context,
                        text: "Volunteer",
                        controller: volenteer),
                    commonTextField(
                        context: context,
                        text: "References",
                        controller: refarence),
                    commonTextField(
                        context: context, text: "Skills", controller: skills),
                    commonTextField(
                        context: context, text: "Hobbies", controller: hobby),
                    commonTextField(
                        context: context,
                        text: "Languages",
                        controller: languages),
                    commonTextField(
                        context: context, text: "Contact", controller: contact),
                  ],
                ),
                ExpansionTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: commonText("Title Customization", size: 14),
                      ),
                    ],
                  ),
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: titleOutline,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              titleOutline = value;
                            });
                          },
                        ),
                        commonText("Title OutLine Enable"),
                      ],
                    ),
                    Visibility(
                        visible: titleOutline,
                        child: commonTextField(
                            context: context,
                            text: "Boarder radious",
                            keyboardType: TextInputType.number,
                            controller: titleBorderRadiousController)),
                    Row(
                      children: [
                        Checkbox(
                          value: titleTrail,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              titleTrail = value;
                            });
                          },
                        ),
                        commonText("Title trail Enable"),
                      ],
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: commonText("Rearange Fields", size: 14),
                      ),
                    ],
                  ),
                  children: [
                    commonText(
                        "Click any Field then use the button to move it up or down.\n(Use it at last of others customization)"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: rightSideSelectedIndex == -1 &&
                                  leftSideSelectedIndex == -1
                              ? null
                              : moveUp,
                          child: commonText('Move Up'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: rightSideSelectedIndex == -1 &&
                                  leftSideSelectedIndex == -1
                              ? null
                              : moveDown,
                          child: commonText('Move Down'),
                        ),
                      ],
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: commonText("Skills customization", size: 14),
                      ),
                    ],
                  ),
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: skillsRatting,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              skillsRatting = value;
                            });
                          },
                        ),
                        commonText("Skills & language Star design Enable"),
                      ],
                    ),
                    Visibility(
                        visible: skillsRatting,
                        child: Column(
                          children: List.generate(
                            widget.skills.length,
                            (index) {
                              return commonTextField(
                                  context: context,
                                  text: widget.skills[index],
                                  controller: skillsRattingsController[index]);
                            },
                          ),
                        )),
                    Visibility(
                        visible: skillsRatting,
                        child: Column(
                          children: List.generate(
                            widget.languages.length,
                            (index) {
                              return commonTextField(
                                  context: context,
                                  text: widget.languages[index],
                                  controller:
                                      languageRattingsController[index]);
                            },
                          ),
                        )),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),

            ////////////////////

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: PdfPageFormat.a4.width,
                            height: 200,
                            color: Color(0xFF548ca7),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: PdfPageFormat.a4.width,
                        height: PdfPageFormat.a4.height,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                  color: Color.fromRGBO(21, 84, 128, 1),
                                  padding: EdgeInsets.all(15),
                                  child: Flex(
                                    direction: Axis.vertical,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      LeftSideContentList.length,
                                      (index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                leftSideSelectedIndex = index;
                                              });
                                            },
                                            child: LeftSideContentList[index]);
                                      },
                                    ),
                                  )),
                            ),
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 30, top: 10, bottom: 20),
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Flex(
                                      direction: Axis.vertical,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        RightSideContentList.length,
                                        (index) {
                                          return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  rightSideSelectedIndex =
                                                      index;
                                                });
                                              },
                                              child:
                                                  RightSideContentList[index]);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),

            ////////////////////

            ElevatedButton(
                onPressed: () async {
                  final pdf = pw.Document();
                  print("1");
                  final imageFile = await screenshotController.capture();
                  print("2");
                  pdf.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (context) {
                        return pw.Center(
                          child: (imageFile != null)
                              ? pw.Image(pw.MemoryImage(imageFile),
                                  width: PdfPageFormat.a4.width,
                                  fit: pw.BoxFit.cover,
                                  height: PdfPageFormat.a4.height)
                              : pw.Text("Sorry! Please try again"),
                        );
                      },
                    ),
                  );
                  print("3");
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => PdfPreview(
                      build: (format) => pdf.save(),
                    ),
                  );
                },
                child: commonText("Create CV")),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget titleBuilder(String title,
      {isBold = true,
      backgroundColor = Colors.black,
      size = 4,
      foregroundColor = Colors.white}) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          width: double.infinity,
          padding: (titleOutline)
              ? const EdgeInsets.only(left: 8, top: 1, bottom: 1)
              : const EdgeInsets.all(0),
          margin: EdgeInsets.only(right: (titleTrail) ? 10 : 0),
          decoration: BoxDecoration(
              border: Border.all(
                width: (titleOutline) ? 1 : 0,
                color: (titleOutline) ? backgroundColor : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(titleBorderRadious)),
          child: commonText(title,
              isBold: isBold, color: backgroundColor, size: fontSize + size),
        ),
        Visibility(
          visible: titleTrail,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: commonText(title.characters.first.toUpperCase(),
                color: foregroundColor, size: fontSize + size + 1),
          ),
        )
      ],
    );
  }

  Widget leftSideContentBody(List<String> list) {
    return commonText("   " + list.join("\n   "),
        color: Colors.white70, size: fontSize + 2);
  }

  String capitalizeFirstLetterOfEachWord(String input) {
    return input;
  }

  String capitalizeFirstLetterOfEachSentence(String paragraph) {
    return paragraph;
  }

  Widget experienceItem(Experience experence) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (experence.companyName != null && experence.companyName!.isNotEmpty)
          commonText(experence.companyName!.toString(),
              color: Colors.black, size: fontSize + 4),
        if (experence.workRole != null && experence.workRole!.isNotEmpty)
          commonText(experence.workRole!,
              color: Colors.black87, size: fontSize + 2),
        if (experence.year != null && experence.year!.isNotEmpty)
          commonText(experence.year!, color: Colors.black87, size: fontSize),
        if (experence.description != null && experence.description!.isNotEmpty)
          commonText(experence.description!,
              color: Colors.black, size: fontSize),
      ],
    );
  }

  Widget educationItem(Education education) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (education.institutionName != null &&
            education.institutionName!.isNotEmpty)
          commonText(education.institutionName!,
              color: Colors.black, size: fontSize + 4),
        if (education.degree != null && education.degree!.isNotEmpty)
          commonText(education.degree!,
              color: Colors.black87, size: fontSize + 2),
        if (education.year != null && education.year!.isNotEmpty)
          commonText(education.year!, color: Colors.black87, size: fontSize),
        if (education.gpa != null && education.gpa!.isNotEmpty)
          commonText(education.gpa!, color: Colors.black87, size: fontSize),
        if (education.description != null && education.description!.isNotEmpty)
          commonText(education.description!,
              color: Colors.black, size: fontSize),
      ],
    );
  }

  Widget trainingItem(
      String title, String organization, String issue, String expire) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          commonText(title, color: Colors.black, size: fontSize + 4),
        if (organization.isNotEmpty)
          commonText(organization, color: Colors.black87, size: fontSize + 2),
        if (issue.isNotEmpty)
          commonText(issue, color: Colors.black87, size: fontSize + 2),
        if (expire.isNotEmpty)
          commonText(expire, color: Colors.black87, size: fontSize + 2),
      ],
    );
  }

  Widget projectItem(String title, String role_responsibility, String linking,
      String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.isNotEmpty)
          commonText(title, color: Colors.black, size: fontSize + 4),
        if (role_responsibility.isNotEmpty)
          commonText(role_responsibility,
              color: Colors.black87, size: fontSize + 2),
        if (description.isNotEmpty)
          commonText(description, color: Colors.black, size: fontSize),
        if (linking.isNotEmpty)
          commonText(linking, color: Colors.blue.shade900, size: fontSize),
      ],
    );
  }

  Widget ReferenceItem(
      String name, String title, String phone, String email, String relation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name.isNotEmpty)
          commonText(name, color: Colors.black, size: fontSize + 4),
        if (title.isNotEmpty)
          commonText(title, color: Colors.black87, size: fontSize + 2),
        if (phone.isNotEmpty)
          commonText(phone, color: Colors.black87, size: fontSize),
        if (email.isNotEmpty)
          commonText(email, color: Colors.black87, size: fontSize),
        if (relation.isNotEmpty)
          commonText(relation, color: Colors.black87, size: fontSize),
      ],
    );
  }

  Widget volunteerItem(
      String role, String organization, String dateService, String location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (role.isNotEmpty)
          commonText(role, color: Colors.black, size: fontSize + 4),
        if (organization.isNotEmpty)
          commonText(organization, color: Colors.black87, size: fontSize + 2),
        if (dateService.isNotEmpty)
          commonText(dateService, color: Colors.black, size: fontSize),
        if (location.isNotEmpty)
          commonText("$location", color: Colors.black87, size: fontSize),
      ],
    );
  }

  File? imagepicked;
}
