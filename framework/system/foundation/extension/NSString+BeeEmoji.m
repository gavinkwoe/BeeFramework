//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "NSString+BeeEmoji.h"

#import "Bee_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

static NSDictionary *			__emojiUnicodes = nil;
static NSMutableDictionary *	__emojiSmileys = nil;
static NSMutableCharacterSet *	__emojiCharacterSet = nil;

#pragma mark -

static unsigned charTo4Bits( char c )
{
    unsigned bits = 0;
	
    if ( c > '/' && c <':' )
	{
        bits = c - '0';
    }
	else if ( c > '@' && c < 'G' )
	{
        bits = (c - 'A') + 10;
    }
	else if ( c > '`' && c < 'g' )
	{
        bits = (c - 'a') + 10;
    }
	else
	{
        bits = 255;
    }
	
    return bits;
}

#pragma mark -

@implementation NSString(BeeEmoji)

+ (void)setupEmojiUnicode
{
    static dispatch_once_t onceToken;
	
    dispatch_once( &onceToken, ^
	{
		__emojiUnicodes = [@{ \
							 @":+1:"                                : @"\U0001F44D", \
							 @":-1:"                                : @"\U0001F44E", \
							 @":100:"                               : @"\U0001F4AF", \
							 @":1234:"                              : @"\U0001F522", \
							 @":8ball:"                             : @"\U0001F3B1", \
							 @":a:"                                 : @"\U0001F170", \
							 @":ab:"                                : @"\U0001F18E", \
							 @":abc:"                               : @"\U0001F524", \
							 @":abcd:"                              : @"\U0001F521", \
							 @":accept:"                            : @"\U0001F251", \
							 @":aerial_tramway:"                    : @"\U0001F6A1", \
							 @":airplane:"                          : @"\U00002708", \
							 @":alarm_clock:"                       : @"\U000023F0", \
							 @":alien:"                             : @"\U0001F47D", \
							 @":ambulance:"                         : @"\U0001F691", \
							 @":anchor:"                            : @"\U00002693", \
							 @":angel:"                             : @"\U0001F47C", \
							 @":anger:"                             : @"\U0001F4A2", \
							 @":angry:"                             : @"\U0001F620", \
							 @":anguished:"                         : @"\U0001F627", \
							 @":ant:"                               : @"\U0001F41C", \
							 @":apple:"                             : @"\U0001F34E", \
							 @":aquarius:"                          : @"\U00002652", \
							 @":aries:"                             : @"\U00002648", \
							 @":arrow_backward:"                    : @"\U000025C0", \
							 @":arrow_double_down:"                 : @"\U000023EC", \
							 @":arrow_double_up:"                   : @"\U000023EB", \
							 @":arrow_down:"                        : @"\U00002B07", \
							 @":arrow_down_small:"                  : @"\U0001F53D", \
							 @":arrow_forward:"                     : @"\U000025B6", \
							 @":arrow_heading_down:"                : @"\U00002935", \
							 @":arrow_heading_up:"                  : @"\U00002934", \
							 @":arrow_left:"                        : @"\U00002B05", \
							 @":arrow_lower_left:"                  : @"\U00002199", \
							 @":arrow_lower_right:"                 : @"\U00002198", \
							 @":arrow_right:"                       : @"\U000027A1", \
							 @":arrow_right_hook:"                  : @"\U000021AA", \
							 @":arrow_up:"                          : @"\U00002B06", \
							 @":arrow_up_down:"                     : @"\U00002195", \
							 @":arrow_up_small:"                    : @"\U0001F53C", \
							 @":arrow_upper_left:"                  : @"\U00002196", \
							 @":arrow_upper_right:"                 : @"\U00002197", \
							 @":arrows_clockwise:"                  : @"\U0001F503", \
							 @":arrows_counterclockwise:"           : @"\U0001F504", \
							 @":art:"                               : @"\U0001F3A8", \
							 @":articulated_lorry:"                 : @"\U0001F69B", \
							 @":astonished:"                        : @"\U0001F632", \
							 @":athletic_shoe:"                     : @"\U0001F45F", \
							 @":atm:"                               : @"\U0001F3E7", \
							 @":b:"                                 : @"\U0001F171", \
							 @":baby:"                              : @"\U0001F476", \
							 @":baby_bottle:"                       : @"\U0001F37C", \
							 @":baby_chick:"                        : @"\U0001F424", \
							 @":baby_symbol:"                       : @"\U0001F6BC", \
							 @":back:"                              : @"\U0001F519", \
							 @":baggage_claim:"                     : @"\U0001F6C4", \
							 @":balloon:"                           : @"\U0001F388", \
							 @":ballot_box_with_check:"             : @"\U00002611", \
							 @":bamboo:"                            : @"\U0001F38D", \
							 @":banana:"                            : @"\U0001F34C", \
							 @":bangbang:"                          : @"\U0000203C", \
							 @":bank:"                              : @"\U0001F3E6", \
							 @":bar_chart:"                         : @"\U0001F4CA", \
							 @":barber:"                            : @"\U0001F488", \
							 @":baseball:"                          : @"\U000026BE", \
							 @":basketball:"                        : @"\U0001F3C0", \
							 @":bath:"                              : @"\U0001F6C0", \
							 @":bathtub:"                           : @"\U0001F6C1", \
							 @":battery:"                           : @"\U0001F50B", \
							 @":bear:"                              : @"\U0001F43B", \
							 @":bee:"                               : @"\U0001F41D", \
							 @":beer:"                              : @"\U0001F37A", \
							 @":beers:"                             : @"\U0001F37B", \
							 @":beetle:"                            : @"\U0001F41E", \
							 @":beginner:"                          : @"\U0001F530", \
							 @":bell:"                              : @"\U0001F514", \
							 @":bento:"                             : @"\U0001F371", \
							 @":bicyclist:"                         : @"\U0001F6B4", \
							 @":bike:"                              : @"\U0001F6B2", \
							 @":bikini:"                            : @"\U0001F459", \
							 @":bird:"                              : @"\U0001F426", \
							 @":birthday:"                          : @"\U0001F382", \
							 @":black_circle:"                      : @"\U000026AB", \
							 @":black_joker:"                       : @"\U0001F0CF", \
							 @":black_large_square:"                : @"\U00002B1B", \
							 @":black_medium_small_square:"         : @"\U000025FE", \
							 @":black_medium_square:"               : @"\U000025FC", \
							 @":black_nib:"                         : @"\U00002712", \
							 @":black_small_square:"                : @"\U000025AA", \
							 @":black_square_button:"               : @"\U0001F532", \
							 @":blossom:"                           : @"\U0001F33C", \
							 @":blowfish:"                          : @"\U0001F421", \
							 @":blue_book:"                         : @"\U0001F4D8", \
							 @":blue_car:"                          : @"\U0001F699", \
							 @":blue_heart:"                        : @"\U0001F499", \
							 @":blush:"                             : @"\U0001F60A", \
							 @":boar:"                              : @"\U0001F417", \
							 @":boat:"                              : @"\U000026F5", \
							 @":bomb:"                              : @"\U0001F4A3", \
							 @":book:"                              : @"\U0001F4D6", \
							 @":bookmark:"                          : @"\U0001F516", \
							 @":bookmark_tabs:"                     : @"\U0001F4D1", \
							 @":books:"                             : @"\U0001F4DA", \
							 @":boom:"                              : @"\U0001F4A5", \
							 @":boot:"                              : @"\U0001F462", \
							 @":bouquet:"                           : @"\U0001F490", \
							 @":bow:"                               : @"\U0001F647", \
							 @":bowling:"                           : @"\U0001F3B3", \
							 @":boy:"                               : @"\U0001F466", \
							 @":bread:"                             : @"\U0001F35E", \
							 @":bride_with_veil:"                   : @"\U0001F470", \
							 @":bridge_at_night:"                   : @"\U0001F309", \
							 @":briefcase:"                         : @"\U0001F4BC", \
							 @":broken_heart:"                      : @"\U0001F494", \
							 @":bug:"                               : @"\U0001F41B", \
							 @":bulb:"                              : @"\U0001F4A1", \
							 @":bullettrain_front:"                 : @"\U0001F685", \
							 @":bullettrain_side:"                  : @"\U0001F684", \
							 @":bus:"                               : @"\U0001F68C", \
							 @":busstop:"                           : @"\U0001F68F", \
							 @":bust_in_silhouette:"                : @"\U0001F464", \
							 @":busts_in_silhouette:"               : @"\U0001F465", \
							 @":cactus:"                            : @"\U0001F335", \
							 @":cake:"                              : @"\U0001F370", \
							 @":calendar:"                          : @"\U0001F4C6", \
							 @":calling:"                           : @"\U0001F4F2", \
							 @":camel:"                             : @"\U0001F42B", \
							 @":camera:"                            : @"\U0001F4F7", \
							 @":cancer:"                            : @"\U0000264B", \
							 @":candy:"                             : @"\U0001F36C", \
							 @":capital_abcd:"                      : @"\U0001F520", \
							 @":capricorn:"                         : @"\U00002651", \
							 @":car:"                               : @"\U0001F697", \
							 @":card_index:"                        : @"\U0001F4C7", \
							 @":carousel_horse:"                    : @"\U0001F3A0", \
							 @":cat:"                               : @"\U0001F431", \
							 @":cat2:"                              : @"\U0001F408", \
							 @":cd:"                                : @"\U0001F4BF", \
							 @":chart:"                             : @"\U0001F4B9", \
							 @":chart_with_downwards_trend:"        : @"\U0001F4C9", \
							 @":chart_with_upwards_trend:"          : @"\U0001F4C8", \
							 @":checkered_flag:"                    : @"\U0001F3C1", \
							 @":cherries:"                          : @"\U0001F352", \
							 @":cherry_blossom:"                    : @"\U0001F338", \
							 @":chestnut:"                          : @"\U0001F330", \
							 @":chicken:"                           : @"\U0001F414", \
							 @":children_crossing:"                 : @"\U0001F6B8", \
							 @":chocolate_bar:"                     : @"\U0001F36B", \
							 @":christmas_tree:"                    : @"\U0001F384", \
							 @":church:"                            : @"\U000026EA", \
							 @":cinema:"                            : @"\U0001F3A6", \
							 @":circus_tent:"                       : @"\U0001F3AA", \
							 @":city_sunrise:"                      : @"\U0001F307", \
							 @":city_sunset:"                       : @"\U0001F306", \
							 @":cl:"                                : @"\U0001F191", \
							 @":clap:"                              : @"\U0001F44F", \
							 @":clapper:"                           : @"\U0001F3AC", \
							 @":clipboard:"                         : @"\U0001F4CB", \
							 @":clock1:"                            : @"\U0001F550", \
							 @":clock10:"                           : @"\U0001F559", \
							 @":clock1030:"                         : @"\U0001F565", \
							 @":clock11:"                           : @"\U0001F55A", \
							 @":clock1130:"                         : @"\U0001F566", \
							 @":clock12:"                           : @"\U0001F55B", \
							 @":clock1230:"                         : @"\U0001F567", \
							 @":clock130:"                          : @"\U0001F55C", \
							 @":clock2:"                            : @"\U0001F551", \
							 @":clock230:"                          : @"\U0001F55D", \
							 @":clock3:"                            : @"\U0001F552", \
							 @":clock330:"                          : @"\U0001F55E", \
							 @":clock4:"                            : @"\U0001F553", \
							 @":clock430:"                          : @"\U0001F55F", \
							 @":clock5:"                            : @"\U0001F554", \
							 @":clock530:"                          : @"\U0001F560", \
							 @":clock6:"                            : @"\U0001F555", \
							 @":clock630:"                          : @"\U0001F561", \
							 @":clock7:"                            : @"\U0001F556", \
							 @":clock730:"                          : @"\U0001F562", \
							 @":clock8:"                            : @"\U0001F557", \
							 @":clock830:"                          : @"\U0001F563", \
							 @":clock9:"                            : @"\U0001F558", \
							 @":clock930:"                          : @"\U0001F564", \
							 @":closed_book:"                       : @"\U0001F4D5", \
							 @":closed_lock_with_key:"              : @"\U0001F510", \
							 @":closed_umbrella:"                   : @"\U0001F302", \
							 @":cloud:"                             : @"\U00002601", \
							 @":clubs:"                             : @"\U00002663", \
							 @":cocktail:"                          : @"\U0001F378", \
							 @":coffee:"                            : @"\U00002615", \
							 @":cold_sweat:"                        : @"\U0001F630", \
							 @":collision:"                         : @"\U0001F4A5", \
							 @":computer:"                          : @"\U0001F4BB", \
							 @":confetti_ball:"                     : @"\U0001F38A", \
							 @":confounded:"                        : @"\U0001F616", \
							 @":confused:"                          : @"\U0001F615", \
							 @":congratulations:"                   : @"\U00003297", \
							 @":construction:"                      : @"\U0001F6A7", \
							 @":construction_worker:"               : @"\U0001F477", \
							 @":convenience_store:"                 : @"\U0001F3EA", \
							 @":cookie:"                            : @"\U0001F36A", \
							 @":cool:"                              : @"\U0001F192", \
							 @":cop:"                               : @"\U0001F46E", \
							 @":copyright:"                         : @"\U000000A9", \
							 @":corn:"                              : @"\U0001F33D", \
							 @":couple:"                            : @"\U0001F46B", \
							 @":couple_with_heart:"                 : @"\U0001F491", \
							 @":couplekiss:"                        : @"\U0001F48F", \
							 @":cow:"                               : @"\U0001F42E", \
							 @":cow2:"                              : @"\U0001F404", \
							 @":credit_card:"                       : @"\U0001F4B3", \
							 @":crescent_moon:"                     : @"\U0001F319", \
							 @":crocodile:"                         : @"\U0001F40A", \
							 @":crossed_flags:"                     : @"\U0001F38C", \
							 @":crown:"                             : @"\U0001F451", \
							 @":cry:"                               : @"\U0001F622", \
							 @":crying_cat_face:"                   : @"\U0001F63F", \
							 @":crystal_ball:"                      : @"\U0001F52E", \
							 @":cupid:"                             : @"\U0001F498", \
							 @":curly_loop:"                        : @"\U000027B0", \
							 @":currency_exchange:"                 : @"\U0001F4B1", \
							 @":curry:"                             : @"\U0001F35B", \
							 @":custard:"                           : @"\U0001F36E", \
							 @":customs:"                           : @"\U0001F6C3", \
							 @":cyclone:"                           : @"\U0001F300", \
							 @":dancer:"                            : @"\U0001F483", \
							 @":dancers:"                           : @"\U0001F46F", \
							 @":dango:"                             : @"\U0001F361", \
							 @":dart:"                              : @"\U0001F3AF", \
							 @":dash:"                              : @"\U0001F4A8", \
							 @":date:"                              : @"\U0001F4C5", \
							 @":deciduous_tree:"                    : @"\U0001F333", \
							 @":department_store:"                  : @"\U0001F3EC", \
							 @":diamond_shape_with_a_dot_inside:"   : @"\U0001F4A0", \
							 @":diamonds:"                          : @"\U00002666", \
							 @":disappointed:"                      : @"\U0001F61E", \
							 @":disappointed_relieved:"             : @"\U0001F625", \
							 @":dizzy:"                             : @"\U0001F4AB", \
							 @":dizzy_face:"                        : @"\U0001F635", \
							 @":do_not_litter:"                     : @"\U0001F6AF", \
							 @":dog:"                               : @"\U0001F436", \
							 @":dog2:"                              : @"\U0001F415", \
							 @":dollar:"                            : @"\U0001F4B5", \
							 @":dolls:"                             : @"\U0001F38E", \
							 @":dolphin:"                           : @"\U0001F42C", \
							 @":door:"                              : @"\U0001F6AA", \
							 @":doughnut:"                          : @"\U0001F369", \
							 @":dragon:"                            : @"\U0001F409", \
							 @":dragon_face:"                       : @"\U0001F432", \
							 @":dress:"                             : @"\U0001F457", \
							 @":dromedary_camel:"                   : @"\U0001F42A", \
							 @":droplet:"                           : @"\U0001F4A7", \
							 @":dvd:"                               : @"\U0001F4C0", \
							 @":e-mail:"                            : @"\U0001F4E7", \
							 @":ear:"                               : @"\U0001F442", \
							 @":ear_of_rice:"                       : @"\U0001F33E", \
							 @":earth_africa:"                      : @"\U0001F30D", \
							 @":earth_americas:"                    : @"\U0001F30E", \
							 @":earth_asia:"                        : @"\U0001F30F", \
							 @":egg:"                               : @"\U0001F373", \
							 @":eggplant:"                          : @"\U0001F346", \
							 @":eight_pointed_black_star:"          : @"\U00002734", \
							 @":eight_spoked_asterisk:"             : @"\U00002733", \
							 @":electric_plug:"                     : @"\U0001F50C", \
							 @":elephant:"                          : @"\U0001F418", \
							 @":email:"                             : @"\U00002709", \
							 @":end:"                               : @"\U0001F51A", \
							 @":envelope:"                          : @"\U00002709", \
							 @":envelope_with_arrow:"               : @"\U0001F4E9", \
							 @":euro:"                              : @"\U0001F4B6", \
							 @":european_castle:"                   : @"\U0001F3F0", \
							 @":european_post_office:"              : @"\U0001F3E4", \
							 @":evergreen_tree:"                    : @"\U0001F332", \
							 @":exclamation:"                       : @"\U00002757", \
							 @":expressionless:"                    : @"\U0001F611", \
							 @":eyeglasses:"                        : @"\U0001F453", \
							 @":eyes:"                              : @"\U0001F440", \
							 @":facepunch:"                         : @"\U0001F44A", \
							 @":factory:"                           : @"\U0001F3ED", \
							 @":fallen_leaf:"                       : @"\U0001F342", \
							 @":family:"                            : @"\U0001F46A", \
							 @":fast_forward:"                      : @"\U000023E9", \
							 @":fax:"                               : @"\U0001F4E0", \
							 @":fearful:"                           : @"\U0001F628", \
							 @":feet:"                              : @"\U0001F43E", \
							 @":ferris_wheel:"                      : @"\U0001F3A1", \
							 @":file_folder:"                       : @"\U0001F4C1", \
							 @":fire:"                              : @"\U0001F525", \
							 @":fire_engine:"                       : @"\U0001F692", \
							 @":fireworks:"                         : @"\U0001F386", \
							 @":first_quarter_moon:"                : @"\U0001F313", \
							 @":first_quarter_moon_with_face:"      : @"\U0001F31B", \
							 @":fish:"                              : @"\U0001F41F", \
							 @":fish_cake:"                         : @"\U0001F365", \
							 @":fishing_pole_and_fish:"             : @"\U0001F3A3", \
							 @":fist:"                              : @"\U0000270A", \
							 @":flags:"                             : @"\U0001F38F", \
							 @":flashlight:"                        : @"\U0001F526", \
							 @":flipper:"                           : @"\U0001F42C", \
							 @":floppy_disk:"                       : @"\U0001F4BE", \
							 @":flower_playing_cards:"              : @"\U0001F3B4", \
							 @":flushed:"                           : @"\U0001F633", \
							 @":foggy:"                             : @"\U0001F301", \
							 @":football:"                          : @"\U0001F3C8", \
							 @":footprints:"                        : @"\U0001F463", \
							 @":fork_and_knife:"                    : @"\U0001F374", \
							 @":fountain:"                          : @"\U000026F2", \
							 @":four_leaf_clover:"                  : @"\U0001F340", \
							 @":free:"                              : @"\U0001F193", \
							 @":fried_shrimp:"                      : @"\U0001F364", \
							 @":fries:"                             : @"\U0001F35F", \
							 @":frog:"                              : @"\U0001F438", \
							 @":frowning:"                          : @"\U0001F626", \
							 @":fuelpump:"                          : @"\U000026FD", \
							 @":full_moon:"                         : @"\U0001F315", \
							 @":full_moon_with_face:"               : @"\U0001F31D", \
							 @":game_die:"                          : @"\U0001F3B2", \
							 @":gem:"                               : @"\U0001F48E", \
							 @":gemini:"                            : @"\U0000264A", \
							 @":ghost:"                             : @"\U0001F47B", \
							 @":gift:"                              : @"\U0001F381", \
							 @":gift_heart:"                        : @"\U0001F49D", \
							 @":girl:"                              : @"\U0001F467", \
							 @":globe_with_meridians:"              : @"\U0001F310", \
							 @":goat:"                              : @"\U0001F410", \
							 @":golf:"                              : @"\U000026F3", \
							 @":grapes:"                            : @"\U0001F347", \
							 @":green_apple:"                       : @"\U0001F34F", \
							 @":green_book:"                        : @"\U0001F4D7", \
							 @":green_heart:"                       : @"\U0001F49A", \
							 @":grey_exclamation:"                  : @"\U00002755", \
							 @":grey_question:"                     : @"\U00002754", \
							 @":grimacing:"                         : @"\U0001F62C", \
							 @":grin:"                              : @"\U0001F601", \
							 @":grinning:"                          : @"\U0001F600", \
							 @":guardsman:"                         : @"\U0001F482", \
							 @":guitar:"                            : @"\U0001F3B8", \
							 @":gun:"                               : @"\U0001F52B", \
							 @":haircut:"                           : @"\U0001F487", \
							 @":hamburger:"                         : @"\U0001F354", \
							 @":hammer:"                            : @"\U0001F528", \
							 @":hamster:"                           : @"\U0001F439", \
							 @":hand:"                              : @"\U0000270B", \
							 @":handbag:"                           : @"\U0001F45C", \
							 @":hankey:"                            : @"\U0001F4A9", \
							 @":hatched_chick:"                     : @"\U0001F425", \
							 @":hatching_chick:"                    : @"\U0001F423", \
							 @":headphones:"                        : @"\U0001F3A7", \
							 @":hear_no_evil:"                      : @"\U0001F649", \
							 @":heart:"                             : @"\U00002764", \
							 @":heart_decoration:"                  : @"\U0001F49F", \
							 @":heart_eyes:"                        : @"\U0001F60D", \
							 @":heart_eyes_cat:"                    : @"\U0001F63B", \
							 @":heartbeat:"                         : @"\U0001F493", \
							 @":heartpulse:"                        : @"\U0001F497", \
							 @":hearts:"                            : @"\U00002665", \
							 @":heavy_check_mark:"                  : @"\U00002714", \
							 @":heavy_division_sign:"               : @"\U00002797", \
							 @":heavy_dollar_sign:"                 : @"\U0001F4B2", \
							 @":heavy_exclamation_mark:"            : @"\U00002757", \
							 @":heavy_minus_sign:"                  : @"\U00002796", \
							 @":heavy_multiplication_x:"            : @"\U00002716", \
							 @":heavy_plus_sign:"                   : @"\U00002795", \
							 @":helicopter:"                        : @"\U0001F681", \
							 @":herb:"                              : @"\U0001F33F", \
							 @":hibiscus:"                          : @"\U0001F33A", \
							 @":high_brightness:"                   : @"\U0001F506", \
							 @":high_heel:"                         : @"\U0001F460", \
							 @":hocho:"                             : @"\U0001F52A", \
							 @":honey_pot:"                         : @"\U0001F36F", \
							 @":honeybee:"                          : @"\U0001F41D", \
							 @":horse:"                             : @"\U0001F434", \
							 @":horse_racing:"                      : @"\U0001F3C7", \
							 @":hospital:"                          : @"\U0001F3E5", \
							 @":hotel:"                             : @"\U0001F3E8", \
							 @":hotsprings:"                        : @"\U00002668", \
							 @":hourglass:"                         : @"\U0000231B", \
							 @":hourglass_flowing_sand:"            : @"\U000023F3", \
							 @":house:"                             : @"\U0001F3E0", \
							 @":house_with_garden:"                 : @"\U0001F3E1", \
							 @":hushed:"                            : @"\U0001F62F", \
							 @":ice_cream:"                         : @"\U0001F368", \
							 @":icecream:"                          : @"\U0001F366", \
							 @":id:"                                : @"\U0001F194", \
							 @":ideograph_advantage:"               : @"\U0001F250", \
							 @":imp:"                               : @"\U0001F47F", \
							 @":inbox_tray:"                        : @"\U0001F4E5", \
							 @":incoming_envelope:"                 : @"\U0001F4E8", \
							 @":information_desk_person:"           : @"\U0001F481", \
							 @":information_source:"                : @"\U00002139", \
							 @":innocent:"                          : @"\U0001F607", \
							 @":interrobang:"                       : @"\U00002049", \
							 @":iphone:"                            : @"\U0001F4F1", \
							 @":izakaya_lantern:"                   : @"\U0001F3EE", \
							 @":jack_o_lantern:"                    : @"\U0001F383", \
							 @":japan:"                             : @"\U0001F5FE", \
							 @":japanese_castle:"                   : @"\U0001F3EF", \
							 @":japanese_goblin:"                   : @"\U0001F47A", \
							 @":japanese_ogre:"                     : @"\U0001F479", \
							 @":jeans:"                             : @"\U0001F456", \
							 @":joy:"                               : @"\U0001F602", \
							 @":joy_cat:"                           : @"\U0001F639", \
							 @":key:"                               : @"\U0001F511", \
							 @":keycap_ten:"                        : @"\U0001F51F", \
							 @":kimono:"                            : @"\U0001F458", \
							 @":kiss:"                              : @"\U0001F48B", \
							 @":kissing:"                           : @"\U0001F617", \
							 @":kissing_cat:"                       : @"\U0001F63D", \
							 @":kissing_closed_eyes:"               : @"\U0001F61A", \
							 @":kissing_heart:"                     : @"\U0001F618", \
							 @":kissing_smiling_eyes:"              : @"\U0001F619", \
							 @":koala:"                             : @"\U0001F428", \
							 @":koko:"                              : @"\U0001F201", \
							 @":lantern:"                           : @"\U0001F3EE", \
							 @":large_blue_circle:"                 : @"\U0001F535", \
							 @":large_blue_diamond:"                : @"\U0001F537", \
							 @":large_orange_diamond:"              : @"\U0001F536", \
							 @":last_quarter_moon:"                 : @"\U0001F317", \
							 @":last_quarter_moon_with_face:"       : @"\U0001F31C", \
							 @":laughing:"                          : @"\U0001F606", \
							 @":leaves:"                            : @"\U0001F343", \
							 @":ledger:"                            : @"\U0001F4D2", \
							 @":left_luggage:"                      : @"\U0001F6C5", \
							 @":left_right_arrow:"                  : @"\U00002194", \
							 @":leftwards_arrow_with_hook:"         : @"\U000021A9", \
							 @":lemon:"                             : @"\U0001F34B", \
							 @":leo:"                               : @"\U0000264C", \
							 @":leopard:"                           : @"\U0001F406", \
							 @":libra:"                             : @"\U0000264E", \
							 @":light_rail:"                        : @"\U0001F688", \
							 @":link:"                              : @"\U0001F517", \
							 @":lips:"                              : @"\U0001F444", \
							 @":lipstick:"                          : @"\U0001F484", \
							 @":lock:"                              : @"\U0001F512", \
							 @":lock_with_ink_pen:"                 : @"\U0001F50F", \
							 @":lollipop:"                          : @"\U0001F36D", \
							 @":loop:"                              : @"\U000027BF", \
							 @":loudspeaker:"                       : @"\U0001F4E2", \
							 @":love_hotel:"                        : @"\U0001F3E9", \
							 @":love_letter:"                       : @"\U0001F48C", \
							 @":low_brightness:"                    : @"\U0001F505", \
							 @":m:"                                 : @"\U000024C2", \
							 @":mag:"                               : @"\U0001F50D", \
							 @":mag_right:"                         : @"\U0001F50E", \
							 @":mahjong:"                           : @"\U0001F004", \
							 @":mailbox:"                           : @"\U0001F4EB", \
							 @":mailbox_closed:"                    : @"\U0001F4EA", \
							 @":mailbox_with_mail:"                 : @"\U0001F4EC", \
							 @":mailbox_with_no_mail:"              : @"\U0001F4ED", \
							 @":man:"                               : @"\U0001F468", \
							 @":man_with_gua_pi_mao:"               : @"\U0001F472", \
							 @":man_with_turban:"                   : @"\U0001F473", \
							 @":mans_shoe:"                         : @"\U0001F45E", \
							 @":maple_leaf:"                        : @"\U0001F341", \
							 @":mask:"                              : @"\U0001F637", \
							 @":massage:"                           : @"\U0001F486", \
							 @":meat_on_bone:"                      : @"\U0001F356", \
							 @":mega:"                              : @"\U0001F4E3", \
							 @":melon:"                             : @"\U0001F348", \
							 @":memo:"                              : @"\U0001F4DD", \
							 @":mens:"                              : @"\U0001F6B9", \
							 @":metro:"                             : @"\U0001F687", \
							 @":microphone:"                        : @"\U0001F3A4", \
							 @":microscope:"                        : @"\U0001F52C", \
							 @":milky_way:"                         : @"\U0001F30C", \
							 @":minibus:"                           : @"\U0001F690", \
							 @":minidisc:"                          : @"\U0001F4BD", \
							 @":mobile_phone_off:"                  : @"\U0001F4F4", \
							 @":money_with_wings:"                  : @"\U0001F4B8", \
							 @":moneybag:"                          : @"\U0001F4B0", \
							 @":monkey:"                            : @"\U0001F412", \
							 @":monkey_face:"                       : @"\U0001F435", \
							 @":monorail:"                          : @"\U0001F69D", \
							 @":moon:"                              : @"\U0001F314", \
							 @":mortar_board:"                      : @"\U0001F393", \
							 @":mount_fuji:"                        : @"\U0001F5FB", \
							 @":mountain_bicyclist:"                : @"\U0001F6B5", \
							 @":mountain_cableway:"                 : @"\U0001F6A0", \
							 @":mountain_railway:"                  : @"\U0001F69E", \
							 @":mouse:"                             : @"\U0001F42D", \
							 @":mouse2:"                            : @"\U0001F401", \
							 @":movie_camera:"                      : @"\U0001F3A5", \
							 @":moyai:"                             : @"\U0001F5FF", \
							 @":muscle:"                            : @"\U0001F4AA", \
							 @":mushroom:"                          : @"\U0001F344", \
							 @":musical_keyboard:"                  : @"\U0001F3B9", \
							 @":musical_note:"                      : @"\U0001F3B5", \
							 @":musical_score:"                     : @"\U0001F3BC", \
							 @":mute:"                              : @"\U0001F507", \
							 @":nail_care:"                         : @"\U0001F485", \
							 @":name_badge:"                        : @"\U0001F4DB", \
							 @":necktie:"                           : @"\U0001F454", \
							 @":negative_squared_cross_mark:"       : @"\U0000274E", \
							 @":neutral_face:"                      : @"\U0001F610", \
							 @":new:"                               : @"\U0001F195", \
							 @":new_moon:"                          : @"\U0001F311", \
							 @":new_moon_with_face:"                : @"\U0001F31A", \
							 @":newspaper:"                         : @"\U0001F4F0", \
							 @":ng:"                                : @"\U0001F196", \
							 @":no_bell:"                           : @"\U0001F515", \
							 @":no_bicycles:"                       : @"\U0001F6B3", \
							 @":no_entry:"                          : @"\U000026D4", \
							 @":no_entry_sign:"                     : @"\U0001F6AB", \
							 @":no_good:"                           : @"\U0001F645", \
							 @":no_mobile_phones:"                  : @"\U0001F4F5", \
							 @":no_mouth:"                          : @"\U0001F636", \
							 @":no_pedestrians:"                    : @"\U0001F6B7", \
							 @":no_smoking:"                        : @"\U0001F6AD", \
							 @":non-potable_water:"                 : @"\U0001F6B1", \
							 @":nose:"                              : @"\U0001F443", \
							 @":notebook:"                          : @"\U0001F4D3", \
							 @":notebook_with_decorative_cover:"    : @"\U0001F4D4", \
							 @":notes:"                             : @"\U0001F3B6", \
							 @":nut_and_bolt:"                      : @"\U0001F529", \
							 @":o:"                                 : @"\U00002B55", \
							 @":o2:"                                : @"\U0001F17E", \
							 @":ocean:"                             : @"\U0001F30A", \
							 @":octopus:"                           : @"\U0001F419", \
							 @":oden:"                              : @"\U0001F362", \
							 @":office:"                            : @"\U0001F3E2", \
							 @":ok:"                                : @"\U0001F197", \
							 @":ok_hand:"                           : @"\U0001F44C", \
							 @":ok_woman:"                          : @"\U0001F646", \
							 @":older_man:"                         : @"\U0001F474", \
							 @":older_woman:"                       : @"\U0001F475", \
							 @":on:"                                : @"\U0001F51B", \
							 @":oncoming_automobile:"               : @"\U0001F698", \
							 @":oncoming_bus:"                      : @"\U0001F68D", \
							 @":oncoming_police_car:"               : @"\U0001F694", \
							 @":oncoming_taxi:"                     : @"\U0001F696", \
							 @":open_book:"                         : @"\U0001F4D6", \
							 @":open_file_folder:"                  : @"\U0001F4C2", \
							 @":open_hands:"                        : @"\U0001F450", \
							 @":open_mouth:"                        : @"\U0001F62E", \
							 @":ophiuchus:"                         : @"\U000026CE", \
							 @":orange_book:"                       : @"\U0001F4D9", \
							 @":outbox_tray:"                       : @"\U0001F4E4", \
							 @":ox:"                                : @"\U0001F402", \
							 @":package:"                           : @"\U0001F4E6", \
							 @":page_facing_up:"                    : @"\U0001F4C4", \
							 @":page_with_curl:"                    : @"\U0001F4C3", \
							 @":pager:"                             : @"\U0001F4DF", \
							 @":palm_tree:"                         : @"\U0001F334", \
							 @":panda_face:"                        : @"\U0001F43C", \
							 @":paperclip:"                         : @"\U0001F4CE", \
							 @":parking:"                           : @"\U0001F17F", \
							 @":part_alternation_mark:"             : @"\U0000303D", \
							 @":partly_sunny:"                      : @"\U000026C5", \
							 @":passport_control:"                  : @"\U0001F6C2", \
							 @":paw_prints:"                        : @"\U0001F43E", \
							 @":peach:"                             : @"\U0001F351", \
							 @":pear:"                              : @"\U0001F350", \
							 @":pencil:"                            : @"\U0001F4DD", \
							 @":pencil2:"                           : @"\U0000270F", \
							 @":penguin:"                           : @"\U0001F427", \
							 @":pensive:"                           : @"\U0001F614", \
							 @":performing_arts:"                   : @"\U0001F3AD", \
							 @":persevere:"                         : @"\U0001F623", \
							 @":person_frowning:"                   : @"\U0001F64D", \
							 @":person_with_blond_hair:"            : @"\U0001F471", \
							 @":person_with_pouting_face:"          : @"\U0001F64E", \
							 @":phone:"                             : @"\U0000260E", \
							 @":pig:"                               : @"\U0001F437", \
							 @":pig2:"                              : @"\U0001F416", \
							 @":pig_nose:"                          : @"\U0001F43D", \
							 @":pill:"                              : @"\U0001F48A", \
							 @":pineapple:"                         : @"\U0001F34D", \
							 @":pisces:"                            : @"\U00002653", \
							 @":pizza:"                             : @"\U0001F355", \
							 @":point_down:"                        : @"\U0001F447", \
							 @":point_left:"                        : @"\U0001F448", \
							 @":point_right:"                       : @"\U0001F449", \
							 @":point_up:"                          : @"\U0000261D", \
							 @":point_up_2:"                        : @"\U0001F446", \
							 @":police_car:"                        : @"\U0001F693", \
							 @":poodle:"                            : @"\U0001F429", \
							 @":poop:"                              : @"\U0001F4A9", \
							 @":post_office:"                       : @"\U0001F3E3", \
							 @":postal_horn:"                       : @"\U0001F4EF", \
							 @":postbox:"                           : @"\U0001F4EE", \
							 @":potable_water:"                     : @"\U0001F6B0", \
							 @":pouch:"                             : @"\U0001F45D", \
							 @":poultry_leg:"                       : @"\U0001F357", \
							 @":pound:"                             : @"\U0001F4B7", \
							 @":pouting_cat:"                       : @"\U0001F63E", \
							 @":pray:"                              : @"\U0001F64F", \
							 @":princess:"                          : @"\U0001F478", \
							 @":punch:"                             : @"\U0001F44A", \
							 @":purple_heart:"                      : @"\U0001F49C", \
							 @":purse:"                             : @"\U0001F45B", \
							 @":pushpin:"                           : @"\U0001F4CC", \
							 @":put_litter_in_its_place:"           : @"\U0001F6AE", \
							 @":question:"                          : @"\U00002753", \
							 @":rabbit:"                            : @"\U0001F430", \
							 @":rabbit2:"                           : @"\U0001F407", \
							 @":racehorse:"                         : @"\U0001F40E", \
							 @":radio:"                             : @"\U0001F4FB", \
							 @":radio_button:"                      : @"\U0001F518", \
							 @":rage:"                              : @"\U0001F621", \
							 @":railway_car:"                       : @"\U0001F683", \
							 @":rainbow:"                           : @"\U0001F308", \
							 @":raised_hand:"                       : @"\U0000270B", \
							 @":raised_hands:"                      : @"\U0001F64C", \
							 @":raising_hand:"                      : @"\U0001F64B", \
							 @":ram:"                               : @"\U0001F40F", \
							 @":ramen:"                             : @"\U0001F35C", \
							 @":rat:"                               : @"\U0001F400", \
							 @":recycle:"                           : @"\U0000267B", \
							 @":red_car:"                           : @"\U0001F697", \
							 @":red_circle:"                        : @"\U0001F534", \
							 @":registered:"                        : @"\U000000AE", \
							 @":relaxed:"                           : @"\U0000263A", \
							 @":relieved:"                          : @"\U0001F60C", \
							 @":repeat:"                            : @"\U0001F501", \
							 @":repeat_one:"                        : @"\U0001F502", \
							 @":restroom:"                          : @"\U0001F6BB", \
							 @":revolving_hearts:"                  : @"\U0001F49E", \
							 @":rewind:"                            : @"\U000023EA", \
							 @":ribbon:"                            : @"\U0001F380", \
							 @":rice:"                              : @"\U0001F35A", \
							 @":rice_ball:"                         : @"\U0001F359", \
							 @":rice_cracker:"                      : @"\U0001F358", \
							 @":rice_scene:"                        : @"\U0001F391", \
							 @":ring:"                              : @"\U0001F48D", \
							 @":rocket:"                            : @"\U0001F680", \
							 @":roller_coaster:"                    : @"\U0001F3A2", \
							 @":rooster:"                           : @"\U0001F413", \
							 @":rose:"                              : @"\U0001F339", \
							 @":rotating_light:"                    : @"\U0001F6A8", \
							 @":round_pushpin:"                     : @"\U0001F4CD", \
							 @":rowboat:"                           : @"\U0001F6A3", \
							 @":rugby_football:"                    : @"\U0001F3C9", \
							 @":runner:"                            : @"\U0001F3C3", \
							 @":running:"                           : @"\U0001F3C3", \
							 @":running_shirt_with_sash:"           : @"\U0001F3BD", \
							 @":sa:"                                : @"\U0001F202", \
							 @":sagittarius:"                       : @"\U00002650", \
							 @":sailboat:"                          : @"\U000026F5", \
							 @":sake:"                              : @"\U0001F376", \
							 @":sandal:"                            : @"\U0001F461", \
							 @":santa:"                             : @"\U0001F385", \
							 @":satellite:"                         : @"\U0001F4E1", \
							 @":satisfied:"                         : @"\U0001F606", \
							 @":saxophone:"                         : @"\U0001F3B7", \
							 @":school:"                            : @"\U0001F3EB", \
							 @":school_satchel:"                    : @"\U0001F392", \
							 @":scissors:"                          : @"\U00002702", \
							 @":scorpius:"                          : @"\U0000264F", \
							 @":scream:"                            : @"\U0001F631", \
							 @":scream_cat:"                        : @"\U0001F640", \
							 @":scroll:"                            : @"\U0001F4DC", \
							 @":seat:"                              : @"\U0001F4BA", \
							 @":secret:"                            : @"\U00003299", \
							 @":see_no_evil:"                       : @"\U0001F648", \
							 @":seedling:"                          : @"\U0001F331", \
							 @":shaved_ice:"                        : @"\U0001F367", \
							 @":sheep:"                             : @"\U0001F411", \
							 @":shell:"                             : @"\U0001F41A", \
							 @":ship:"                              : @"\U0001F6A2", \
							 @":shirt:"                             : @"\U0001F455", \
							 @":shit:"                              : @"\U0001F4A9", \
							 @":shoe:"                              : @"\U0001F45E", \
							 @":shower:"                            : @"\U0001F6BF", \
							 @":signal_strength:"                   : @"\U0001F4F6", \
							 @":six_pointed_star:"                  : @"\U0001F52F", \
							 @":ski:"                               : @"\U0001F3BF", \
							 @":skull:"                             : @"\U0001F480", \
							 @":sleeping:"                          : @"\U0001F634", \
							 @":sleepy:"                            : @"\U0001F62A", \
							 @":slot_machine:"                      : @"\U0001F3B0", \
							 @":small_blue_diamond:"                : @"\U0001F539", \
							 @":small_orange_diamond:"              : @"\U0001F538", \
							 @":small_red_triangle:"                : @"\U0001F53A", \
							 @":small_red_triangle_down:"           : @"\U0001F53B", \
							 @":smile:"                             : @"\U0001F604", \
							 @":smile_cat:"                         : @"\U0001F638", \
							 @":smiley:"                            : @"\U0001F603", \
							 @":smiley_cat:"                        : @"\U0001F63A", \
							 @":smiling_imp:"                       : @"\U0001F608", \
							 @":smirk:"                             : @"\U0001F60F", \
							 @":smirk_cat:"                         : @"\U0001F63C", \
							 @":smoking:"                           : @"\U0001F6AC", \
							 @":snail:"                             : @"\U0001F40C", \
							 @":snake:"                             : @"\U0001F40D", \
							 @":snowboarder:"                       : @"\U0001F3C2", \
							 @":snowflake:"                         : @"\U00002744", \
							 @":snowman:"                           : @"\U000026C4", \
							 @":sob:"                               : @"\U0001F62D", \
							 @":soccer:"                            : @"\U000026BD", \
							 @":soon:"                              : @"\U0001F51C", \
							 @":sos:"                               : @"\U0001F198", \
							 @":sound:"                             : @"\U0001F509", \
							 @":space_invader:"                     : @"\U0001F47E", \
							 @":spades:"                            : @"\U00002660", \
							 @":spaghetti:"                         : @"\U0001F35D", \
							 @":sparkle:"                           : @"\U00002747", \
							 @":sparkler:"                          : @"\U0001F387", \
							 @":sparkles:"                          : @"\U00002728", \
							 @":sparkling_heart:"                   : @"\U0001F496", \
							 @":speak_no_evil:"                     : @"\U0001F64A", \
							 @":speaker:"                           : @"\U0001F50A", \
							 @":speech_balloon:"                    : @"\U0001F4AC", \
							 @":speedboat:"                         : @"\U0001F6A4", \
							 @":star:"                              : @"\U00002B50", \
							 @":star2:"                             : @"\U0001F31F", \
							 @":stars:"                             : @"\U0001F303", \
							 @":station:"                           : @"\U0001F689", \
							 @":statue_of_liberty:"                 : @"\U0001F5FD", \
							 @":steam_locomotive:"                  : @"\U0001F682", \
							 @":stew:"                              : @"\U0001F372", \
							 @":straight_ruler:"                    : @"\U0001F4CF", \
							 @":strawberry:"                        : @"\U0001F353", \
							 @":stuck_out_tongue:"                  : @"\U0001F61B", \
							 @":stuck_out_tongue_closed_eyes:"      : @"\U0001F61D", \
							 @":stuck_out_tongue_winking_eye:"      : @"\U0001F61C", \
							 @":sun_with_face:"                     : @"\U0001F31E", \
							 @":sunflower:"                         : @"\U0001F33B", \
							 @":sunglasses:"                        : @"\U0001F60E", \
							 @":sunny:"                             : @"\U00002600", \
							 @":sunrise:"                           : @"\U0001F305", \
							 @":sunrise_over_mountains:"            : @"\U0001F304", \
							 @":surfer:"                            : @"\U0001F3C4", \
							 @":sushi:"                             : @"\U0001F363", \
							 @":suspension_railway:"                : @"\U0001F69F", \
							 @":sweat:"                             : @"\U0001F613", \
							 @":sweat_drops:"                       : @"\U0001F4A6", \
							 @":sweat_smile:"                       : @"\U0001F605", \
							 @":sweet_potato:"                      : @"\U0001F360", \
							 @":swimmer:"                           : @"\U0001F3CA", \
							 @":symbols:"                           : @"\U0001F523", \
							 @":syringe:"                           : @"\U0001F489", \
							 @":tada:"                              : @"\U0001F389", \
							 @":tanabata_tree:"                     : @"\U0001F38B", \
							 @":tangerine:"                         : @"\U0001F34A", \
							 @":taurus:"                            : @"\U00002649", \
							 @":taxi:"                              : @"\U0001F695", \
							 @":tea:"                               : @"\U0001F375", \
							 @":telephone:"                         : @"\U0000260E", \
							 @":telephone_receiver:"                : @"\U0001F4DE", \
							 @":telescope:"                         : @"\U0001F52D", \
							 @":tennis:"                            : @"\U0001F3BE", \
							 @":tent:"                              : @"\U000026FA", \
							 @":thought_balloon:"                   : @"\U0001F4AD", \
							 @":thumbsdown:"                        : @"\U0001F44E", \
							 @":thumbsup:"                          : @"\U0001F44D", \
							 @":ticket:"                            : @"\U0001F3AB", \
							 @":tiger:"                             : @"\U0001F42F", \
							 @":tiger2:"                            : @"\U0001F405", \
							 @":tired_face:"                        : @"\U0001F62B", \
							 @":tm:"                                : @"\U00002122", \
							 @":toilet:"                            : @"\U0001F6BD", \
							 @":tokyo_tower:"                       : @"\U0001F5FC", \
							 @":tomato:"                            : @"\U0001F345", \
							 @":tongue:"                            : @"\U0001F445", \
							 @":top:"                               : @"\U0001F51D", \
							 @":tophat:"                            : @"\U0001F3A9", \
							 @":tractor:"                           : @"\U0001F69C", \
							 @":traffic_light:"                     : @"\U0001F6A5", \
							 @":train:"                             : @"\U0001F683", \
							 @":train2:"                            : @"\U0001F686", \
							 @":tram:"                              : @"\U0001F68A", \
							 @":triangular_flag_on_post:"           : @"\U0001F6A9", \
							 @":triangular_ruler:"                  : @"\U0001F4D0", \
							 @":trident:"                           : @"\U0001F531", \
							 @":triumph:"                           : @"\U0001F624", \
							 @":trolleybus:"                        : @"\U0001F68E", \
							 @":trophy:"                            : @"\U0001F3C6", \
							 @":tropical_drink:"                    : @"\U0001F379", \
							 @":tropical_fish:"                     : @"\U0001F420", \
							 @":truck:"                             : @"\U0001F69A", \
							 @":trumpet:"                           : @"\U0001F3BA", \
							 @":tshirt:"                            : @"\U0001F455", \
							 @":tulip:"                             : @"\U0001F337", \
							 @":turtle:"                            : @"\U0001F422", \
							 @":tv:"                                : @"\U0001F4FA", \
							 @":twisted_rightwards_arrows:"         : @"\U0001F500", \
							 @":two_hearts:"                        : @"\U0001F495", \
							 @":two_men_holding_hands:"             : @"\U0001F46C", \
							 @":two_women_holding_hands:"           : @"\U0001F46D", \
							 @":u5272:"                             : @"\U0001F239", \
							 @":u5408:"                             : @"\U0001F234", \
							 @":u55b6:"                             : @"\U0001F23A", \
							 @":u6307:"                             : @"\U0001F22F", \
							 @":u6708:"                             : @"\U0001F237", \
							 @":u6709:"                             : @"\U0001F236", \
							 @":u6e80:"                             : @"\U0001F235", \
							 @":u7121:"                             : @"\U0001F21A", \
							 @":u7533:"                             : @"\U0001F238", \
							 @":u7981:"                             : @"\U0001F232", \
							 @":u7a7a:"                             : @"\U0001F233", \
							 @":umbrella:"                          : @"\U00002614", \
							 @":unamused:"                          : @"\U0001F612", \
							 @":underage:"                          : @"\U0001F51E", \
							 @":unlock:"                            : @"\U0001F513", \
							 @":up:"                                : @"\U0001F199", \
							 @":v:"                                 : @"\U0000270C", \
							 @":vertical_traffic_light:"            : @"\U0001F6A6", \
							 @":vhs:"                               : @"\U0001F4FC", \
							 @":vibration_mode:"                    : @"\U0001F4F3", \
							 @":video_camera:"                      : @"\U0001F4F9", \
							 @":video_game:"                        : @"\U0001F3AE", \
							 @":violin:"                            : @"\U0001F3BB", \
							 @":virgo:"                             : @"\U0000264D", \
							 @":volcano:"                           : @"\U0001F30B", \
							 @":vs:"                                : @"\U0001F19A", \
							 @":walking:"                           : @"\U0001F6B6", \
							 @":waning_crescent_moon:"              : @"\U0001F318", \
							 @":waning_gibbous_moon:"               : @"\U0001F316", \
							 @":warning:"                           : @"\U000026A0", \
							 @":watch:"                             : @"\U0000231A", \
							 @":water_buffalo:"                     : @"\U0001F403", \
							 @":watermelon:"                        : @"\U0001F349", \
							 @":wave:"                              : @"\U0001F44B", \
							 @":wavy_dash:"                         : @"\U00003030", \
							 @":waxing_crescent_moon:"              : @"\U0001F312", \
							 @":waxing_gibbous_moon:"               : @"\U0001F314", \
							 @":wc:"                                : @"\U0001F6BE", \
							 @":weary:"                             : @"\U0001F629", \
							 @":wedding:"                           : @"\U0001F492", \
							 @":whale:"                             : @"\U0001F433", \
							 @":whale2:"                            : @"\U0001F40B", \
							 @":wheelchair:"                        : @"\U0000267F", \
							 @":white_check_mark:"                  : @"\U00002705", \
							 @":white_circle:"                      : @"\U000026AA", \
							 @":white_flower:"                      : @"\U0001F4AE", \
							 @":white_large_square:"                : @"\U00002B1C", \
							 @":white_medium_small_square:"         : @"\U000025FD", \
							 @":white_medium_square:"               : @"\U000025FB", \
							 @":white_small_square:"                : @"\U000025AB", \
							 @":white_square_button:"               : @"\U0001F533", \
							 @":wind_chime:"                        : @"\U0001F390", \
							 @":wine_glass:"                        : @"\U0001F377", \
							 @":wink:"                              : @"\U0001F609", \
							 @":wolf:"                              : @"\U0001F43A", \
							 @":woman:"                             : @"\U0001F469", \
							 @":womans_clothes:"                    : @"\U0001F45A", \
							 @":womans_hat:"                        : @"\U0001F452", \
							 @":womens:"                            : @"\U0001F6BA", \
							 @":worried:"                           : @"\U0001F61F", \
							 @":wrench:"                            : @"\U0001F527", \
							 @":x:"                                 : @"\U0000274C", \
							 @":yellow_heart:"                      : @"\U0001F49B", \
							 @":yen:"                               : @"\U0001F4B4", \
							 @":yum:"                               : @"\U0001F60B", \
							 @":zap:"                               : @"\U000026A1", \
							 @":zzz:"                               : @"\U0001F4A4" \
		} retain];

		__emojiSmileys = [[NSMutableDictionary alloc] init];
		
		for ( NSString * key in __emojiUnicodes.allKeys )
		{
			[__emojiSmileys setObject:key forKey:[__emojiUnicodes objectForKey:key]];
		}
	});
}

+ (void)setupEmojiCharset
{
    static dispatch_once_t onceToken;
	
    dispatch_once( &onceToken, ^
	{
		__emojiCharacterSet = [[NSMutableCharacterSet alloc] init];
		
        for ( NSString * key in __emojiUnicodes )
		{
            [__emojiCharacterSet addCharactersInString:[__emojiUnicodes objectForKey:key]];
        }

		[__emojiCharacterSet addCharactersInRange:NSMakeRange(0x1F300, (0x1F6C5 - 0x1F300))];
		[__emojiCharacterSet addCharactersInRange:NSMakeRange(0x1F0CF, 4)];
		[__emojiCharacterSet addCharactersInRange:NSMakeRange(0x1F004, 4)];
		[__emojiCharacterSet addCharactersInRange:NSMakeRange(0x1F170, 0x1F19B - 0x1F170)];
		[__emojiCharacterSet addCharactersInRange:NSMakeRange(0x1F201, 0x1F251 - 0x1F201)];
    });
}

+ (NSData *)dataFromHexString:(NSString *)string
{
	if ( 0 == string.length )
		return nil;
	
	UInt32 len = [string length];
	UInt32 byteLength = len / 2;
	UInt32 byteCounter = 0;
	
	Byte	srcBuffer[64] = { 0 };
	Byte *	src = srcBuffer;
	
	Byte	dstBuffer[64] = { 0 };
	Byte *	dst = dstBuffer;

	[string getCString:(char *)srcBuffer];
	
	for ( ;byteCounter < byteLength; )
	{
		unsigned char c = *src++;
		unsigned char d = *src++;
		unsigned hi = 0, lo = 0;

		hi = charTo4Bits(c);
		lo = charTo4Bits(d);
		
		if ( hi == 255 || lo == 255 )
		{
			//errorCase
			return nil;
		}
		
		dstBuffer[byteCounter++] = ((hi << 4) | lo);
	}
	
	return [NSData dataWithBytes:dst length:byteLength];
}

- (NSString *)encodeEmoji
{
	[NSString setupEmojiUnicode];
	[NSString setupEmojiCharset];

	NSMutableString * result = [[self mutableCopy] autorelease];

	NSRange range = [result rangeOfCharacterFromSet:__emojiCharacterSet options:NSLiteralSearch range:NSMakeRange(0, result.length)];
	while ( range.location != NSNotFound )
	{
		NSString * emoji = [result substringWithRange:range];
		NSString * smiley = [__emojiSmileys objectForKey:emoji];
		if ( smiley && smiley.length )
		{
			[result replaceCharactersInRange:range withString:smiley];
		}
		else
		{
			NSMutableString * unicode = [NSMutableString string];
			
			for ( NSInteger i = 0; i < [emoji length]; i++ )
			{
				unichar value = [emoji characterAtIndex:i];
				[unicode appendFormat:@"%x", value];
			}

			[result replaceCharactersInRange:range withString:[NSString stringWithFormat:@":%@:", unicode]];
		}
		
		range = [result rangeOfCharacterFromSet:__emojiCharacterSet options:NSLiteralSearch range:NSMakeRange(0, result.length)];
	}

	return result;
}

- (NSString *)decodeEmoji
{
	[NSString setupEmojiUnicode];
	[NSString setupEmojiCharset];

    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@":[A-Za-z0-9_]+:" options:NSRegularExpressionCaseInsensitive error:NULL];

	NSArray * matchs = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
	if ( nil == matchs || 0 == [matchs count] )
	{
		return self;
	}

	NSMutableString *	result = [[self mutableCopy] autorelease];
	NSMutableSet *		emojis = [NSMutableSet set];

	for ( NSTextCheckingResult * match in matchs )
	{
		NSString * emoji = [self substringWithRange:match.range];
		if ( [emoji hasPrefix:@":"] && [emoji hasSuffix:@":"] )
		{
			[emojis addObject:emoji];
		}
	}
	
	for ( NSString * emoji in emojis )
	{
		NSString * unicodeValue = [__emojiUnicodes objectForKey:emoji];
		if ( unicodeValue )
		{
			[result replaceOccurrencesOfString:emoji
									withString:unicodeValue
									   options:NSLiteralSearch
										 range:NSMakeRange(0, [result length])];
		}
		else
		{
			NSString *		codeString = [emoji substringWithRange:NSMakeRange(1, emoji.length - 2)];
			unsigned int	codeValue = 0;
			
			BOOL flag = [[NSScanner scannerWithString:codeString] scanHexInt:&codeValue];
			if ( flag )
			{
				NSData * unicodeData = [NSString dataFromHexString:codeString];
				if ( unicodeData )
				{
					NSString * unicode = [[NSString alloc] initWithData:unicodeData encoding:NSUTF16BigEndianStringEncoding];

					[result replaceOccurrencesOfString:emoji
											withString:unicode
											   options:NSLiteralSearch
												 range:NSMakeRange(0, [result length])];
					[unicode release];
				}
			}
		}
	}
	
	return result;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSString_BeeEmoji )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
