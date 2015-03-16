//
//  MyCollectionView.m
//  ASentenceOfADay
//
//  Created by Chen Hsin Hsuan on 2015/3/5.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import "MyCollectionView.h"
#import "SentenceCollectionViewCell.h"
#import "AirImageView.h"
#import "AppDelegate.h"
@interface MyCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>{
    NSMutableDictionary *myDict;
    NSString *deleteKey;
    NSString *rootPath;
    NSString *plistPath;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MyCollectionView

- (void) viewDidLoad
{
    rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"mySentence.plist"];
    // 從 plist 檔案讀出
    myDict = [NSMutableDictionary dictionaryWithContentsOfFile: plistPath];
}

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (myDict == nil || [[myDict allKeys]count] == 0) {
        return 1;
    }
    return [[myDict allKeys]count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SentenceCollectionViewCell *cell;

    if (cell == nil) {
        if (myDict == nil || myDict.allKeys.count == 0) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoSentenceCell" forIndexPath:indexPath];
        }else{
            NSString * key = [[myDict allKeys] objectAtIndex:indexPath.row];
            NSDictionary *innerDict = [myDict objectForKey: key];
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SentenceCell" forIndexPath:indexPath];
            NSURL *url = [NSURL URLWithString:[innerDict objectForKey:@"authorImageURL"]];
            
            //Asynchronous
            cell.authorImageView.image = nil;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^(void) {
                
                UIImage *urlImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.authorImageView.image = urlImage;
                    [cell setNeedsLayout];
                });
            });
            
            cell.authorLabel.text = [innerDict objectForKey:@"author"];
            cell.sentenceENLabel.text = [innerDict objectForKey:@"sentenceEN"];
            cell.sentenceTWLabel.text = [innerDict objectForKey:@"sentenceTW"];
            
            cell.deleteButton.indexKey = key;
            cell.deleteButton.author = [innerDict objectForKey:@"author"];
            cell.deleteButton.sentenceEN = [innerDict objectForKey:@"sentenceEN"];
            cell.deleteButton.sentenceTW = [innerDict objectForKey:@"sentenceTW"];
        }
    }

    return cell;
}

- (IBAction)deleteButtonPressed:(AirButton *)sender {
    deleteKey = sender.indexKey;
    NSString *message =[NSString stringWithFormat:@"確認刪除%@的管理原則？",sender.author];
    [AppDelegate showConfirmWithMessage:message
                              withTitle:@"刪除資料"
                              deletgate:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [myDict removeObjectForKey:deleteKey];
        // 寫入 plist 檔案
        if ([myDict writeToFile:plistPath atomically:YES]) {
            NSLog(@"成功儲存 dic");
            [AppDelegate showAlertWithMessage:@"資料刪除成功！" withTitle:@"刪除資料"];
            [self.collectionView reloadData];
        }else{
            NSLog(@"寫入 dic  失敗");
        }
    }
    deleteKey = nil;
}



@end
