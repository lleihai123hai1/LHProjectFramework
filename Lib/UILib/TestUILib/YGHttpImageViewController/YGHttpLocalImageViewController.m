//
//  YGHttpLocalImageViewController.m
//  LhProjectFramework
//
//  Created by 雷海 on 2019/4/12.
//  Copyright © 2019 LH. All rights reserved.
//

#import "YGHttpLocalImageViewController.h"
#import "YYImage.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WebP.h"
#import "UIImage+MultiFormat.h"
#import "SDImageCache.h"
@interface YGHttpLocalImageViewController (){
}
@property(nonatomic,assign)CGFloat ygStartTime;
@property(nonatomic,assign)CGFloat ygEndTime;
@end

@implementation YGHttpLocalImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self addHttpOldImage];
//    [self addHttpTailorJpegImage];
    [self addHttpTailorWebpImage];
}

-(void)addHttpOldImage{
    NSInteger imageViewCount = 10;
    CGFloat width = self.view.width/2;
    CGFloat height = 2*self.view.height/imageViewCount;
    NSMutableArray*url = [NSMutableArray new];
    for (NSInteger i = 1; i <= imageViewCount; i++) {
        [url addObject: [NSString stringWithFormat:@"old%ld",(long)i]];
    }
    self.ygStartTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0 ; i < url.count; i++) {
        UIImageView* uiImageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%2)*width, i/2*height, width, height)];
        uiImageView.contentMode = UIViewContentModeScaleAspectFit;
        uiImageView.layer.borderWidth = 2;
        uiImageView.layer.borderColor = [UIColor blackColor].CGColor;
        NSString *SuperBgImgPath = [[NSBundle mainBundle] pathForResource:url[i] ofType:@"jpeg"];
        NSData *data  = [NSData dataWithContentsOfFile: SuperBgImgPath];
        uiImageView.image = [UIImage sd_imageWithData:data];
        [self.view addSubview:uiImageView];
    }
    self.ygEndTime = CFAbsoluteTimeGetCurrent();
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
    }];
    NSLog(@"原图，客户端的载入时间: %f", self.ygEndTime - self.ygStartTime);
    
}

-(void)addHttpTailorJpegImage{
    NSInteger imageViewCount = 10;
    CGFloat width = self.view.width/2;
    CGFloat height = 2*self.view.height/imageViewCount;
    NSMutableArray*url = [NSMutableArray new];
    for (NSInteger i = 1; i <= imageViewCount; i++) {
         [url addObject: [NSString stringWithFormat:@"a%ld",(long)i]];
    }
    self.ygStartTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0 ; i < url.count; i++) {
        UIImageView* uiImageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%2)*width, i/2*height, width, height)];
        uiImageView.contentMode = UIViewContentModeScaleAspectFit;
        uiImageView.layer.borderWidth = 2;
        uiImageView.layer.borderColor = [UIColor blackColor].CGColor;
        NSString *SuperBgImgPath = [[NSBundle mainBundle] pathForResource:url[i] ofType:@"jpeg"];
        NSData *data  = [NSData dataWithContentsOfFile: SuperBgImgPath];
        uiImageView.image = [UIImage sd_imageWithData:data];
        [self.view addSubview:uiImageView];
    }
    self.ygEndTime = CFAbsoluteTimeGetCurrent();
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
    }];
    NSLog(@"裁剪后，以jpeg返回，客户端的载入时间: %f", self.ygEndTime - self.ygStartTime);
    
}


-(void)addHttpTailorWebpImage{
    NSInteger imageViewCount = 10;
    CGFloat width = self.view.width/2;
    CGFloat height = 2*self.view.height/imageViewCount;
    NSMutableArray*url = [NSMutableArray new];
    for (NSInteger i = 1; i <= imageViewCount; i++) {
        [url addObject: [NSString stringWithFormat:@"a%ld",(long)i]];
    }
    self.ygStartTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0 ; i < url.count; i++) {
        UIImageView* uiImageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%2)*width, i/2*height, width, height)];
        uiImageView.contentMode = UIViewContentModeScaleAspectFit;
        uiImageView.layer.borderWidth = 2;
        uiImageView.layer.borderColor = [UIColor blackColor].CGColor;
        NSString *SuperBgImgPath = [[NSBundle mainBundle] pathForResource:url[i] ofType:@"webp"];
        NSData *data  = [NSData dataWithContentsOfFile: SuperBgImgPath];
        uiImageView.image = [UIImage sd_imageWithWebPData:data];
        [self.view addSubview:uiImageView];
    }
    self.ygEndTime = CFAbsoluteTimeGetCurrent();
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
    }];
    NSLog(@"裁剪后，以webp返回，客户端的载入时间: %f", self.ygEndTime - self.ygStartTime);
}

@end
