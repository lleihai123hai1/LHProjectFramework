//
//  XRDragTableView.m
//  XRDragTableViewDemo
//
//  Created by 肖睿 on 16/4/9.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "XRDragTableView.h"
typedef enum {
    AutoScrollUp,
    AutoScrollDown
} AutoScroll;


@interface XRDragTableView()
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) NSIndexPath *fromIndexPath;
@property (nonatomic, strong) NSIndexPath *toIndexPath;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) AutoScroll autoScroll;
@property (nonatomic, assign) NSInteger index;
@end

@implementation XRDragTableView

- (instancetype)init{
    if(self = [super init]){
        self.scrollSpeed = 5.0;
        //给tableView添加手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveRow:)]];
    }
    return self;
}
-(void)dealloc{
    NSLog(@"dealloc %@",[self class]);
}

- (void)moveRow:(UILongPressGestureRecognizer *)sender {
    //获取点击的位置
    CGPoint point = [sender locationInView:self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        //根据手势点击的位置，获取被点击cell所在的indexPath
        self.fromIndexPath = [self indexPathForRowAtPoint:point];
        
        if (!self.fromIndexPath) return;
        //根据indexPath获取cell
        UITableViewCell *cell = [self cellForRowAtIndexPath:self.fromIndexPath];
        //创建一个imageView，imageView的image由cell渲染得来
        self.cellImageView = [self createCellImageView:cell];
        
        //更改imageView的中心点为手指点击位置
        __block CGPoint center = cell.center;
        self.cellImageView.center = center;
        self.cellImageView.alpha = 0.0;
        [UIView animateWithDuration:0.25 animations:^{
            center.y = point.y;
            self.cellImageView.center = center;
            self.cellImageView.alpha = 0.9;
            cell.alpha = 0.0;
        } completion:^(BOOL finished) {
            cell.hidden = YES;
        }];
        
    } else if (sender.state == UIGestureRecognizerStateChanged){
        //根据手势的位置，获取手指移动到的cell的indexPath
        self.toIndexPath = [self indexPathForRowAtPoint:point];
        
        //更改imageView的中心点为手指点击位置
        CGPoint center = self.cellImageView.center;
        center.y = point.y;
        self.cellImageView.center = center;
        
        //判断cell是否被拖拽到了tableView的边缘，如果是，则自动滚动tableView
        if ([self isScrollToEdge]) {
            [self startTimerToScrollTableView];
        } else {
            [self.displayLink invalidate];
        }
        if(self.cellImageView.top <= (self.contentOffset.y + 64)){
            self.cellImageView.top = (self.contentOffset.y + 64);
        }
        if(self.cellImageView.bottom > (self.height + self.contentOffset.y)){
            self.cellImageView.bottom = self.height + self.contentOffset.y;
        }
        NSLog(@"center:(%f,%f)",self.cellImageView.frame.origin.x,self.cellImageView.frame.origin.y);
        /*
         若当前手指所在indexPath不是要移动cell的indexPath，
         且是插入模式，则执行cell的插入操作
         每次移动手指都要执行该判断，实时插入
        */
        if (self.toIndexPath && ![self.toIndexPath isEqual:self.fromIndexPath])
            [self insertCell:self.toIndexPath];
        
    } else {
        /*
         如果是交换模式，则执行交换操作
         交换操作等手势结束时执行，不用每次移动都执行
         */
        [self.displayLink invalidate];
        //将隐藏的cell显示出来，并将imageView移除掉
        UITableViewCell *cell = [self cellForRowAtIndexPath:self.fromIndexPath];
        cell.hidden = NO;
        cell.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            
            cell.alpha = 1;
            self.cellImageView.alpha = 0;
            self.cellImageView.transform = CGAffineTransformIdentity;
            self.cellImageView.center = cell.center;
        } completion:^(BOOL finished) {
            [self.cellImageView removeFromSuperview];
            self.cellImageView = nil;
        }];
    }
}

- (BOOL)isScrollToEdge {
    //imageView拖动到tableView顶部，且tableView没有滚动到最上面
    if ((CGRectGetMaxY(self.cellImageView.frame) > self.contentOffset.y + self.frame.size.height - self.contentInset.bottom) && (self.contentOffset.y < self.contentSize.height - self.frame.size.height + self.contentInset.bottom)) {
        self.autoScroll = AutoScrollDown;
        return YES;
    }
    
    //imageView拖动到tableView底部，且tableView没有滚动到最下面
    if ((self.cellImageView.frame.origin.y < self.contentOffset.y + self.contentInset.top) && (self.contentOffset.y > -self.contentInset.top)) {
        self.autoScroll = AutoScrollUp;
        return YES;
    }
    return NO;
}

- (void)startTimerToScrollTableView {
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTableView)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)scrollTableView{
    //如果已经滚动到最上面或最下面，则停止定时器并返回
    if ((self.autoScroll == AutoScrollUp && self.contentOffset.y <= -self.contentInset.top)
        || (self.autoScroll == AutoScrollDown && self.contentOffset.y >= self.contentSize.height - self.frame.size.height + self.contentInset.bottom)) {
            [self.displayLink invalidate];
            return;
    }
    
    //改变tableView的contentOffset，实现自动滚动
    CGFloat height = self.autoScroll == AutoScrollUp? -self.scrollSpeed : self.scrollSpeed;
    [self setContentOffset:CGPointMake(0, self.contentOffset.y + height)];

    if(self.autoScroll == AutoScrollUp){
        self.cellImageView.top = (self.contentOffset.y + 64) ;
    }else{
        self.cellImageView.bottom = self.height + self.contentOffset.y;
    }
    //滚动tableView的同时也要执行插入操作
    self.toIndexPath = [self indexPathForRowAtPoint:self.cellImageView.center];
    if (self.toIndexPath && ![self.toIndexPath isEqual:self.fromIndexPath]){
        [self insertCell:self.toIndexPath];
    }
}


- (void)insertCell:(NSIndexPath *)toIndexPath {
    //交换两个cell的数据模型
    [self.dataArray exchangeObjectAtIndex:self.fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.fromIndexPath,toIndexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:toIndexPath];
    cell.hidden = YES;
    self.fromIndexPath = toIndexPath;
}

- (UIImageView *)createCellImageView:(UITableViewCell *)cell {
    //打开图形上下文，并将cell的根层渲染到上下文中，生成图片
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, YES, 0.0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:image];
    cellImageView.layer.shadowOffset = CGSizeMake(0, 0.0);
    cellImageView.layer.shadowRadius = 5.0;
    [self addSubview:cellImageView];
    return cellImageView;
}

@end
