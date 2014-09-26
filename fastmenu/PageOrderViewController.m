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
    
    int realtableid = self.tableid - 2000;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSArray *tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *table = [tables objectAtIndex:realtableid];
    self.orders = [table objectForKey:@"orders"];
    
    
    
    [self createOrderedButtonsFromArray:self.orders];

}



-(void) createOrderedButtonsFromArray:(NSArray *) arr{
    
    //get var,create table buttons
    int margintop = 10;
    int marginleft = 10;
    int count = 0;
    double width = self.scrollView.frame.size.width;
    double ypos = margintop;
 //   double xpos = marginleft;
    double boxwidth = width*90/128;
    double boxheight = 100;
    
    // create add button
    // setup some frames
    //CGRect *frame = CGRectMake(marginleft, ypos, boxwidth, boxheight);
//    UITextField* tf = [[UITextField alloc] initWithFrame:CGRectMake(marginleft,ypos,boxheight,boxwidth)];
//    tf.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
//    tf.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
//    tf.backgroundColor=[UIColor whiteColor];
//    tf.text=@"Hello World";
//    [self.scrollView addSubview:tf];
    ypos += boxheight + margintop;
    
    
    
    // create already ordered
    
    for (NSDictionary *item in arr) {
        NSString *name = [item objectForKey:@"name"];
        double price = [[item objectForKey:@"price"] doubleValue];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [button addTarget:self
//                       action:@selector(didPressTableNeedsOrder:) forControlEvents:UIControlEventTouchUpInside];

        //button.tag = 2000;
        
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
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:name    attributes:dict1]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[@(price) stringValue]      attributes:dict2]];
        
        
        [button setAttributedTitle:attString forState:UIControlStateNormal];
        
        

        button.frame = CGRectMake(marginleft, ypos, boxwidth, boxheight);
        
        [self.scrollView addSubview:button];
        
        count++;
        ypos += boxheight + margintop;
        
    }
    
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(width, ypos)];
}

@end
