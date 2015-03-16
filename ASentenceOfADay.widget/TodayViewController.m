//
//  TodayViewController.m
//  ASentenceOfADay.widget
//
//  Created by Chen Hsin Hsuan on 2015/3/4.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TFHpple.h"
@interface TodayViewController () <NCWidgetProviding>{
    NSString *sentenceEN;//英文句子
    NSString *imageURL;//圖檔路徑
}
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *englishSentenceLabel;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self callWeb];
    
    self.englishSentenceLabel.text = sentenceEN;
    
    NSURL *url = [NSURL URLWithString:imageURL];
    //Asynchronous
    self.authorImage.image = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        UIImage *urlImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.authorImage.image = urlImage;
            [self.authorImage setNeedsLayout];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

-(void) callWeb
{
    NSString *htmlString=[NSString stringWithContentsOfURL:[NSURL URLWithString: @"http://www.managertoday.com.tw/quotes/"] encoding: NSUTF8StringEncoding error:nil];
    NSData *htmlData=[htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [doc searchWithXPathQuery:@"//div[@class='quote-mainBlock']"];
    TFHppleElement *element = [elements objectAtIndex:0];
    
    imageURL = [[[element searchWithXPathQuery:@"//div[@class='quote-imgBorder']/img"] objectAtIndex:0] objectForKey:@"src"];
    
    if ([element searchWithXPathQuery:@"//p[@class='sentence-eng']"].count > 0 ) {
        sentenceEN = [[[element searchWithXPathQuery:@"//p[@class='sentence-eng']"] objectAtIndex:0] content];
    }else{
        sentenceEN = @"本日僅提供中文,請點下方按鈕!";
    }
}


- (IBAction)goAPPButtonPressed:(id)sender {
    //寫入userdefault
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aircon.ASentenceOfADay"];
    [sharedDefaults setBool:YES forKey:@"fromTodayExtention"];
    [sharedDefaults synchronize];
    NSURL *customURL = [NSURL URLWithString:@"ASentenceOfADay://"];
    [self.extensionContext openURL:customURL completionHandler:nil];
}



@end
