//
//  CameraView.swift
//  Camera
//
//  Created by Benjámin Szilágyi on 03/03/2024.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            VStack{
                if camera.isTaken{
                    Image(systemName: "camera.on.rectangle")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                }
                Spacer()
                HStack{
                    if camera.isTaken{
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        Spacer()
                        
                    }else{
                        Button(action: {camera.isTaken.toggle()}, label: {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }.frame(height: 75)
            }
        }.onAppear(perform: {
            camera.Check()
        })
    }
}

#Preview {
    CameraView()
}
