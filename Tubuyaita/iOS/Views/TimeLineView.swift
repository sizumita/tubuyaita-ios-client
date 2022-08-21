//
//  TimeLineView.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/19.
//

import SwiftUI


struct TimeLineView: View {
    @StateObject var model: TimeLineModel
    @Environment(\.managedObjectContext) private var viewContext
    
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
                        TweetView(message: msg)
                            .swipeActions(edge: .trailing) {
                                NavigationLink {
                                    Text("av")
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
            }
        }
        .listStyle(.grouped)
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
