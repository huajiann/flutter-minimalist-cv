class CvModel {
  final String? name;
  final String? location;
  final String? locationLink;
  final String? quote;
  final String? imageUrl;
  final String? aboutMe;
  final List<Contact>? contact;
  final List<Work>? work;
  final List<Education>? education;
  final List<Project>? projects;
  final List<String>? skills;

  CvModel({
    this.name,
    this.location,
    this.locationLink,
    this.quote,
    this.imageUrl,
    this.aboutMe,
    this.contact,
    this.work,
    this.education,
    this.projects,
    this.skills,
  });

  factory CvModel.fromJson(Map<String, dynamic> json) => CvModel(
        name: json["name"],
        location: json["location"],
        locationLink: json["locationLink"],
        quote: json["quote"],
        imageUrl: json["imageUrl"],
        aboutMe: json["aboutMe"],
        contact: json["contact"] == null ? [] : List<Contact>.from(json["contact"]!.map((x) => Contact.fromJson(x))),
        work: json["work"] == null ? [] : List<Work>.from(json["work"]!.map((x) => Work.fromJson(x))),
        education:
            json["education"] == null ? [] : List<Education>.from(json["education"]!.map((x) => Education.fromJson(x))),
        projects: json["projects"] == null ? [] : List<Project>.from(json["projects"]!.map((x) => Project.fromJson(x))),
        skills: json["skills"] == null ? [] : List<String>.from(json["skills"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "location": location,
        "locationLink": locationLink,
        "quote": quote,
        "imageUrl": imageUrl,
        "aboutMe": aboutMe,
        "contact": contact == null ? [] : List<dynamic>.from(contact!.map((x) => x.toJson())),
        "work": work == null ? [] : List<dynamic>.from(work!.map((x) => x.toJson())),
        "education": education == null ? [] : List<dynamic>.from(education!.map((x) => x.toJson())),
        "projects": projects == null ? [] : List<dynamic>.from(projects!.map((x) => x.toJson())),
        "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
      };
}

class Contact {
  final int? id;
  final String? name;
  final String? url;

  Contact({
    this.id,
    this.name,
    this.url,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
      };
}

class Education {
  final String? school;
  final String? degree;
  final String? description;
  final String? start;
  final String? end;

  Education({
    this.school,
    this.degree,
    this.description,
    this.start,
    this.end,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        school: json["school"],
        degree: json["degree"],
        description: json["description"],
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "school": school,
        "degree": degree,
        "description": description,
        "start": start,
        "end": end,
      };
}

class Project {
  final String? title;
  final String? description;
  final List<String>? badges;
  final bool? isOngoing;
  final String? link;

  Project({
    this.title,
    this.description,
    this.badges,
    this.isOngoing,
    this.link,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        title: json["title"],
        description: json["description"],
        badges: json["badges"] == null ? [] : List<String>.from(json["badges"]!.map((x) => x)),
        isOngoing: json["isOngoing"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "badges": badges == null ? [] : List<dynamic>.from(badges!.map((x) => x)),
        "isOngoing": isOngoing,
        "link": link,
      };
}

class Work {
  final String? company;
  final List<String>? badges;
  final String? position;
  final String? description;
  final String? startDate;
  final String? endDate;

  Work({
    this.company,
    this.badges,
    this.position,
    this.description,
    this.startDate,
    this.endDate,
  });

  factory Work.fromJson(Map<String, dynamic> json) => Work(
        company: json["company"],
        badges: json["badges"] == null ? [] : List<String>.from(json["badges"]!.map((x) => x)),
        position: json["position"],
        description: json["description"],
        startDate: json["startDate"],
        endDate: json["endDate"],
      );

  Map<String, dynamic> toJson() => {
        "company": company,
        "badges": badges == null ? [] : List<dynamic>.from(badges!.map((x) => x)),
        "position": position,
        "description": description,
        "startDate": startDate,
        "endDate": endDate,
      };
}
