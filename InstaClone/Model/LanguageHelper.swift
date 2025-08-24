//
//  LanguageHelper.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import SwiftUI


struct LanguageHelper {

      // Helper function for language-based gradients
    static func gradientColorsForLanguage(_ language: String) -> [Color] {
        switch language.lowercased() {
        case "swift": return [.orange, .red]
        case "javascript": return [.yellow, .orange]
        case "python": return [.blue, .cyan]
        case "java": return [.red, .orange]
        case "typescript": return [.blue, .purple]
        case "html": return [.orange, .pink]
        case "css": return [.blue, .green]
        case "dart": return [.blue, .teal]
        case "kotlin": return [.purple, .pink]
        case "go": return [.cyan, .blue]
        case "rust": return [.orange, .brown]
        case "c++", "cpp": return [.blue, .purple]
        case "c": return [.gray, .blue]
        case "php": return [.purple, .blue]
        case "Blade": return [.red, .orange]
        case "ruby": return [.red, .pink]
        default: return [.gray, .secondary]
        }
    }
    
    // Helper function for language-based icons
    static func iconForLanguage(_ language: String) -> String {
        switch language.lowercased() {
        case "swift": return "swift"
        case "javascript": return "curlybraces"
        case "python": return "terminal"
        case "java": return "cup.and.saucer"
        case "typescript": return "t.square"
        case "html": return "globe"
        case "css": return "paintbrush"
        case "dart": return "target"
        case "kotlin": return "k.square"
        case "go": return "goforward"
        case "rust": return "gear"
        case "c++", "cpp": return "plus.forwardslash.minus"
        case "c": return "c.square"
        case "php": return "p.square"
        case "Blade": return "crown"
        case "ruby": return "diamond"
        default: return "code"
        }
    }


}

