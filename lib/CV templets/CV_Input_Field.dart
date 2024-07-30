// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, file_names, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:camscanner/CV%20templets/cv_models.dart';
import 'package:camscanner/CV%20templets/templets_1.dart';
import 'package:camscanner/CV%20templets/templets_3.dart';
import 'package:camscanner/common_widget.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pdf/pdf.dart';

class CvMaker extends StatefulWidget {
  String? AIResponse;
  CvMaker({super.key, required this.templets, this.AIResponse});
  int templets;

  @override
  State<CvMaker> createState() => _CvMakerState();
}

class _CvMakerState extends State<CvMaker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    if (widget.AIResponse != null && widget.AIResponse!.isNotEmpty) {
      assignValue(widget.AIResponse!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: inputPage(context),
    );
  }

  double currentHight = 0;
  int currentStep = 0;
  bool isvisible(GlobalKey key) {
    if (key.currentContext == null) {
      return false;
    }
    final obj = key.currentContext!.findRenderObject() as RenderBox;
    double height = obj.size.height;
    if (currentHight + height < PdfPageFormat.a4.height) {
      currentHight += height;
      return true;
    }
    return false;
  }

  String genaratedText = "";

  Widget MoveToTemplets(int x) {
    switch (x) {
      case 1:
        return CvTemplate1(
            imageFile: imageFile,
            aboutMe: aboutMe.text,
            address: address.text,
            education: education,
            email: email.text,
            experence: experence,
            hobboys: hobboys,
            languages: languages,
            name: name.text,
            numbers: numbers,
            profession: profession.text,
            projects: projects,
            references: references,
            skills: skills,
            sumarryText: sumarryText.text,
            training: training,
            volenteer: volenteer);

      case 2:
        return CvTemplate1(
            isTemplet2: true,
            imageFile: imageFile,
            aboutMe: aboutMe.text,
            address: address.text,
            education: education,
            email: email.text,
            experence: experence,
            hobboys: hobboys,
            languages: languages,
            name: name.text,
            numbers: numbers,
            profession: profession.text,
            projects: projects,
            references: references,
            skills: skills,
            sumarryText: sumarryText.text,
            training: training,
            volenteer: volenteer);
      case 3:
        return CvTemplate3(
            imageFile: imageFile,
            aboutMe: aboutMe.text,
            address: address.text,
            education: education,
            email: email.text,
            experence: experence,
            hobboys: hobboys,
            languages: languages,
            name: name.text,
            numbers: numbers,
            profession: profession.text,
            projects: projects,
            references: references,
            skills: skills,
            sumarryText: sumarryText.text,
            training: training,
            volenteer: volenteer);
      default:
        return Container();
    }
  }

  Widget inputPage(BuildContext context) {
    return Stepper(
        onStepTapped: (value) {
          setState(() {
            currentStep = value;
          });
        },
        physics: BouncingScrollPhysics(),
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep == 6) {
            print(currentHight);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return MoveToTemplets(widget.templets);
              },
            ));
          } else {
            setState(() {
              currentStep++;
            });
          }
        },
        controlsBuilder: (context, details) {
          return Container(
            height: 60,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (currentStep != 0)
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: commonText("Back")),
                    ),
                  ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: (currentStep == 6)
                            ? commonText("Preview")
                            : commonText("Next")),
                  ),
                ),
              ],
            ),
          );
        },
        onStepCancel: () {
          setState(() {
            currentStep--;
          });
        },
        steps: [
          Step(
              title: commonTitleText("Personal Details"),
              content: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () {
                      imageDialogChooser();
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow.shade50,
                          border: Border.all(color: Colors.yellow),
                          image: (imageFile != null)
                              ? DecorationImage(image: FileImage(imageFile!))
                              : null),
                      child: (imageFile != null)
                          ? null
                          : const Center(
                              child: CircleAvatar(
                                radius: 25,
                                child: Icon(Icons.add),
                              ),
                            ),
                    ),
                  ),
                  commonTextField(
                      context: context, text: "Name*", controller: name),
                  commonTextField(
                      context: context,
                      text: "Profession*",
                      controller: profession),
                  commonTextField(
                      context: context,
                      text: "About me",
                      maxLine: 5,
                      controller: aboutMe),
                ],
              )),
          Step(
              title: commonTitleText("Contact details"),
              content: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: commonTextField(
                              context: context,
                              text: "phone number",
                              controller: numbercontroller)),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (numbercontroller.text.isNotEmpty) {
                              numbers
                                  .add(numbercontroller.text.trim().toString());
                              numbercontroller.text = "";
                            } else {
                              commonsnakbar(context, massage: "enter a number");
                            }
                            setState(() {});
                          },
                          child: commonText("Add now")),
                    ],
                  ),
                  commonText("(you can add multiple number)",
                      color: Colors.red),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: numbers.length,
                    itemBuilder: (context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(numbers[index].toString()),
                        InkWell(
                            onTap: () {
                              numbers.removeAt(index);
                              setState(() {});
                            },
                            child: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                  commonTextField(
                      context: context, text: "Email", controller: email),
                  commonTextField(
                      context: context, text: "Address:*", controller: address),
                ],
              )),
          Step(
              title: commonTitleText("Additional Information"),
              content: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: commonTextField(
                              context: context,
                              text: "Skills name",
                              controller: skill)),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (skill.text.trim().isNotEmpty) {
                              skills.add(skill.text.trim().toString());
                            }
                            skill.text = "";
                            setState(() {});
                          },
                          child: commonText("Add now")),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: skills.length,
                    itemBuilder: (context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(skills[index].toString()),
                        InkWell(
                            onTap: () {
                              skills.removeAt(index);
                              setState(() {});
                            },
                            child: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: commonTextField(
                              context: context,
                              text: "Language name",
                              controller: language)),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (language.text.trim().isNotEmpty) {
                              languages.add(language.text.trim().toString());
                            }
                            language.text = "";
                            setState(() {});
                          },
                          child: commonText("Add now")),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: languages.length,
                    itemBuilder: (context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(languages[index].toString()),
                        InkWell(
                            onTap: () {
                              languages.removeAt(index);
                              setState(() {});
                            },
                            child: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: commonTextField(
                              context: context,
                              text: "Hobby name",
                              controller: hobby)),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (hobby.text.trim().isNotEmpty) {
                              hobboys.add(hobby.text.trim().toString());
                            }
                            hobby.text = "";
                            setState(() {});
                          },
                          child: commonText("Add now")),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: hobboys.length,
                    itemBuilder: (context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(hobboys[index].toString()),
                        InkWell(
                            onTap: () {
                              hobboys.removeAt(index);
                              setState(() {});
                            },
                            child: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                ],
              )),
          Step(
            title: commonTitleText("Education"),
            content: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                commonTextField(
                    context: context,
                    text: "Institution name",
                    controller: instisutionName),
                commonTextField(
                    context: context, text: "Degree Name", controller: degree),
                commonTextField(
                    context: context,
                    text: "Year (start-end)",
                    controller: educationYear),
                commonTextField(
                    context: context,
                    text: "GPA(4.56 out of 5.00)",
                    controller: gpaController),
                commonTextField(
                    context: context,
                    text: "Description",
                    maxLine: 5,
                    controller: educationkDescription),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: commonText("Click Add now To add the details:",
                          color: Colors.red),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (instisutionName.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty ||
                              degree.text.trim().toString().isNotEmpty ||
                              educationYear.text.trim().toString().isNotEmpty ||
                              educationkDescription.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty ||
                              gpaController.text.isNotEmpty) {
                            education.add(Education(
                                gpa: gpaController.text.trim().toString(),
                                institutionName:
                                    instisutionName.text.trim().toString(),
                                drgree: degree.text.trim().toString(),
                                year: educationYear.text.trim().toString(),
                                description: educationkDescription.text
                                    .trim()
                                    .toString()));
                            instisutionName.text = "";
                            degree.text = "";
                            educationYear.text = "";
                            educationkDescription.text = "";
                          } else {
                            commonsnakbar(context, massage: "Enter all data");
                          }
                          setState(() {});
                        },
                        child: commonText("Add now")),
                  ],
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  shrinkWrap: true,
                  itemCount: education.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(education[index].degree ?? ""),
                            commonText(education[index].institutionName ?? ""),
                            commonText(education[index].year ?? ""),
                            commonText(education[index].gpa ?? ""),
                            commonText(education[index].description ?? ""),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            education.removeAt(index);
                            setState(() {});
                          },
                          child: Icon(Icons.delete)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: commonTitleText("Certifications and Training"),
            content: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                commonTextField(
                    context: context,
                    text: "Certification Name",
                    controller: certificate_Name),
                commonTextField(
                    context: context,
                    text: "Organization Name",
                    controller: certificate_organization_Name),
                commonTextField(
                    context: context,
                    text: "Issue Date",
                    controller: certificate_issue_Date),
                commonTextField(
                    context: context,
                    text: "Expiry Date(if aplicable)",
                    controller: certificate_expiry_Date),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: commonText("Click Add now To add the details:",
                          color: Colors.red),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (certificate_Name.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty ||
                              certificate_organization_Name.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty ||
                              certificate_issue_Date.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty ||
                              certificate_expiry_Date.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty) {
                            training.add(CertificationsAndTraining(
                              certificationName:
                                  certificate_Name.text.trim().toString(),
                              organizationName: certificate_organization_Name
                                  .text
                                  .trim()
                                  .toString(),
                              expiryDate: certificate_expiry_Date.text
                                  .trim()
                                  .toString(),
                              issueDate:
                                  certificate_issue_Date.text.trim().toString(),
                            ));

                            commonsnakbar(context, massage: "Added");
                          } else {
                            commonsnakbar(context, massage: "Enter data");
                          }
                          setState(() {});
                        },
                        child: commonText("Add now")),
                  ],
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  shrinkWrap: true,
                  itemCount: training.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(training[index].certificationName ?? ""),
                            commonText(training[index].organizationName ?? ""),
                            commonText(training[index].issueDate ?? ""),
                            commonText(training[index].expiryDate ?? ""),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            training.removeAt(index);
                            setState(() {});
                          },
                          child: Icon(Icons.delete)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: commonTitleText("Projects"),
            content: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                commonTextField(
                    context: context,
                    text: "Project Title",
                    controller: project_tilte),
                commonTextField(
                    context: context,
                    text: "Project role responsibility",
                    controller: project_role_responsibility),
                commonTextField(
                    context: context,
                    text: "link(github,website,any link)",
                    controller: project_linking),
                commonTextField(
                    context: context,
                    text: "description",
                    controller: project_description),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: commonText("Click Add now To add the details:",
                          color: Colors.red),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (project_tilte.text.trim().toString().isNotEmpty ||
                              project_role_responsibility.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty ||
                              project_description.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty ||
                              project_linking.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty) {
                            projects.add(Project(
                              title: project_tilte.text.trim().toString(),
                              description:
                                  project_description.text.trim().toString(),
                              linking: project_linking.text.trim().toString(),
                              roleResponsibility: project_role_responsibility
                                  .text
                                  .trim()
                                  .toString(),
                            ));

                            commonsnakbar(context, massage: "Added");
                          } else {
                            commonsnakbar(context, massage: "Enter data");
                          }
                          setState(() {});
                        },
                        child: commonText("Add now")),
                  ],
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  shrinkWrap: true,
                  itemCount: projects.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(projects[index].title ?? ""),
                            commonText(
                                projects[index].roleResponsibility ?? ""),
                            commonText(projects[index].linking ?? ""),
                            commonText(projects[index].description ?? ""),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            projects.removeAt(index);
                            setState(() {});
                          },
                          child: Icon(Icons.delete)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: commonTitleText("Experence"),
            content: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                commonTextField(
                    context: context,
                    text: "Company name",
                    controller: companyName),
                commonTextField(
                    context: context,
                    text: "Working Role",
                    controller: workRole),
                commonTextField(
                    context: context,
                    text: "Year (start-end)",
                    controller: workingYear),
                commonTextField(
                    context: context,
                    text: "Description",
                    maxLine: 5,
                    controller: workDescription),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: commonText("Click Add now To add the details:",
                          color: Colors.red),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (companyName.text.trim().toString().isNotEmpty ||
                              workRole.text.trim().toString().isNotEmpty ||
                              workingYear.text.trim().toString().isNotEmpty ||
                              workDescription.text
                                  .trim()
                                  .toString()
                                  .isNotEmpty) {
                            experence.add(Experience(
                                companyName: companyName.text.trim().toString(),
                                workRole: workRole.text.trim().toString(),
                                year: workingYear.text.trim().toString(),
                                description:
                                    workDescription.text.trim().toString()));
                            companyName.text = "";
                            workRole.text = "";
                            workingYear.text = "";
                            workDescription.text = "";
                          } else {
                            commonsnakbar(context, massage: "Enter all data");
                          }
                          setState(() {});
                        },
                        child: commonText("Add now")),
                  ],
                ),
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: experence.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonText(experence[index].companyName ?? ""),
                            commonText(experence[index].workRole ?? ""),
                            commonText(experence[index].year ?? ""),
                            commonText(experence[index].description ?? ""),
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            experence.removeAt(index);
                            setState(() {});
                          },
                          child: Icon(Icons.delete)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]);
  }

  TextEditingController name = TextEditingController(text: "John Doe");

  TextEditingController sumarryText = TextEditingController();

  TextEditingController email =
      TextEditingController(text: "john.doe@example.com");

  TextEditingController address =
      TextEditingController(text: "123 Main St, Anytown, USA");

  TextEditingController numbercontroller =
      TextEditingController(text: "123-456-7890");

  List<String> numbers = ["123-456-7890"];

  TextEditingController aboutMe = TextEditingController(
      text:
          "A dedicated professional with 10 years of experience.A dedicated professional with 10 years of experience.A dedicated professional with 10 years of experience.A dedicated professional with 10 years of experience.A dedicated professional with 10 years of experience.");

  TextEditingController profession =
      TextEditingController(text: "Software Engineer");

  List<Experience> experence = [
    Experience(
        companyName: "Tech Corp",
        workRole: "Senior Developer",
        year: "2015-2020",
        description: "Worked on various software development projects."),
    Experience(
        companyName: "Innovate Inc.",
        workRole: "Team Lead",
        year: "2020-Present",
        description: "Leading a team of developers."),
    Experience(
        companyName: "Tech Corp",
        workRole: "Senior Developer",
        year: "2015-2020",
        description: "Worked on various software development projects."),
  ];

  TextEditingController companyName = TextEditingController();

  TextEditingController workRole = TextEditingController();

  TextEditingController workingYear = TextEditingController();

  TextEditingController workDescription = TextEditingController();

  List<CertificationsAndTraining> training = [
    CertificationsAndTraining(
        certificationName: "Certified Scrum Master",
        organizationName: "Scrum Alliance",
        issueDate: "2021-01-15",
        expiryDate: "2024-01-15"),
    CertificationsAndTraining(
        certificationName: "AWS Certified Solutions Architect",
        organizationName: "Amazon",
        issueDate: "2022-05-10",
        expiryDate: "2025-05-10")
  ];

  TextEditingController certificate_Name = TextEditingController();

  TextEditingController certificate_organization_Name = TextEditingController();

  TextEditingController certificate_issue_Date = TextEditingController();

  TextEditingController certificate_expiry_Date = TextEditingController();

  List<Project> projects = [
    Project(
        title: "Project Alpha",
        roleResponsibility: "Lead Developer",
        description: "Developed a scalable web application.",
        linking: "http://example.com/project-alpha"),
    Project(
        title: "Project Beta",
        roleResponsibility: "Project Manager",
        description: "Managed a team of 10 developers.",
        linking: "http://example.com/project-beta"),
    Project(
        title: "Project Beta",
        roleResponsibility: "Project Manager",
        description: "Managed a team of 10 developers.",
        linking: "http://example.com/project-beta")
  ];

  TextEditingController project_tilte = TextEditingController();

  TextEditingController project_role_responsibility = TextEditingController();

  TextEditingController project_description = TextEditingController();

  TextEditingController project_linking = TextEditingController();

  List<Volunteer> volenteer = [
    Volunteer(
        role: "Volunteer Teacher",
        organization: "Local School",
        description: "Taught programming to high school students.",
        date_service: "2021",
        location: "Anytown, USA"),
    Volunteer(
        role: "Volunteer Teacher",
        organization: "Local School",
        description: "Taught programming to high school students.",
        date_service: "2021",
        location: "Anytown, USA")
  ];

  List<Reference> references = [
    Reference(
        name: "Jane Smith",
        title: "Manager",
        phone: "987-654-3210",
        email: "jane.smith@example.com",
        relation: "Former Manager"),
    Reference(
        name: "Jane Smith",
        title: "Manager",
        phone: "987-654-3210",
        email: "jane.smith@example.com",
        relation: "Former Manager")
  ];

  TextEditingController referencerName = TextEditingController();

  TextEditingController referencerTitle = TextEditingController();

  TextEditingController referencerPhone = TextEditingController();

  TextEditingController referencerEmail = TextEditingController();

  TextEditingController referencerRelation = TextEditingController();

  List<Education> education = [
    Education(
        institutionName: "State University",
        drgree: "B.Sc. in Computer Science",
        year: "2010-2014",
        gpa: "3.8",
        description: "Graduated with honors."),
    Education(
        institutionName: "Tech Institute",
        drgree: "M.Sc. in Software Engineering",
        year: "2015-2017",
        gpa: "3.9",
        description: "Specialized in machine learning."),
  ];

  TextEditingController instisutionName = TextEditingController();

  TextEditingController gpaController = TextEditingController();

  TextEditingController degree = TextEditingController();

  TextEditingController educationYear = TextEditingController();

  TextEditingController educationkDescription = TextEditingController();

  List<String> skills = ["Java", "Python", "Flutter"];

  List<String> hobboys = ["Reading", "Hiking", "Gaming"];

  List<String> languages = ["English", "Spanish"];

  TextEditingController skill = TextEditingController();

  TextEditingController language = TextEditingController();

  TextEditingController hobby = TextEditingController();
  File? imageFile;

  void assignValue(String jsonString) {
    Map<String, dynamic> parsedJson = jsonDecode(jsonString);
    name.text = parsedJson['name'] ?? "";
    email.text = parsedJson['email'] ?? "";
    address.text = parsedJson['address'] ?? "";

    numbers = parsedJson['phone'] != null
        ? List<String>.from(parsedJson['phone'])
        : [];
    numbercontroller.text = (numbers.isNotEmpty) ? numbers[0] : "";
    aboutMe.text = parsedJson['aboutMe'] ?? "";
    profession.text = parsedJson['profession'] ?? "";

    experence = parsedJson['experience'] != null
        ? List<Map<String, dynamic>>.from(parsedJson['experience'])
            .map((e) => Experience(
                  companyName: e['companyName'],
                  workRole: e['workRole'],
                  year: e['year'],
                  description: e['description'],
                ))
            .toList()
        : [];
    training = parsedJson['certifications_and_training'] != null
        ? List<Map<String, dynamic>>.from(
                parsedJson['certifications_and_training'])
            .map((e) => CertificationsAndTraining(
                  certificationName: e['certification_Name'],
                  organizationName: e['organization_Name'],
                  issueDate: e['issue_Date'],
                  expiryDate: e['expiry_Date'],
                ))
            .toList()
        : [];
    projects = parsedJson['projects'] != null
        ? List<Map<String, dynamic>>.from(parsedJson['projects'])
            .map((e) => Project(
                  title: e['title'],
                  roleResponsibility: e['role_responsibility'],
                  description: e['description'],
                  linking: e['linking'],
                ))
            .toList()
        : [];
    volenteer = parsedJson['volunteer'] != null
        ? List<Map<String, dynamic>>.from(parsedJson['volunteer'])
            .map((e) => Volunteer(
                  role: e['role'],
                  organization: e['organization'],
                  description: e['description'],
                  date_service: e['date_service'],
                  location: e['location'],
                ))
            .toList()
        : [];
    references = parsedJson['references'] != null
        ? List<Map<String, dynamic>>.from(parsedJson['references'])
            .map((e) => Reference(
                  name: e['Name'],
                  title: e['title'],
                  phone: e['phone'],
                  email: e['email'],
                  relation: e['relation'],
                ))
            .toList()
        : [];
    education = parsedJson['education'] != null
        ? List<Map<String, dynamic>>.from(parsedJson['education'])
            .map((e) => Education(
                  institutionName: e['institutionName'],
                  drgree: e['degree'],
                  year: e['year'],
                  gpa: e['gpa'],
                  description: e['description'],
                ))
            .toList()
        : [];
    skills = parsedJson['skills'] != null
        ? List<String>.from(parsedJson['skills'])
        : [];
    hobboys = parsedJson['hobby'] != null
        ? List<String>.from(parsedJson['hobby'])
        : [];
    languages = parsedJson['languages'] != null
        ? List<String>.from(parsedJson['languages'])
        : [];
    setState(() {});
  }

  void imageDialogChooser() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Choose from gerally"),
                onTap: () {
                  Navigator.pop(context);
                  image_picker(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("take a picture"),
                onTap: () {
                  Navigator.pop(context);
                  image_picker(ImageSource.camera);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void image_picker(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source);

    if (file != null) {
      imageFile = File(file.path);
    }
    setState(() {});
  }
}
