# تطبيق MedCare - إدارة الدواء الذكية (Smart Medication Management)

تم بناء وتطوير واجهات التطبيق بالكامل باستخدام **Flutter** استناداً لتصميم **Banani Flow**.

---

## 🌟 مميزات الهيكلية والكود

1. **كود واحد لكل شاشة (Single Screen per Feature):**
   - تم تصميم الشاشات بحيث لا يتم تكرار أي كود للشاشات العربية والإنجليزية.
   - الشاشة تدعم اللغتين تلقائياً وتنعكس اتجاهاتها (RTL / LTR) بضغطة زر واحدة.

2. **تحويل التطبيق للعربية دفعة واحدة (Instant Language Switching):**
   - في أول شاشة (**Splash Screen**)، يوجد خيار بارز لاختيار لغة التطبيق `(العربية / English)`.
   - في كافة الشاشات العلوية، يوجد زر تبديل سريع `[ 🌐 العربية / EN ]`.
   - بمجرد الضغط، يتم تحديث حالة التطبيق فورياً عبر `AppLanguage` بدون الحاجة لإعادة تشغيل التطبيق.

3. **جاهز للربط بقواعد البيانات (Database-Ready Architecture):**
   - تم فصل واجهات المستخدم (UI) تماماً عن طبقة البيانات.
   - توجد طبقة خدمات موحدة: `lib/services/database_service.dart`.
   - توجد نماذج بيانات مجهزة بالكامل:
     - `Medication` (الأدوية، الجرعات، التكرار، المخزون، تنبيه النفاد).
     - `DoseReminder` (مواعيد وجدول اليوم، تسجيل التناول، التأجيل).
     - `UserModel` (المستخدم، الاسم، البريد، تاريخ الميلاد).
   - عند الرغبة في ربط Firebase Firestore أو Supabase أو SQLite أو REST API، يتم فقط تعديل الدوال في ملف `database_service.dart` دون المساس بأي شاشة في الواجهة.

---

## 📁 هيكل مجلدات المشروع (Clean Architecture)

```text
lib/
├── main.dart                          # نقطة الدخول الرئيسية وتجهيز الـ Localization
├── theme/
│   └── app_theme.dart                 # نظام الألوان والخطوط الأخضر الزمردي من Banani
├── localization/
│   ├── app_language.dart              # إدارة وتغيير لغة التطبيق بنقرة واحدة
│   └── app_strings.dart               # قاموس الكلمات والترجمات (عربي / إنجليزي)
├── models/
│   ├── medication_model.dart          # نموذج بيانات الدواء
│   ├── dose_reminder_model.dart       # نموذج بيانات جرعات وتذكيرات اليوم
│   └── user_model.dart                # نموذج بيانات المستخدم
├── services/
│   └── database_service.dart          # طبقة الوسيط للبيانات (جاهزة للربط بالـ DB)
├── widgets/
│   ├── app_logo.dart                  # شعار MedCare المتناسق مع اللغتين
│   ├── language_toggle_button.dart    # زر التبديل السريع بين العربي والإنجليزي
│   ├── custom_button.dart             # الأزرار الأساسية والثانوية
│   └── custom_text_field.dart         # حقول الإدخال والتحقق
└── screens/
    ├── splash/
    │   └── splash_screen.dart         # شاشة البداية واختيار اللغة الأولي
    ├── onboarding/
    │   └── onboarding_screen.dart     # شاشة التعريف والبطاقات الثلاث التفاعلية
    ├── auth/
    │   ├── login_screen.dart          # تسجيل الدخول وتذكرني والمتابعة مع Google
    │   └── signup_screen.dart         # إنشاء الحساب وتاريخ الميلاد
    ├── home/
    │   └── home_screen.dart           # الرئيسية: مؤشر الالتزام، الإجراءات السريعة، جدول اليوم
    ├── medications/
    │   ├── medications_screen.dart    # قائمة الأدوية، البحث، التصفية، عداد الحبات المتبقية
    │   ├── add_medication_screen.dart # شاشة إضافة دواء جديد بكامل تفاصيله
    │   └── med_details_screen.dart    # تفاصيل الدواء، متابعة المخزون، الحذف
    ├── reminders/
    │   └── reminders_screen.dart      # شاشة التنبيهات وإعدادات الصوت والاهتزاز
    └── main_navigation_screen.dart    # شريط التنقل السفلي (Bottom Navigation)
```

---

## 🚀 كيفية تشغيل المشروع

1. تأكد من فتح المجلد في محرر الأكواد (VS Code / Android Studio):
   ```bash
   cd C:\Users\DELL\.gemini\antigravity\scratch\medical_reminder_app
   ```
2. تثبيت الحزم:
   ```bash
   flutter pub get
   ```
3. تشغيل التطبيق (على الهاتف أو المحاكي أو Chrome):
   ```bash
   flutter run
   ```
