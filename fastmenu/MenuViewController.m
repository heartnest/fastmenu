//
//  MenuViewController.m
//  fastmenu
//
//  Created by HeartNest on 19/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *categories;

@end

@implementation MenuViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}




- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.categories = @[@"te",@"analcolico",@"alcolico",@"succo",@"dolce",@"altri"];
    
    
    [self createButtonsFromArray:self.categories];
    
//    [button addTarget:self
//               action:@selector(didPressButton:)
//     forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}

-(void) createButtonsFromArray:(NSArray *) arr{
    
    double xcoord = 1;
    double yheight = 1;
    for (NSString *btn in self.categories) {
        
        
//        sizeWithFont:[UIFont systemFontOfSize:14]
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:btn forState:UIControlStateNormal];
        
        CGSize stringsize = [btn sizeWithAttributes: @{NSFontAttributeName:
                                                           [UIFont systemFontOfSize:17.0f]}];

    
        [button setFrame:CGRectMake(xcoord,1,stringsize.width+10, stringsize.height)];
        
        yheight = stringsize.height;
        xcoord += stringsize.width+20;
        [self.scrollView addSubview:button];
        
    }
    
    
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(xcoord, yheight)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
