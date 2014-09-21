//
//  TableViewController.m
//  fastmenu
//
//  Created by HeartNest on 19/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "TableViewController.h"
#import "OrdersViewController.h"
#import "MenuViewController.h"


@interface TableViewController ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *tables;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@end

@implementation TableViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.scrollView setScrollEnabled:YES];
   // [self.scrollView setContentSize:CGSizeMake(320, 1200)];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
//    UITabBarController *tabBarController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController ;
    [self.tabbar setDelegate:self];
    //get table info
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    self.tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    
    [self createTableButtonsFromArray:self.tables];

}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"aa %@",item.title);
    
}

#pragma mark - UIButton outlets




#pragma mark - Navigation

-(void)someMethod
{
    [self performSegueWithIdentifier:@"occupiedtable" sender:self];
}

- (void)didPressTableHasOrder:(UIButton *)sender
{
 
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    OrdersViewController *viewController = (OrdersViewController *)[storyboard instantiateViewControllerWithIdentifier:@"order-story-id"];
    
//    [self presentViewController:viewController animated:YES completion:nil];
 [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didPressTableNeedsOrder:(UIButton *)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MenuViewController *viewController = (MenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menu-story-id"];
    
    //    [self presentViewController:viewController animated:YES completion:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(NSArray *)filterTablesWithArray:(NSArray *)arr andState:(NSString *)state{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (NSDictionary *table in arr) {
         NSString *tablestate = [table objectForKey:@"state"];
        if([state isEqualToString:tablestate]){
            [result addObject:table];
        }
            
    }
    return [result copy];
}


-(void) createTableButtonsFromArray:(NSArray *) arr{
    
    //get var,create table buttons
    int margintop = 10;
    int marginleft = 10;
    int count = 0;
    double width = self.scrollView.frame.size.width;
    double ypos = margintop;
    double boxwidth = width*6/16;
    double boxheight = 100;
    
    
    for (NSDictionary *table in arr) {
        
        int tableid = [[table  objectForKey:@"tableid"] intValue];
        NSString *tablestate = [table objectForKey:@"state"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if ([tablestate isEqualToString:@"free"]) {
            button.backgroundColor = [UIColor greenColor];
            [button addTarget:self
                       action:@selector(didPressTableNeedsOrder:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([tablestate isEqualToString:@"busy"]) {
            button.backgroundColor = [UIColor redColor];
            [button addTarget:self
                       action:@selector(didPressTableHasOrder:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            button.backgroundColor = [UIColor yellowColor];
            [button addTarget:self
                       action:@selector(didPressTableNeedsOrder:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        button.tag = 2000+tableid;
        
        //make the buttons content appear in the top-left
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        
        //move text 10 pixels down and right
        [button setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 10.0f, 0.0f, 0.0f)];
        
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [button setTitle:@"Show View\nlalala" forState:UIControlStateNormal];
        
        if (count%2 == 1) {
            button.frame = CGRectMake(width/2 + 1, ypos, boxwidth, boxheight);
            ypos += (boxheight+margintop);
        }else
            button.frame = CGRectMake(marginleft, ypos, boxwidth, boxheight);
        
        [self.scrollView addSubview:button];
        
        count++;

    }
    
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(width, ypos)];
}

#pragma marks - tabbar select event -
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    NSLog(@"a");
//}

@end
