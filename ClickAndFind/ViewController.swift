//
//  ViewController.swift
//  ClickAndFind
//
//  Created by Rahul Sharma on 23/03/20.
//  Copyright © 2020 Rahul Sharma. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickImage
            
            
            guard let ciImage = CIImage(image: userPickImage) else {
                fatalError("Could not convert user pick image to ciImage")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
     
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            //print(results)
            
            if let firstResult = results.first {
                print(firstResult.identifier)
                self.navigationItem.title = "firstResult.identifier"
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}


