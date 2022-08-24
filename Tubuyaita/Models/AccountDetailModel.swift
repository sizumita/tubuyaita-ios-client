//
//  AccountDetailModel.swift
//  Tubuyaita
//
//  Created by Sumito Izumita on 2022/08/24.
//

import Foundation
import SwiftUI

class AccountDetailModel : ObservableObject {
    @Binding var account: Account
    
    init(account: Binding<Account>) {
        self._account = account
    }
}
