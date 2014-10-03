//
//  PageContentViewController.m
//  Demo
//
//  Created by HeartNest on 20/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "TempOrderVC.h"
#import "Tools.h"

@interface TempOrderVC () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) NSArray *orders;
@property  (strong,nonatomic) UITextField *textField;

@end

@implementation TempOrderVC



- (void)viewDidLoad
{
    //[super viewDidLoad];

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
    
    
    //text field
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(marginleft+functnWidh+5, 10, 240, boxheight - 1 )];
    self.textField.borderStyle = UITextBorderStyleBezel;
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.placeholder = @"cuba libre";
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.scrollView addSubview:self.textField];
    
    //add Plate button
    
    UIButton *addNewPlateBtn = [Tools createPlusBtnComponentWithQnt:@"✚" andColor:nil];
    
    [addNewPlateBtn addTarget:self
               action:@selector(aMethod)
     forControlEvents:UIControlEventTouchUpInside];
    addNewPlateBtn.frame = CGRectMake(marginleft, 10.0, functnWidh, boxheight);
    
    [self.scrollView addSubview:addNewPlateBtn];
    
    
    ypos += functnWidh;

    
    // create already ordered
    
    for (NSDictionary *item in arr) {
        
        
        // VALUES
        NSString *platename = [item objectForKey:@"name"];
        double price = [[item objectForKey:@"price"] doubleValue];
        NSString *quantity = [item objectForKey:@"quantity"];
        NSString *x = [[NSString alloc] initWithFormat:@"%@",quantity];
        NSString *state = [item objectForKey:@"state"];

        // Buttons declaration
        UIButton *platePlusButton,*plateMinuesButton,*plateContentButton;
        

        if ([state isEqualToString:@"new"]) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:nil];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"➖" andColor:nil];
            
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:nil];
            
        }else if ([state isEqualToString:@"sent"]) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:@"#FFFFF0"];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"📌" andColor:@"#FFFFF0"];
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:nil];
        }else if ([state isEqualToString:@"cooking"]) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:@"#FFFFF0"];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"♨️" andColor:@"#FFFFF0"];
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:@"#FFFFF0"];
        }else if ([state isEqualToString:@"ready"]) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:@"#FFFFF0"];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"🔔" andColor:@"#FFDEAD"];
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:@"#FFFFF0"];
        }else if ([state isEqualToString:@"served"]) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:@"#FFFFF0"];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"👍" andColor:@"#FFFFF0"];
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:@"#FFFFF0"];
        }
        
        
        //set buttons positions
        plateMinuesButton.frame = CGRectMake(marginleft+functnWidh+boxwidth+10, ypos, functnWidh, boxheight);
        plateContentButton.frame = CGRectMake(marginleft+functnWidh+5, ypos, boxwidth, boxheight );
        platePlusButton.frame = CGRectMake(marginleft, ypos, functnWidh, boxheight);
        
        //add buttons
        [self.scrollView addSubview:platePlusButton];
        [self.scrollView addSubview:plateMinuesButton];
        [self.scrollView addSubview:plateContentButton];
        
        ypos += boxheight + margintop;
        
        
    }
    
    
    // Coperto button --- start
    
        UIButton *platePlusButton = [Tools createPlusBtnComponentWithQnt:@"3" andColor:nil];
        platePlusButton.frame = CGRectMake(marginleft, ypos+topspace, functnWidh, boxheight);
        [self.scrollView addSubview:platePlusButton];
    
        UIButton *btn = [Tools createCopertoBtnWithNumPeople:2.5];
        btn.frame = CGRectMake(marginleft+functnWidh+5, ypos+topspace, boxwidth, boxheight);
        [self.scrollView addSubview:btn];
    
        UIButton *plateMinusButton = [Tools createPlusBtnComponentWithQnt:@"➖" andColor:nil];
        plateMinusButton.frame = CGRectMake(marginleft+functnWidh+boxwidth+10, ypos+topspace, functnWidh, boxheight);
        [self.scrollView addSubview:plateMinusButton];
    
    // Coperto button --- end
    
    ypos += 4*boxheight + margintop;
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(0, ypos)];
}


#pragma mark - Button click handlers -

-(void)aMethod{
    NSLog(@"aa");
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    
    NSLog(@"aa");
    [self.textField resignFirstResponder];
}



@end

