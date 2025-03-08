import SwiftUI

enum Bodoni: String, CaseIterable {
    case regular = "BodoniModa-Regular.ttf"
    case bold = "BodoniModa-Bold.ttf"
    case italic = "BodoniModa-Italic.ttf"
    case black = "BodoniModa-Black.ttf"
    case semibold = "BodoniModa-SemiBold.ttf"
    case medium = "BodoniModa-Medium.ttf"
    case boldItalic = "BodoniModa-BoldItalic.ttf"
    case extraBold = "BodoniModa-ExtraBold.ttf"
}

extension Font {
    static func bodoni(_ bodoni: Bodoni, size: CGFloat) -> Font {
        custom(String(bodoni.rawValue.dropLast(4)), size: size)
    }
}

struct BodoniFont {
    public static func registerAllFonts() {
        Bodoni.allCases.forEach { font in
            registerFont(fontName: font.rawValue)
        }
    }
    
    fileprivate static func registerFont(fontName: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: nil) else {
            fatalError("Couldn't create fonts.")
        }
        
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
    }
}
