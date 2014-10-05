//
//  PageContentViewController.m
//  Demo
//
//  Created by HeartNest on 20/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "PageContentViewController.h"
#import "Tools.h"

@interface PageContentViewController () 

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *orders;


@end

@implementation PageContentViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    
    
    self.titleLabel.text = self.category;
    
    
    
//  Get Already ordered

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSArray *tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *table = [tables objectAtIndex:self.tableid - 2001];
    self.orders = [table objectForKey:@"orders"];
 //   NSLog(@"%@",self.orders);
    [self createMenuItemButtonsFromArray:self.list];
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
        UIButton *platePlusButton,*plateContentButton,*plateMinuesButton;
        
        NSString *platename = [item objectForKey:@"name"];

        int plateQntOrdered = [self getQuantityOrderedOfThisPlate:platename];
        
        if (plateQntOrdered > 0) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:[@(plateQntOrdered) stringValue]  andColor:@"#FFDEAD"];
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:3 color:@"#FFDEAD"];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"➖" andColor:@"#FFDEAD"];
        }else{
        platePlusButton = [Tools createPlusBtnComponentWithQnt:@"✚" andColor:nil];
        plateContentButton = [Tools createMenuBtnComponentWithName:platename price:3 color:nil];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"➖" andColor:nil];
            
        }
        
        
        //Actions bounded to buttons
        [platePlusButton addTarget:self
                            action:@selector(onClickPlusBtn:) forControlEvents:UIControlEventTouchUpInside];
        [plateContentButton addTarget:self
                               action:@selector(onClickPlateBtn:) forControlEvents:UIControlEventTouchUpInside];
        [plateMinuesButton addTarget:self
                              action:@selector(onClickMinusBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //Fix button postions
        platePlusButton.frame = CGRectMake(marginleft, ypos, functnWidh, boxheight);
        plateContentButton.frame = CGRectMake(marginleft+functnWidh+5, ypos, boxwidth, boxheight);
        plateMinuesButton.frame = CGRectMake(marginleft+functnWidh+boxwidth+10, ypos, functnWidh, boxheight);
        
        
        //Attach buttons
        [self.scrollView addSubview:platePlusButton];
        [self.scrollView addSubview:plateContentButton];
        [self.scrollView addSubview:plateMinuesButton];
        
        //update postion tmp
        ypos += boxheight + 2*margintop;
    }
    
    ypos += boxheight + margintop;
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(0, ypos)];
}

-(int)getQuantityOrderedOfThisPlate:(NSString *)name{
    
    for (NSDictionary *p in self.orders) {
        NSString *platename = [p objectForKey:@"name"];
        NSString *platestate = [p objectForKey:@"state"];

        if ([platename isEqualToString:name] && [platestate isEqualToString:@"new"]) {
            return [[p objectForKey:@"quantity"] intValue];
        }
    }
    return -1;
}

#pragma mark - UIButton click events -
-(void)onClickPlusBtn:(UIButton *)sender
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-bold"  size:14.0f];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:style}; // Added line
    
    NSString *quantity;
    
    NSString *txt = sender.titleLabel.text;
    if (![txt isEqualToString:@"✚"]) {
        int num = [txt intValue];
        num ++;
        quantity = [[NSString alloc] initWithFormat:@"%i",num ];
    }else{
        quantity = [[NSString alloc] initWithFormat:@"1"];
    }
    
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:quantity attributes:dict1]];
    [sender setAttributedTitle:attString forState:UIControlStateNormal];
    
    
    // useful for future use
    //int tid = (int)sender.tag;
}
-(void)onClickMinusBtn:(UIButton *)sender
{
    
    int tid = (int)sender.tag;
    NSLog(@"Minus button tag %i",tid);
}
-(void)onClickPlateBtn:(UIButton *)sender
{
    
    int tid = (int)sender.tag;
    NSLog(@"Plate button tag %i",tid);
    [self alertMenuItem];
}


#pragma mark - UIAlerts -
-(void)alertMenuItem{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Plate"
                           message:@""
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:@"+1",@"Note",@"Correct price",@"-1",nil];
    [alert show];
}
@end
