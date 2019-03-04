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
    NSMutableArray *tmpYGImageViewMuArray = [self.ygImageViewMuArray copy];
    for (UIView *view in tmpYGImageViewMuArray) {
        [view removeFromSuperview];
    }
    self.ygImageViewMuArray = [NSMutableArray new];
    [self cutingImage:image];
}

- (void)cutingImage:(UIImage *)image {
    NSInteger diff = 256;
    CGSize imageSize = image.size;
    
    NSInteger maxLine = floorf(imageSize.height/diff);
    NSInteger maxColumn = floorf(imageSize.width/diff);
    
    CGFloat widthDiff = imageSize.width/ maxColumn;
    CGFloat heightDiff = imageSize.height/ maxLine;
    
    
    CGFloat viewWidth = self.width/maxColumn;
    CGFloat viewHeight = self.height/maxLine;
    
    for (NSInteger j = 0; j < maxLine ; j++) {
        for (NSInteger i = 0; i < maxColumn ; i++) {
            CGRect rect = CGRectMake(i*widthDiff, j*heightDiff , widthDiff, heightDiff);
            UIImage*tmpImage = [self getImageByCuttingImage:image Rect:rect];
            UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*viewWidth, j*viewHeight, viewWidth, viewHeight)];
            imageView.image = tmpImage;
            [self addSubview:imageView];
            [self.ygImageViewMuArray addObject:imageView];
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

    return smallImage;
}

@end
