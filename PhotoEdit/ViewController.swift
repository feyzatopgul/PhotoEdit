//
//  ViewController.swift
//  CameraApp
//
//  Created by fyz on 12/1/20.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var filterScrollView: UIScrollView!
    
    @IBOutlet weak var showFilterButton: UIButton!
    
    @IBOutlet weak var showEditButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
        
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIVignette"
    ]

    var filteredImage: UIImage? = UIImage()
    var originalImage: UIImage? = UIImage()
    var editedImage: UIImage? = nil
    
    let transparentSliderBrightness = UISlider (frame:CGRect(x: 0, y: 0, width: 400, height: 35))
    let rightSliderBrightness = UISlider (frame: CGRect(x: 0, y: 0, width: 200, height: 35))
    let leftSliderBrightness = UISlider (frame: CGRect(x: 0, y: 0, width: 200, height: 35))
    
    let transparentSliderContrast = UISlider (frame:CGRect(x: 0, y: 0, width: 400, height: 35))
    let rightSliderContrast = UISlider (frame: CGRect(x: 0, y: 0, width: 200, height: 35))
    let leftSliderContrast = UISlider (frame: CGRect(x: 0, y: 0, width: 200, height: 35))
    
    let transparentSliderSaturation = UISlider (frame:CGRect(x: 0, y: 0, width: 400, height: 35))
    let rightSliderSaturation = UISlider (frame: CGRect(x: 0, y: 0, width: 200, height: 35))
    let leftSliderSaturation = UISlider (frame: CGRect(x: 0, y: 0, width: 200, height: 35))

    let brightnessLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
    let brightnessValue = UILabel(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
    let saturationLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
    let saturationValue = UILabel(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
    let contrastLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
    let contrastValue = UILabel(frame:CGRect(x: 0, y: 0, width: 30, height: 30))

    override func viewDidLoad() {
        super.viewDidLoad()
        showFilterButton.isHidden = true
        showEditButton.isHidden = true
        saveButton.isHidden = true
        resetButton.isHidden = true
        doneButton.isHidden = true
        cancelButton.isHidden = true
        
        rightSliderBrightness.value = 0.0
        leftSliderBrightness.value = 0.0
        transparentSliderBrightness.value = 0.0
    
        rightSliderContrast.value = 1.0
        leftSliderContrast.value = 1.0
        transparentSliderContrast.value = 1.0
    
        rightSliderSaturation.value = 1.0
        leftSliderSaturation.value = 1.0
        transparentSliderSaturation.value = 1.0
        
        brightnessValue.text = "0"
        contrastValue.text = "0"
        saturationValue.text = "0"
    }

    @IBAction func showFiltersButton(_ sender: Any) {
        editFilterButtons()
    }
    
    @IBAction func showEditButton(_ sender: Any) {
        editEditButtons()
    }
    func editEditButtons() {

        for view in self.filterScrollView.subviews {
            view.removeFromSuperview()
        }
        filterScrollView.isScrollEnabled = false
        filterScrollView.contentOffset = CGPoint(x: 0, y: 0)
        let leadingAnchor = self.filterScrollView!.leadingAnchor
        let brightnessButton = UIButton.init(frame: CGRect.zero)
        let saturationButton = UIButton.init(frame: CGRect.zero)
        let contrastButton = UIButton.init(frame: CGRect.zero)

        brightnessButton.translatesAutoresizingMaskIntoConstraints = false
        saturationButton.translatesAutoresizingMaskIntoConstraints = false
        contrastButton.translatesAutoresizingMaskIntoConstraints = false

        filterScrollView.addSubview(brightnessButton)
        filterScrollView.addSubview(saturationButton)
        filterScrollView.addSubview(contrastButton)

        NSLayoutConstraint.activate([
            brightnessButton.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
            brightnessButton.heightAnchor.constraint(equalToConstant: 75.0),
            brightnessButton.widthAnchor.constraint(equalToConstant: 75.0),
                                        
            saturationButton.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
            saturationButton.heightAnchor.constraint(equalToConstant: 75.0),
            saturationButton.widthAnchor.constraint(equalToConstant: 75.0),
                                        
            contrastButton.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
            contrastButton.centerXAnchor.constraint(equalTo: filterScrollView.centerXAnchor),
            contrastButton.heightAnchor.constraint(equalToConstant: 75.0),
            contrastButton.widthAnchor.constraint(equalToConstant: 75.0)])
        
        NSLayoutConstraint(item: contrastButton, attribute: .leading, relatedBy: .equal, toItem: brightnessButton, attribute: .trailing, multiplier: 1.0, constant: 30).isActive = true
            NSLayoutConstraint(item: saturationButton, attribute: .leading, relatedBy: .equal, toItem: contrastButton, attribute: .trailing, multiplier: 1.0, constant: 30).isActive = true

            brightnessButton.setBackgroundImage(UIImage(named: "sun-white"), for: UIControl.State.normal)
            saturationButton.setBackgroundImage(UIImage(named: "saturation-white"), for: UIControl.State.normal)
            contrastButton.setBackgroundImage(UIImage(named: "contrast-white"), for: UIControl.State.normal)
      
            brightnessButton.addTarget(self, action: #selector(setBrightnessButton(_:)), for: .touchUpInside)
            saturationButton.addTarget(self, action: #selector(setSaturationButton(_:)), for: .touchUpInside)
            contrastButton.addTarget(self, action: #selector(setContrastButton(_:)), for: .touchUpInside)

            self.filterScrollView.trailingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
    }
    
    func editFilterButtons (){
        
        for view in self.filterScrollView.subviews {
            view.removeFromSuperview()
        }
        filterScrollView.isScrollEnabled = true
        var leadingAnchor = self.filterScrollView!.leadingAnchor
        
        for i in 0..<CIFilterNames.count {
            
            let filterButton = UIButton.init(frame: CGRect.zero)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            
            if let buttonInputImage = imageView.image {
                let context = CIContext(options: nil)
                if let currentFilter = CIFilter(name: "\(CIFilterNames[i])") {
                    let beginImage = CIImage(image: buttonInputImage)
                    currentFilter.setDefaults()
                    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                
                    if let output = currentFilter.outputImage{
                    if let cgimg = context.createCGImage(output, from: output.extent) {
                        let imageFiltered = UIImage(cgImage: cgimg)
                        filterButton.setBackgroundImage(imageFiltered, for: UIControl.State.normal)}
                    }
                }
            }
            
            filterScrollView.addSubview(filterButton)
            NSLayoutConstraint.activate([
                filterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant:5.0),
                filterButton.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                filterButton.heightAnchor.constraint(equalToConstant: 100.0),
                filterButton.widthAnchor.constraint(equalToConstant: 100.0)
            ])
                   
                leadingAnchor = filterButton.trailingAnchor
                filterButton.addTarget(self, action: #selector(setFilterButtons(_:)), for: .touchUpInside)
                }
                self.filterScrollView.trailingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    @objc func setFilterButtons(_ sender:Any?){
        
        if let filterButton = sender as? UIButton{
            
            imageView.image = filterButton.backgroundImage(for: UIControl.State.normal)
            filteredImage = imageView.image
        }
    }
    @objc func setBrightnessButton(_ sender:Any?){
        filteredImage = imageView.image
        if (sender as? UIButton) != nil {
            for view in self.filterScrollView.subviews {
                view.removeFromSuperview()
            }
            showFilterButton.isHidden = true
            showEditButton.isHidden = true
            doneButton.isHidden = false
            cancelButton.isHidden = false
        
            filterScrollView.isScrollEnabled = false
          
            rightSliderBrightness.isUserInteractionEnabled = false
            leftSliderBrightness.isUserInteractionEnabled = false
            transparentSliderBrightness.isContinuous = true
        
            transparentSliderBrightness.minimumTrackTintColor = .clear
            transparentSliderBrightness.maximumTrackTintColor = .clear
            rightSliderBrightness.minimumTrackTintColor = .clear
            rightSliderBrightness.maximumTrackTintColor = .systemBlue
            leftSliderBrightness.minimumTrackTintColor = .systemBlue
            leftSliderBrightness.maximumTrackTintColor = .clear
                    
            rightSliderBrightness.setThumbImage(UIImage(), for: .normal)
            leftSliderBrightness.setThumbImage(UIImage(), for: .normal)
     
            transparentSliderBrightness.maximumValue = 0.4
            transparentSliderBrightness.minimumValue = -0.4
            rightSliderBrightness.minimumValue = -0.4
            rightSliderBrightness.maximumValue = 0.0
            leftSliderBrightness.minimumValue = 0.0
            leftSliderBrightness.maximumValue = 0.4
            //rightSliderBrightness.value = 0.0
            //leftSliderBrightness.value = 0.0
            //transparentSliderBrightness.value = 0.0
            
            filterScrollView.addSubview(transparentSliderBrightness)
            filterScrollView.addSubview(leftSliderBrightness)
            filterScrollView.addSubview(rightSliderBrightness)
            transparentSliderBrightness.layer.zPosition = 1000
            filterScrollView.addSubview(brightnessLabel)
            filterScrollView.addSubview(brightnessValue)
        
            transparentSliderBrightness.translatesAutoresizingMaskIntoConstraints = false
            rightSliderBrightness.translatesAutoresizingMaskIntoConstraints = false
            leftSliderBrightness.translatesAutoresizingMaskIntoConstraints = false
            brightnessLabel.translatesAutoresizingMaskIntoConstraints = false
            brightnessValue.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                transparentSliderBrightness.centerXAnchor.constraint(equalTo: filterScrollView.centerXAnchor),
                transparentSliderBrightness.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                transparentSliderBrightness.heightAnchor.constraint(equalToConstant: 35.0),
                transparentSliderBrightness.widthAnchor.constraint(equalToConstant: 400.0),
                leftSliderBrightness.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                leftSliderBrightness.trailingAnchor.constraint(equalTo: transparentSliderBrightness.trailingAnchor),
                leftSliderBrightness.heightAnchor.constraint(equalToConstant: 35.0),
                leftSliderBrightness.widthAnchor.constraint(equalToConstant: 200),
                rightSliderBrightness.heightAnchor.constraint(equalToConstant: 35.0),
                rightSliderBrightness.widthAnchor.constraint(equalToConstant: 200),
                rightSliderBrightness.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                rightSliderBrightness.leadingAnchor.constraint(equalTo: transparentSliderBrightness.leadingAnchor),
            
                brightnessLabel.centerXAnchor.constraint(equalTo: filterScrollView.centerXAnchor),
               
            ])
        
            NSLayoutConstraint(item: brightnessLabel, attribute: .topMargin, relatedBy: .equal, toItem: transparentSliderBrightness, attribute: .bottomMargin, multiplier: 1.0, constant: 20).isActive = true
            
            NSLayoutConstraint(item: brightnessValue, attribute: .leading, relatedBy: .equal, toItem: brightnessLabel, attribute: .trailing, multiplier: 1.0, constant: 5).isActive = true
            
            NSLayoutConstraint(item: brightnessValue, attribute: .topMargin, relatedBy: .equal, toItem: transparentSliderBrightness, attribute: .bottomMargin, multiplier: 1.0, constant: 20).isActive = true
        
            transparentSliderBrightness.addTarget(self, action: #selector(editBrightnessVlaue(_:)), for: .valueChanged)
            
            brightnessLabel.textColor = UIColor.white
            brightnessLabel.text = "Brightness:"
            brightnessValue.textColor = UIColor.white
        }
    }
    @objc func editBrightnessVlaue(_ sender:UISlider){
        let value = transparentSliderBrightness.value
        if  value > 0.0 {
            leftSliderBrightness.value = value
            rightSliderBrightness.value = 0.0
            transparentSliderBrightness.minimumTrackTintColor = .clear
            transparentSliderBrightness.maximumTrackTintColor = .clear
            rightSliderBrightness.minimumTrackTintColor = .clear
            rightSliderBrightness.maximumTrackTintColor = .systemBlue
            leftSliderBrightness.minimumTrackTintColor = .systemBlue
            leftSliderBrightness.maximumTrackTintColor = .clear
        }
        else {
            rightSliderBrightness.value = value
            leftSliderBrightness.value = 0.0
            transparentSliderBrightness.minimumTrackTintColor = .clear
            transparentSliderBrightness.maximumTrackTintColor = .clear
            rightSliderBrightness.minimumTrackTintColor = .clear
            rightSliderBrightness.maximumTrackTintColor = .systemBlue
            leftSliderBrightness.minimumTrackTintColor = .systemBlue
            leftSliderBrightness.maximumTrackTintColor = .clear
        }
                
        self.brightnessValue.text = "\(Int(sender.value*250))"

        if let inputImage = filteredImage {
            let context = CIContext(options: nil)
            if let brightnessFilter = CIFilter(name: "CIColorControls"){
                let beginImage = CIImage(image: inputImage)
                brightnessFilter.setValue(beginImage, forKey: kCIInputImageKey)
                brightnessFilter.setValue(sender.value, forKey: kCIInputBrightnessKey)

                if let output = brightnessFilter.outputImage{
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let outputImage = UIImage(cgImage: cgimg)
                    imageView.image = outputImage
                }
                }
            }
        }
    }

    @objc func setContrastButton(_ sender:Any?){
        filteredImage = imageView.image
        if (sender as? UIButton) != nil {
            for view in self.filterScrollView.subviews {
                view.removeFromSuperview()
            }
            showFilterButton.isHidden = true
            showEditButton.isHidden = true
            doneButton.isHidden = false
            cancelButton.isHidden = false
            
            filterScrollView.isScrollEnabled = false
            rightSliderContrast.isUserInteractionEnabled = false
            leftSliderContrast.isUserInteractionEnabled = false
            transparentSliderContrast.isContinuous = true
            
            transparentSliderContrast.minimumTrackTintColor = .clear
            transparentSliderContrast.maximumTrackTintColor = .clear
            rightSliderContrast.minimumTrackTintColor = .clear
            rightSliderContrast.maximumTrackTintColor = .systemBlue
            leftSliderContrast.minimumTrackTintColor = .systemBlue
            leftSliderContrast.maximumTrackTintColor = .clear
                    
            rightSliderContrast.setThumbImage(UIImage(), for: .normal)
            leftSliderContrast.setThumbImage(UIImage(), for: .normal)
     
            transparentSliderContrast.maximumValue = 1.5
            transparentSliderContrast.minimumValue = 0.5
            rightSliderContrast.minimumValue = 0.5
            rightSliderContrast.maximumValue = 1.0
            leftSliderContrast.minimumValue = 1.0
            leftSliderContrast.maximumValue = 1.5
            //rightSliderContrast.value = 1.0
            //leftSliderContrast.value = 1.0
            //transparentSliderContrast.value = 1.0
            
            filterScrollView.addSubview(transparentSliderContrast)
            filterScrollView.addSubview(leftSliderContrast)
            filterScrollView.addSubview(rightSliderContrast)
            transparentSliderContrast.layer.zPosition = 1000
            filterScrollView.addSubview(contrastLabel)
            filterScrollView.addSubview(contrastValue)
        
            transparentSliderContrast.translatesAutoresizingMaskIntoConstraints = false
            rightSliderContrast.translatesAutoresizingMaskIntoConstraints = false
            leftSliderContrast.translatesAutoresizingMaskIntoConstraints = false
            contrastLabel.translatesAutoresizingMaskIntoConstraints = false
            contrastValue.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                transparentSliderContrast.centerXAnchor.constraint(equalTo: filterScrollView.centerXAnchor),
                transparentSliderContrast.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                transparentSliderContrast.heightAnchor.constraint(equalToConstant: 35.0),
                transparentSliderContrast.widthAnchor.constraint(equalToConstant: 400.0),
                leftSliderContrast.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                leftSliderContrast.trailingAnchor.constraint(equalTo: transparentSliderContrast.trailingAnchor),
                leftSliderContrast.heightAnchor.constraint(equalToConstant: 35.0),
                leftSliderContrast.widthAnchor.constraint(equalToConstant: 200),
                rightSliderContrast.heightAnchor.constraint(equalToConstant: 35.0),
                rightSliderContrast.widthAnchor.constraint(equalToConstant: 200),
                rightSliderContrast.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                rightSliderContrast.leadingAnchor.constraint(equalTo: transparentSliderContrast.leadingAnchor),
            
                contrastLabel.centerXAnchor.constraint(equalTo: filterScrollView.centerXAnchor)
            ])
            NSLayoutConstraint(item: contrastLabel, attribute: .topMargin, relatedBy: .equal, toItem: transparentSliderContrast, attribute: .bottomMargin, multiplier: 1.0, constant: 20).isActive = true
            
            NSLayoutConstraint(item: contrastValue, attribute: .leading, relatedBy: .equal, toItem: contrastLabel, attribute: .trailing, multiplier: 1.0, constant: 5).isActive = true
            
            NSLayoutConstraint(item: contrastValue, attribute: .topMargin, relatedBy: .equal, toItem: transparentSliderContrast, attribute: .bottomMargin, multiplier: 1.0, constant: 20).isActive = true
            
            transparentSliderContrast.addTarget(self, action: #selector(editContrastVlaue(_:)), for: .valueChanged)
            
            contrastLabel.textColor = UIColor.white
            contrastLabel.text = "Contrast:"
            contrastValue.textColor = UIColor.white
        }
    }
    @objc func editContrastVlaue(_ sender:UISlider){
        let value = transparentSliderContrast.value
        if  value >= 1.0 {
            leftSliderContrast.value = value
            rightSliderContrast.value = 1.0
            transparentSliderContrast.minimumTrackTintColor = .clear
            transparentSliderContrast.maximumTrackTintColor = .clear
            rightSliderContrast.minimumTrackTintColor = .clear
            rightSliderContrast.maximumTrackTintColor = .systemBlue
            leftSliderContrast.minimumTrackTintColor = .systemBlue
            leftSliderContrast.maximumTrackTintColor = .clear
        }
        else {
            rightSliderContrast.value = value
            leftSliderContrast.value = 1.0
            transparentSliderContrast.minimumTrackTintColor = .clear
            transparentSliderContrast.maximumTrackTintColor = .clear
            rightSliderContrast.minimumTrackTintColor = .clear
            rightSliderContrast.maximumTrackTintColor = .systemBlue
            leftSliderContrast.minimumTrackTintColor = .systemBlue
            leftSliderContrast.maximumTrackTintColor = .clear
        }
        self.contrastValue.text = "\(Int((sender.value-1)*200))"
        
        if let inputImage = filteredImage {
            let context = CIContext(options: nil)
            if let contrastFilter = CIFilter(name: "CIColorControls"){
                let beginImage = CIImage(image: inputImage)
                contrastFilter.setValue(beginImage, forKey: kCIInputImageKey)
                contrastFilter.setValue(sender.value, forKey: kCIInputContrastKey)
                if let output = contrastFilter.outputImage{
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let outputImage = UIImage(cgImage: cgimg)
                    imageView.image = outputImage
                }
                }
            }
        }
    }
    @objc func setSaturationButton(_ sender:Any?){
        filteredImage = imageView.image
        if (sender as? UIButton) != nil {
            for view in self.filterScrollView.subviews {
                view.removeFromSuperview()
            }
            showFilterButton.isHidden = true
            showEditButton.isHidden = true
            doneButton.isHidden = false
            cancelButton.isHidden = false
            
            filterScrollView.isScrollEnabled = false
            rightSliderSaturation.isUserInteractionEnabled = false
            leftSliderSaturation.isUserInteractionEnabled = false
            transparentSliderSaturation.isContinuous = true
            
            transparentSliderSaturation.minimumTrackTintColor = .clear
            transparentSliderSaturation.maximumTrackTintColor = .clear
            rightSliderSaturation.minimumTrackTintColor = .clear
            rightSliderSaturation.maximumTrackTintColor = .systemBlue
            leftSliderSaturation.minimumTrackTintColor = .systemBlue
            leftSliderSaturation.maximumTrackTintColor = .clear
                    
            rightSliderSaturation.setThumbImage(UIImage(), for: .normal)
            leftSliderSaturation.setThumbImage(UIImage(), for: .normal)
     
            transparentSliderSaturation.maximumValue = 3.0
            transparentSliderSaturation.minimumValue = -1.0
            rightSliderSaturation.minimumValue = -1.0
            rightSliderSaturation.maximumValue = 1.0
            leftSliderSaturation.minimumValue = 1.0
            leftSliderSaturation.maximumValue = 3.0
            //rightSliderSaturation.value = 1.0
            //leftSliderSaturation.value = 1.0
            //transparentSliderSaturation.value = 1.0
            
            filterScrollView.addSubview(transparentSliderSaturation)
            filterScrollView.addSubview(leftSliderSaturation)
            filterScrollView.addSubview(rightSliderSaturation)
            transparentSliderSaturation.layer.zPosition = 1000
            filterScrollView.addSubview(saturationLabel)
            filterScrollView.addSubview(saturationValue)
        
            transparentSliderSaturation.translatesAutoresizingMaskIntoConstraints = false
            rightSliderSaturation.translatesAutoresizingMaskIntoConstraints = false
            leftSliderSaturation.translatesAutoresizingMaskIntoConstraints = false
            saturationLabel.translatesAutoresizingMaskIntoConstraints = false
            saturationValue.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                transparentSliderSaturation.centerXAnchor.constraint(equalTo: filterScrollView.centerXAnchor),
                transparentSliderSaturation.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                transparentSliderSaturation.heightAnchor.constraint(equalToConstant: 35.0),
                transparentSliderSaturation.widthAnchor.constraint(equalToConstant: 400.0),
                leftSliderSaturation.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                leftSliderSaturation.trailingAnchor.constraint(equalTo: transparentSliderSaturation.trailingAnchor),
                leftSliderSaturation.heightAnchor.constraint(equalToConstant: 35.0),
                leftSliderSaturation.widthAnchor.constraint(equalToConstant: 200),
                rightSliderSaturation.heightAnchor.constraint(equalToConstant: 35.0),
                rightSliderSaturation.widthAnchor.constraint(equalToConstant: 200),
                rightSliderSaturation.centerYAnchor.constraint(equalTo: filterScrollView.centerYAnchor),
                rightSliderSaturation.leadingAnchor.constraint(equalTo: transparentSliderSaturation.leadingAnchor),
            
                saturationLabel.centerXAnchor.constraint(equalTo: filterScrollView.centerXAnchor)
            ])
            NSLayoutConstraint(item: saturationLabel, attribute: .topMargin, relatedBy: .equal, toItem: transparentSliderSaturation, attribute: .bottomMargin, multiplier: 1.0, constant: 20).isActive = true
            
            NSLayoutConstraint(item: saturationValue, attribute: .leading, relatedBy: .equal, toItem: saturationLabel, attribute: .trailing, multiplier: 1.0, constant: 5).isActive = true
            
            NSLayoutConstraint(item: saturationValue, attribute: .topMargin, relatedBy: .equal, toItem: transparentSliderSaturation, attribute: .bottomMargin, multiplier: 1.0, constant: 20).isActive = true
            
            transparentSliderSaturation.addTarget(self, action: #selector(editSaturationVlaue(_:)), for: .valueChanged)
            
            saturationLabel.textColor = UIColor.white
            saturationLabel.text = "Saturation:"
            saturationValue.textColor = UIColor.white
        }
    }
    @objc func editSaturationVlaue(_ sender:UISlider){
        let value = transparentSliderSaturation.value
        if  value >= 1.0 {
            leftSliderSaturation.value = value
            rightSliderSaturation.value = 1.0
            transparentSliderSaturation.minimumTrackTintColor = .clear
            transparentSliderSaturation.maximumTrackTintColor = .clear
            rightSliderSaturation.minimumTrackTintColor = .clear
            rightSliderSaturation.maximumTrackTintColor = .systemBlue
            leftSliderSaturation.minimumTrackTintColor = .systemBlue
            leftSliderSaturation.maximumTrackTintColor = .clear
        }
        else {
            rightSliderSaturation.value = value
            leftSliderSaturation.value = 1.0
            transparentSliderSaturation.minimumTrackTintColor = .clear
            transparentSliderSaturation.maximumTrackTintColor = .clear
            rightSliderSaturation.minimumTrackTintColor = .clear
            rightSliderSaturation.maximumTrackTintColor = .systemBlue
            leftSliderSaturation.minimumTrackTintColor = .systemBlue
            leftSliderSaturation.maximumTrackTintColor = .clear
        }
       self.saturationValue.text = "\(Int((sender.value-1)*50))"
        
        if let inputImage = filteredImage {
            let context = CIContext(options: nil)
            if let saturationFilter = CIFilter(name: "CIColorControls"){
                let beginImage = CIImage(image: inputImage)
                saturationFilter.setValue(beginImage, forKey: kCIInputImageKey)
                saturationFilter.setValue(sender.value, forKey: kCIInputSaturationKey)
                if let output = saturationFilter.outputImage{
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let outputImage = UIImage(cgImage: cgimg)
                    imageView.image = outputImage
                }
                }
            }
        }
    }
    var valueBrightness:Float = 0.0
    var valueBrightnessRight:Float = 0.0
    var valueBrightnessLeft:Float = 0.0
    var valueContrast:Float = 0.0
    var valueContrastRight:Float = 0.0
    var valueContrastLeft:Float = 0.0
    var valueSaturation:Float = 0.0
    var valueSaturationRight:Float = 0.0
    var valueSaturationLeft:Float = 0.0
    var brightnessText:String = ""
    var contrastText:String = ""
    var saturationText:String = ""
    
    @IBAction func doneButton(_ sender: Any) {
        showFilterButton.isHidden = false
        showEditButton.isHidden = false
        doneButton.isHidden = true
        cancelButton.isHidden = true
        
        valueBrightness = transparentSliderBrightness.value
        valueBrightnessRight = rightSliderBrightness.value
        valueBrightnessLeft = leftSliderBrightness.value
        brightnessText = brightnessValue.text ?? ""
        
        valueContrast = transparentSliderContrast.value
        valueContrastRight = rightSliderContrast.value
        valueContrastLeft = leftSliderContrast.value
        contrastText = contrastValue.text ?? ""
        
        valueSaturation = transparentSliderSaturation.value
        valueSaturationRight = rightSliderSaturation.value
        valueSaturationLeft = leftSliderSaturation.value
        saturationText = saturationValue.text ?? ""
        
        editEditButtons()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        imageView.image = filteredImage
        
        rightSliderBrightness.value = valueBrightnessRight
        leftSliderBrightness.value = valueBrightnessLeft
        transparentSliderBrightness.value = valueBrightness
        brightnessValue.text = brightnessText
    
        rightSliderContrast.value = valueContrastRight
        leftSliderContrast.value = valueContrastLeft
        transparentSliderContrast.value = valueContrast
        contrastValue.text = contrastText
    
        rightSliderSaturation.value = valueSaturationRight
        leftSliderSaturation.value = valueSaturationLeft
        transparentSliderSaturation.value = valueSaturation
        saturationValue.text = saturationText
        
        editEditButtons()
    }
    
    @IBAction func addButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose Photo From", message:nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.takePhoto()}))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in self.choosePhoto()}))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true)
    }
    func takePhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)

    }
    func choosePhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)

    }
    
    @IBAction func savePhoto(_ sender: Any) {
        let imageSaver = ImageSaver()
        if let capturedImage = imageView.image{
            imageSaver.writeToPhotoAlbum(image: capturedImage)
            let alert = UIAlertController(title: "", message: "Saved!", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func resetPhoto(_ sender: Any) {
        imageView.image = originalImage
        
        rightSliderBrightness.value = 0.0
        leftSliderBrightness.value = 0.0
        transparentSliderBrightness.value = 0.0
    
        rightSliderContrast.value = 1.0
        leftSliderContrast.value = 1.0
        transparentSliderContrast.value = 1.0
    
        rightSliderSaturation.value = 1.0
        leftSliderSaturation.value = 1.0
        transparentSliderSaturation.value = 1.0
        
        brightnessValue.text = "0"
        contrastValue.text = "0"
        saturationValue.text = "0"
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        imageView.image = image
        filteredImage = image
        originalImage = image
        showFilterButton.isHidden = false
        showEditButton.isHidden = false
        saveButton.isHidden = false
        resetButton.isHidden = false
        editFilterButtons()
    }
}
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
}

