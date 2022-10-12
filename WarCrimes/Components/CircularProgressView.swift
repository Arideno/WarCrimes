//
//  CircularProgressView.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import SwiftUI

struct CircularProgressView: View {

    let progress: Double
    let color: Color
    let lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.5),
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

#if DEBUG
struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.8, color: .red)
    }
}
#endif
