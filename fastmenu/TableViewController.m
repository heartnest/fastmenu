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

    //set delegates
    [self.tabbar setDelegate:self];
    
    //JSon: load table info
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    self.tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    //load buttons
    [self createTableButtonsFromArray:self.tables];
}


#pragma mark - tab bar delegate -

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    for (UIButton *aButton in [self.scrollView subviews]) {
        [aButton removeFromSuperview];
    }
    NSArray *arr;
    if ([item.title isEqualToString:@"Occupati"]) {
        arr = [self filterTablesWithArray:self.tables andState:@"busy"];
        
    }else if([item.title isEqualToString:@"Liberi"]) {
        arr = [self filterTablesWithArray:self.tables andState:@"free"];
        
    }else if([item.title isEqualToString:@"Tutti"]) {
        arr = self.tables;
        
    }
    [self createTableButtonsFromArray:arr];
}


#pragma mark - button actions -


- (void)didPressTableHasOrder:(UIButton *)sender
{
 
    int tid = sender.tag;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MenuViewController *viewController = (MenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menu-story-id"];
    
    viewController.tableid = tid;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didPressTableNeedsOrder:(UIButton *)sender
{
    int tid = sender.tag;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MenuViewController *viewController = (MenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menu-story-id"];
    
    viewController.tableid = tid;
    
    
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
    double boxwidth = width*57/128;
    double boxheight = 100;
    
    NSString *numpeople;
    
    for (NSDictionary *table in arr) {
        
        int tableid = [[table  objectForKey:@"tableid"] intValue];
        NSString *tablestate = [table objectForKey:@"state"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if ([tablestate isEqualToString:@"free"]) {
          //  button.backgroundColor = [UIColor greenColor];
            
            [button addTarget:self
                       action:@selector(didPressTableNeedsOrder:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([tablestate isEqualToString:@"busy"]) {
          numpeople = [table objectForKey:@"person"];
          button.backgroundColor = [self colorFromHexString:@"#FFDEAD"];
            [button addTarget:self
                       action:@selector(didPressTableHasOrder:) forControlEvents:UIControlEventTouchUpInside];
        }else{
          //  button.backgroundColor = [UIColor yellowColor];
            [button addTarget:self
                       action:@selector(didPressTableNeedsOrder:) forControlEvents:UIControlEventTouchUpInside];
}
        
        button.tag = 2000+tableid;
        
        //make the buttons content appear in the top-left
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        
        //move text 10 pixels down and right
        [button setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 10.0f, 0.0f, 0.0f)];
        
        //enable line break
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        //button layer
        [[button layer] setBorderWidth:1.0f];
        [[button layer] setBorderColor:[UIColor grayColor].CGColor];
        
        
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


- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end
