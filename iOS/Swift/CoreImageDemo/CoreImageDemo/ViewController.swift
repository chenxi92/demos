//
//  ViewController.swift
//  CoreImageDemo
//
//  Created by peak on 2022/6/17.
//

/// https://www.raywenderlich.com/30195423-core-image-tutorial-getting-started
///

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    let context = CIContext(options: nil)
    let filter = CIFilter(name: "CISepiaTone")!
    var orientation = UIImage.Orientation.up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let uiImage = UIImage(named: "image") else { return }
        let ciImage = CIImage(image: uiImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
    }


    @IBAction func sliderValueChanged(_ sender: UISlider) {
//        applySepiaFilter(intensity: sender.value)
        applyOldPhotoFilter(intensity: sender.value)
    }
    
    @IBAction func loadPhoto(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func applySepiaFilter(intensity: Float) {
        filter.setValue(intensity, forKey: kCIInputIntensityKey)
        
        guard let outputImage = filter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        imageView.image = UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
    }
    
    func applyOldPhotoFilter(intensity: Float) {
        filter.setValue(intensity, forKey: kCIInputIntensityKey)
        
        let random = CIFilter(name: "CIRandomGenerator")
        
        let lighten = CIFilter(name: "CIColorControls")
        lighten?.setValue(random?.outputImage, forKey: kCIInputImageKey)
        lighten?.setValue(1 - intensity, forKey: kCIInputBrightnessKey)
        lighten?.setValue(0, forKey: kCIInputSaturationKey)
        
        guard let ciImage = filter.value(forKey: kCIInputImageKey) as? CIImage else {
            return
        }
        let croppedImage = lighten?.outputImage?.cropped(to: ciImage.extent)
        
        let composite = CIFilter(name: "CIHardLightBlendMode")
        composite?.setValue(filter.outputImage, forKey: kCIInputImageKey)
        composite?.setValue(croppedImage, forKey: kCIInputBackgroundImageKey)
        
        let vignette = CIFilter(name: "CIVignette")
        vignette?.setValue(composite?.outputImage, forKey: kCIInputImageKey)
        vignette?.setValue(intensity * 2, forKey: kCIInputIntensityKey)
        vignette?.setValue(intensity * 30, forKey: kCIInputRadiusKey)
        
        guard let outputImage = vignette?.outputImage else {
            return
        }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        imageView.image = UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        let ciImage = CIImage(image: selectedImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        orientation = selectedImage.imageOrientation
        applySepiaFilter(intensity: slider.value)
        
        dismiss(animated: true)
    }
}

