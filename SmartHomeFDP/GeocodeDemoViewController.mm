//
//  GeocodeDemoViewController.mm
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import "GeocodeDemoViewController.h"
#import "SmartHomeAPIs.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface GeocodeDemoViewController ()
{
    bool isGeoSearch;
}
@end
@implementation GeocodeDemoViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏tabbar工具条
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    //_geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    [_mapView setZoomLevel:14];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    //_geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    //_geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    //_geocodesearch.delegate = nil; // 不用时，置nil
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
    // [super dealloc];
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //NSLog(@"didAddAnnotationViews");
}
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    return annotationView;
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    //    [_mapView removeAnnotations:array];
    //    array = [NSArray arrayWithArray:_mapView.overlays];
    //    [_mapView removeOverlays:array];
    //NSLog(@"onGetReverseGeoCodeResult%d",[[NSArray arrayWithArray:_mapView.annotations] count]);

    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        //        NSString* titleStr;
        //        NSString* showmeg;
        //        titleStr = @"反向地理编码";
        //        showmeg = [NSString stringWithFormat:@"%@",item.title];
        //
        //        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        //        [myAlertView show];
    }
}



-(IBAction)onClickSearch:(id)sender
{
    [self.view endEditing:YES];
    //删除所有标注
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
   // array = [NSArray arrayWithArray:_mapView.overlays];
    //[_mapView removeOverlays:array];
    
    if (_searchDate.text != nil) {
        dispatch_async(kBgQueue, ^{
            NSDictionary *oneDayGPSData = [SmartHomeAPIs GetOneDayGPSData:_searchDate.text];
            if ([[oneDayGPSData objectForKey:@"result"] isEqualToString:@"fail"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"获取gps数据失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                });
                return;
            } else {
                
                NSArray *gpsDataList = [oneDayGPSData objectForKey:@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    int len = [gpsDataList count];
                    if (len == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"当日数据为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alertView show];
                        });
                        return;
                    }
                    for (int i=0; i<len; i++) {
                        isGeoSearch = false;
                        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
                        _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
                        NSDictionary *dic = [gpsDataList objectAtIndex:i];
                        NSString *lon = [dic objectForKey:@"longitude"];
                        NSString *lat = [dic objectForKey:@"latitude"];
                        
                        double longitude = [[lon substringWithRange:NSMakeRange(0, 3)] doubleValue] + [[lon substringFromIndex:3] doubleValue]/60;
                        double latitude = [[lat substringWithRange:NSMakeRange(0, 2)] doubleValue] + [[lat substringFromIndex:2] doubleValue]/60;
                        
                        [self reverseGeocode:latitude andLongtitude:longitude];
                        _geocodesearch = nil;
                        _geocodesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
                    }
                });

            }
        });
    }
    
    
}

-(void)reverseGeocode:(double)lat andLongtitude:(double)lon
{
    isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){lat, lon};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        //NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
