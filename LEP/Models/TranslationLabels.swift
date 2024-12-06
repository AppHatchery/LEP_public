//
//  TranslationLabels.swift
//  LEP
//
//  Created by Yago Arconada on 11/19/24.
//

class TranslationLabelsManager {
    static let shared = TranslationLabelsManager()
    
    let realTimeTranslationInstructions: [String: [String: String]] = [
        "en": [
            "timeText": "Please limit speaking to 10 seconds.",
            "timeoutText": "Time's up, please avoid long phrases.",
            "placeholderText": "Speak now..."
        ],
        "fr": [
            "timeText": "Veuillez limiter la parole à 10 secondes.",
            "timeoutText": "Temps écoulé, veuillez éviter les phrases longues.",
            "placeholderText": "Parlez maintenant..."
        ],
        "es": [
            "timeText": "Por favor, limite la grabación a 10 segundos.",
            "timeoutText": "Se acabó el tiempo, por favor evite frases largas.",
            "placeholderText": "Hable ahora..."
        ],
        "pt": [
            "timeText": "Por favor, limite a fala a 10 segundos.",
            "timeoutText": "O tempo acabou, evite frases longas.",
            "placeholderText": "Fale agora..."
        ],
        "vi": [
            "timeText": "Vui lòng giới hạn ghi âm trong 10 giây.",
            "timeoutText": "Hết thời gian, vui lòng tránh các câu dài.",
            "placeholderText": "Nói ngay bây giờ..."
        ],
        "ko": [
            "timeText": "%@ 초 이내로 말을 제한하세요.",
            "timeoutText": "시간이 다 됐습니다. 긴 문장을 피해주세요.",
            "placeholderText": "지금 말하세요..."
        ]
    ]
}
