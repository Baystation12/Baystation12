//Quick defines for fire modes
#define FULL_AUTO_300		list(mode_name = "full auto",  mode_desc = "300 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 8, one_hand_penalty=2)
#define FULL_AUTO_400		list(mode_name = "full auto",  mode_desc = "400 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 4, one_hand_penalty=3)
#define FULL_AUTO_600		list(mode_name = "full auto",  mode_desc = "600 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 2, one_hand_penalty=4)
#define FULL_AUTO_800		list(mode_name = "fuller auto",  mode_desc = "800 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 1, one_hand_penalty=5)

#define SEMI_AUTO_NODELAY	list(mode_name = "semiauto",  mode_desc = "Fire as fast as you can pull the trigger", burst=1, fire_delay=0, move_delay=null)

//Cog firemode
#define BURST_2_ROUND		list(mode_name="2-beam bursts", mode_desc = "Short, controlled bursts", burst=2, fire_delay=null, move_delay=2, one_hand_penalty=2)

#define BURST_3_ROUND		list(mode_name="3-round bursts", mode_desc = "Short, controlled bursts", burst=3, fire_delay=null, move_delay=4, one_hand_penalty=3)
#define BURST_5_ROUND		list(mode_name="5-round bursts", mode_desc = "Short, controlled bursts", burst=5, fire_delay=null, move_delay=6, one_hand_penalty=3)
#define BURST_8_ROUND		list(mode_name="8-round bursts", mode_desc = "Short, uncontrolled bursts", burst=8, fire_delay=null, move_delay=8, one_hand_penalty=4)

#define MAX_ACCURACY_OFFSET  45 //It's both how big gun recoil can build up, and how hard you can miss
#define RECOIL_REDUCTION_TIME 1 SECOND
