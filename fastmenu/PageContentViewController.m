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



@end

@implementation PageContentViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    
    
    self.titleLabel.text = self.category;
    [self createMenuItemButtonsFromArray:self.list];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createMenuItemButtonsFromArray:(NSArray *) arr{
    
    double xcoord = 1;
    double yheight = 20;
    for (NSDictionary *item in arr) {
        
        NSString *btnname = [item objectForKey:@"name"];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:btnname forState:UIControlStateNormal];
        
        CGSize stringsize = [btnname sizeWithAttributes: @{NSFontAttributeName:
                                                           [UIFont systemFontOfSize:17.0f]}];
        
        
        [button setFrame:CGRectMake(1,yheight,stringsize.width+10, stringsize.height)];
        
        yheight += stringsize.height;
        //xcoord += stringsize.width+20;
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
