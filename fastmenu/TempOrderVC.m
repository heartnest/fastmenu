//
//  PageContentViewController.m
//  Demo
//
//  Created by HeartNest on 20/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "TempOrderVC.h"

@interface TempOrderVC () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) NSArray *orders;
@property  (strong,nonatomic) UITextField *textField;

@end

@implementation TempOrderVC



- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
//    self.titleLabel.text = self.category;
//    [self createMenuItemButtonsFromArray:self.list];
//    
    
    self.titleLabel.text = self.category;
    int realtableid = self.tableid - 2001;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSArray *tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *table = [tables objectAtIndex:realtableid];
    self.orders = [table objectForKey:@"orders"];
    
    [self createMenuItemButtonsFromArray:self.orders];
}


-(void) createMenuItemButtonsFromArray:(NSArray *) arr{
    
    
    //get var,create table buttons
    int topspace = 40;
    int margintop = 6;
    int marginleft = 6;
    
    double width = self.scrollView.frame.size.width;
    double ypos = margintop + topspace;
    

    double boxwidth = width*85/128;
    double boxheight = 38;
    
    //foo button
    int functnWidh = boxwidth*23/128;
    
    
    ypos += margintop;
    
    
    //text view
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(45, 10, 240, boxheight)];
    self.textField.borderStyle = UITextBorderStyleBezel;
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.placeholder = @"cuba libre";
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.scrollView addSubview:self.textField];
    
    //button near text view
    UIButton *addNewPlateBtn = [self createPlusBtnComponentWithQnt:@"+"];
    //UIButton *addNewPlatebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addNewPlateBtn addTarget:self
               action:@selector(aMethod)
     forControlEvents:UIControlEventTouchUpInside];
    addNewPlateBtn.frame = CGRectMake(marginleft, 10.0, functnWidh, boxheight);
    
    [self.scrollView addSubview:addNewPlateBtn];
    
    
    ypos += functnWidh;

    
    // create already ordered
    
    for (NSDictionary *item in arr) {
        
        
        //get vals
        NSString *platename = [item objectForKey:@"name"];
        double price = [[item objectForKey:@"price"] doubleValue];
        NSString *quantity = [item objectForKey:@"quantity"];
        NSString *x = [[NSString alloc] initWithFormat:@"%@",quantity];
        
        
        //NSString *platename = [item objectForKey:@"name"];
        
        //plus button
        UIButton *platePlusButton = [self createPlusBtnComponentWithQnt:x];
        platePlusButton.frame = CGRectMake(marginleft, ypos, functnWidh, boxheight);
        
        
        
        
        [self.scrollView addSubview:platePlusButton];
        
        UIButton *plateContentButton = [self createMenuBtnComponentWithName:platename andPrice:price];
        plateContentButton.frame = CGRectMake(marginleft+functnWidh, ypos, boxwidth, boxheight);
        [self.scrollView addSubview:plateContentButton];
        
        UIButton *plateMinuesButton = [self createPlusBtnComponentWithQnt:@"➖"];
        plateMinuesButton.frame = CGRectMake(marginleft+functnWidh+boxwidth, ypos, functnWidh, boxheight);
        [self.scrollView addSubview:plateMinuesButton];
        
        ypos += boxheight + margintop;
        
        
    }
    
    
    // Coperto button --- start
    
        UIButton *platePlusButton = [self createPlusBtnComponentWithQnt:@"3"];
        platePlusButton.frame = CGRectMake(marginleft, ypos+topspace, functnWidh, boxheight);
        [self.scrollView addSubview:platePlusButton];
    
        UIButton *btn = [self createCopertoBtnWithNumPeople:2.5];
        btn.frame = CGRectMake(marginleft+functnWidh, ypos+topspace, boxwidth, boxheight);
        [self.scrollView addSubview:btn];
    
        UIButton *plateMinusButton = [self createPlusBtnComponentWithQnt:@"➖"];
        plateMinusButton.frame = CGRectMake(marginleft+functnWidh+boxwidth, ypos+topspace, functnWidh, boxheight);
        [self.scrollView addSubview:plateMinusButton];
    
    // Coperto button --- end
    ypos += 4*boxheight + margintop;
    
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

-(UIButton *)createCopertoBtnWithNumPeople:(float) copertoCost{
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
    
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"coperto %.02f€",copertoCost ]      attributes:dict1]];
    [button setAttributedTitle:attString forState:UIControlStateNormal];
    return button;
    
}

-(void)aMethod{
    NSLog(@"aa");
}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    NSLog(@"aa");
//    [self.textField resignFirstResponder];
//}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    
    NSLog(@"aa");
    [self.textField resignFirstResponder];
}

@end

