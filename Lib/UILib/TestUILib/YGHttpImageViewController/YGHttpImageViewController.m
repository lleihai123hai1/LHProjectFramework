//
//  YGHttpImageViewController.m
//  LhProjectFramework
//
//  Created by 雷海 on 2019/4/12.
//  Copyright © 2019 LH. All rights reserved.
//

#import "YGHttpImageViewController.h"
#import "UIImageView+WebCache.h"
@interface YGHttpImageViewController ()
@property(nonatomic,assign)CGFloat ygStartTime;
@property(nonatomic,assign)CGFloat ygEndTime;
@end

@implementation YGHttpImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    [self addHttpImage];
    // Do any additional setup after loading the view.
}

-(void)addHttpImage{
    NSArray *url = @[@"http://st3.dailyyoga.com.edgesuite.net//2d/3c/2d3cec3618e4758e1fe364c3ab9b6c0d.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//97/ff/97ffee2fb6283bafd3b24dc0537403c4.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//84/6c/846cff018cde4837ea8cca3042134390.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//bd/ee/bdee5005c8a516bc844bb94b794e7617.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//85/e9/85e9dc979fc8d99fcdfab085973e51eb.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//7d/9e/7d9e8fbd3a802bf4550bf4d34303bc88.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//d8/d7/d8d7f752b03ec9e40728a3136c5b3c1c.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//ee/73/ee731d8298f1811209e7f3a0c0c1bbe4.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//3c/1b/3c1b148fb3f4699f5da28573bccbd053.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//b0/1d/b01dcd036de6287a37ad16563d0c51f0.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//15/41/15417d0654fcce7a24757be68dba6857.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//c9/ca/c9caecdbfb7808d03ffe697fcec104f8.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//a2/b9/a2b9fa580ee37b529a9b983d87a695f6.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//84/7f/847f04ab33bbfc009619bc066ea2193c.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//22/c9/22c9db8db09b088ca04bf89aef2d77ae.jpeg?size=1920-1080_",
                     @"http://st3.dailyyoga.com.edgesuite.net//5d/62/5d622cd5ff255cf828594f38a9948fc1.jpeg?size=1920-1080_"];
    NSInteger imageViewCount = url.count;
    CGFloat width = self.view.width/2;
    CGFloat height = 2*self.view.height/imageViewCount;
    self.ygStartTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0 ; i < url.count; i++) {
       UIImageView* uiImageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%2)*width, i/2*height, width, height)];
        uiImageView.layer.borderWidth = 2;
        uiImageView.layer.borderColor = [UIColor blackColor].CGColor;
//        [uiImageView sd_setImageWithURL:[NSURL URLWithString:url[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            uiImageView.image = image;
//            self.ygEndTime = CFAbsoluteTimeGetCurrent();
//        }];
        [uiImageView sd_setImageWithURL:[NSURL URLWithString:[url[i] stringByAppendingString:@"1024-700"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            uiImageView.image = image;
            self.ygEndTime = CFAbsoluteTimeGetCurrent();
        }];
        [self.view addSubview:uiImageView];
    }
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
