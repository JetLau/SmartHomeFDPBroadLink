//
//  HomeViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "HomeViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "CustomCollectionViewCell.h"
#import "RMDeviceManager.h"
#import "TCPDeviceManager.h"
#import "DeviceViewController.h"
#import "AirConditionViewController.h"
#import "TVViewController.h"
#import "CurtainViewController.h"
#import "ProjectorViewController.h"
#import "LightViewController.h"
#import "CustomRemoteViewController.h"
#import "TCPDeviceViewController.h"
#import "TCPDevice.h"
#import "SceneViewCollectionViewCell.h"
#import "ScenePlistManager.h"
#import "AddSceneViewController.h"
#import "MJExtension.h"
#import "RMButton.h"
#import "ProgressHUD.h"
#import "BLNetwork.h"

#define homeViewQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface HomeViewController ()


@property (nonatomic, strong) BLNetwork *network;

@end




@implementation HomeViewController
@synthesize rmDeviceManager;
@synthesize tcpDeviceManager;
@synthesize rmDeviceArray;
@synthesize tcpDeviceArray;
@synthesize scenePlistmanager;
@synthesize sceneArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _network = [[BLNetwork alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"customCollectionViewCell"];
    [self.sceneView registerClass:[SceneViewCollectionViewCell class] forCellWithReuseIdentifier:@"SceneViewCollectionViewCell"];
    
    [self.navigationItem setTitle:@"首页"];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    /*Add button*/
    UIBarButtonItem *addSceneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSceneItemClicked)];
                                     
    [self.navigationItem setRightBarButtonItem:addSceneItem];
                                     

    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editScene:) name:@"EditSceneNotification" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    rmDeviceManager=[RMDeviceManager createRMDeviceManager];
    tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
    scenePlistmanager = [ScenePlistManager createScenePlistManager];
    rmDeviceArray=rmDeviceManager.RMDeviceArray;
    tcpDeviceArray=tcpDeviceManager.TCPDeviceArray;
    sceneArray = scenePlistmanager.SceneArray;
//    NSLog(@"sceneArray=%@",sceneArray);
    //sceneArray = [[NSArray alloc] initWithObjects:@"11",@"11",@"11",@"11",@"11",@"11",@"11",@"11", nil];
    [self.collectionView reloadData];
    [self.sceneView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.sceneView]) {
        return [sceneArray count];
    }else{
        return [rmDeviceArray count]+[tcpDeviceArray count];

    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView isEqual:self.sceneView]) {
        return 1;
    }else{
        return 1;
        
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.sceneView]) {
        SceneViewCollectionViewCell *cell;
        
        cell= (SceneViewCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SceneViewCollectionViewCell" forIndexPath:indexPath];
        
        if(!cell)
        {
            cell=[[SceneViewCollectionViewCell alloc]init];
        }
        
        int index=indexPath.row;
        //NSString *picName;
        NSString *name;
        
        if(index<[sceneArray count]) //RMDevice
        {
            NSDictionary *rmDic=[sceneArray objectAtIndex:index];
            name=[rmDic objectForKey:@"name"];
        }
        
        cell.imageView.image=[UIImage imageNamed:@"defaultScenePic.jpg"];
        cell.label.text = name;
        cell.collectionViewId = index;
        return cell;
    }else if([collectionView isEqual:self.collectionView]){
        CustomCollectionViewCell *cell;
        
        cell= (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"customCollectionViewCell" forIndexPath:indexPath];
        
        if(!cell)
        {
            cell=[[CustomCollectionViewCell alloc]init];
        }
        
        int index=indexPath.row;
        NSString *type;
        NSString *name;
        
        if(index<[rmDeviceArray count]) //RMDevice
        {
            NSDictionary *rmDic=[rmDeviceArray objectAtIndex:index];
            type=[rmDic objectForKey:@"type"];
            name=[rmDic objectForKey:@"name"];
        }
        else//TCPDevice
        {
            int tcpIndex=index-[rmDeviceArray count];
            NSDictionary *rmDic=[tcpDeviceArray objectAtIndex:tcpIndex];
            type=[rmDic objectForKey:@"type"];
            name=[rmDic objectForKey:@"name"];
        }
        //NSLog(@"type = %@",type);
        cell.imageView.image=[UIImage imageNamed:[type lowercaseString]];
        cell.label.text=name;
        
        return cell;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index=indexPath.row;
    if ([collectionView isEqual:self.sceneView]) {
        NSArray *btnArray = [[sceneArray objectAtIndex:index] objectForKey:@"buttonArray"];
        int btnCount = [btnArray count];
        int failnum = 0;
        if (btnCount == 0) {
            [ProgressHUD showError:@"此场景未添加控制命令"];
        }else{
            for (int i = 0; i < btnCount; i++) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[NSNumber numberWithInt:134] forKey:@"api_id"];
                [dic setObject:@"rm2_send" forKey:@"command"];
                [dic setObject:[[btnArray objectAtIndex:i] objectForKey:@"btnMac"] forKey:@"mac"];
                [dic setObject:[[btnArray objectAtIndex:i] objectForKey:@"sendData"] forKey:@"data"];
                NSData *requestData = [dic JSONData];
                NSData *responseData = [_network requestDispatch:requestData];
//                NSLog(@"%@",[responseData objectFromJSONData]);
                if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] != 0)
                {
                    failnum++;
                }
                [NSThread sleepForTimeInterval:0.5];
               
            }
            [ProgressHUD showSuccess:[NSString stringWithFormat:@"发送成功%d/%d个",btnCount-failnum,btnCount]];

        }
        

        //NSLog(@"sceneView index %d,failnum = %d",indexPath.row,failnum);
    }else if([collectionView isEqual:self.collectionView]){
        if(index<[rmDeviceArray count])//RMDevice
        {
            DeviceViewController *deviceViewController;
            NSDictionary *rmDic=[rmDeviceArray objectAtIndex:index];
            NSString *type=[rmDic objectForKey:@"type"];
            NSString *mac=[rmDic objectForKey:@"mac"];
            
            if([type isEqualToString:@"AirCondition"])
            {
                deviceViewController=[[AirConditionViewController alloc]init];
            }
            else if([type isEqualToString:@"TV"])
            {
                deviceViewController=[[TVViewController alloc]init];
            }
            else if([type isEqualToString:@"Curtain"])
            {
                deviceViewController=[[CurtainViewController alloc]init];
            }
            else if([type isEqualToString:@"Projector"])
            {
                deviceViewController=[[ProjectorViewController alloc]init];
            }
            else if([type isEqualToString:@"Light"])
            {
                deviceViewController=[[LightViewController alloc]init];
            }
            else if([type isEqualToString:@"Custom"])
            {
                deviceViewController=[[CustomRemoteViewController alloc]init];
            }
            else
            {
                deviceViewController=[[DeviceViewController alloc]init];
            }
            
            [deviceViewController setRemoteType:type];
            deviceViewController.rmDeviceIndex=index;
            BLDeviceInfo *info=[[BLDeviceInfo alloc]init];
            info.mac=mac;
            [deviceViewController setInfo:info];
            
            [self.navigationController pushViewController:deviceViewController animated:YES];
        }
        else//TCPDevice
        {
            TCPDeviceViewController *tcpDeviceViewController=[[TCPDeviceViewController alloc]init];
            
            int tcpIndex=index-[rmDeviceArray count];
            NSDictionary *tcpDic=[tcpDeviceArray objectAtIndex:tcpIndex];
            
            TCPDevice *device=[[TCPDevice alloc]init];
            [device setTcpDev_id:[tcpDic objectForKey:@"id"]];
            [device setTcpDev_mac:[tcpDic objectForKey:@"mac"]];
            [device setTcpDev_name:[tcpDic objectForKey:@"name"]];
            [device setTcpDev_state:[tcpDic objectForKey:@"state"]];
            [device setTcpDev_type:[tcpDic objectForKey:@"type"]];
            tcpDeviceViewController.deviceInfo=device;
            
            [self.navigationController pushViewController:tcpDeviceViewController animated:YES];
        }
        
    }
    
   }

-(void) addSceneItemClicked{
    AddSceneViewController *addSceneCtrl = [[AddSceneViewController alloc] init];
    addSceneCtrl.style = @"add";
    
    [self.navigationController pushViewController:addSceneCtrl animated:YES];
    
    [self.sceneView reloadData];
}


-(void) editScene:(NSNotification*)notification{
    NSDictionary *dic = [notification userInfo];
//    NSLog(@"%@",dic);
    if([[dic objectForKey:@"mode"] isEqualToString:@"edit"]){
        //修改scene
        AddSceneViewController *addSceneVC = [[AddSceneViewController alloc] init];
        addSceneVC.style = @"edit";
        int sceneNum =[[dic objectForKey:@"collectionViewId"] intValue];
        addSceneVC.sceneNum = sceneNum;
        addSceneVC.sceneName =[[self.sceneArray objectAtIndex:sceneNum] objectForKey:@"name"];
        addSceneVC.sceneVoice = [[self.sceneArray objectAtIndex:sceneNum] objectForKey:@"voice"];
        addSceneVC.sceneBtnArray = [[NSMutableArray alloc] initWithArray:[RMButton objectArrayWithKeyValuesArray:[[self.sceneArray objectAtIndex:sceneNum] objectForKey:@"buttonArray"]]];
        [self.navigationController pushViewController:addSceneVC animated:YES];
//        self.sceneArray = scenePlistmanager.SceneArray;
//        [self.sceneView reloadData];

    }else if([[dic objectForKey:@"mode"] isEqualToString:@"delete"]){
        
        if ([scenePlistmanager deleteOneScene:[[dic objectForKey:@"collectionViewId"] intValue]]) {
            self.sceneArray = scenePlistmanager.SceneArray;
            [self.sceneView reloadData];
        }
    }
}
@end
