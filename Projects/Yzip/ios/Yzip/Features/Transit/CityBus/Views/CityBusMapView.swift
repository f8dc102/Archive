//
// CityBusMapView.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI
import MapKit

struct CityBusMapView: View {
    @StateObject private var viewModel = CityBusMapViewModel()
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: Config.defaultMapLocation.latitude,
                longitude: Config.defaultMapLocation.longitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    var body: some View {
        ZStack {
            mapLayer
            inactiveOverlay
        }
        .onAppear {
            viewModel.startPolling()
        }
        .onDisappear {
            viewModel.stopPolling()
        }
    }
    
    @ViewBuilder
    private var mapLayer: some View {
        Map(position: $cameraPosition) {
            ForEach(viewModel.allStops, id: \.nodeid) { stop in
                Annotation(
                    stop.nodeid,
                    coordinate: CLLocationCoordinate2D(latitude: stop.gpslati, longitude: stop.gpslong),
                    anchor: .center
                ) {
                    CityBusStopMarkerComponent(stop: stop)
                }
                .annotationTitles(.hidden)
            }
            
            ForEach(viewModel.allBusList, id: \.vehicleno) { bus in
                Annotation(
                    "\(bus.vehicleno)",
                    coordinate: CLLocationCoordinate2D(
                        latitude: bus.gpslati,
                        longitude: bus.gpslong
                    ),
                    anchor: .bottom
                ) {
                    CityBusLocationAnnotationComponent(
                        bus: bus,
                        direction: viewModel.getDirection(
                            for: bus,
                            stops: viewModel.busStops(for: bus.routenm)
                        ) ?? 0
                    )
                }
                .annotationTitles(.hidden)
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
    }
    
    @ViewBuilder
    private var inactiveOverlay: some View {
        if viewModel.allRouteInfos.allSatisfy({ viewModel.isInactiveMap[$0.routeName] == true }) {
            VStack {
                Text("transit.citybus.map.no_active_bus".localized())
                    .font(.subheadline)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CityBusMapView()
}
