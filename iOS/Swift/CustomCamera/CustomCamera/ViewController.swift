//
//  ViewController.swift
//  CustomCamera
//
//  Created by Alex Barbulescu on 2020-05-21.
//  Copyright © 2020 ca.alexs. All rights reserved.
//

import UIKit
import AVFoundation
import MetalKit

class ViewController: UIViewController {
    //MARK:- Vars
    var captureSession : AVCaptureSession!
    
    var backCamera : AVCaptureDevice!
    var frontCamera : AVCaptureDevice!
    var backInput : AVCaptureInput!
    var frontInput : AVCaptureInput!
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    var videoOutput : AVCaptureVideoDataOutput!
    
    var takePicture = false
    var backCameraOn = true
    
    //metal
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    
    //core image
    var ciContext: CIContext!
    var currentCIImage: CIImage?
    
    //filter
    let fadeFilter = CIFilter(name: "CIPhotoEffectFade")
    let sepiaFilter = CIFilter(name: "CISepiaTone")
    
    //MARK:- View Components
    let switchCameraButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "switchcamera")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let captureImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let mtkView = MTKView()
    
    let capturedImageView = CapturedImageView()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
        setupMetal()
        setupCoreImage()
        setupAndStartCaptureSession()
    }
    
    //MARK: - Metal
    func setupMetal() {
        metalDevice = MTLCreateSystemDefaultDevice()
        
        // tell our MTKView which gpu to use
        mtkView.device = metalDevice
        
        mtkView.isPaused = true
        mtkView.enableSetNeedsDisplay = false
        
        // create a command queue to be able to send down instruction to the GPU
        metalCommandQueue = metalDevice.makeCommandQueue()
        
        mtkView.delegate = self
        
        // let it's drawable texture be writen to
        mtkView.framebufferOnly = true
    }
    
    //MARK: Core Image
    func setupCoreImage() {
        ciContext = CIContext(mtlDevice: metalDevice)
        setupFilters()
    }
    
    //MARK: Filters
    func setupFilters() {
        sepiaFilter?.setValue(NSNumber(value: 0.2), forKeyPath: "inputIntensity")
    }
    
    func applyFilters(inputImage image: CIImage) -> CIImage? {
        var filteredImage: CIImage?
        
        sepiaFilter?.setValue(image, forKeyPath: kCIInputImageKey)
        filteredImage = sepiaFilter?.outputImage
        
        fadeFilter?.setValue(filteredImage, forKeyPath: kCIInputImageKey)
        filteredImage = fadeFilter?.outputImage
        
        return filteredImage
    }
    
    //MARK:- Camera Setup
    func setupAndStartCaptureSession(){
        DispatchQueue.global(qos: .userInitiated).async{
            //init session
            self.captureSession = AVCaptureSession()
            //start configuration
            self.captureSession.beginConfiguration()
            
            //session specific configuration
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            //setup inputs
            self.setupInputs()
            
            DispatchQueue.main.async {
                //setup preview layer
                self.setupPreviewLayer()
            }
            
            //setup output
            self.setupOutput()
            
            //commit configuration
            self.captureSession.commitConfiguration()
            //start running it
            self.captureSession.startRunning()
        }
    }
    
    func setupInputs(){
        //get back camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = device
        } else {
            //handle this appropriately for production purposes
            fatalError("no back camera")
        }
        
        //get front camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontCamera = device
        } else {
            fatalError("no front camera")
        }
        
        //now we need to create an input objects from our devices
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("could not create input device from back camera")
        }
        backInput = bInput
        if !captureSession.canAddInput(backInput) {
            fatalError("could not add back camera input to capture session")
        }
        
        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("could not create input device from front camera")
        }
        frontInput = fInput
        if !captureSession.canAddInput(frontInput) {
            fatalError("could not add front camera input to capture session")
        }
        
        //connect back camera input to session
        captureSession.addInput(backInput)
    }
    
    func setupOutput(){
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func setupPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.insertSublayer(previewLayer, below: switchCameraButton.layer)
        previewLayer.frame = self.view.layer.frame
    }
    
    func switchCameraInput(){
        //don't let user spam the button, fun for the user, not fun for performance
        switchCameraButton.isUserInteractionEnabled = false
        
        //reconfigure the input
        captureSession.beginConfiguration()
        if backCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            backCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            backCameraOn = true
        }
        
        //deal with the connection again  for portrait mode
        videoOutput.connections.first?.videoOrientation = .portrait
        
        //mirror the video stream for front camera
        videoOutput.connections.first?.isVideoMirrored = !backCameraOn
        
        //commit config
        captureSession.commitConfiguration()
        
        //acitvate the camera button again
        switchCameraButton.isUserInteractionEnabled = true
    }
    
    //MARK:- Actions
    @objc func captureImage(_ sender: UIButton?){
        takePicture = true
    }
    
    @objc func switchCamera(_ sender: UIButton?){
        switchCameraInput()
    }

}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        if !takePicture {
//            return //we have nothing to do with the image buffer
//        }
        
        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        //filters it
        guard let filteredCIImage = applyFilters(inputImage: ciImage) else {
            return
        }
        
        self.currentCIImage = filteredCIImage
        
        mtkView.draw()
        
        if !takePicture {
            return
        }
        
        //get UIImage out of CIImage
        let uiImage = UIImage(ciImage: filteredCIImage)

        DispatchQueue.main.async {
            self.capturedImageView.image = uiImage
            self.takePicture = false
        }
    }
        
}

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
       // tells us the drawable's size has changed
    }
    
    func draw(in view: MTKView) {
        // create command buffer for ciContext to use to encode it's redering instructions to our GPU
        guard let commandBuffer = metalCommandQueue.makeCommandBuffer() else {
            return
        }
        
        // make sure we actually have a ciImage to work with
        guard let ciImage = currentCIImage else {
            return
        }
        
        // make sure the current drawable object for this metal view is available (it's not in use by the previous draw cycle)
        guard let currentDrawable = view.currentDrawable else {
            return
        }
        
        // make sure frame is centered on screen
        let heightOfciImage = ciImage.extent.height
        let heightOfDrawable = view.drawableSize.height
        let yOffsetFromButtom = (heightOfDrawable - heightOfciImage) / 2
        
        // render into the metal texture
        self.ciContext.render(
            ciImage,
            to: currentDrawable.texture,
            commandBuffer: commandBuffer,
            bounds: CGRect(origin: CGPoint(x: 0, y: -yOffsetFromButtom), size: view.drawableSize),
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )
        
        // register where to draw the instructions in the command buffer once it executes
        commandBuffer.present(currentDrawable)
        
        // commit the command to the queue so it executes
        commandBuffer.commit()
    }
}
