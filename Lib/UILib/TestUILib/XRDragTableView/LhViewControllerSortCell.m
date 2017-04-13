#import "LhViewControllerSortCell.h"
@interface LhViewControllerSortCell () {
}

@end


@implementation LhViewControllerSortCell
+(UITableViewCell*)getLhDemoCell:(UITableView*)table  dict:(NSDictionary*)dict{
    DemoCell *cell = [table dequeueReusableCellWithIdentifier:table.lh_NSObjectId];
    if (!cell) {
        cell = [[DemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:table.lh_NSObjectId];
    }
    cell.titleLabel.text = [dict strValue:@"title"];
    cell.contentLabel.text = [dict strValue:@"content"];
    return cell;
}
@end
