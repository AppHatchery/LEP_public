//
//  LanguageManager.swift
//  LEP
//
//  Created by Yago Arconada on 4/22/24.
//

import Foundation
import UIKit

class LanguageManager {
    static let shared = LanguageManager()

    let languageCodeMap: [String: (code: String, locale: String, namecaps: String, flag: String, color: UIColor)] = [
        "French": (code: "fr", locale: "fr-FR", namecaps: "FRENCH", flag: "french-flag", color: UIColor.frenchColor),
        "Spanish": (code: "es", locale: "es-MX", namecaps: "SPANISH", flag: "spanish-flag", color: UIColor.spanishColor),
        "Portuguese": (code: "pt", locale: "pt-BR", namecaps: "PORTUGUESE", flag: "portuguese-flag", color: UIColor.portugueseColor),
        "Vietnamese": (code: "vi", locale: "vi-VN", namecaps: "VIETNAMESE", flag: "vietnamese-flag", color: UIColor.vietnameseColor),
//        "Amharic": (code: "am", locale: "am-ET", namecaps: "AMHARIC", flag: "amharic-flag", color: UIColor.amharicColor),
//        "Burmese": (code: "my", locale: "my-MM", namecaps: "BURMESE", flag: "burmese-flag", color: UIColor.burmeseColor),
//        "Arabic": (code: "ar", locale: "ar-SA", namecaps: "ARABIC", flag: "arabic-flag", color: UIColor.arabicColor),
        "Korean": (code: "ko", locale: "ko-KR", namecaps: "KOREAN", flag: "korean-flag", color: UIColor.koreanColor),
//        "Mandarin": (code: "zh", locale: "zh-CN", namecaps: "MANDARIN", flag: "mandarin-flag", color: UIColor.mandarinColor)
    ]


    // Holds the current locale, initially set to English.
    var currentLocale: String = "es-MX"
    var currentLanguage: String = "Spanish"
    
    // Property to get the current language code based on the current locale
    var currentLanguageCode: String {
        return languageCodeMap.first { $0.value.locale == currentLocale }?.value.code ?? "es-MX"
    }
    
    var currentLanguageName: String {
        return languageCodeMap.first { $0.value.locale == currentLocale }?.key ?? "Spanish"
    }
    
    var currentLanguageFlag: String {
        return languageCodeMap.first { $0.value.locale == currentLocale }?.value.flag ?? "spanish-flag"
    }
    
    var currentLanguageColor: UIColor {
        return languageCodeMap.first { $0.value.locale == currentLocale }?.value.color ?? UIColor.clear
    }

    func setCurrentLocale(to newLocale: String) {
        currentLocale = newLocale
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
    }
}

extension Notification.Name {
    static let languageDidChange = Notification.Name("LanguageDidChange")
}
