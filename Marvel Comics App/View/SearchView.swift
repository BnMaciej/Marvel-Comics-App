//
//  SearchView.swift
//  Marvel Comics App
//
//  Created by Magda Banaszyński on 18/06/2021.
//

import SwiftUI


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct SearchView: View {
    @EnvironmentObject var searchData: HomeViewModel
    var body: some View {
            
        NavigationView(){
            
            ScrollView(.vertical, showsIndicators: false, content:{
                
                VStack(spacing: 15){
                    
                    HStack{
                        
                        HStack(spacing: 10){
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(10)
                                .font(.system(size:30))
                            
                            TextField("Search for a comic book", text: $searchData.searchedQuery)
                                .padding(.vertical, 15)
                                .font(.system(size: 20))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(Color(.systemGray))
                            
                          
                            
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(8.0)
                        .padding(.vertical, 10)
                        .padding(.horizontal,10)
                        
                        if searchData.searchedQuery != ""{
                            
                            Button(action:{
                                searchData.searchedQuery = ""
                            }){
                                Text("Cancel")
                                    .foregroundColor(Color(.systemGray))
                                    .font(.system(size: 20))
                            }
                            .padding(.horizontal)
                            
                        }
                        
                    }
                    
                    if searchData.searchedQuery == ""{
                        
                        
                    }
                    
                }
                .padding()
                
                if let comics = searchData.fetchedComics{
                    
                    if comics.isEmpty{
                        
                        Text("No comics found")
                            .padding(.top,100)
                            .padding(.vertical, 15)
                            .font(.system(size: 20))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(Color(.systemGray))
                        
                    }
                    else{
                        
                        ForEach(comics){data in
                            NavigationLink(destination: DetailsView(comic: data)){
                                ComicRowView(comic: data)
                            }
                        }
                    }
                    
                }
                else{
                    
                    if searchData.searchedQuery != ""{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                            .scaleEffect(x: 2, y: 2, anchor: .center)
                            .padding(.top,250)
                    }
                    else{
                        
                        VStack{
                            
                            Image(systemName: "book.fill")
                                .font(.system(size: 90))
                                .foregroundColor(Color(.systemGray3))
                            
                            Text("Start typing to find a particular comincs.")
                                .font(.system(size: 20))
                                .foregroundColor(Color(.label))
                            
                        }
                        .padding(.top,250)
                        
                    }
                }
            })
            .navigationBarHidden(true)
            .onTapGesture{
                hideKeyboard()
            }
        }
        .accentColor(Color(.label))
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}

struct ComicRowView: View{
    var comic: Comic
    
    var body: some View{
        
        Group{
            HStack(alignment: .center) {
            
            
                WebImage(url: extractImage(data: comic.thumbnail))
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .frame(maxWidth: 150)
                    .frame(width: 150, height: 200)
                    
                
                VStack(alignment: .leading, spacing: 8, content: {
                    
                    Text(comic.title)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("written by \(getCreators(data: comic))")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if let description = comic.description{
                        Text(description)
                            .font(.callout)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    
                })
                .padding()
                .foregroundColor(Color(.label))
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            .border(Color(.systemGray6), width: 0.5)
            .shadow(color: Color(.systemGray6), radius: 0.6, x: 1, y: 1)
            .shadow(color: Color(.systemGray6), radius: 0.6, x: -1, y: -1)
            
        }
        .frame(minWidth: 0,maxWidth: .infinity)
        .cornerRadius(8)
        .padding(.horizontal,/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    
    }
    
    
    func extractImage(data: [String: String]) -> String{
        
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        
        var url = "\(path).\(ext)"
        
        url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
        
        return url
    }
    
    func getCreators(data: Comic) -> String{
        
        var creators = ""
        for comic in data.creators.items{
            creators += "\(comic.name) "
        }
        return creators
    }
    
    func extractURL(data: [String: String]) -> URL{
        
        let url = data["url"] ?? ""

        return URL(string: url)!
    }
    
    func extractURLType(data: [String: String]) -> String{
        
        let type = data["type"] ?? ""
        
        return type.capitalized
    }
}
