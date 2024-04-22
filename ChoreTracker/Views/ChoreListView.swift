//
//  ContentView.swift
//  ChoreTracker
//
//  Created by Nathan Fuller on 3/17/24.
//

import UIKit
import SwiftUI
import SwiftData
import DeveloperToolsSupport

struct ChoreListView: View {
    @Environment(\.modelContext) private var modelContext
    @State var isEditing: Bool = false
    @Query private var chores: [Chore]
    
    var editButtonText: String {
        isEditing ? "Done".localized : "Edit".localized
    }
    
    var incompleteChores: [Chore] {
        chores.filter { $0.completedAt == nil}.sorted()
    }
    
    var completedChores: [Chore] {
        chores.filter { $0.completedAt != nil }.sorted { chore1, chore2 in
            guard let lhs = chore1.completedAt, let rhs = chore2.completedAt else {
                return false
            }
            
            return lhs >= rhs
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.Background.page.ignoresSafeArea()
                VStack(alignment: .leading) {
                    NewChoreView()
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            if !incompleteChores.isEmpty {
                                ChoreList(
                                    title: "Todo",
                                    chores: incompleteChores,
                                    isEditing: $isEditing,
                                    transition: .asymmetric(
                                        insertion: .scale(scale: 0.8),
                                        removal: .opacity
                                    )
                                )
                            }
                            
                            if !completedChores.isEmpty {
                                ChoreList(
                                    title: "Complete",
                                    chores: completedChores,
                                    isEditing: $isEditing,
                                    transition: .asymmetric(
                                        insertion: .opacity,
                                        removal: .opacity
                                    )
                                )
                            }
                        }
                        // animate additions to and removals from the `chores` datasource
                        .animation(.easeInOut(duration: 0.3), value: chores)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(editButtonText)
                    }
                    .onChange(of: chores.isEmpty, { oldValue, newValue in
                        if newValue {
                            isEditing = false
                        }
                    })
                    .opacity(chores.isEmpty ? 0 : 1)
                    .animation(.easeInOut, value: chores.isEmpty)
                }
            }
            .navigationTitle("My Chores")
        }
        .tint(Color.Text.primary)
    }
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(resource: .Colors.Text.primary)
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(resource: .Colors.Text.primary)
        ]
    }
}

extension ChoreListView {
    struct ChoreList: View {
        var title: String
        var chores: [Chore]
        @Binding var isEditing: Bool
        var transition: AnyTransition
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(title.uppercased())
                        .font(.caption)
                        .foregroundStyle(Color.Text.secondary)
                    Spacer()
                }

                ForEach(chores, id: \.self) { chore in
                    ChoreDetailView(chore: chore,
                                    isEditing: $isEditing)
                    .background(.clear)
                    .listRowInsets(.none)
                    .transition(transition)
                }
            }
            .padding(.vertical, chores.isEmpty ? 0 : 8)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Chore.self, configurations: config)
    
//    for i in 1..<3 {
//        let chore = Chore(title: "Test \(i)")
//        container.mainContext.insert(chore)
//    }
    
    for i in 1..<3 {
        let completeDate = Date(timeIntervalSinceNow: -1 * Double(i) * 60 * 60)
        let chore = Chore(title: "Completed Chore \(i)")
        chore.complete(date: completeDate)
        container.mainContext.insert(chore)
    }
    
    return ChoreListView().modelContainer(container)
}
