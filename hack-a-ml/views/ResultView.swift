//
//  ResultView.swift
//  hack-a-ml
//
//  Created by Taylor Pubins on 2/17/24.
//

import SwiftUI

struct ResultView: View {
    let playerName: String?
    let hr: Int
    let truth: Int
    let bambinoBI: Double

    var body: some View {
        Text("\(playerName ?? "") hit \(truth) HRs in 2023")
        let biFormatted = Double(round(bambinoBI * 10) / 10).formatted()
        Text("BambinoBI guessed \(biFormatted) HRs")
        if Double((hr - truth).magnitude) <= (bambinoBI - Double(truth)).magnitude {
            Text("You beat BambinoBI!!")
        } else {
            Text("He beat you, try again")
        }
    }
}

#Preview {
    ResultView(playerName: "Tommy Pham", hr: 16, truth: 17, bambinoBI: 19.3565468432)
}
