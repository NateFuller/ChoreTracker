//
//  CTTextView.swift
//  ChoreTracker
//
//  Created by Nathan Fuller on 3/24/24.
//

import SwiftUI

struct CTTextView: View {
    var placeholder: LocalizedStringKey
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .lineLimit(3)
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
            }
            .frame(alignment: .topLeading)
            .font(.title)
            .foregroundStyle(Color.Text.primary)
            .padding()
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundStyle(Color.Background.card)
            }
            .shadow(radius: 4)
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
                    CTTextView(
                        placeholder: "Enter something",
                        text: $text
                    )
                }
                .padding()
            }
        }
    }
    
    return PreviewWrapper()
}
