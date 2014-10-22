//
//  TableViewController.m
//  fastmenu
//
//  Created by HeartNest on 19/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "TableViewController.h"
#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"

@interface TableViewController ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *tables;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@end

@implementation TableViewController


#pragma mark - view controller life cycle -

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.scrollView setScrollEnabled:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    //set delegates for buttom tab bar
    [self.tabbar setDelegate:self];
    
    //Load table infos
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    self.tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];


    //right top button
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [button1 addTarget:self action:@selector(alertNotifications) forControlEvents:UIControlEventTouchUpInside];
    [button1 setImage:[UIImage imageNamed:@"bell36.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = button;
    
    //show table buttons
    [self createTableButtonsFromArray:self.tables];
}


#pragma mark - tab bar delegate -

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    for (UIButton *aButton in [self.scrollView subviews]) {
        [aButton removeFromSuperview];
    }
   
    NSArray *arr;
    if ([item.title isEqualToString:@"Occupied"]) {
        
        arr = [self filterTablesWithArray:self.tables andState:@"busy"];
        
    }else if([item.title isEqualToString:@"Free"]) {
        arr = [self filterTablesWithArray:self.tables andState:@"free"];
        
    }else if([item.title isEqualToString:@"All"]) {
        arr = self.tables;
        
    }
    [self createTableButtonsFromArray:arr];
}


#pragma mark - UIButton actions -


- (void)didPressTableHasOrder:(UIButton *)sender
{
 
    int tid = (int)sender.tag;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MenuViewController *viewController = (MenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menu-story-id"];
    
    viewController.tableid = tid;
    viewController.tablestate = 1;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didPressTableNeedsOrder:(UIButton *)sender
{
    int tid = (int)sender.tag;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MenuViewController *viewController = (MenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menu-story-id"];
    
    viewController.tableid = tid;
    viewController.tablestate = 0;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - creating buttons -

-(void) createTableButtonsFromArray:(NSArray *) arr{
    
    //get var,create table buttons
    int margintop = 10;
    int marginleft = 10;
    int count = 0;
    double width = self.scrollView.frame.size.width;
    double ypos = margintop;
    double boxwidth = width*57/128;
    double boxheight = 100;
    
    NSString *numpeople;
    
    for (NSDictionary *table in arr) {
        
        int tableid = [[table  objectForKey:@"tableid"] intValue];
        NSString *tablestate = [table objectForKey:@"state"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if ([tablestate isEqualToString:@"free"]) {
            [button addTarget:self
                       action:@selector(didPressTableNeedsOrder:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([tablestate isEqualToString:@"busy"]) {
          numpeople = [table objectForKey:@"person"];
          button.backgroundColor = [Tools colorFromHexString:@"#FFDEAD"];
            [button addTarget:self
                       action:@selector(didPressTableHasOrder:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button addTarget:self
                       action:@selector(didPressTableNeedsOrder:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        button.tag = 2000+tableid;
        
        //background image of tables
        [button setBackgroundImage:[UIImage imageNamed:@"tavologb.png"]
                            forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(1, 10, 20, 1)];
        
        //make the buttons content appear in the top-left
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        
        //move text 10 pixels down and right
        [button setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 10.0f, 0.0f, 0.0f)];
        
        //enable line break
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        //button layer
       // [[button layer] setBorderWidth:1.0f];
       // [[button layer] setBorderColor:[UIColor grayColor].CGColor];
        
        
        //prepare the style
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentLeft];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-Light"  size:14.0f];
        UIFont *font2 = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
        NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                NSFontAttributeName:font1,
                                NSParagraphStyleAttributeName:style}; // Added line
        NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                NSFontAttributeName:font2,
                                NSParagraphStyleAttributeName:style}; // Added line
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Table "    attributes:dict1]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[@(tableid) stringValue]      attributes:dict2]];
        
        if ([tablestate isEqualToString:@"busy"]) {
            int sum =[[table objectForKey:@"sum"] intValue];
            [attString appendAttributedString:[[NSAttributedString alloc] initWithString: [[NSString alloc] initWithFormat:@"\nPeople:%@\nTotal: %d €",numpeople,sum ]     attributes:dict1]];
        }
        
        
        [button setAttributedTitle:attString forState:UIControlStateNormal];

        
        if (count%2 == 1) {
            button.frame = CGRectMake(width/2 + marginleft, ypos, boxwidth, boxheight);
            ypos += (boxheight+margintop);
        }else
            button.frame = CGRectMake(marginleft, ypos, boxwidth, boxheight);
        
        [self.scrollView addSubview:button];
        
        count++;

    }
    
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(width, ypos)];
}

#pragma mark - Alerts & utilities -

-(void)alertNotifications{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Notifications"
                           message:@""
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:@"Call from table 2",@"Call from table 3",@"Meal ready for table 5",nil];
    
    alert.tag = 20;
    [alert show];
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

@end
