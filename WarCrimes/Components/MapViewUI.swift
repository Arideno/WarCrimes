//
//  MapViewUI.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import Foundation
import SwiftUI
import MapKit

struct MapViewUI: UIViewRepresentable {

    let region: MKCoordinateRegion
    let mapViewType: MKMapType
    let annotations: [EventAnnotation]
    let eventIdColors: [String: Color]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: false)
        mapView.isRotateEnabled = false
        mapView.mapType = mapViewType
        mapView.addAnnotations(annotations)
        mapView.delegate = context.coordinator
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Event")
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Cluster")
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        context.coordinator.eventIdColors = eventIdColors

        if context.coordinator.initialRegion != region {
            mapView.setRegion(region, animated: true)
            context.coordinator.initialRegion = region
        }

        if mapView.mapType != mapViewType {
            mapView.mapType = mapViewType
        }

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }

    func makeCoordinator() -> Coordinator {
        .init(initialRegion: region, eventIdColors: eventIdColors)
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        var initialRegion: MKCoordinateRegion
        var eventIdColors: [String: Color]

        init(initialRegion: MKCoordinateRegion, eventIdColors: [String: Color]) {
            self.initialRegion = initialRegion
            self.eventIdColors = eventIdColors
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            switch annotation {
            case let clusterAnnotation as MKClusterAnnotation:
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Cluster", for: clusterAnnotation) as! MKMarkerAnnotationView
                var mostPopularTypes = [String: Int]()
                for annotation in clusterAnnotation.memberAnnotations {
                    guard let annotation = annotation as? EventAnnotation else { continue }
                    for eventId in annotation.event.eventIds {
                        if mostPopularTypes[eventId] != nil {
                            mostPopularTypes[eventId]! += 1
                        } else {
                            mostPopularTypes[eventId] = 1
                        }
                    }
                }
                if let mostPopularEventId = mostPopularTypes.max(by: { $0.value < $1.value })?.key {
                    annotationView.markerTintColor = UIColor(eventIdColors[mostPopularEventId] ?? .blue)
                } else {
                    annotationView.markerTintColor = .blue
                }
                annotationView.titleVisibility = .hidden
                return annotationView
            case let eventAnnotation as EventAnnotation:
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Event", for: eventAnnotation) as! MKMarkerAnnotationView
                annotationView.clusteringIdentifier = "Cluster"
                if let eventId = eventAnnotation.event.eventIds.first {
                    annotationView.markerTintColor = UIColor(eventIdColors[eventId] ?? .blue)
                } else {
                    annotationView.markerTintColor = UIColor.blue
                }
                annotationView.subtitleVisibility = .visible
                annotationView.canShowCallout = true
                annotationView.detailCalloutAccessoryView = UIHostingController(rootView: AnnotationCalloutView(event: eventAnnotation.event)).view
                return annotationView
            default: return nil
            }
        }
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center && lhs.span == rhs.span
    }
}
extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}
extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
