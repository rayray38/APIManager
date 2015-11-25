//
//  APIViewController.h
//  APIManager
//
//  Created by RayRayDer on 2015/11/25.
//  Copyright © 2015年 rayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APIViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView      *bannerView;
}

@property (nonatomic, strong) IBOutlet UILabel *greetingId;
@property (nonatomic, strong) IBOutlet UILabel *greetingContent;
@property (nonatomic, strong) IBOutlet UIButton *req_button;
@property (nonatomic, strong) IBOutlet UIButton *web_button;

- (IBAction)SendHttpRequest;
- (IBAction)refreshBannerView;
- (void)parseUserInformation:(NSDictionary *)info;

@end
