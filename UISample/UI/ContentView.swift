//
//  ContentView.swift
//  UISample
//
//  Created by 정영민 on 2024/05/31.
//

import SwiftUI
import CoreData
import Combine

extension ContentView {
    enum Route: Routable {
        case detail(text: String)
        case login
    }
    
    // Builds the views
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .detail(let text):
            ItemDetailView(timestamp: text)
        case .login:
            LoginView()
                .environmentObject(navRouter)
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var isDetailViewActive = false
    
    @State private var isNavActive = false {
        didSet {
            print("isNavActive: \(isNavActive)")
        }
    }
    @State private var isLoginActive = false
    @State private var isLoginPresented = false
    
    let subject = PassthroughSubject<Int, Never>()
    
    let cancelBag = CancelBag()
    
    @State var currentSelection: Int32? = nil
    
    var index: Int = 0
    
    @ObservedObject var navRouter = NavigationRouter()

    var body: some View {
        NavigationStack {
            content
            Text("Select an item")
        }
    }
    
    var content: some View {
        VStack {
            NavigationStack(path: $navRouter.path) {
                rootContent
                    .navigationDestination(for: Route.self) { route in
                        view(for: route)
                    }
            }
            .environmentObject(navRouter)
        }
    }
    
    private var rootContent: some View {
        VStack {
            List {
                ForEach(items) { item in
                    let route: Route = .detail(text: "Item at \(formatDate(item.timestamp))")
                    NavigationLink("Item at \(formatDate(item.timestamp))", value: route)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Home")
            
            Button(action: {
                navRouter.push(route: Route.login)
            }) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.index = Int32(items.count)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

extension ContentView {
    class ViewModdel: ObservableObject {
        @Published var isLoginActive: Bool = false
        @Published var isDetailActive: Bool = false
        
        
    }
}

struct ItemDetailView: View {
    var timestamp: String = ""
    
    var body: some View {
        Text("Item at \(timestamp)")
            .navigationTitle("Detail")
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
