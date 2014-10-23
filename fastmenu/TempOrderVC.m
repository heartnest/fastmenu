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

@property (weak, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *orders;
@property  (strong,nonatomic) UITextField *textField;


@end

@implementation TempOrderVC



- (void)viewDidLoad
{
    //[super viewDidLoad];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
  
    self.titleLabel.text = self.category;
    int realtableid = self.tableid - 2001;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSArray *tables = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *table = [tables objectAtIndex:realtableid];
    self.orders = [table objectForKey:@"orders"];
    
    [self createMenuItemButtonsFromArray:self.orders];
}


-(void)setOrders:(NSArray *)orders{
    
    if (_orders == nil) {
        _orders = [[NSArray alloc ] init];
    }
    
    _orders = orders;
    
    [[NSUserDefaults standardUserDefaults]setObject:orders forKey:[[NSString alloc] initWithFormat:@"ordersOfTable%i",self.tableid]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}


#pragma mark - creating buttons -


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
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(marginleft, 10, 250, boxheight - 1 )];
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
               action:@selector(addNewPlate)
     forControlEvents:UIControlEventTouchUpInside];
    addNewPlateBtn.frame = CGRectMake(marginleft+250+5, 10.0, functnWidh, boxheight);
    
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
        NSString *note = [item objectForKey:@"note"];
        

        // Buttons declaration
        UIButton *platePlusButton,*plateMinuesButton,*plateContentButton;
        

        if ([state isEqualToString:@"new"]) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:nil];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"➖" andColor:nil];
            
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:nil];
            
            
            //Actions bounded to buttons
            [platePlusButton addTarget:self
                                action:@selector(onClickPlusBtn:) forControlEvents:UIControlEventTouchUpInside];
            [plateContentButton addTarget:self
                                   action:@selector(onClickPlateBtn:) forControlEvents:UIControlEventTouchUpInside];
            [plateMinuesButton addTarget:self
                                  action:@selector(onClickMinusBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else if ([state isEqualToString:@"sent"]) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:@"#FFFFF0"];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"" andColor:@"#FFFFF0"];
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:nil];
            
            [plateMinuesButton setBackgroundImage:[UIImage imageNamed:@"confirmed.png"] forState:UIControlStateNormal];

            UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] init];
            [gr addTarget:self action:@selector(longPressKitAll:)];
            [plateContentButton addGestureRecognizer:gr];
            
        }else if ([state isEqualToString:@"cooking"]) {
            
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:@"#FFFFF0"];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"" andColor:@"#FFFFF0"];
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:@"#FFFFF0"];
            
            [plateMinuesButton setBackgroundImage:[UIImage imageNamed:@"cooking.png"] forState:UIControlStateNormal];
            
            UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressKitPrice:)];
            [plateContentButton addGestureRecognizer:gr];
            
        }else if ([state isEqualToString:@"ready"]) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:@"#FFFFF0"];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"" andColor:@"#FFDEAD"];
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:@"#FFFFF0"];
            
            [plateMinuesButton setBackgroundImage:[UIImage imageNamed:@"ready.png"] forState:UIControlStateNormal];
            
            UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressKitPrice:)];
            [plateContentButton addGestureRecognizer:gr];
            
            
        }else if ([state isEqualToString:@"served"]) {
            platePlusButton = [Tools createPlusBtnComponentWithQnt:x andColor:@"#FFFFF0"];
            plateMinuesButton = [Tools createPlusBtnComponentWithQnt:@"" andColor:@"#FFFFF0"];
            plateContentButton = [Tools createMenuBtnComponentWithName:platename price:price color:@"#FFFFF0"];
            
            [plateMinuesButton setBackgroundImage:[UIImage imageNamed:@"served2.png"] forState:UIControlStateNormal];
            
            UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressKitPrice:)];
            [plateContentButton addGestureRecognizer:gr];
        }
        
        

        
        //set buttons positions
        plateMinuesButton.frame = CGRectMake(marginleft, ypos, functnWidh, boxheight);
        plateContentButton.frame = CGRectMake(marginleft+functnWidh+5, ypos, boxwidth, boxheight );
        platePlusButton.frame = CGRectMake(marginleft+functnWidh+boxwidth+10, ypos, functnWidh, boxheight);
        
        //add buttons
        [self.scrollView addSubview:platePlusButton];
        [self.scrollView addSubview:plateMinuesButton];
        [self.scrollView addSubview:plateContentButton];
        
        
        
        ypos += boxheight + margintop;
        
        if (note != nil && ![note isEqualToString:@""]) {
            UIButton *notebtn = [Tools createNoteBtnWithString:note];
            UIButton *noteminus = [Tools createPlusBtnComponentWithQnt:@"➖" andColor:nil];
            notebtn.frame = CGRectMake(marginleft+functnWidh+5, ypos, boxwidth, boxheight );
            //noteminus.frame = CGRectMake(marginleft+functnWidh+boxwidth+10, ypos, functnWidh, boxheight);
            noteminus.frame = CGRectMake(marginleft, ypos, functnWidh, boxheight);
            [self.scrollView addSubview:notebtn];
            [self.scrollView addSubview:noteminus];
            ypos += boxheight + margintop;
            [notebtn addTarget:self
                    action:@selector(alertAddNote) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    
    // Coperto button --- start
    
        UIButton *platePlusButton = [Tools createPlusBtnComponentWithQnt:@"3" andColor:nil];
        platePlusButton.frame = CGRectMake(marginleft+functnWidh+boxwidth+10, ypos+topspace, functnWidh, boxheight);
        [self.scrollView addSubview:platePlusButton];
    
        UIButton *btn = [Tools createCopertoBtnWithNumPeople:2.5];
        btn.frame = CGRectMake(marginleft+functnWidh+5, ypos+topspace, boxwidth, boxheight);
        [self.scrollView addSubview:btn];
    
        UIButton *plateMinusButton = [Tools createPlusBtnComponentWithQnt:@"➖" andColor:nil];
        plateMinusButton.frame = CGRectMake(marginleft, ypos+topspace, functnWidh, boxheight);
        [self.scrollView addSubview:plateMinusButton];
    
        [btn addTarget:self
                        action:@selector(alertChangeServiceFee) forControlEvents:UIControlEventTouchUpInside];
    
    // Coperto button --- end
    
    ypos += 4*boxheight + margintop;
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(0, ypos)];
}


#pragma mark - Button Actions -

-(void)addNewPlate{
    NSLog(@"add new plate tapped");
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"tapped outside");
    [self.textField resignFirstResponder];
}


- (void)longPressKitAll:(UILongPressGestureRecognizer *)sender {
    if ( sender.state == UIGestureRecognizerStateBegan){
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"Plate"
                               message:@""
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:@"+1",@"Note",@"Correct price",@"-1",nil];
        
        alert.tag = 110;
        [alert show];
        
    }
}

- (void)longPressKitPrice:(UILongPressGestureRecognizer *)sender {
    if ( sender.state == UIGestureRecognizerStateBegan){
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"Correct the price"
                               message:@""
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:@"Correct",nil];
        alert.tag = 120;
        [alert show];
    }
}

#pragma mark - Alerts -

-(void)alertChangeServiceFee{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Sercice Price"
                           message:@""
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
    alert.tag = 130;
    [alert show];
}

-(void)alertAddNote{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Note"
                           message:@""
                           delegate:self
                           cancelButtonTitle:@"Cancell"
                           otherButtonTitles:@"Confirm",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
    alert.tag = 140;
    [alert show];
}

-(void)alertCorrectPrice{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Price"
                           message:@""
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
    alert.tag = 140;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 110 || alertView.tag == 100) {
        NSLog(@"a");
        if (buttonIndex == 2) {
            [self alertAddNote];
        }else if(buttonIndex == 3) {
            [self alertCorrectPrice];
        }
        
    }
}
@end

