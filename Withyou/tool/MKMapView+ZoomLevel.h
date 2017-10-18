//
//  MKMapView+ZoomLevel.h
//  Withyou
//
//  Created by Tong Lu on 8/10/14.
//  Copyright (c) 2014 Withyou Inc. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
