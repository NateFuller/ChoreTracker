//
//  NewChoreView.swift
//  ChoreTracker
//
//  Created by Nathan Fuller on 3/29/24.
//

import SwiftUI

struct NewChoreView: View {
    @Environment(\.modelContext) private var modelContext
    @State var title: String = ""
    
    var body: some View {
        TextField("", text: $title)
            .lineLimit(3)
            .placeholder(when: title.isEmpty) {
                Text("Chore title")
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
            .onSubmit {
                if !title.isEmpty {
                    modelContext.insert(Chore(title: title))
                    title = ""
                }
            }
    }
}

struct NewChoreViewModel {
    private var chore: Chore
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    var completedAtString: String? {
        guard let completedAt = chore.completedAt else { return nil }
        
        return dateFormatter.string(from: completedAt)
    }
    
    var createdAtString: String {
        dateFormatter.string(from: chore.createdAt)
    }
    
    init(chore: Chore) {
        self.chore = chore
    }
}

#Preview {
    struct NewChoreView_Preview: View {
        var body: some View {
            ZStack {
                Color.Background.page.ignoresSafeArea()
                NewChoreView()
            }
        }
    }
    return NewChoreView_Preview()
        .modelContainer(for: Chore.self, inMemory: true)
}
