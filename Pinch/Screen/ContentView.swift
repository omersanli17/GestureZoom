//
//  ContentView.swift
//  Pinch
//
//  Created by omer sanli on 25.12.2021.
//

import SwiftUI

struct ContentView: View {
    // MARK: Property
    @State private var isAnimating: Bool = true
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    func resetImageState(){
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.clear
                // MARK: Gorsel
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .scaleEffect(imageScale)
                // MARK: 1. Tap Gesture
                    .onTapGesture(count: 2) {
                        if imageScale == 1{
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }else{
                         resetImageState()
                        }
                    }
                    .gesture(DragGesture()
                                .onChanged({ value in
                        withAnimation(.linear(duration: 1)){
                            imageOffset = value.translation
                        }
                    })
                                .onEnded{ _ in
                        if imageScale <= 1 {
                            resetImageState()
                        }
                    }
                    
                    
                    )
                // MARK: DRAG GESTURE
                
            } // MARK: End of Zstack
            
            .navigationTitle(Text("Pinch & Zoom"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            })
            
            // MARK: INFO Panel
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                , alignment: .top
            
            )
            
            
        } // MARK: End of NavigationView
    
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            
    }
}
