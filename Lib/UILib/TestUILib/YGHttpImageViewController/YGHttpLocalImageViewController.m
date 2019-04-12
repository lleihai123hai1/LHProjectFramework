//
//  YGHttpLocalImageViewController.m
//  LhProjectFramework
//
//  Created by 雷海 on 2019/4/12.
//  Copyright © 2019 LH. All rights reserved.
//

#import "YGHttpLocalImageViewController.h"
#import "YYImage.h"
@interface YGHttpLocalImageViewController ()
@property(nonatomic,assign)CGFloat ygStartTime;
@property(nonatomic,assign)CGFloat ygEndTime;
@end

@implementation YGHttpLocalImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addHttpImage];
    // Do any additional setup after loading the view.
}

-(void)addHttpImage{
   
    NSInteger imageViewCount = 16;
    CGFloat width = self.view.width/2;
    CGFloat height = 2*self.view.height/imageViewCount;
    
    NSMutableArray*url = [NSMutableArray new];
    for (NSInteger i = 1; i <= imageViewCount; i++) {
//        [url addObject: [NSString stringWithFormat:@"a%ld.jpeg",(long)i]];
        [url addObject: [NSString stringWithFormat:@"old%ld.jpeg",(long)i]];
    }
    self.ygStartTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0 ; i < url.count; i++) {
        UIImageView* uiImageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%2)*width, i/2*height, width, height)];
        uiImageView.contentMode = UIViewContentModeScaleAspectFit;
        uiImageView.layer.borderWidth = 2;
        uiImageView.layer.borderColor = [UIColor blackColor].CGColor;
        uiImageView.image = [YYImage imageNamed:url[i]];
        [self.view addSubview:uiImageView];
    }
    self.ygEndTime = CFAbsoluteTimeGetCurrent();
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"YG: Download All Time: %f", self.ygEndTime - self.ygStartTime);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
