//
//  PageOrderViewController.m
//  fastmenu
//
//  Created by HeartNest on 20/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "PageOrderViewController.h"

@interface PageOrderViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *orders;
@end

@implementation PageOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSArray *tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *table = [tables objectAtIndex:1];
    self.orders = [table objectForKey:@"orders"];
    NSLog(@"%i  aaa",self.tableid);

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
