//
//  HomeView.swift
//  RepAngle
//
//  Created by Wilson Chan on 1/28/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            MeasureView()
                .tabItem {
                    VStack {
                        Image(systemName: "lines.measurement.horizontal")
                        Text("Measure")
                    }
                }
            TargetView()
                .tabItem {
                    VStack {
                        Image(systemName: "scope")
                        Text("Target")
                    }
                }
        }
    }
}
    #Preview {
        HomeView()
    }
