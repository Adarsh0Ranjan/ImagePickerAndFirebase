//
//  ImagePicker.swift
//  imagePickerFirebase
//
//  Created by Roro Solutions on 15/01/23.
//

import Foundation
import UIKit
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var showPicker: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator   //object that can recieve UiImagepeckerController event
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //jgu
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    
    init(_ picker : ImagePicker) {
        self.parent = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // run code when user has selected an image
        print("Image selected")
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
            
        }
        parent.showPicker = false
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // runn code when user cancel ui
        print("cancel")
    }
}
