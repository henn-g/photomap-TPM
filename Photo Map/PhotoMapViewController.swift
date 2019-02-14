//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {

    // General instance variables
    var chosenPicture: UIImage?
    
    // Public Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // Public Actions
    @IBAction func takePictureButton(_ sender: Any) {
        takePicture()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
    }

    
    /* Delegate Methods for imagepicker to implement */
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        _ = info[UIImagePickerControllerOriginalImage] as! UIImage
        _ = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.chosenPicture = image
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: {
            print("DOING SEGUE NOW")
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        })
    }
    
    
    
    
    /* Private Helper Methods */
    private func initMapView() {
        let cityCoord = CLLocationCoordinate2DMake(37.783333, -122.416667)
        let coordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let sfRegion = MKCoordinateRegionMake(cityCoord, coordinateSpan)
        mapView.setRegion(sfRegion, animated: false)
    }
    
    private func takePicture() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    /* END Helpers */
    
    /* Perare for segue and picture location tagging */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tagSegue" {
            let destinationVC = segue.destination as! LocationsViewController
            destinationVC.delegate = self
        }
    }
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        print("locationPickedLocation() called!")
        
        let locationCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees.init(latitude), CLLocationDegrees.init(longitude))
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "Picture!"
        mapView.addAnnotation(annotation)
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        print("mapView protocol called!")
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if (annotationView == nil){
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
            annotationView?.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
        }
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        
        imageView.image = UIImage(named: "Camera")
        
        return annotationView
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
