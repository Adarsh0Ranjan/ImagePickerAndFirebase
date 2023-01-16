//
//  ContentView.swift
//  imagePickerFirebase
//
//  Created by Roro Solutions on 15/01/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct ContentView: View {
    
    @State var showPicker = false
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    var body: some View {
        VStack{
            
            
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            Button{
                showPicker = true
            }label: {
                Text("slect a photo")
            }
            if selectedImage != nil {
                Button{
                    uploadPhoto()
                }label: {
                    Text("upload image")
                }
            }
            
            Divider()
            
            HStack {
                
                ForEach(retrievedImages, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50,height: 50)
                }
            }
            
            
        }
        .onAppear(perform: retreivePhotos)
        .sheet(isPresented: $showPicker,onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, showPicker: $showPicker)
        }
        
        
    }
    func uploadPhoto() {
        // Make Sure that the selcted image is not nil
        guard selectedImage != nil else{
            return
        }
        
        // create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn image into data
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        // Specify the file path
        let path = "image/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        // Upload the data
        _ = fileRef.putData(imageData!,metadata: nil) { metaData, error in
             
            //check for error
            if error == nil && metaData != nil {
                // Save a refrence to the file in Firestore  Db
                
                let db = Firestore.firestore()
                db.collection("images").document().setData(["url": path],completion: { error in
    
                    //if there is no errors, display the new image
                    if error == nil {
                        
                         // add the uploaded images to the list of images for disply
                        DispatchQueue.main.async {
                            self.retrievedImages.append(self.selectedImage!)
                        }
                    }

                })
            }
        }
        
    }
    
    func retreivePhotos() {
        // Get the image data from database
        let db = Firestore.firestore()
        
        db.collection("images").getDocuments { snapshot, error in
            
            
            if error == nil && snapshot != nil {
                
                
                var paths = [String]()
                
                //lop through all returnned docs
                for doc in snapshot!.documents {
                    //Exctract the file path and add to array
                    
                    paths.append(doc["url"] as! String)
                }
                
                // Lopp through  each file path and fetach the data from storage
                for path in paths {
                   
                    
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                    
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    //Recieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        
                        //check for error
                        if error == nil && data != nil{
                            
                            // create the ui image and put it innto our array to display
                            if let image = UIImage(data: data!){
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
