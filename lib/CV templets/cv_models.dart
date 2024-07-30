class Experience {
  String? companyName, workRole, year, description;
  Experience({this.companyName, this.description, this.workRole, this.year});

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'workRole': workRole,
      'year': year,
      'description': description,
    };
  }
}

class Education {
  String? institutionName, degree, year, gpa, description;
  Education(
      {this.institutionName,
      this.description,
      this.degree,
      this.year,
      this.gpa,
      required drgree});

  Map<String, dynamic> toJson() {
    return {
      'institutionName': institutionName,
      'degree': degree,
      'year': year,
      'gpa': gpa,
      'description': description,
    };
  }
}

class CertificationsAndTraining {
  String? organizationName, certificationName, issueDate, expiryDate;
  CertificationsAndTraining(
      {this.certificationName,
      this.expiryDate,
      this.issueDate,
      this.organizationName});

  Map<String, dynamic> toJson() {
    return {
      'organizationName': organizationName,
      'certificationName': certificationName,
      'issueDate': issueDate,
      'expiryDate': expiryDate,
    };
  }
}

class Project {
  String? title, roleResponsibility, description, linking;
  Project(
      {this.title, this.roleResponsibility, this.description, this.linking});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'roleResponsibility': roleResponsibility,
      'description': description,
      'linking': linking,
    };
  }
}

class Volunteer {
  String? role, organization, description, dateService, location;
  Volunteer(
      {this.dateService,
      this.description,
      this.location,
      this.organization,
      this.role,
      required date_service});

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'organization': organization,
      'description': description,
      'dateService': dateService,
      'location': location,
    };
  }
}

class Reference {
  String? name, title, phone, email, relation;
  Reference({this.name, this.phone, this.email, this.relation, this.title});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'phone': phone,
      'email': email,
      'relation': relation,
    };
  }
}
