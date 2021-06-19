//
//  Home.swift
//  Marvel Comics App
//
//  Created by Maciej Banaszyński on 18/06/2021.
//

import SwiftUI

struct Home: View {
    @StateObject var homeData = HomeViewModel()
    var body: some View {
        
        TabView{
           HomeView()
                .tabItem{
                    Image(systemName: "house.fill")
                }
                .environmentObject(homeData)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .environmentObject(homeData)
                
        }
        .accentColor(.red)

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
