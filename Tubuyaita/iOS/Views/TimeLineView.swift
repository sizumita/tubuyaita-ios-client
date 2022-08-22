//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI


extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}


struct TimeLineView: View {
    @ObservedObject var model: TimeLineModel
    @Environment(\.managedObjectContext) private var viewContext
    @FocusState var focus: Bool
    
    @FetchRequest(entity: FetchHistory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FetchHistory.createdAt, ascending: false)])
    var fetchHistories: FetchedResults<FetchHistory>
    
    @FetchRequest(entity: Message.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Message.timestamp, ascending: false)])
    var messages: FetchedResults<Message>
    
    @FetchRequest(entity: Account.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)])
    var accounts: FetchedResults<Account>

    var body: some View {
        ZStack {
            if messages.count == 0 {
                Text("メッセージがありません")
            } else {
                List {
                    ForEach(messages) { msg in
                        let account = accounts.filter({ a in a.publicKey! == msg.publicKey! }).first
                        TweetView(
                            message: Binding(get: {msg}, set: {v, t in}),
                            account: Binding<Account?>.init(get: { account }, set: { acc in }))
                            .swipeActions(edge: .trailing) {
                                NavigationLink {
                                    MessageDetailView(
                                        message: Binding<Message>.init(get: { msg }, set: { m, t in }),
                                        account: Binding<Account?>.init(get: { account }, set: {acc in}))
                                } label: {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.red)
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "return")
                                }
                            }
                        let historyIndex = fetchHistories.firstIndex { history in
                            return history.lastMessageHash == msg.contentHash
                        }
                        if historyIndex != nil && !fetchHistories[historyIndex!].fetched {
                            Button {
                                // msgを使ってメッセージ一覧を次存在するメッセージまで取ってくる。
                                // 取ってきたらhistoryを消す！
                                model.loadMessages(history: fetchHistories[historyIndex!],
                                                   isFirst: historyIndex! == 0,
                                                   previousHistory: historyIndex! < (fetchHistories.count-1) ? fetchHistories[historyIndex! + 1] : nil)
                            } label: {
                                Label {
                                    Text("読み込む")
                                } icon: {
                                    Image(systemName: "doc.text.magnifyingglass")
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear() {
            messages.nsPredicate = NSPredicate(format: "server == %@", model.server)
            fetchHistories.nsPredicate = NSPredicate(format: "server == %@", model.server)
            accounts.nsPredicate = NSPredicate(format: "server == %@", model.server)
            fetchHistories.forEach { history in
                if history != fetchHistories.first && history.lastMessageHash == nil {
                    viewContext.delete(history)
                }
            }
            try? viewContext.save()
        }
    }
}
