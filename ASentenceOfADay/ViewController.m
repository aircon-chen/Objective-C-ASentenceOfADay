//
//  ViewController.m
//  ASentenceOfADay
//
//  Created by Chen Hsin Hsuan on 2015/3/3.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
#import "AirButton.h"
#import "AppDelegate.h"
@interface ViewController (){

    NSString *sentenceTW;//中文句子
    NSString *sentenceEN;//英文句子
    NSString *author;//作者
    NSString *imageURL;//圖檔路徑
    NSMutableDictionary *mySentenceDict;
    NSString *plistPath;
}
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *authorIntroLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishSentenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseSentenceLabel;
@property (weak, nonatomic) IBOutlet AirButton *favorButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.favorButton setHidden:YES];
    
    if([AppDelegate isConnectInternet]){
        
        [self callWebSwitch];
        [self checkMySentenceDict];
        
        self.authorIntroLabel.text = author;
        if (sentenceEN.length > 0) {
            self.englishSentenceLabel.text = [NSString stringWithFormat:@"\"%@\"", sentenceEN];
        }else{
            self.englishSentenceLabel.hidden = NO;
            self.englishSentenceLabel.hidden = YES;
        }
        
        if (sentenceTW.length > 0) {
            self.chineseSentenceLabel.text = sentenceTW;
            self.chineseSentenceLabel.hidden = NO;
        }else{
            self.chineseSentenceLabel.hidden = YES;
        }
        
        NSURL *url = [NSURL URLWithString:imageURL];
        //Asynchronous
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^(void) {
            
            UIImage *urlImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.authorImage.image = urlImage;
                [self.authorImage setNeedsLayout];
            });
        });
        
        //Admob
        self.aGADBannerView.adUnitID = @"ca-app-pub-5200673733349176/1456677640";
        self.aGADBannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
//        request.testDevices = @[@"ffd5b4c17425a518e4f9c99b1738ae16"];
        [self.aGADBannerView loadRequest:request];
    }else{
        //網路不通
        [AppDelegate showAlertWithMessage:@"網路服務異常！" withTitle:@"服務異常"];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}



- (IBAction)favorButtonPressed:(id)sender {
    NSDictionary *innerDataDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                   author,@"author",
                                   imageURL,@"authorImageURL",
                                   sentenceEN,@"sentenceEN",
                                   sentenceTW,@"sentenceTW",
                                   nil];
    
    
    NSString *key =[NSString stringWithFormat:@"%@#%@", author, sentenceEN];
    if ([[mySentenceDict allKeys]count] > 0) {
        [mySentenceDict setObject:innerDataDict forKey:key];
    }else{
        mySentenceDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:innerDataDict, key,nil];
    }
    
    // 寫入 plist 檔案
    if ([mySentenceDict writeToFile:plistPath atomically:YES]) {
        NSLog(@"成功寫入 dic");
        [AppDelegate showAlertWithMessage:@"管理原則新增成功！" withTitle:@"新增管理原則"];
        self.favorButton.hidden = YES;
    }else{
        NSLog(@"寫入 dic  失敗");
    }

}


- (void) checkMySentenceDict
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"mySentence.plist"];
    mySentenceDict = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
 
    NSString *key =[NSString stringWithFormat:@"%@#%@", author, sentenceEN];
    
    if (mySentenceDict != nil && [mySentenceDict objectForKey:key] !=nil) {
        self.favorButton.hidden = YES;
    }else{
        self.favorButton.hidden = NO;
    }
    
}

#pragma mark -
#pragma mark Segue
- (IBAction)backToMain:(UIStoryboardSegue *)unwindSegue
{
    [self viewDidLoad];
}


-(void)callWebSwitch
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    int dDate = [strDate intValue];
    if (dDate % 2 > 0) {
        [self callWeb1];
    }else{
        [self callWeb2];
    }
}


-(void) callWeb1
{
    NSString *htmlString=[NSString stringWithContentsOfURL:[NSURL URLWithString: @"http://www.managertoday.com.tw/quotes/"] encoding: NSUTF8StringEncoding error:nil];
    NSData *htmlData=[htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [doc searchWithXPathQuery:@"//div[@class='quote-mainBlock']"];
    TFHppleElement *element = [elements objectAtIndex:0];
    
    imageURL = [[[element searchWithXPathQuery:@"//div[@class='quote-imgBorder']/img"] objectAtIndex:0] objectForKey:@"src"];
    NSArray *authorNSArray = [element searchWithXPathQuery:@"//ul[@class='caption-list']/li"];
    for (TFHppleElement *element in authorNSArray) {
        if (author == nil) {
            author = [[NSString alloc] initWithString:[element content]];
        }else{
            author = [NSString stringWithFormat:@"%@\n%@", author,[element content]];
        }
    }
    
    if ([element searchWithXPathQuery:@"//p[@class='sentence-zh_tw']"].count > 0 ) {
        sentenceTW = [[[element searchWithXPathQuery:@"//p[@class='sentence-zh_tw']"] objectAtIndex:0] content];
    }
    if ([element searchWithXPathQuery:@"//p[@class='sentence-eng']"].count > 0 ) {
        sentenceEN = [[[element searchWithXPathQuery:@"//p[@class='sentence-eng']"] objectAtIndex:0] content];
    }
}

-(void) callWeb2
{
    NSString *htmlString=[NSString stringWithContentsOfURL:[NSURL URLWithString: @"http://www.dailyenglishquote.com/"]
                                                  encoding: NSUTF8StringEncoding
                                                     error:nil];
    NSData *htmlData=[htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple * doc  = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [doc searchWithXPathQuery:@"//div[@class='entry']"];
    TFHppleElement *element = [elements objectAtIndex:0];
    imageURL = [[[element searchWithXPathQuery:@"//a/img"] objectAtIndex:0] objectForKey:@"src"];
    
    if ([element searchWithXPathQuery:@"//div"].count > 0 ) {
        author = [[[element searchWithXPathQuery:@"//div"] objectAtIndex:2] content];
    }
    if ([element searchWithXPathQuery:@"//p/strong"].count > 0 ) {
        sentenceEN = [[[element searchWithXPathQuery:@"//p/strong"] objectAtIndex:0] content];
    }
    if ([element searchWithXPathQuery:@"//p"].count > 0 ) {
        sentenceTW = [[[element searchWithXPathQuery:@"//p"] objectAtIndex:3] content];
    }
}




@end
