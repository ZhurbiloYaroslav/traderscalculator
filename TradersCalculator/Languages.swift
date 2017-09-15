//
//  Languages.swift
//  TraderCalculator
//
//  Created by Yaroslav Zhurbilo on 15.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation


struct Languages {
    
    //TODO: Determine code for System language
    struct System {
        static let name = "System"
        static var code: String {
            let prefLang = Locale.preferredLanguages[0]
            return prefLang.components(separatedBy: "-")[0]
        }
        static var locale: String {
            let prefLang = Locale.preferredLanguages[0]
            return prefLang.components(separatedBy: "-")[1]
        }
    }
    
    struct English {
        static let name = "English"
        static let code = "Base"
    }
    
    struct Russian {
        static let name = "Русский"
        static let code = "ru"
    }
    
    struct French {
        static let name = "Français"
        static let code = "fr"
    }
    
    struct Spanish {
        static let name = "Español"
        static let code = "es"
    }
    
    struct German {
        static let name = "Deutsch"
        static let code = "de"
    }
    
    struct Portuguese {
        static let name = "Português"
        static let code = "pt-PT"
    }
    
    struct Turkish {
        static let name = "Türkçe"
        static let code = "tr"
    }
    
    struct Arabic {
        static let name = "العربية"
        static let code = "ar"
    }
    
    struct Hindi {
        static let name = "हिन्दी"
        static let code = "hi"
    }
    
    struct ChineseSimplified {
        static let name = "中国"
        static let code = "zh-Hans"
    }
    
    struct Japanese {
        static let name = "日本語"
        static let code = "ja"
    }
    
}

    
