//
//  ViewController.swift
//  Image Picker and Gestures App
//
//  Created by DCS on 03/07/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let toolBar:UIToolbar = {
        let toolBar = UIToolbar()
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(handleSpacer))
        let gallery = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleGallery))
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleCamera))
        toolBar.items = [cancel, spacer, gallery, camera]
        return toolBar
    }()
    
    @objc private func handleCancel() {
        print("cancel called")
        self.dismiss(animated: true)
    }
    @objc private func handleSpacer() {
        print("Spacer called")
    }
    
    
    @objc private func handleGallery() {
        print("gallery called")
        imagePicker.sourceType = .photoLibrary
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true)
        }
    }
    
    @objc private func handleCamera() {
        print("camera called")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            DispatchQueue.main.async {
                self.present(self.imagePicker, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Oops!", message: "Camera not found. Try picking an image from your gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private let imagePicker:UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        return imagePicker
    }()
    private let myImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "i1")
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchView))
            view.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action:#selector(didRotateView))
        view.addGestureRecognizer(rotationGesture)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeView))
        view.addGestureRecognizer(leftSwipe)
      /*
        let lpan = UIPanGestureRecognizer(target: self, action: #selector(didPanView(_:)))
        view.addGestureRecognizer(lpan)
      */
        
        self.view.backgroundColor = .black
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg4.jpg")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        view.addSubview(myImageView)
        view.addSubview(toolBar)
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            myImageView.frame = CGRect(x: 20, y: 150, width: view.width - 40, height: 200)
    }
    
    
}
extension ViewController{
    @objc private func didTapView(_ gesture:UITapGestureRecognizer){
        print("Tapped at location: \(gesture.location(in: myImageView))")
        let toolBarHeight:CGFloat = view.safeAreaInsets.top + 40
        toolBar.frame = CGRect(x: 0, y: 30, width: view.width, height: toolBarHeight )
        
        
    }
    @objc private func didPinchView(_ gesture:UIPinchGestureRecognizer){
        myImageView.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
    }
    @objc private func didRotateView(_ gesture:UIRotationGestureRecognizer){
        myImageView.transform = CGAffineTransform(rotationAngle: gesture.rotation)
    }
    @objc private func didSwipeView(_ gesture:UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            UIView.animate(withDuration: 0.2) {
                self.myImageView.frame = CGRect(x: self.myImageView.frame.origin.x - 40, y:  self.myImageView.frame.origin.y, width: 200, height: 200)
            }
        } else if gesture.direction == .right {
            UIView.animate(withDuration: 0.2) {
                self.myImageView.frame = CGRect(x: self.myImageView.frame.origin.x + 40, y:  self.myImageView.frame.origin.y, width: 200, height: 200)
            }
        } else if gesture.direction == .up {
            UIView.animate(withDuration: 0.2) {
                self.myImageView.frame = CGRect(x: self.myImageView.frame.origin.x, y:  self.myImageView.frame.origin.y - 40, width: 200, height: 200)
            }
        } else if gesture.direction == .down {
            UIView.animate(withDuration: 0.2) {
                self.myImageView.frame = CGRect(x: self.myImageView.frame.origin.x, y:  self.myImageView.frame.origin.y + 40, width: 200, height: 200)
            }
        } else {
            print("Could not detect direction of swipe")
        }
    }
/*
    @objc private func didPanView(_ gesture:UIPanGestureRecognizer){
        let x = gesture.location(in: view).x
        let y = gesture.location(in: view).y
        myImageView.center = CGPoint(x: x, y: y)

        
    }
  */
}
extension ViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            myImageView.image = selectedImage
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
