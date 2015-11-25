//
//  APIViewController.m
//  APIManager
//
//  Created by RayRayDer on 2015/11/25.
//  Copyright © 2015年 rayer. All rights reserved.
//

#import "APIViewController.h"

@interface APIViewController ()

@end

@implementation APIViewController

@synthesize req_button,web_button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    req_button.backgroundColor = [UIColor blueColor];
    req_button.layer.borderWidth = 1.0f;
    req_button.layer.borderColor = [UIColor blackColor].CGColor;
    req_button.layer.masksToBounds = YES;
    req_button.layer.cornerRadius = 5.0f;
    
    web_button.backgroundColor = [UIColor blueColor];
    web_button.layer.borderWidth = 1.0f;
    web_button.layer.borderColor = [UIColor blackColor].CGColor;
    web_button.layer.masksToBounds = YES;
    web_button.layer.cornerRadius = 5.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SendHttpRequest
{
    NSLog(@"Send request");
//    NSURL *URL = [NSURL URLWithString:@"http://$SERVER_URL/songlist"];
    NSURL *URL = [NSURL URLWithString:@"http://rest-service.guides.spring.io/greeting"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 5;
    
    [queue addOperationWithBlock:^{
        NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                      dataTaskWithRequest:request
                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          if (error) {
                                              // handle error
                                              return;
                                          }
                                          
                                          if (data.length > 0 && error == nil)
                                          {
                                              // parse data
                                              NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:0
                                                                                                           error:NULL];
                                              if (!dictionary) {
                                                  return;
                                              }
                                              else {
                                                  //NSLog(@"%@",dictionary);
                                                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                      [self parseUserInformation:dictionary];
                                                  }];
                                              }
                                          }
                                      }];
        
        [task resume];
    }];
}

- (IBAction)refreshBannerView
{
    NSURL *url = [NSURL URLWithString:@"http://kkbox.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [bannerView loadRequest:request];
}

#pragma mark - JSON Parser

- (void)parseUserInformation:(NSDictionary *)info
{
    if (info.count) {
        self.greetingId.text = [NSString stringWithFormat:@"[ %@ ]",[[info objectForKey:@"id"] stringValue]];
        self.greetingContent.text = [[NSString stringWithFormat:@"[ %@ ]",[info objectForKey:@"content"]] copy];
    }
}

@end
