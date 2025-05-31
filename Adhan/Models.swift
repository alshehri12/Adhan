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
        case .afterPrayer: return "hands.sparkles"
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
            // MARK: - Morning Adhkar
            Adhkar(
                arabicText: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                transliteration: "Asbahna wa asbahal-mulku lillah, walhamdu lillah, la ilaha illa Allah wahdahu la shareeka lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay'in qadeer",
                englishTranslation: "We have reached the morning and with it Allah's dominion, and praise is to Allah. There is no god but Allah alone, with no partner. To Him belongs sovereignty and praise, and He is capable of all things.",
                frenchTranslation: "Nous avons atteint le matin et avec lui la domination d'Allah, et la louange est à Allah. Il n'y a de dieu qu'Allah seul, sans associé. À Lui appartient la souveraineté et la louange, et Il est capable de toutes choses.",
                urduTranslation: "ہم نے صبح کی اور اللہ کی بادشاہت کے ساتھ صبح ہوئی، اور تمام تعریف اللہ کے لیے ہے۔ اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اسی کی بادشاہت ہے اور اسی کے لیے تعریف ہے اور وہ ہر چیز پر قادر ہے۔",
                category: .morning,
                repeatCount: 1,
                source: "Muslim"
            ),
            Adhkar(
                arabicText: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ",
                transliteration: "Allahumma anta rabbi la ilaha illa ant, khalaqtani wa ana abduk, wa ana ala ahdika wa wa'dika mastata't",
                englishTranslation: "O Allah, You are my Lord, there is no god but You. You created me and I am Your servant, and I am faithful to my covenant and promise to You as much as I can.",
                frenchTranslation: "Ô Allah, Tu es mon Seigneur, il n'y a de dieu que Toi. Tu m'as créé et je suis Ton serviteur, et je reste fidèle à mon alliance et à ma promesse envers Toi autant que je le peux.",
                urduTranslation: "اے اللہ! تو ہی میرا رب ہے، تیرے سوا کوئی معبود نہیں، تو نے مجھے پیدا کیا اور میں تیرا بندہ ہوں، اور میں اپنی استطاعت کے مطابق تیرے عہد اور وعدے پر قائم ہوں۔",
                category: .morning,
                repeatCount: 1,
                source: "Bukhari"
            ),
            Adhkar(
                arabicText: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
                transliteration: "Subhan Allah wa bihamdihi",
                englishTranslation: "Glory is to Allah and praise is to Him",
                frenchTranslation: "Gloire à Allah et louange à Lui",
                urduTranslation: "اللہ پاک ہے اور اس کی تعریف کے ساتھ",
                category: .morning,
                repeatCount: 100,
                source: "Bukhari & Muslim"
            ),
            
            // MARK: - Evening Adhkar
            Adhkar(
                arabicText: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                transliteration: "Amsayna wa amsal-mulku lillah, walhamdu lillah, la ilaha illa Allah wahdahu la shareeka lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shay'in qadeer",
                englishTranslation: "We have reached the evening and with it Allah's dominion, and praise is to Allah. There is no god but Allah alone, with no partner. To Him belongs sovereignty and praise, and He is capable of all things.",
                frenchTranslation: "Nous avons atteint le soir et avec lui la domination d'Allah, et la louange est à Allah. Il n'y a de dieu qu'Allah seul, sans associé. À Lui appartient la souveraineté et la louange, et Il est capable de toutes choses.",
                urduTranslation: "ہم نے شام کی اور اللہ کی بادشاہت کے ساتھ شام ہوئی، اور تمام تعریف اللہ کے لیے ہے۔ اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اسی کی بادشاہت ہے اور اسی کے لیے تعریف ہے اور وہ ہر چیز پر قادر ہے۔",
                category: .evening,
                repeatCount: 1,
                source: "Muslim"
            ),
            Adhkar(
                arabicText: "اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ",
                transliteration: "Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namoot, wa ilaykal-maseer",
                englishTranslation: "O Allah, by You we have reached the evening, by You we have reached the morning, by You we live, by You we die, and to You is the return.",
                frenchTranslation: "Ô Allah, par Toi nous avons atteint le soir, par Toi nous avons atteint le matin, par Toi nous vivons, par Toi nous mourrons, et vers Toi est le retour.",
                urduTranslation: "اے اللہ! تیرے ذریعے ہم نے شام کی، تیرے ذریعے ہم نے صبح کی، تیرے ذریعے ہم زندہ ہیں، تیرے ذریعے ہم مریں گے، اور تیری طرف ہی واپسی ہے۔",
                category: .evening,
                repeatCount: 1,
                source: "Abu Dawud & At-Tirmidhi"
            ),
            Adhkar(
                arabicText: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
                transliteration: "A'udhu bikalimatillahit-tammati min sharri ma khalaq",
                englishTranslation: "I seek refuge in the perfect words of Allah from the evil of what He has created",
                frenchTranslation: "Je cherche refuge dans les paroles parfaites d'Allah contre le mal de ce qu'Il a créé",
                urduTranslation: "میں اللہ کے مکمل کلمات کی پناہ مانگتا ہوں اس کی مخلوقات کے شر سے",
                category: .evening,
                repeatCount: 3,
                source: "Muslim"
            ),
            
            // MARK: - After Prayer Adhkar
            Adhkar(
                arabicText: "سُبْحَانَ اللَّهِ",
                transliteration: "Subhan Allah",
                englishTranslation: "Glory is to Allah",
                frenchTranslation: "Gloire à Allah",
                urduTranslation: "اللہ پاک ہے",
                category: .afterPrayer,
                repeatCount: 33,
                source: "Bukhari & Muslim"
            ),
            Adhkar(
                arabicText: "الْحَمْدُ لِلَّهِ",
                transliteration: "Alhamdulillah",
                englishTranslation: "Praise is to Allah",
                frenchTranslation: "Louange à Allah",
                urduTranslation: "تمام تعریف اللہ کے لیے",
                category: .afterPrayer,
                repeatCount: 33,
                source: "Bukhari & Muslim"
            ),
            Adhkar(
                arabicText: "اللَّهُ أَكْبَرُ",
                transliteration: "Allahu Akbar",
                englishTranslation: "Allah is the Greatest",
                frenchTranslation: "Allah est le Plus Grand",
                urduTranslation: "اللہ سب سے بڑا ہے",
                category: .afterPrayer,
                repeatCount: 34,
                source: "Bukhari & Muslim"
            ),
            Adhkar(
                arabicText: "رَبِّ اغْفِرْ لِي ذَنْبِي وَخَطَئِي وَجَهْلِي",
                transliteration: "Rabbi ghfir li dhanbi wa khata'i wa jahli",
                englishTranslation: "My Lord, forgive my sin, my mistake, and my ignorance",
                frenchTranslation: "Mon Seigneur, pardonne mon péché, mon erreur et mon ignorance",
                urduTranslation: "اے میرے رب! میرے گناہ، میری خطا اور میری جہالت کو معاف فرما",
                category: .afterPrayer,
                repeatCount: 3,
                source: "Bukhari & Muslim"
            )
        ]
    }
} 