//
//  YGCuttingImageView.m
//  LhProjectFramework
//
//  Created by 雷海 on 2019/3/4.
//  Copyright © 2019 LH. All rights reserved.
//

#import "YGCuttingImageView.h"

@implementation YGCuttingImageView

- (void)setImage:(UIImage *)image {
    
    NSMutableArray *tmpYGImageViewMuArray = [NSMutableArray arrayWithArray:self.ygImageViewMuArray?:@[]];
    for (UIView *view in tmpYGImageViewMuArray) {
        [view removeFromSuperview];
    }
    self.ygImageViewMuArray = [NSMutableArray new];
    [self cutingImage:image];
}

- (void)cutingImage:(UIImage *)image {
    NSInteger diff = 256;
    CGSize imageSize = image.size;
    
    NSInteger maxLine = ceilf(imageSize.height/diff);
    NSInteger maxColumn = ceilf(imageSize.width/diff);
    
    CGFloat widthDiff = imageSize.width/ maxColumn;
    CGFloat heightDiff = imageSize.height/ maxLine;
    
    
    CGFloat viewWidth = self.width/maxColumn;
    CGFloat viewHeight = self.height/maxLine;
    
//    BOOL flag = NO;
    BOOL flag = YES;
    for (NSInteger j = 0; j < maxLine ; j++) {
        for (NSInteger i = 0; i < maxColumn ; i++) {
            CGRect rect = CGRectMake(i*widthDiff, j*heightDiff , widthDiff, heightDiff);
            UIImage*tmpImage;
            if(flag){
                tmpImage = [self getImageByCuttingImage:image Rect:rect];
            }else{
                tmpImage = [UIImage imageWithContentsOfFile:[self getpathByName:[NSString stringWithFormat:@"%ld_%ld.png",(long)i,(long)j]]];;
            }
            UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*viewWidth, j*viewHeight, viewWidth, viewHeight)];
            imageView.image = tmpImage;
            [self addSubview:imageView];
            [self.ygImageViewMuArray addObject:imageView];
            if(flag){
                [UIImagePNGRepresentation(tmpImage) writeToFile:[self getpathByName:[NSString stringWithFormat:@"%ld_%ld.png",(long)i,(long)j]] atomically:YES];
            }
            
            NSLog(@"%@",tmpImage);
            
        }
    }
}

- (UIImage *)getImageByCuttingImage:(UIImage *)image Rect:(CGRect)rect {
    //大图bigImage
    //定义myImageRect，截图的区域

    CGRect myImageRect = rect;

    UIImage *bigImage = image;

    CGImageRef imageRef = bigImage.CGImage;

    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);

    CGSize size;

    size.width = rect.size.width;

    size.height = rect.size.height;

    UIGraphicsBeginImageContext(size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextDrawImage(context, myImageRect, subImageRef);

    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];

    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}


-(NSString *)getpathByName:(NSString*)name{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:name];  // 保存文件的名称
    return filePath;
}
@end
