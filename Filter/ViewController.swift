//
//  ViewController.swift
//  Filter
//
//  Created by Yisheng Li on 2020/6/2.
//  Copyright © 2020 GreatApps. All rights reserved.
//

import UIKit

struct Filter {
    let label: String
    let image: UIImage
    
    init(label:String, image:UIImage) {
        self.label = label
        self.image = image
    }
}



class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let dispatchGroup = DispatchGroup()
    let filtersUpdateQueue = DispatchQueue.global(qos: .utility)
    
    let filtersEditQueue = DispatchQueue.global(qos: .userInteractive)
    let myProgress = Progress(totalUnitCount: 5)
    let processor: ImageProcessor = ImageProcessor()
    let filterNames = ["Brightness", "Contrast", "Grayscale", "Red", "Green"]
    var originalImage = UIImage(named: "scenery")!
    
    var currentImage: UIImage! = UIImage(named: "scenery")! {
        didSet{
            
            DispatchQueue.main.async {
                self.changeImage(newImage: self.currentImage)            }
            
            
        }
    }
    var filters = [Filter]()
    var filterVolume = 0.0
    var selectedFilter = "None" {
        didSet{
            if selectedFilter != "None"{
                filterVolume = 2.0
                compareButton.isEnabled = true
                editButton.isEnabled = true
                originalLabel.isEnabled = true
            } else {
                compareButton.isEnabled = false
                editButton.isEnabled = false
                originalLabel.isEnabled = false
            }
        }
    }
    var myFractionCompleted: Float = 0 {
        didSet{
            DispatchQueue.main.async {
                self.progressView.setProgress(self.myFractionCompleted, animated: true)
            }
        }
        
    }
    
    static var gallery = [Photo]()
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var pastImageView: UIImageView!
    @IBOutlet var filtersMenu: UIView!
    @IBOutlet var editMenu: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var editActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var originalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gestureRecofnizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        gestureRecofnizer.minimumPressDuration = 0.01
        gestureRecofnizer.allowableMovement = CGFloat(600)
        mainImageView.addGestureRecognizer(gestureRecofnizer)
        
        mainImageView.image = originalImage
        
        
        
        filterNames.forEach { name in
            filters.append(Filter(label: name, image: processor.applyFilter(image: originalImage, volume: 2, filter: name)))
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.indentifier)
        
        filtersMenu.translatesAutoresizingMaskIntoConstraints = false
        editMenu.translatesAutoresizingMaskIntoConstraints = false
        compareButton.isEnabled = false
        editButton.isEnabled = false
        editActivityIndicator.isHidden = true
        originalLabel.isEnabled = false
        self.originalLabel.alpha = 0
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func changeImage(newImage: UIImage){
        
        self.mainImageView.alpha = 0
        self.pastImageView.alpha = 1
        pastImageView.image = mainImageView.image
        mainImageView.image = newImage
        
        
        UIView.animate(withDuration: 0.4) {
            self.mainImageView.alpha = 1
            self.pastImageView.alpha = 0
        }
        
    }
    
    
    @objc func handleTap(sender: UILongPressGestureRecognizer) {
        if (selectedFilter != ""){
            if sender.state == .began{
                changeImage(newImage: originalImage)
                
                UIView.animate(withDuration: 0.4) {
                    self.originalLabel.alpha = 1
                    
                }
            }
            if sender.state == .ended {
                changeImage(newImage: currentImage)
                UIView.animate(withDuration: 0.4){
                    self.originalLabel.alpha = 0
                }
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        
        cell.configure(with: filters[indexPath.row])
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        slider.setValue(2, animated: false)
        
        selectedFilter = filters[indexPath.row].label
        currentImage = filters[indexPath.row].image
    }
    
    @IBAction func onSavetoGallery(_ sender: Any) {
        let currentDate = Date()
        let photo = Photo(context: DataController.context)
        
        photo.date = currentDate
        photo.filter = selectedFilter
        photo.volume = filterVolume
        photo.currentImage = currentImage.pngData()!
        photo.originalImage = originalImage.pngData()!
        
        DataController.saveContext()
        
        ViewController.gallery.append(photo)
        
        print(filterVolume)
        print(currentDate)
        print(selectedFilter)
        
    }
    
    
    @IBAction func onNewPhoto(_ sender: Any) {
        hideFiltersMenu()
        hideEditMenu()
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler:{
            action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler:{
            action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func onFilter(_ sender: UIButton) {
        hideEditMenu()
        if(sender.isSelected){
            hideFiltersMenu()
        }else{
            showFiltersMenu()
        }
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        hideFiltersMenu()
        if(sender.isSelected){
            hideEditMenu()
        }else{
            showEditMenu()
        }
    }
    
    @IBAction func onSlider(_ sender: UISlider) {
        let newFilterIntensity = Double(sender.value)
        filterVolume = newFilterIntensity
        editActivityIndicator.isHidden = false
        dispatchGroup.enter()
        filtersEditQueue.async {
            self.currentImage = self.processor.applyFilter(image: self.originalImage, volume: newFilterIntensity, filter: self.selectedFilter)
            self.dispatchGroup.leave()
        }
        bottomMenu.isUserInteractionEnabled = false
        slider.isEnabled = false
        dispatchGroup.notify(queue: .main) {
            
            self.bottomMenu.isUserInteractionEnabled = true
            self.editActivityIndicator.isHidden = true
            self.slider.isEnabled = true
        }
    }
    
    
    @IBAction func onCompare(_ sender: UIButton) {
        if(sender.isSelected){
            changeImage(newImage: currentImage)
            UIView.animate(withDuration: 0.4){
                self.originalLabel.alpha = 0
            }
            sender.isSelected = false
        } else {
            changeImage(newImage: originalImage)
            UIView.animate(withDuration: 0.4) {
                self.originalLabel.alpha = 1
            }
            sender.isSelected = true
        }
    }
    
    
    @IBAction func onShare(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [mainImageView.image!], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            originalImage = image
            currentImage = image
            updateFilters(image: image)
            selectedFilter = ""
            filterButton.isEnabled = false
            slider.setValue(2, animated: false)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSingleFilter(image: UIImage, filter_aneme: String) {
        dispatchGroup.enter()
        filtersUpdateQueue.async {
            self.filters.append(Filter(label: filter_aneme, image: self.processor.applyFilter(image: image, volume: 2, filter: filter_aneme)))
            
            self.myProgress.completedUnitCount += 1
            self.myFractionCompleted = Float(self.myProgress.fractionCompleted)
            self.dispatchGroup.leave()
        }
    }
    
    
    func updateFilters(image: UIImage) {
        showLoadingView()
        self.myProgress.completedUnitCount = 0
        self.progressView.setProgress(0.05, animated: false)
        filters.removeAll()
        self.collectionView.reloadData()
        filterNames.forEach { name in
            updateSingleFilter(image: image, filter_aneme: name)
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
            self.filterButton.isEnabled = true
            self.hideLoadingView()
        }
    }
    
    func showFiltersMenu() {
        filterButton.isSelected = true
        view.addSubview(filtersMenu)
        
        let bottomConstraint = filtersMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = filtersMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = filtersMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = filtersMenu.heightAnchor.constraint(equalToConstant: 105)
        NSLayoutConstraint.activate([bottomConstraint,leftConstraint,rightConstraint,heightConstraint])
        view.layoutIfNeeded()
        
        self.filtersMenu.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.filtersMenu.alpha = 1
        }
    }
    
    func hideFiltersMenu(){
        filterButton.isSelected = false
        UIView.animate(withDuration: 0.4, animations: {
            self.filtersMenu.alpha = 0
        }){ complerted in
            if complerted == true {
                self.filtersMenu.removeFromSuperview()
            }
        }
    }
    
    
    func showEditMenu() {
        editButton.isSelected = true
        view.addSubview(editMenu)
        
        let bottomConstraint = editMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = editMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = editMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = editMenu.heightAnchor.constraint(equalToConstant: 80)
        NSLayoutConstraint.activate([bottomConstraint,leftConstraint,rightConstraint,heightConstraint])
        view.layoutIfNeeded()
        
        self.editMenu.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.editMenu.alpha = 1
        }
    }
    
    func hideEditMenu() {
        editButton.isSelected = false
        UIView.animate(withDuration: 0.4, animations: {
            self.editMenu.alpha = 0
        }){ complerted in
            if complerted == true{
                self.editMenu.removeFromSuperview()
            }
        }
    }
    
    
    
    func showLoadingView() {
        view.addSubview(loadingView)
        
        let widthConstraint = loadingView.widthAnchor.constraint(equalToConstant: 182)
        let heightConstraint = loadingView.heightAnchor.constraint(equalToConstant: 100)
        let xConstraint = loadingView.centerXAnchor.constraint(equalTo: self.mainImageView.centerXAnchor)
        let yConstraint = loadingView.centerYAnchor.constraint(equalTo: self.mainImageView.centerYAnchor)
        NSLayoutConstraint.activate([widthConstraint,heightConstraint,xConstraint,yConstraint])
        view.layoutIfNeeded()
        
        self.loadingView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.loadingView.alpha = 0.7
        }
    }
    
    func hideLoadingView(){
        UIView.animate(withDuration: 0.4, animations: {
            self.loadingView.alpha = 0
        }){ complerted in
            if complerted == true{
                self.loadingView.removeFromSuperview()
            }
        }
        
        
    }
    
    
    
}
