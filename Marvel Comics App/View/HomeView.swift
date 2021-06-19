//
//  HomeView.swift
//  Marvel Comics App
//
//  Created by Maciej Banaszyński on 18/06/2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var searchData: HomeViewModel
    var body: some View {
        
        NavigationView {
            
            HStack{
                
                if searchData.fetchComics.isEmpty{
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                        .scaleEffect(x: 2, y: 2, anchor: .center)
                        .padding()
                    
                }
                else{
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 15){
                            
                            ForEach(searchData.fetchComics){comic in
                                NavigationLink(destination: DetailsView(comic: comic)){
                                    ComicRowView(comic: comic)
                                }
                            }
                            
                            if searchData.offset == searchData.fetchComics.count{
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                                    .scaleEffect(x: 2, y: 2, anchor: .center)
                                    .padding(.top,50)
                                    .onAppear(perform: {
                                        searchData.fetchAllComics()
                                    })
                            }
                            else{
                                GeometryReader{reader -> Color in
                                    
                                    let minY = reader.frame(in: .global).minY
                                    
                                    let height = UIScreen.main.bounds.height / 1.3
                                    
                                    if !searchData.fetchComics.isEmpty && minY < height{
                                        
                                        DispatchQueue.main.async {
                                            searchData.offset = searchData.fetchComics.count
                                        }
                                        
                                    }
                                    
                                    return Color.clear
                                    
                                }
                            }
                            
                        }
                        .padding(.vertical)
                        
                    }
                }
            }
            .navigationTitle("Marvel Comics")
            
        }
        .accentColor(Color(.label))
        .onAppear(perform: {
            if searchData.fetchComics.isEmpty{
                searchData.fetchAllComics()
            }
        })
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

