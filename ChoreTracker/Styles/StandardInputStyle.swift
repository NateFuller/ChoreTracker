//
//  StandardInputStyle.swift
//  ChoreTracker
//
//  Created by Nathan Fuller on 3/24/24.
//

import SwiftUI

struct StandardInput: View {
    var placeholder: LocalizedStringKey
    var text: Binding<String>
    
    var body: some View {
        TextField("", text: text)
            .standardStyle()
            .placeholder(when: text.wrappedValue.isEmpty) {
               Text(placeholder)
            }
    }
}

struct StandardInputStyle: ViewModifier{
    func body(content: Content) -> some View {
        ZStack {
            content
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundStyle(.white)
                .background {
                    Color(white: 1.0, opacity: 0.3)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
        }
    }
}

extension TextField {
    func standardStyle() -> some View {
        return self.modifier(StandardInputStyle())
    }
}
    
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .topLeading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder()
                .foregroundStyle(.white.opacity(0.46))
                .opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var text = ""
        var body: some View {
            ZStack {
                Color.Background.page.ignoresSafeArea()
                VStack {
                    StandardInput(placeholder: "Enter something", text: $text)
                }
                .padding()
            }
        }
    }
    
    return PreviewWrapper()
}
