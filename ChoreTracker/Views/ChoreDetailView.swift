//
//  ChoreDetailView.swift
//  ChoreTracker
//
//  Created by Nathan Fuller on 3/23/24.
//

import SwiftUI

struct ChoreDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var chore: Chore
    @Binding var isEditing: Bool
    
    @State private var opacity: Double = 1.0
    private var detailText: String {
        if let completedAt = viewModel.completedAtString {
            return "Completed on \(completedAt)"
        } else {
            return "Created on \(viewModel.createdAtString)"
        }
    }
    
    private var viewModel: ChoreDetailViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(chore.title)
                    .frame(alignment: .topLeading)
                    .font(.title)
                    .foregroundStyle(Color.Text.primary)
                Text(detailText)
                    .font(.caption2)
            }
            Spacer()
            ControlButton(
                isComplete: chore.completedAt != nil,
                isEditing: $isEditing
            ) {
                guard !isEditing else {
                    withAnimation {
                        opacity = 0
                    } completion: {
                        modelContext.delete(chore)
                    }
                    
                    return
                }
               
                withAnimation(.easeInOut(duration: 0.3)) {
                    if chore.completedAt == nil {
                        chore.complete()
                    } else {
                        chore.uncomplete()
                    }
                }
                
            }
        }
        .padding()
        .foregroundStyle(Color.Text.primary)
        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .foregroundStyle(Color.Background.card)
        }
        .shadow(radius: 4)
        .opacity(opacity)
    }
    
    init(chore: Chore, isEditing: Binding<Bool>) {
        self.chore = chore
        self.viewModel = ChoreDetailViewModel(chore: chore)
        _isEditing = isEditing
    }
}

extension ChoreDetailView {
    struct ControlButton: View {
        var isComplete: Bool
        @Binding var isEditing: Bool
        var action: () -> Void
        
        private var controlButtonImage: some View {
            var symbolName: String = "circle"
            var tintColor: Color = .Icon.neutral
            
            if isEditing {
                symbolName = "minus.circle.fill"
                tintColor = .Icon.destructive
            } else if isComplete {
                symbolName = "checkmark.circle.fill"
            }
            
            return Image(systemName: symbolName)
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundStyle(tintColor)
        }
        
        var body: some View {
            Button(action: {
                action()
            }, label: {
                controlButtonImage
                    .animation(.easeInOut, value: isEditing)
                    .animation(.easeIn, value: isComplete)
            })
        }
    }
}

struct ChoreDetailViewModel {
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
    struct ChoreDetailView_Preview: View {
        @State var isEditing: Bool = false
        
        var editButtonText: String {
            isEditing ? "Done" : "Edit"
        }
        
        var body: some View {
            NavigationStack {
                ZStack {
                    Color.Background.page.ignoresSafeArea()
                    VStack {
                        ChoreDetailView(chore: Chore(title: "A long task that will take at least a couple of hours!"), isEditing: $isEditing)
                        ChoreDetailView(chore: Chore(title: "Do the dishes"), isEditing: $isEditing)
                    }
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isEditing.toggle()
                            }, label: {
                                Text(editButtonText)
                            })
                        }
                    }
                }
            }
        }
    }
    return ChoreDetailView_Preview()
        .modelContainer(for: Chore.self, inMemory: true)
}

#Preview("isEditing == true") {
    ZStack {
        Color.Background.page.ignoresSafeArea()
        ChoreDetailView(chore: Chore(title: "Editing Mode On"), isEditing: .constant(true))
            .padding()
    }
}
