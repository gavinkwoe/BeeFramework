#Step 1

1. Locate `bee.services.wizard` under `/services`
2. Then drag and drop it into your project.
3. \#import "bee.services.wizard.h"

#Step 2

<pre>
bee.services.wizard.config.showPageControl = YES;
bee.services.wizard.config.pageDotSize = CGSizeMake( 22.0f, 22.0f );
bee.services.wizard.config.pageDotNormal = ...;
bee.services.wizard.config.pageDotHighlighted = ...;
bee.services.wizard.config.pageDotLast = ...;

bee.services.wizard.config.splashes[0] = @"splash1.xml";
bee.services.wizard.config.splashes[1] = @"splash2.xml";
bee.services.wizard.config.splashes[2] = @"splash3.xml";
bee.services.wizard.config.splashes[3] = @"splash4.xml";

bee.services.wizard.whenShown = ^{
	// TODO:		
};
bee.services.wizard.whenSkipped = ^{
	// TODO:
};
</pre>

#Step 3

<pre>
bee.services.wizard.ON();
bee.services.wizard.OFF();
</pre>

#Good luck
