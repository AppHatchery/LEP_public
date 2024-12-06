//
//  TranslationManager.swift
//  LEP
//
//  Created by Yago Arconada on 6/6/24.
//

import Foundation

class TranslationManager {
    static let shared = TranslationManager()
    
    var translationsCards: [String: NurseCard] = [:]
    var translationsPhrases: [String: Drawer] = [:]
    
    
    private init() {
        // Update phrase bank with each new version
//        if VersionManager.shared.isNewVersion {
            loadCardTranslations()
            loadPhraseTranslations()
//        }
    }
    
    private func loadCardTranslations() {
        guard let path = Bundle.main.path(forResource: "translations_cards", ofType: "csv") else {
            print("CSV file not found")
            return
        }
        
        do {
            let content = try String(contentsOfFile: path)
            let rows = content.split { $0.isNewline }.dropFirst()
                                    
            for row in rows {
                let columns = row.split(separator: ",")
                let variable = String(columns[0])
                let nurseCard = NurseCard(
                    image: String(columns[1]),
                    en: String(columns[2]),
                    en_long: String(columns[3]),
                    es: String(columns[4]),
                    pt: String(columns[5]),
                    vi: String(columns[6]),
                    fr: String(columns[7]),
                    ko: String(columns[8]),
                    am: String(columns[9]),
                    my: String(columns[10]),
                    ar: String(columns[11]),
                    zh: String(columns[12])
                )
                translationsCards[variable] = nurseCard
                print(nurseCard)
            }
        } catch {
            print("Error reading CSV file: \(error)")
        }
    }
    
    private func loadPhraseTranslations() {
        guard let path = Bundle.main.path(forResource: "translations_phrases", ofType: "csv") else {
            print("CSV file not found")
            return
        }
        
        do {
            let content = try String(contentsOfFile: path)
            let rows = content.split { $0.isNewline }.dropFirst()
            
//            print("Rows:\n\(rows)")
            
            for row in rows {
                let columns = row.split(separator: ",")
                let variable = String(columns[0])
                let phrase = Drawer(
                    en: String(columns[1]),
                    es: String(columns[2]),
                    pt: String(columns[3]),
                    vi: String(columns[4]),
                    fr: String(columns[5]),
                    ko: String(columns[6]),
                    am: String(columns[7]),
                    my: String(columns[8]),
                    ar: String(columns[9]),
                    zh: String(columns[10])
                )
                translationsPhrases[variable] = phrase
            }
        } catch {
            print("Error reading CSV file: \(error)")
        }
    }
    
    func getCardTranslation(for variable: String) -> NurseCard? {
        return translationsCards[variable]
    }
    
    func getPhraseTranslation(for variable: String) -> Drawer? {
        return translationsPhrases[variable]
    }
}
