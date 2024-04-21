//
//  MapView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/21/24.
//
import MapKit
import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var endLocation: CLLocationCoordinate2D?
    @Published var eta: String = ""
    @Published var distance: String = ""
    @Published var onRoute: Bool = true
    @Published var currentRoute: MKRoute?

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location.coordinate
        checkUserIsOnRoute(location: location)
        if let userLocation = self.userLocation, let endLocation = self.endLocation {
            calculateRouteDetails(from: userLocation, to: endLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }

    func calculateRouteDetails(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        let startPlacemark = MKPlacemark(coordinate: start)
        let endPlacemark = MKPlacemark(coordinate: end)
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: startPlacemark)
        directionRequest.destination = MKMapItem(placemark: endPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (response, error) in
            guard let strongSelf = self, let route = response?.routes.first else { return }
            strongSelf.currentRoute = route
            strongSelf.eta = "ETA: \(Int(route.expectedTravelTime / 60)) min"
            strongSelf.distance = "Distance: \(Int(route.distance / 1000)) km"
            strongSelf.onRoute = true  // Reset to true whenever a new route is calculated
        }
    }

    func checkUserIsOnRoute(location: CLLocation) {
        guard let polyline = currentRoute?.polyline else {
            onRoute = false
            return
        }

        let userPoint = MKMapPoint(location.coordinate)
        var minimumDistance = Double.greatestFiniteMagnitude

        for i in 0..<(polyline.pointCount - 1) {
            let currentPoint = polyline.points()[i]
            let nextPoint = polyline.points()[i + 1]
            let segment = (currentPoint, nextPoint)
            
            let distance = distanceFromPoint(point: userPoint, segmentStart: segment.0, segmentEnd: segment.1)
            if distance < minimumDistance {
                minimumDistance = distance
            }
        }

        DispatchQueue.main.async {
            self.onRoute = minimumDistance < 2  // 50 meters tolerance
        }
    }

    func distanceFromPoint(point: MKMapPoint, segmentStart: MKMapPoint, segmentEnd: MKMapPoint) -> Double {
        let dx = segmentEnd.x - segmentStart.x
        let dy = segmentEnd.y - segmentStart.y
        let magnitudeSquared = dx*dx + dy*dy
        var t = ((point.x - segmentStart.x) * dx + (point.y - segmentStart.y) * dy) / magnitudeSquared
        t = max(0, min(1, t))
        let nearestPoint = MKMapPoint(x: segmentStart.x + t * dx, y: segmentStart.y + t * dy)
        return point.distance(to: nearestPoint)
    }
}
struct MapyView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var address: String = ""
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 235/255, blue: 235/255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                MapView(userLocation: locationManager.userLocation, endLocation: locationManager.endLocation, route: locationManager.currentRoute)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 500)
                
                TextField("Enter End Address", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Set End Location") {
                    let geocoder = CLGeocoder()
                    geocoder.geocodeAddressString(address) { (placemarks, error) in
                        guard let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate else { return }
                        locationManager.endLocation = coordinate
                        if let userLocation = locationManager.userLocation {
                            locationManager.calculateRouteDetails(from: userLocation, to: coordinate)
                        }
                    }
                }.padding()
                
                Text(locationManager.eta)
                    .padding(7)
                Text(locationManager.distance)
                    .padding(7)
                
                Text(locationManager.onRoute ? "On Route" : "Off Route")
                    .foregroundColor(locationManager.onRoute ? .green : .red)
                    .padding()
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    var userLocation: CLLocationCoordinate2D?
    var endLocation: CLLocationCoordinate2D?
    var route: MKRoute?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateMap(uiView)
    }

    func updateMap(_ mapView: MKMapView) {
        guard let route = route else { return }

        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(route.polyline)
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        
        if let userLocation = userLocation, let endLocation = endLocation {
            let annotations = mapView.annotations.filter { $0 !== mapView.userLocation }
            mapView.removeAnnotations(annotations)
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.coordinate = endLocation
            mapView.addAnnotation(destinationAnnotation)

            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (userLocation.latitude + endLocation.latitude) / 2, longitude: (userLocation.longitude + endLocation.longitude) / 2), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            mapView.setRegion(region, animated: true)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapyView()
    }
}
