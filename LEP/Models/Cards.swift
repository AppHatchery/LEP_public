//
//  DrawerQuestions.swift
//  LEP
//
//  Created by Yago Arconada on 6/23/22.
//

import Foundation




struct PatientCard {
    let image: String
    let en: String
    let es: String
    let en_long: String
    let es_long: String
}

struct NurseCard {
    let image: String
    let en: String
    let en_long: String
    let es: String
    let pt: String
    let vi: String
    let fr: String
    let ko: String
    let am: String
    let my: String
    let ar: String
    let zh: String
    
    func text(for languageCode: String) -> String {
        switch languageCode {
        case "en":
            return en
        case "es":
            return es
        case "pt":
            return pt
        case "vi":
            return vi
        case "fr":
            return fr
        case "ko":
            return ko
        case "am":
            return am
        case "my":
            return my
        case "ar":
            return ar
        case "zh":
            return zh
        default:
            return en  // Default to English if the language code is not recognized
        }
    }
}

struct Drawer {
    let en: String
    let es: String
    let pt: String
    let vi: String
    let fr: String
    let ko: String
    let am: String
    let my: String
    let ar: String
    let zh: String
    
    func text(for languageCode: String) -> String {
        switch languageCode {
        case "en":
            return en
        case "es":
            return es
        case "pt":
            return pt
        case "vi":
            return vi
        case "fr":
            return fr
        case "ko":
            return ko
        case "am":
            return am
        case "my":
            return my
        case "ar":
            return ar
        case "zh":
            return zh
        default:
            return en  // Default to English if the language code is not recognized
        }
    }
}

struct IntroCard {
    let image: String
    let en: String
    let es: String
    let englishSecondTitle: String
    let spanishSecondTitle: String
    let englishThirdTitle: String
    let spanishThirdTitle: String
}
