//
//  Models.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import Foundation

// MARK: - Prayer Time Models

struct PrayerTimes {
    let fajr: Date
    let sunrise: Date
    let dhuhr: Date
    let asr: Date
    let maghrib: Date
    let isha: Date
    let date: Date
    
    var allPrayers: [(name: String, time: Date, arabicName: String)] {
        return [
            ("Fajr", fajr, "الفجر"),
            ("Shrouq", sunrise, "الشروق"),
            ("Dhuhr", dhuhr, "الظهر"),
            ("Asr", asr, "العصر"),
            ("Maghrib", maghrib, "المغرب"),
            ("Isha", isha, "العشاء")
        ]
    }
}

enum Prayer: String, CaseIterable {
    case fajr = "Fajr"
    case shrouq = "Shrouq"
    case dhuhr = "Dhuhr" 
    case asr = "Asr"
    case maghrib = "Maghrib"
    case isha = "Isha"
    
    var arabicName: String {
        switch self {
        case .fajr: return "الفجر"
        case .shrouq: return "الشروق"
        case .dhuhr: return "الظهر"
        case .asr: return "العصر"
        case .maghrib: return "المغرب"
        case .isha: return "العشاء"
        }
    }
    
    var icon: String {
        switch self {
        case .fajr: return "moon.stars"
        case .shrouq: return "sunrise"
        case .dhuhr: return "sun.max"
        case .asr: return "sun.min"
        case .maghrib: return "sunset"
        case .isha: return "moon"
        }
    }
}

// MARK: - Calculation Methods

enum CalculationMethod: String, CaseIterable {
    case islamicFinder = "Islamic Finder"
    case makkah = "Umm Al-Qura (Makkah)"
    case karachi = "Karachi"
    case isna = "ISNA"
    case mwl = "Muslim World League"
    
    var description: String {
        return self.rawValue
    }
}

enum JuristicMethod: String, CaseIterable {
    case shafi = "Shafi/Maliki/Hanbali"
    case hanafi = "Hanafi"
    
    var schoolId: Int {
        switch self {
        case .shafi:
            return 0
        case .hanafi:
            return 1
        }
    }
}

// MARK: - Adhkar Models

struct Adhkar: Identifiable {
    let id = UUID()
    let arabicText: String
    let transliteration: String?
    let englishTranslation: String?
    let frenchTranslation: String?
    let urduTranslation: String?
    let category: AdhkarCategory
    let repeatCount: Int?
    let source: String?
    let isFavorite: Bool = false
}

enum AdhkarCategory: String, CaseIterable {
    case morning = "Morning Adhkar"
    case evening = "Evening Adhkar"
    case afterPrayer = "After Prayer"
    
    var icon: String {
        switch self {
        case .morning: return "sun.and.horizon"
        case .evening: return "moon.and.stars"
        case .afterPrayer: return "hands.and.sparkles.fill"
        }
    }
}

// MARK: - Sample Data

extension PrayerTimes {
    static var sample: PrayerTimes {
        let calendar = Calendar.current
        let now = Date()
        
        return PrayerTimes(
            fajr: calendar.date(bySettingHour: 5, minute: 30, second: 0, of: now) ?? now,
            sunrise: calendar.date(bySettingHour: 6, minute: 0, second: 0, of: now) ?? now,
            dhuhr: calendar.date(bySettingHour: 12, minute: 15, second: 0, of: now) ?? now,
            asr: calendar.date(bySettingHour: 15, minute: 45, second: 0, of: now) ?? now,
            maghrib: calendar.date(bySettingHour: 18, minute: 30, second: 0, of: now) ?? now,
            isha: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) ?? now,
            date: now
        )
    }
}

extension Adhkar {
    static var sampleAdhkar: [Adhkar] {
        return [
            // MARK: - Morning Adhkar (أذكار الصباح)
            Adhkar(
                arabicText: "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ",
                transliteration: "Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namootu, wa ilaykan-nushoor",
                englishTranslation: "O Allah, by Your leave we have reached morning, and by Your leave we have reached evening, and by Your leave we live, and by Your leave we die, and to You is the resurrection.",
                frenchTranslation: "Ô Allah, par Toi nous atteignons le matin, et par Toi nous atteignons le soir, et par Toi nous vivons, et par Toi nous mourons, et c'est vers Toi que nous serons ressuscités.",
                urduTranslation: "اے اللہ! تیری مدد سے ہم نے صبح کی، اور تیری مدد سے ہم نے شام کی، اور تیری مدد سے ہم زندہ ہیں، اور تیری مدد سے ہم مریں گے، اور تیری طرف ہی اٹھنا ہے۔",
                category: .morning,
                repeatCount: 1,
                source: "Muslim"
            ),
            Adhkar(
                arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ",
                transliteration: "Allahumma anta Rabbi la ilaha illa anta, khalaqtani wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mastata'tu. A'udhu bika min sharri ma sana'tu, aboo'u laka bi ni'matika 'alayya, wa aboo'u bi dhanbi faghfir li, fa innahu la yaghfirudh-dhunooba illa ant",
                englishTranslation: "O Allah, You are my Lord, there is no god but You. You created me and I am Your servant, and I am abiding by Your covenant and Your promise as best as I can. I seek refuge in You from the evil of what I have done. I acknowledge Your blessings upon me, and I acknowledge my sins, so forgive me, for none forgives sins except You.",
                frenchTranslation: "Ô Allah, Tu es mon Seigneur, il n'y a de divinité que Toi. Tu m'as créé et je suis Ton serviteur, et je m'en tiens à Ton pacte et à Ta promesse autant que je le peux. Je cherche refuge auprès de Toi contre le mal que j'ai commis. Je reconnais Tes bienfaits sur moi et je reconnais mes péchés, alors pardonne-moi, car personne ne pardonne les péchés sauf Toi.",
                urduTranslation: "اے اللہ، تو میرا رب ہے، تیرے سوا کوئی معبود نہیں، تو نے مجھے پیدا کیا اور میں تیرا بندہ ہوں، اور میں اپنی استطاعت کے مطابق تیرے عہد اور وعدے پر قائم ہوں۔ میں اپنے کیے ہوئے کاموں کی برائی سے تیری پناہ مانگتا ہوں۔ میں اپنے اوپر تیری نعمتوں کا اقرار کرتا ہوں، اور میں اپنے گناہوں کا اقرار کرتا ہوں، پس مجھے بخش دے، کیونکہ تیرے سوا کوئی گناہوں کو نہیں بخشتا۔",
                category: .morning,
                repeatCount: 1,
                source: "Bukhari"
            ),
            Adhkar(
                arabicText: "أَصْبَحْنَا عَلَى فِطْرَةِ الإِسْلاَمِ، وَعَلَى كَلِمَةِ الإِخْلاَصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صلى الله عليه وسلم، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ",
                transliteration: "Asbahna 'ala fitratil-Islam, wa 'ala kalimatil-ikhlas, wa 'ala deeni Nabiyyina Muhammad (s.a.w.), wa 'ala millati abeena Ibraheema haneefan musliman wama kana minal-mushrikeen",
                englishTranslation: "We have entered morning upon the natural disposition of Islam, and upon the word of sincerity, and upon the religion of our Prophet Muhammad (peace be upon him), and upon the faith of our father Ibrahim, who was upright in submission and was not of the polytheists.",
                frenchTranslation: "Nous sommes entrés dans le matin sur la disposition naturelle de l'Islam, et sur la parole de sincérité, et sur la religion de notre Prophète Muhammad (que la paix soit sur lui), et sur la foi de notre père Ibrahim, qui était droit et soumis, et qui n'était pas des polythéistes.",
                urduTranslation: "ہم نے اسلام کی فطرت پر صبح کی، اور کلمہ اخلاص پر، اور ہمارے نبی محمد صلی اللہ علیہ وسلم کے دین پر، اور ہمارے والد ابراہیم کے ملت پر صبح کی، جو سیدھے راستے پر چلنے والے مسلم تھے اور مشرکوں میں سے نہیں تھے۔",
                category: .morning,
                repeatCount: 1,
                source: "Muslim"
            ),
            
            // MARK: - Evening Adhkar (أذكار المساء)
            Adhkar(
                arabicText: "اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ",
                transliteration: "Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namootu, wa ilaykal-maseer",
                englishTranslation: "O Allah, by Your leave we have reached evening, and by Your leave we have reached morning, and by Your leave we live, and by Your leave we die, and to You is the return.",
                frenchTranslation: "Ô Allah, par Toi nous atteignons le soir, et par Toi nous atteignons le matin, et par Toi nous vivons, et par Toi nous mourons, et c'est vers Toi que sera le retour.",
                urduTranslation: "اے اللہ! تیری مدد سے ہم نے شام کی، اور تیری مدد سے ہم نے صبح کی، اور تیری مدد سے ہم زندہ ہیں، اور تیری مدد سے ہم مریں گے، اور تیری طرف ہی لوٹنا ہے۔",
                category: .evening,
                repeatCount: 1,
                source: "Muslim"
            ),
            Adhkar(
                arabicText: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ",
                transliteration: "Allahu la ilaha illa Huwa, Al-Hayyul-Qayyum. La ta'khudhuhu sinatun wa la nawm. Lahu ma fis-samawati wa ma fil-ard. Man dhal-ladhi yashfa'u 'indahu illa bi idhnihi. Ya'lamu ma bayna aydeehim wa ma khalfahum, wa la yuheetuna bi shay'in min 'ilmihi illa bima sha'a. Wasi'a Kursiyyuhus-samawati wal-ard. Wa la ya'ooduhu hifdhuhuma. Wa Huwal-'Aliyyul-Azeem",
                englishTranslation: "Allah! There is no god but He, the Ever-Living, the Sustainer of existence. Neither slumber nor sleep overtakes Him. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what will be behind them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and He feels no fatigue in guarding and preserving them. And He is the Most High, the Most Great.",
                frenchTranslation: "Allah ! Il n'y a de divinité que Lui, le Vivant, Celui qui subsiste par Lui-même. Ni somnolence ni sommeil ne Le saisissent. À Lui appartient tout ce qui est dans les cieux et tout ce qui est sur la terre. Qui peut intercéder auprès de Lui sans Sa permission ? Il connaît ce qui est devant eux et ce qui est derrière eux. Et ils n'embrassent de Sa science que ce qu'Il veut. Son Trône s'étend sur les cieux et la terre, et leur garde ne Lui coûte aucune peine. Et Il est le Très Haut, le Très Grand.",
                urduTranslation: "اللہ کے سوا کوئی معبود نہیں، وہ زندہ جاوید، سب کو سنبھالنے والا ہے۔ اسے نہ اونگھ آتی ہے اور نہ نیند۔ اسی کا ہے جو کچھ آسمانوں میں ہے اور جو کچھ زمین میں ہے۔ کون ہے جو اس کی اجازت کے بغیر اس کے حضور شفاعت کر سکے؟ وہ جانتا ہے جو کچھ ان کے سامنے ہے اور جو کچھ ان کے پیچھے ہے۔ اور وہ اس کے علم میں سے کسی چیز کا احاطہ نہیں کر سکتے مگر جتنا وہ چاہے۔ اس کی کرسی آسمانوں اور زمین پر وسیع ہے۔ اور اسے ان دونوں کی حفاظت تھکاتی نہیں۔ اور وہ بلند ہے، بہت بڑا ہے۔",
                category: .evening,
                repeatCount: 1,
                source: "Quran 2:255"
            ),
            
            // MARK: - After Prayer Adhkar (أذكار بعد الصلاة)
            Adhkar(
                arabicText: "أَسْتَغْفِرُ اللَّهَ (ثلاث مرات) اللَّهُمَّ أَنْتَ السَّلاَمُ، وَمِنْكَ السَّلاَمُ، تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ",
                transliteration: "Astaghfirullah (x3). Allahumma Antas-Salam, wa minkas-salam, tabarakta ya Dhal-Jalali wal-Ikram",
                englishTranslation: "I seek Allah's forgiveness (3 times). O Allah, You are Peace, and from You comes peace. Blessed are You, O Possessor of Majesty and Honor.",
                frenchTranslation: "Je demande pardon à Allah (3 fois). Ô Allah, Tu es la Paix, et de Toi vient la paix. Béni sois-Tu, Ô Possesseur de la Majesté et de l'Honneur.",
                urduTranslation: "میں اللہ سے مغفرت طلب کرتا ہوں (تین بار)۔ اے اللہ، تو ہی سلامتی ہے، اور تجھ ہی سے سلامتی ہے، تو بڑا بابرکت ہے، اے عظمت اور بزرگی والے۔",
                category: .afterPrayer,
                repeatCount: 1,
                source: "Muslim"
            ),
            Adhkar(
                arabicText: "سُبْحَانَ اللَّهِ (33 مرة) الْحَمْدُ لِلَّهِ (33 مرة) اللَّهُ أَكْبَرُ (33 مرة) لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                transliteration: "Subhanallah (x33). Alhamdulillah (x33). Allahu Akbar (x33). La ilaha illallahu wahdahu la shareeka lahu, lahul-mulku wa lahul-hamdu, wa Huwa 'ala kulli shay'in Qadeer",
                englishTranslation: "Glory be to Allah (33 times). All praise is due to Allah (33 times). Allah is the Greatest (33 times). There is no god but Allah alone, He has no partner. To Him belongs all sovereignty and all praise, and He is over all things omnipotent.",
                frenchTranslation: "Gloire à Allah (33 fois). Louange à Allah (33 fois). Allah est le Plus Grand (33 fois). Il n'y a de dieu qu'Allah seul, Il n'a pas d'associé. À Lui appartient la royauté et à Lui les louanges, et Il est Omnipotent sur toute chose.",
                urduTranslation: "اللہ پاک ہے (33 بار)۔ تمام تعریفیں اللہ کے لیے ہیں (33 بار)۔ اللہ سب سے بڑا ہے (33 بار)۔ اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ اسی کی بادشاہی ہے اور اسی کے لیے تمام تعریفیں ہیں، اور وہ ہر چیز پر قادر ہے۔",
                category: .afterPrayer,
                repeatCount: 99,
                source: "Bukhari & Muslim"
            )
        ]
    }
} 