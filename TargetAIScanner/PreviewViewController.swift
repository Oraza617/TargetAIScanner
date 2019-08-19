//
//  PreviewViewController.swift
//  TargetAIScanner
//
//  Created by Owais Raza on 8/17/19.
//

import UIKit
import CoreML
import Vision

class PreviewViewController: UIViewController {

    var image: UIImage!
    
    
    @IBOutlet weak var resultPhoto: UIImageView!
    
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        detectPhoto(image: photo.image!)
        // Do any additional setup after loading the view.
    }
    
    func detectPhoto(image: UIImage) {
        //load the machine learning model
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UI Image to CIImage")
        }
        
        guard let model = try? VNCoreMLModel(for: MobileNet().model)else {
            fatalError("can't load the ML model")
        }
        let request = VNCoreMLRequest(model: model) { (vnRequest, error) in
            print(vnRequest.results?.first)
            guard let results = vnRequest.results as? [VNClassificationObservation], let firstResult = results.first else {
                fatalError("unexpected reuslt")
            }
            print(results.first?.confidence)
            print(results.first?.identifier)
            DispatchQueue.main.async {
                if firstResult.identifier.contains("banana") {
                    print("banana")
                    self.resultPhoto.image = UIImage(named: "yes")
                } else {
                    print("notbanana")
                    self.resultPhoto.image = UIImage(named: "no")
                }
            }

        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    

    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
