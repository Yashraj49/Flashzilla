//
//  LoginScreen.swift
//  Flashzilla
//
//  Created by Yashraj jadhav on 16/05/23.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
        Text("Login")
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .frame(width: 284, height: 50, alignment: .top)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
