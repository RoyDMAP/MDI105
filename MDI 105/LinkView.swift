//
//  LinkView.swift
//  MDI 105
//
//  Ceated by Roy Dimapilis on 8/6/25.
//

import SwiftUI

struct LinkView: View {
    let item: Book
    
    var body: some View {
        HStack {
            Image(item.image)
                .resizable()
                .frame(width: 47, height: 47)
                .scaledToFit()
            Text(item.title)
        }
        .border(Color.black, width: 2)
        
    }
}
#Preview {
    ContentView()
}
