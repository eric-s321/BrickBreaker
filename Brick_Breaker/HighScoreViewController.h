

#import <UIKit/UIKit.h>
#import "Universe.h"
#import "HighScore.h"

@interface HighScoreViewController : UIViewController{
    NSMutableArray *highScores;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

