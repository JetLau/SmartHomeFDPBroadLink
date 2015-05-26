//
//  GeocodeDemoViewController.h
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface GeocodeDemoViewController : UIViewController<BMKMapViewDelegate, BMKGeoCodeSearchDelegate> {
	IBOutlet BMKMapView* _mapView;

    IBOutlet UITextField *_searchDate;
	BMKGeoCodeSearch* _geocodesearch;
}
-(IBAction)onClickSearch:(id)sender;
- (IBAction)textFiledReturnEditing:(id)sender;
@end
