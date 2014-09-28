//
//  PageOrderViewController.m
//  fastmenu
//
//  Created by HeartNest on 20/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "PageOrderViewController.h"


@interface PageOrderViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *addPlateBtn;
@property (strong,nonatomic) NSArray *orders;
@end

@implementation PageOrderViewController

-(void)viewDidAppear:(BOOL)animated{
     [self createOrderedButtonsFromArray:self.orders];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int realtableid = self.tableid - 2001;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSArray *tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *table = [tables objectAtIndex:realtableid];
    self.orders = [table objectForKey:@"orders"];
    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height)];
//    [self.scrollView setShowsVerticalScrollIndicator:NO];
//    //[self.scrollView setPagingEnabled:YES];
//    [self.view addSubview:self.scrollView];
    
    //add button
    [[self.addPlateBtn layer] setBorderWidth:1.0f];
    [[self.addPlateBtn layer] setBorderColor:[UIColor grayColor].CGColor];
}



-(void) createOrderedButtonsFromArray:(NSArray *) arr{
    
    //
    int topspace = 30;
    
    //get var,create table buttons
    int margintop = 6;
    int marginleft = 6;
    int count = 0;
    double width = self.scrollView.frame.size.width;
    double ypos = margintop;
    
 //   double xpos = marginleft;
    double boxwidth = width*85/128;
    double boxheight = 38;
    
    //foo button
    int functnWidh = boxwidth*23/128;
    

    ypos += boxheight + margintop + topspace;
    
    // create already ordered
    
    for (NSDictionary *item in arr) {
        
        //get vals
        NSString *name = [item objectForKey:@"name"];
        double price = [[item objectForKey:@"price"] doubleValue];
        NSString *quantity = [item objectForKey:@"quantity"];
        NSString *x = [[NSString alloc] initWithFormat:@"%@",quantity];

        //create btns
        UIButton *platePlusButton = [self createPlusBtnComponentWithQnt:x];
        platePlusButton.frame = CGRectMake(marginleft, ypos, functnWidh, boxheight);
        [self.scrollView addSubview:platePlusButton];
        
        UIButton *plateContentButton = [self createMenuBtnComponentWithName:name andPrice:price];
        plateContentButton.frame = CGRectMake(marginleft+functnWidh, ypos, boxwidth, boxheight);
        [self.scrollView addSubview:plateContentButton];
        
        UIButton *plateMinuesButton = [self createPlusBtnComponentWithQnt:@"➖"];
        plateMinuesButton.frame = CGRectMake(marginleft+functnWidh+boxwidth, ypos, functnWidh, boxheight);
        [self.scrollView addSubview:plateMinuesButton];
        
        count++;
        ypos += boxheight + margintop;
        
    }
    
    
   
    // Coperto button --- start
    
    UIButton *platePlusButton = [self createPlusBtnComponentWithQnt:@"✚"];
    platePlusButton.frame = CGRectMake(marginleft, ypos+topspace, functnWidh, boxheight);
    [self.scrollView addSubview:platePlusButton];
    
    UIButton *btn = [self createCopertoBtnWithNumPeople:3];
    btn.frame = CGRectMake(marginleft+functnWidh, ypos+topspace, boxwidth, boxheight);
    [self.scrollView addSubview:btn];
    
    UIButton *plateMinusButton = [self createPlusBtnComponentWithQnt:@"➖"];
    plateMinusButton.frame = CGRectMake(marginleft+functnWidh+boxwidth, ypos+topspace, functnWidh, boxheight);
    [self.scrollView addSubview:plateMinusButton];
    
    // Coperto button --- end
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,self.scrollView.frame.size.height);
//      [self.scrollView setShowsHorizontalScrollIndicator:NO];
//    [self.scrollView setScrollEnabled:YES];
//    CGSize scrollableSize = CGSizeMake(120, ypos*2);
//    [self.scrollView setContentSize:scrollableSize];
    //[self.scrollView setContentSize:CGSizeMake(0, ypos*2)];
}

-(UIButton *)createCopertoBtnWithNumPeople:(int) numPeople{
     UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    //move text 10 pixels down and right
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 10.0f, 0.0f, 0.0f)];
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

    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%i ✕ coperto 2,5€",numPeople ]      attributes:dict1]];
    [button setAttributedTitle:attString forState:UIControlStateNormal];
    return button;
    
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
