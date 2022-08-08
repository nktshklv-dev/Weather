//
//  ViewController.swift
//  Weather-V1
//
//  Created by Nikita  on 8/8/22.
//
import CoreLocation
import UIKit

class ViewController: UIViewController{

    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
    }
    
    func startLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateView(){
        
    }
    func updateWeatherInfo(latitude: Double, longitude: Double){
        let session = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longitude.description)&appid=c2249643fbc743dff414b110230958ed&query=&operationName=&variables=")
        let task = session.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print("DataTask error: \(error?.localizedDescription ?? "Error")")
                return
            }
            do{
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                    self.updateView()
                }
                print(self.weatherData)
            } catch{
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    
    


}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last{
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        }
    }
}

