
#ifndef GameOverViewController_h
#define GameOverViewController_h

#import <UIKit/UIKit.h>
#import "Universe.h"

@interface GameOverViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;

-(IBAction)submitHighScore;
-(IBAction)dismissKeyboard:(id)sender;

@end


#endif /* GameOverViewController_h */
