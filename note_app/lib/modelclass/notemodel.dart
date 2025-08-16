/*
هاض المودل كلاس مهم جدا لتنظيم الامور بحولك الجيسون لاوبجبكت 
عشان يسهل مثلا فلنفترض ان الابك اند بده يعرف اسماء المتغيارت بالداتا بيس او الفرونت اند
مهو مش منطق اروح اقله انو انه هيم سميتهم لا بقدر من خلال المودل يعرف لانو 
المودل كلاس بقدر يحول الكود الجاي من جيسون لابوجكت وخلص بستخدمه بفلتر 
وكذكلك فنكشن التو جيسون مهم لانو بقدر من خلاله ار ارجع الباينات لجيسون وارد ارسلهم للغة 
الباك اند لو احتجت ذلك
 */

/*
المودل كلاس بنعمل فوت متصفح قلو  from json to dart وكمان انا مو مكل البيانالت 
الرجعة بحولها لابجكت لا  انا بهمني الداتا فبس بمسك الداتا وبروح على الموقع وبحولها لا مودل كلاس 
وعشان تعرف البيانات الي بدي احولها لمودل كلاس ببساطة عن طريق الثندر كلاين بعمل ريكويست 
تبعت الفيو لعرض البيانات وبوخذ الداتا وبرح لحولها 
 */

/*
 يعني من الاخر لو انا بشرمة والشخص تبع الباك اند الاعطاني ملف الجيسون انا شو بسوي بمسكه
 وبرح على الموقع وبعمل منه مود كلاس وبحطو بالمشروع وهيك بكون قادر اعرف كل محتويات الملف 
 وشو اسماء المتغيرات وكل الامور والحبشتكنات 
 */
class NoteModel {
  String? notesId;
  String? notesTitle;
  String? notesContent;
  String? notesImage;
  String? notesUsers;

  NoteModel({
    this.notesId,
    this.notesTitle,
    this.notesContent,
    this.notesImage,
    this.notesUsers,
  });

  NoteModel.fromJson(Map<String, dynamic> json) {
    notesId = json['notes_id'];
    notesTitle = json['notes_title'];
    notesContent = json['notes_content'];
    notesImage = json['notes_image'];
    notesUsers = json['notes_users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notes_id'] = notesId;
    data['notes_title'] = notesTitle;
    data['notes_content'] = notesContent;
    data['notes_image'] = notesImage;
    data['notes_users'] = notesUsers;
    return data;
  }
}
