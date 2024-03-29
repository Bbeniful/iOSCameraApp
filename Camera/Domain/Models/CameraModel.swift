//
//  CameraModel.swift
//  Camera
//
//  Created by Benjámin Szilágyi on 03/03/2024.
//

import Foundation
import AVFoundation
import SwiftUI


class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    func Check(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ (status) in
                if status{
                    self.setUp()
                }
            }
            return
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp(){
        
        do{
            self.session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func retakePicture(){
        DispatchSerialQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                }
                self.isSaved = false
            }
        }
    }
    
    func takePicture(){
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil{
            return
        }
        
        print("picture has been taken")
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        self.picData = imageData
    }
    
    func savePicture(){
        let image = UIImage(data: self.picData)!
        UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil)
        self.isSaved = true
        
        print("Image has been saved")
    }
}
