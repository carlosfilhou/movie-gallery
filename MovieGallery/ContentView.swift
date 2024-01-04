//
//  ContentView.swift
//  MovieGallery
//
//  Created by Carlos dos Santos Filho on 02/01/2024.
//

import SwiftUI

struct Item: Identifiable, Equatable {
    let image: ImageResource
    let title: String
    
    var id: Int {
        image.hashValue
    }
}

struct ContentView: View {
    @Namespace private var smoothPreview
    
    @State private var preview = false
    @State private var selected: Item?
    
    private var items: [Item] {
        [
            .init(image: .pic1, title: "Fight Club"),
            .init(image: .pic2, title: "Kill Bill"),
            .init(image: .pic3, title: "The Batman"),
            .init(image: .pic4, title: "Pulp Fiction"),
            .init(image: .pic5, title: "The Lord of The Rings"),
            .init(image: .pic6, title: "Star Wars"),
            
            .init(image: .pic8, title: "Django"),
            .init(image: .pic10, title: "Inception"),
            .init(image: .pic9, title: "Spider-Man 2"),
            
            .init(image: .pic7, title: "Rocky")
        ]
    }
    
    var body: some View {
        GeometryReader { proxy in
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Group {
                        Text("Album")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        Text("Movie Night")
                            .font(.system(size: 32, weight: .bold))
                    }
                    .padding(.horizontal, 16)
                    
                    let maxWidth = (proxy.size.width - 6) / 2
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: maxWidth)),
                        GridItem(.flexible(minimum: maxWidth))
                    ], spacing: 6,  content: {
                        
                        ForEach(items, id: \.id) { item in
                            createImage(from: item, width: maxWidth)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 0.6)) {
                                        selected = item
                                        preview = true
                                    }
                                }
                        }
                    })
                    .padding(.top, 24)
                }
                
                .background(Color.systemBackground)
                
            }
            .padding(.top, proxy.safeAreaInsets.top)
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
            .overlay {
                if preview, let selected = selected {
                    
                    ZStack(alignment: .bottom) {
                        Color.black.ignoresSafeArea()
                        
                        //Put here your cover view
                        
                        createImage(from: selected, width: proxy.size.width, height: proxy.size.height)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.6)) {
                                    self.selected = selected
                                    preview = false
                                }
                            }
                        
                        Text(selected.title)
                            .font(.system(size: 22, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .zIndex(2)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(.black.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                }
            }
        }
        .background(Color.black)
        .foregroundColor(Color.white)
    }
}

extension ContentView {
    
    private func createImage(from item: Item, width: CGFloat, height: CGFloat = 300) -> some View {
        Image(item.image)
            .resizable()
            .scaledToFill()
            .zIndex(selected?.id == selected?.id ? 1 : 0)
            .matchedGeometryEffect(id: item.id, in: smoothPreview)
            .frame(width: max(width, 0), height: height)
            .clipped()
            .clipShape(Rectangle())
    }
    
}

#Preview {
    ContentView()
}
