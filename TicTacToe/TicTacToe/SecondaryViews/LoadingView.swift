//
//  LoadingView.swift
//  LoadingView
//
//  Created by David Kababyan on 07/08/2021.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {

        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
        }
    }
}


