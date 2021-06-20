//
//  DetailsView.swift
//  Marvel Comics App
//
//  Created by Maciej Banaszyński on 18/06/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct DetailsView: View {
    var comic: Comic
    var body: some View {
        
        GeometryReader{ geometry in
            
            ZStack(){
                
                VStack(alignment: .center, content: {
                    
                    HStack {
                        Spacer()
                    }
                    
                    WebImage(url: extractImage(data: comic.thumbnail))
                        .resizable()
                        .frame(maxHeight: geometry.size.height/1.15)
                        .aspectRatio(contentMode: .fit)
                    
                    Spacer()
                
                })
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                
                VStack(alignment: .leading){
                    
                    HStack {
                        Spacer()
                    }
                    
                    ScrollView(.vertical, showsIndicators: false){
                    
                        Text(comic.title)
                            .font(.system(size:30))
                            .padding(.top,10)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 5)
                        
                        Text("\(getCreators(data: comic))")
                            .font(.caption)
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 5)
                        
                        if let description = comic.description{
                            Text(description)
                                .font(.callout)
                                .multilineTextAlignment(.leading)
                                .font(.system(size:40))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 5)
                            
                        }
                        
                    }
                    .padding(.bottom, 100)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground))
                .foregroundColor(Color(.label))
                .cornerRadius(40)
                .padding(.top, geometry.size.height/2.6)
                
                VStack(){
                    
                    Spacer()
                    
                    VStack(){
                        
                        HStack {
                            Spacer()
                        }
                        
                        Button(action: {
                            UIApplication.shared.open(getURL(comics: comic), options: [:], completionHandler: nil)
                        }){
                            Text("Find out more")
                                .foregroundColor(.white)
                                .font(.system(size:20))
                                .padding(.vertical, 20)
                                .frame(minWidth: geometry.size.width/1.1)
                                
                        }
                        .background(Color.red)
                        .frame(alignment: .center)
                        .cornerRadius(8)
                        .padding(.bottom,20)
                        
                    }
                    .background(Color(UIColor.systemBackground))
                }
                
            }
        }
    }

    
    func extractImage(data: [String: String]) -> URL{
        
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        
        var url = "\(path).\(ext)"
        
        url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
        
        return URL(string: url)!
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
    
    func getURL(comics: Comic)->URL{
        
        return extractURL(data: comics.urls[0])
    }
}


struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
            
    }
}
