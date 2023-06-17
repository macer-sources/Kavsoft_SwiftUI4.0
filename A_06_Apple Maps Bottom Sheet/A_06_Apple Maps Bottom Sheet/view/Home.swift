//
//  Home.swift
//  A_06_Apple Maps Bottom Sheet
//
//  Created by work on 6/17/23.
//

import SwiftUI
import MapKit

struct Home: View {
    @State private var showAnotherSheet = false
    
    var body: some View {
        ZStack {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 25.2048, longitude: 55.2708), latitudinalMeters: 10000, longitudinalMeters: 10000)
            Map(coordinateRegion: .constant(region))
                .ignoresSafeArea()
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        showAnotherSheet.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                    }
                    .padding()

                })
                .bottomSheet(presentationDetents: [.medium, .large, .height(70)], isPresented: .constant(true), sheetCornerRadius: 20) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            TextField("Search Maps", text: .constant(""))
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.ultraThickMaterial)
                                }

                            // MARK: song list
                            SongList()
                        }
                        .padding()
                        .padding(.top)
                    }
//                     MARK: 默认情况下，一个controller 只能 present 一个 sheet
//                     因此，如果我们尝试显示另一张工作表，它将不会显示，但是有一个解决方法，只需将所有工作表和全屏封面视图插入底部工作表视图即可，因为它是一个新的视图控制器，因此它能够显示另一张工作表
                    .sheet(isPresented: $showAnotherSheet) {
                        Text("Hello Sheet ")
                    }
                }
        }
    }
    
    
    
    @ViewBuilder
    func SongList() -> some View {
        VStack(spacing: 15) {
            ForEach(albums, id: \.id) { album in
                HStack(spacing: 12) {
                    Text("#\(getIndex(album:album) + 1)")
                        .fontWeight(.semibold)
                    
                    Image(album.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text (album.name)
                            .fontWeight(.semibold)
                        
                        Label {
                            Text("65,78,999")
                        } icon: {
                            Image(systemName: "beats.headphones")
                        }
                        .font(.caption)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: album.liked ? "suit.heart.fill" : "suit.heart")
                            .font(.title3)
                            .foregroundColor(album.liked ? .red : .primary)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }

                    
                }
            }
        }
        .padding(.top, 15)
    }
    
    func getIndex(album: Album) -> Int {
        return albums.firstIndex(where: {$0.id == album.id}) ?? 0
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
