import "dart:io";
import "package:google_generative_ai/google_generative_ai.dart";

Future<GenerateContentResponse> geminiApiCallWithImage(
    {required List<File> imageFile,
    required String textData,
    required String oldResponse}) async {
  print(oldResponse);
  final model = GenerativeModel(
    model: "gemini-1.5-flash-latest",
    apiKey: "AIzaSyC5JLEGLd2I3u1kqeJ82G7FmREx6z590m0",
    safetySettings: [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
    ],
  );

  String formating = "";
  if (oldResponse.isNotEmpty) {
    formating = """
Return the JSON using the following structure:
{
  "name": \$name,
  "email": \$email,
  "phone": [\$numbers],
  "address": \$address,
  "hobby": [\$hobbies],
  "aboutMe": \$aboutMe,
  "profession": \$profession,
  "experience": [
    {
      "companyName": \$companyName,
      "workRole": \$workRole,
      "year": \$workingYear,
      "description": \$workDescription
    },
    // Repeat for each experience entry
  ],
  "certifications_and_training": [
    {
      "certification_Name": \$certificate_Name,
      "organization_Name": \$certificate_organization_Name,
      "issue_Date": \$certificate_issue_Date,
      "expiry_Date": \$certificate_expiry_Date
    },
    // Repeat for each certification/training entry
  ],
  "projects": [
    {
      "title": \$project_tilte,
      "role_responsibility": \$project_role_responsibility,
      "description": \$project_description,
      "linking": \$project_linking
    },
    // Repeat for each project entry
  ],
  "volunteer": [
    {
      "role": \$role,
      "organization": \$organization,
      "description": \$description,
      "date_service": \$date_service,
      "location": \$location
    },
    // Repeat for each volunteer entry
  ],
  "references": [
    {
      "Name": \$referencerName,
      "title": \$referencerTitle,
      "phone": \$referencerPhone,
      "email": \$referencerEmail,
      "relation": \$referencerRelation
    },
    // Repeat for each reference entry
  ],
  "education": [
    {
      "institutionName": \$instisutionName,
      "degree": \$degree,
      "year": \$educationYear,
      "gpa": \$gpaController,
      "description": \$educationkDescription
    },
    // Repeat for each education entry
  ],
  "skills": [\$skill],
  "languages": [\$language]
}


Merge the new data with the existing data provided below. 
- Replace any existing empty fields in the old data with the corresponding fields from the new data.
- If a new entry (e.g., a new job in the experience section) is detected, add it to the list without removing the old entries.

Previous Data:{""" +
        oldResponse +
        """}
New Data:
- Analyze the given text and images.
- Generate the "About Me" section best suited for the job post.
- Return the combined JSON data with the structure mentioned above.

Only provide the JSON so that I can decode it easily. Do not include any null values; use empty strings instead.
""";
  } else {
    formating = """
Return the JSON using the following structure:
{
  "name": \$name,
  "email": \$email,
  "phone": [\$numbers],
  "address": \$address,
  "hobby": [\$hobbies],
  "aboutMe": \$aboutMe,
  "profession": \$profession,
  "experience": [
    {
      "companyName": \$companyName,
      "workRole": \$workRole,
      "year": \$workingYear,
      "description": \$workDescription
    },
    // Repeat for each experience entry
  ],
  "certifications_and_training": [
    {
      "certification_Name": \$certificate_Name,
      "organization_Name": \$certificate_organization_Name,
      "issue_Date": \$certificate_issue_Date,
      "expiry_Date": \$certificate_expiry_Date
    },
    // Repeat for each certification/training entry
  ],
  "projects": [
    {
      "title": \$project_tilte,
      "role_responsibility": \$project_role_responsibility,
      "description": \$project_description,
      "linking": \$project_linking
    },
    // Repeat for each project entry
  ],
  "volunteer": [
    {
      "role": \$role,
      "organization": \$organization,
      "description": \$description,
      "date_service": \$date_service,
      "location": \$location
    },
    // Repeat for each volunteer entry
  ],
  "references": [
    {
      "Name": \$referencerName,
      "title": \$referencerTitle,
      "phone": \$referencerPhone,
      "email": \$referencerEmail,
      "relation": \$referencerRelation
    },
    // Repeat for each reference entry
  ],
  "education": [
    {
      "institutionName": \$instisutionName,
      "degree": \$degree,
      "year": \$educationYear,
      "gpa": \$gpaController,
      "description": \$educationkDescription
    },
    // Repeat for each education entry
  ],
  "skills": [\$skill],
  "languages": [\$language]
}

Data:
- Analyze the given text and images.
- Generate the "About Me" section best suited for the job post.
- Return the combined JSON data with the structure mentioned above.

Only provide the JSON so that I can decode it easily. Do not include any null values; use empty strings instead.
""";
  }
  print(formating);
  List<Part> image = [];
  for (var element in imageFile) {
    image.add(DataPart("image/jpeg", await element.readAsBytes()));
  }
  image.add(TextPart(textData));
  image.add(TextPart(formating));

  return await model.generateContent([Content.multi(image)]);
}
