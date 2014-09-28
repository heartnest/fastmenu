//
//  PageContentViewController.m
//  Demo
//
//  Created by HeartNest on 20/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController () 

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) NSArray *orders;


@end

@implementation PageContentViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    
    
    self.titleLabel.text = self.category;
    [self createMenuItemButtonsFromArray:self.list];
    
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
//    NSArray *tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    NSDictionary *table = [tables objectAtIndex:1];
//    self.orders = [table objectForKey:@"orders"];
//    NSLog(@"%i",self.tableid);
}


-(void) createMenuItemButtonsFromArray:(NSArray *) arr{
    

    //get var,create table buttons
    int margintop = 6;
    int marginleft = 6;

    double width = self.scrollView.frame.size.width;
    double ypos = margintop;
    
    //   double xpos = marginleft;
    double boxwidth = width*85/128;
    double boxheight = 38;
    
    //foo button
    int functnWidh = boxwidth*23/128;
    
    
    ypos += margintop;
    
    // create already ordered
    
    for (NSDictionary *item in arr) {
        NSString *platename = [item objectForKey:@"name"];
        UIButton *platePlusButton = [self createPlusBtnComponentWithQnt:@"+"];
        platePlusButton.frame = CGRectMake(marginleft, ypos, functnWidh, boxheight);
        [self.scrollView addSubview:platePlusButton];
        
        UIButton *plateContentButton = [self createMenuBtnComponentWithName:platename andPrice:3];
        plateContentButton.frame = CGRectMake(marginleft+functnWidh, ypos, boxwidth, boxheight);
        [self.scrollView addSubview:plateContentButton];
        
        UIButton *plateMinuesButton = [self createPlusBtnComponentWithQnt:@"➖"];
        plateMinuesButton.frame = CGRectMake(marginleft+functnWidh+boxwidth, ypos, functnWidh, boxheight);
        [self.scrollView addSubview:plateMinuesButton];
        
        ypos += boxheight + margintop;
    }
    
//    double xcoord = 1;
//    double yheight = 20;
//    for (NSDictionary *item in arr) {
//        
//        NSString *btnname = [item objectForKey:@"name"];
//
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        button.backgroundColor = [UIColor greenColor];
//        [button setTitle:btnname forState:UIControlStateNormal];
//        
//        CGSize stringsize = [btnname sizeWithAttributes: @{NSFontAttributeName:
//                                                           [UIFont systemFontOfSize:17.0f]}];
//        
//        
//        [button setFrame:CGRectMake(1,yheight,stringsize.width+10, stringsize.height)];
//        
//        yheight += stringsize.height;
//        //xcoord += stringsize.width+20;
//        [self.scrollView addSubview:button];
//
//    }
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(0, ypos)];
}


-(UIButton *)createMenuBtnComponentWithName:(NSString *)name andPrice:(double)price{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //make the buttons content appear in the top-left
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    
    //move text 10 pixels down and right
    [button setTitleEdgeInsets:UIEdgeInsetsMake(9.0f, 10.0f, 0.0f, 0.0f)];
    
    //enable line break
    button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    //button layer
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[UIColor grayColor].CGColor];
    
    
    //prepare the style
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-bold"  size:16.0f];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style}; // Added line
    
    UIFont *font2 = [UIFont fontWithName:@"HelveticaNeue-Light"  size:16.0f];
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2,
                            NSParagraphStyleAttributeName:style}; // Added line
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%@ ",name]    attributes:dict1]];
    
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%.02f€",price ]   attributes:dict2]];
    ;
    
    
    [button setAttributedTitle:attString forState:UIControlStateNormal];
    return button;
}

- (UIButton *)createPlusBtnComponentWithQnt:(NSString *)quantity{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //move text 10 pixels down and right
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 2.0f, 0.0f, 0.0f)];
    //button layer
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[UIColor grayColor].CGColor];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-Light"  size:14.0f];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style}; // Added line
    
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:quantity attributes:dict1]];
    [button setAttributedTitle:attString forState:UIControlStateNormal];
    return button;
}
@end
