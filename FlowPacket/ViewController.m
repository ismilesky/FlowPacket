//
//  ViewController.m
//  PacketFlow
//
//  Created by VS on 16/1/13.
//  Copyright © 2016年 VS. All rights reserved.
//

#define IMAGENAMED(NAME)        [UIImage imageNamed:NAME]
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define IMAGE_X                arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
#define IMAGE_WIDTH            arc4random()%20 + 20
#define PLUS_HEIGHT            Main_Screen_Height/25

#define kTotleTime MAXFLOAT

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *packets;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger totleTime;

@property (weak, nonatomic) IBOutlet UIImageView *packetImgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _packets = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 12; ++ i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(IMAGE_X, -130, 125, 130);
        imageView.image = [UIImage imageNamed:@"packet"];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [_packets addObject:imageView];
        [self.view addSubview:imageView];
    }
    _totleTime = kTotleTime;
   _timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(packetFlow) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    UITapGestureRecognizer *tagGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPacket:)];
    [self.view addGestureRecognizer:tagGR];
}

- (void)onClickPacket:(UITapGestureRecognizer *)tapGR {
    
    CGPoint touchPoint = [tapGR locationInView:tapGR.view];
    
    for (UIImageView *imageView in [self.view subviews]) {
        if ([imageView.layer.presentationLayer hitTest:touchPoint]) {
            
//            NSLog(@"%d",imageView.tag);
            imageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            imageView.transform = CGAffineTransformMakeScale(3, 3);
            [UIView animateWithDuration:0.3 animations:^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""message:@"🎁,抢到了红包了哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                imageView.transform = CGAffineTransformIdentity;
            }];
            
            break;
        }
    }
}

- (UIImageView *)packetViewWithPoint:(CGPoint)point {
    __block UIImageView *destView = nil;
    [_packets enumerateObjectsUsingBlock:^(UIImageView *packetView, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(packetView.frame, point)) {
            destView = packetView;
            *stop = YES;
        }
    }];
    return destView;
}

static int i = 0;
- (void)packetFlow {
    if (_totleTime > 0) {
        _totleTime-- ;
        i = i + 1;
        if ([_packets count] > 0) {
            UIImageView *imageView = [_packets objectAtIndex:0];
            imageView.tag = i;
            [self packetsFall:imageView];
            [_packets removeObjectAtIndex:0];
        }
    } else {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)packetsFall:(UIImageView *)aImageView {
    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)aImageView.tag] context:nil];
    [UIView setAnimationDuration:5];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
    float x = IMAGE_WIDTH;
    imageView.frame = CGRectMake(IMAGE_X, -130, 125, 130);
    [_packets addObject:imageView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
       
    }
}



@end
