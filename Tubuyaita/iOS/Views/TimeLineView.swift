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
    @StateObject var task: TimeLineTask
    @State var i: Double = 0

    var body: some View {
        Group {
            if task.model.isInitialized {
                List {
                    ForEach(task.model.messages) { message in
                        Text(message.parsedContent)
                    }
                }
            } else {
                Spinner()
            }
        }
        .navigationTitle(task.model.server.address!)
        .onAppear() {
            task.initializeMessages()
        }
    }
}
