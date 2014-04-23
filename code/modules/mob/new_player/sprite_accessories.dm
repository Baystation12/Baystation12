/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/datum/sprite_accessory

	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name			// the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species
	var/list/species_allowed = list("Human")

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1


/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair

	icon = 'icons/mob/Human_face.dmi'	  // default icon for all hairs

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		species_allowed = list("Human","Unathi")

	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you

	cut
		name = "Cut Hair"
		icon_state = "hair_c"

	flair
		name = "Flaired Hair"
		icon_state = "hair_flair"

	long
		name = "Shoulder-length Hair"
		icon_state = "hair_b"

	longalt
		name = "Shoulder-length Hair Alt"
		icon_state = "hair_longfringe"

	/*longish
		name = "Longer Hair"
		icon_state = "hair_b2"*/

	longer
		name = "Long Hair"
		icon_state = "hair_vlong"

	longeralt
		name = "Long Hair Alt"
		icon_state = "hair_vlongfringe"

	longest
		name = "Very Long Hair"
		icon_state = "hair_longest"

	longfringe
		name = "Long Fringe"
		icon_state = "hair_longfringe"

	longestalt
		name = "Longer Fringe"
		icon_state = "hair_vlongfringe"

	halfbang
		name = "Half-banged Hair"
		icon_state = "hair_halfbang"

	halfbangalt
		name = "Half-banged Hair Alt"
		icon_state = "hair_halfbang_alt"

	ponytail1
		name = "Ponytail 1"
		icon_state = "hair_ponytail"

	ponytail2
		name = "Ponytail 2"
		icon_state = "hair_pa"
		gender = FEMALE

	ponytail3
		name = "Ponytail 3"
		icon_state = "hair_ponytail3"

	sideponytail
		name = "Side Ponytail"
		icon_state = "hair_stail"
		gender = FEMALE

	parted
		name = "Parted"
		icon_state = "hair_parted"

	pompadour
		name = "Pompadour"
		icon_state = "hair_pompadour"
		gender = MALE
		species_allowed = list("Human","Unathi")

	quiff
		name = "Quiff"
		icon_state = "hair_quiff"
		gender = MALE

	bedhead
		name = "Bedhead"
		icon_state = "hair_bedhead"

	bedhead2
		name = "Bedhead 2"
		icon_state = "hair_bedheadv2"

	bedhead3
		name = "Bedhead 3"
		icon_state = "hair_bedheadv3"

	beehive
		name = "Beehive"
		icon_state = "hair_beehive"
		gender = FEMALE
		species_allowed = list("Human","Unathi")

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"
		gender = FEMALE
		species_allowed = list("Human","Unathi")

	bob
		name = "Bob"
		icon_state = "hair_bobcut"
		gender = FEMALE
		species_allowed = list("Human","Unathi")

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"
		gender = MALE

	buzz
		name = "Buzzcut"
		icon_state = "hair_buzzcut"
		gender = MALE
		species_allowed = list("Human","Unathi")

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"
		gender = MALE

	combover
		name = "Combover"
		icon_state = "hair_combover"
		gender = MALE

	devillock
		name = "Devil Lock"
		icon_state = "hair_devilock"

	dreadlocks
		name = "Dreadlocks"
		icon_state = "hair_dreads"

	curls
		name = "Curls"
		icon_state = "hair_curls"

	afro
		name = "Afro"
		icon_state = "hair_afro"

	afro2
		name = "Afro 2"
		icon_state = "hair_afro2"

	afro_large
		name = "Big Afro"
		icon_state = "hair_bigafro"
		gender = MALE

	sargeant
		name = "Flat Top"
		icon_state = "hair_sargeant"
		gender = MALE

	emo
		name = "Emo"
		icon_state = "hair_emo"

	fag
		name = "Flow Hair"
		icon_state = "hair_f"

	feather
		name = "Feather"
		icon_state = "hair_feather"

	hitop
		name = "Hitop"
		icon_state = "hair_hitop"
		gender = MALE

	mohawk
		name = "Mohawk"
		icon_state = "hair_d"
		species_allowed = list("Human","Unathi")
	jensen
		name = "Adam Jensen Hair"
		icon_state = "hair_jensen"
		gender = MALE

	gelled
		name = "Gelled Back"
		icon_state = "hair_gelled"
		gender = FEMALE

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"
		gender = FEMALE

	spiky
		name = "Spiky"
		icon_state = "hair_spikey"
		species_allowed = list("Human","Unathi")
	kusangi
		name = "Kusanagi Hair"
		icon_state = "hair_kusanagi"

	kagami
		name = "Pigtails"
		icon_state = "hair_kagami"
		gender = FEMALE

	himecut
		name = "Hime Cut"
		icon_state = "hair_himecut"
		gender = FEMALE

	braid
		name = "Floorlength Braid"
		icon_state = "hair_braid"
		gender = FEMALE

	braid2
		name = "Long Braid"
		icon_state = "hair_hbraid"
		gender = FEMALE

	odango
		name = "Odango"
		icon_state = "hair_odango"
		gender = FEMALE

	ombre
		name = "Ombre"
		icon_state = "hair_ombre"
		gender = FEMALE

	updo
		name = "Updo"
		icon_state = "hair_updo"
		gender = FEMALE

	skinhead
		name = "Skinhead"
		icon_state = "hair_skinhead"

	balding
		name = "Balding Hair"
		icon_state = "hair_e"
		gender = MALE // turnoff!

	bald
		name = "Bald"
		icon_state = "bald"

	icp_screen_pink
		name = "pink IPC screen"
		icon_state = "ipc_pink"
		species_allowed = list("Machine")

	icp_screen_red
		name = "red IPC screen"
		icon_state = "ipc_red"
		species_allowed = list("Machine")

	icp_screen_green
		name = "green IPC screen"
		icon_state = "ipc_green"
		species_allowed = list("Machine")

	icp_screen_blue
		name = "blue IPC screen"
		icon_state = "ipc_blue"
		species_allowed = list("Machine")

	icp_screen_breakout
		name = "breakout IPC screen"
		icon_state = "ipc_breakout"
		species_allowed = list("Machine")

	icp_screen_eight
		name = "eight IPC screen"
		icon_state = "ipc_eight"
		species_allowed = list("Machine")

	icp_screen_goggles
		name = "goggles IPC screen"
		icon_state = "ipc_goggles"
		species_allowed = list("Machine")

	icp_screen_heart
		name = "heart IPC screen"
		icon_state = "ipc_heart"
		species_allowed = list("Machine")

	icp_screen_monoeye
		name = "monoeye IPC screen"
		icon_state = "ipc_monoeye"
		species_allowed = list("Machine")

	icp_screen_nature
		name = "nature IPC screen"
		icon_state = "ipc_nature"
		species_allowed = list("Machine")

	icp_screen_orange
		name = "orange IPC screen"
		icon_state = "ipc_orange"
		species_allowed = list("Machine")

	icp_screen_purple
		name = "purple IPC screen"
		icon_state = "ipc_purple"
		species_allowed = list("Machine")

	icp_screen_shower
		name = "shower IPC screen"
		icon_state = "ipc_shower"
		species_allowed = list("Machine")

	icp_screen_static
		name = "static IPC screen"
		icon_state = "ipc_static"
		species_allowed = list("Machine")

	icp_screen_yellow
		name = "yellow IPC screen"
		icon_state = "ipc_yellow"
		species_allowed = list("Machine")

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair

	icon = 'icons/mob/Human_face.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix /w beards :P)

	shaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER
		species_allowed = list("Human","Unathi","Tajaran","Skrell","Vox","Machine")

	watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"
		species_allowed = list("Human","Unathi")

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/hair
	una_spines_long
		name = "Long Unathi Spines"
		icon_state = "soghun_longspines"
		species_allowed = list("Unathi")
		do_colouration = 0

	una_spines_short
		name = "Short Unathi Spines"
		icon_state = "soghun_shortspines"
		species_allowed = list("Unathi")
		do_colouration = 0

	una_frills_long
		name = "Long Unathi Frills"
		icon_state = "soghun_longfrills"
		species_allowed = list("Unathi")
		do_colouration = 0

	una_frills_short
		name = "Short Unathi Frills"
		icon_state = "soghun_shortfrills"
		species_allowed = list("Unathi")
		do_colouration = 0

	una_horns
		name = "Unathi Horns"
		icon_state = "soghun_horns"
		species_allowed = list("Unathi")
		do_colouration = 0

	skr_tentacle_m
		name = "Skrell Male Tentacles"
		icon_state = "skrell_hair_m"
		species_allowed = list("Skrell")
		gender = MALE
		do_colouration = 0

	skr_tentacle_f
		name = "Skrell Female Tentacles"
		icon_state = "skrell_hair_f"
		species_allowed = list("Skrell")
		gender = FEMALE
		do_colouration = 0

	skr_gold_m
		name = "Gold plated Skrell Male Tentacles"
		icon_state = "skrell_goldhair_m"
		species_allowed = list("Skrell")
		gender = MALE
		do_colouration = 0

	skr_gold_f
		name = "Gold chained Skrell Female Tentacles"
		icon_state = "skrell_goldhair_f"
		species_allowed = list("Skrell")
		gender = FEMALE
		do_colouration = 0

	skr_clothtentacle_m
		name = "Cloth draped Skrell Male Tentacles"
		icon_state = "skrell_clothhair_m"
		species_allowed = list("Skrell")
		gender = MALE
		do_colouration = 0

	skr_clothtentacle_f
		name = "Cloth draped Skrell Female Tentacles"
		icon_state = "skrell_clothhair_f"
		species_allowed = list("Skrell")
		gender = FEMALE
		do_colouration = 0

	taj_ears
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_clean
		name = "Tajara Clean"
		icon_state = "hair_clean"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_bangs
		name = "Tajara Bangs"
		icon_state = "hair_bangs"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_braid
		name = "Tajara Braid"
		icon_state = "hair_tbraid"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_shaggy
		name = "Tajara Shaggy"
		icon_state = "hair_shaggy"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_mohawk
		name = "Tajaran Mohawk"
		icon_state = "hair_mohawk"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_plait
		name = "Tajara Plait"
		icon_state = "hair_plait"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_straight
		name = "Tajara Straight"
		icon_state = "hair_straight"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_long
		name = "Tajara Long"
		icon_state = "hair_long"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_rattail
		name = "Tajara Rat Tail"
		icon_state = "hair_rattail"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_spiky
		name = "Tajara Spiky"
		icon_state = "hair_tajspiky"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_ears_messy
		name = "Tajara Messy"
		icon_state = "hair_messy"
		species_allowed = list("Tajaran")
		do_colouration = 0

	vox_quills_short
		name = "Short Vox Quills"
		icon_state = "vox_shortquills"
		species_allowed = list("Vox")

/datum/sprite_accessory/hair

// black tajaran shit goes here

	tajb_ears
		name = "Tajaran Ears (black)"
		icon_state = "ears_plainb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_straight
		name = "Tajara Straight (black)"
		icon_state = "hair_straightb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_clean
		name = "Tajara Clean (black)"
		icon_state = "hair_cleanb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_bangs
		name = "Tajara Bangs (black)"
		icon_state = "hair_bangsb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_braid
		name = "Tajara Braid (black)"
		icon_state = "hair_tbraidb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_shaggy
		name = "Tajara Shaggy (black)"
		icon_state = "hair_shaggyb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_mohawk
		name = "Tajaran Mohawk (black)"
		icon_state = "hair_mohawkb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_plait
		name = "Tajara Plait (black)"
		icon_state = "hair_plaitb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_long
		name = "Tajara Long (black)"
		icon_state = "hair_longb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_rattail
		name = "Tajara Rat Tail (black)"
		icon_state = "hair_rattailb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_spiky
		name = "Tajara Spiky (black)"
		icon_state = "hair_tajspikyb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_ears_messy
		name = "Tajara Messy (black)"
		icon_state = "hair_messyb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

//orange tajaran shit goes here

	tajo_ears
		name = "Tajaran Ears (orange)"
		icon_state = "ears_plaino"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_clean
		name = "Tajara Clean (orange)"
		icon_state = "hair_cleano"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_bangs
		name = "Tajara Bangs (orange)"
		icon_state = "hair_bangso"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_braid
		name = "Tajara Braid (orange)"
		icon_state = "hair_tbraido"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_shaggy
		name = "Tajara Shaggy (orange)"
		icon_state = "hair_shaggyo"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_mohawk
		name = "Tajaran Mohawk (orange)"
		icon_state = "hair_mohawko"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_plait
		name = "Tajara Plait (orange)"
		icon_state = "hair_plaito"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_straight
		name = "Tajara Straight (orange)"
		icon_state = "hair_straighto"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_long
		name = "Tajara Long (orange)"
		icon_state = "hair_longo"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_rattail
		name = "Tajara Rat Tail (orange)"
		icon_state = "hair_rattailo"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_spiky
		name = "Tajara Spiky (orange)"
		icon_state = "hair_tajspikyo"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_ears_messy
		name = "Tajara Messy (orange)"
		icon_state = "hair_messyo"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

//siamese tajaran shit goes here

	tajs_ears
		name = "Tajaran Ears (light)"
		icon_state = "ears_plains"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_clean
		name = "Tajara Clean (light)"
		icon_state = "hair_cleans"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_bangs
		name = "Tajara Bangs (light)"
		icon_state = "hair_bangss"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_braid
		name = "Tajara Braid (light)"
		icon_state = "hair_tbraids"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_shaggy
		name = "Tajara Shaggy (light)"
		icon_state = "hair_shaggys"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_mohawk
		name = "Tajaran Mohawk (light)"
		icon_state = "hair_mohawks"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_plait
		name = "Tajara Plait (light)"
		icon_state = "hair_plaits"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_straight
		name = "Tajara Straight (light)"
		icon_state = "hair_straights"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_long
		name = "Tajara Long (light)"
		icon_state = "hair_longs"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_rattail
		name = "Tajara Rat Tail (light)"
		icon_state = "hair_rattails"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_spiky
		name = "Tajara Spiky (light)"
		icon_state = "hair_tajspikys"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_ears_messy
		name = "Tajara Messy (light)"
		icon_state = "hair_messys"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

//russian blue tajaran shit goes here

	tajl_ears
		name = "Tajaran Ears (blue)"
		icon_state = "ears_plainl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_clean
		name = "Tajara Clean (blue)"
		icon_state = "hair_cleanl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_bangs
		name = "Tajara Bangs (blue)"
		icon_state = "hair_bangsl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_braid
		name = "Tajara Braid (blue)"
		icon_state = "hair_tbraidl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_shaggy
		name = "Tajara Shaggy (blue)"
		icon_state = "hair_shaggyl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_mohawk
		name = "Tajaran Mohawk (blue)"
		icon_state = "hair_mohawkl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_plait
		name = "Tajara Plait (blue)"
		icon_state = "hair_plaitl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_straight
		name = "Tajara Straight (blue)"
		icon_state = "hair_straightl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_long
		name = "Tajara Long (blue)"
		icon_state = "hair_long"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_rattail
		name = "Tajara Rat Tail (blue)"
		icon_state = "hair_rattaill"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_spiky
		name = "Tajara Spiky (blue)"
		icon_state = "hair_tajspikyl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_ears_messy
		name = "Tajara Messy (blue)"
		icon_state = "hair_messyl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

//brown tabby tajaran shit goes here

	tajt_ears
		name = "Tajaran Ears (brown)"
		icon_state = "ears_plaint"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_clean
		name = "Tajara Clean (brown)"
		icon_state = "hair_cleant"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_bangs
		name = "Tajara Bangs (brown)"
		icon_state = "hair_bangst"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_braid
		name = "Tajara Braid (brown)"
		icon_state = "hair_tbraidt"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_shaggy
		name = "Tajara Shaggy (brown)"
		icon_state = "hair_shaggyt"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_mohawk
		name = "Tajaran Mohawk (brown)"
		icon_state = "hair_mohawkt"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_plait
		name = "Tajara Plait (brown)"
		icon_state = "hair_plaitt"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_straight
		name = "Tajara Straight (brown)"
		icon_state = "hair_straightt"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_long
		name = "Tajara Long (brown)"
		icon_state = "hair_longt"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_rattail
		name = "Tajara Rat Tail (brown)"
		icon_state = "hair_rattailt"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_spiky
		name = "Tajara Spiky (brown)"
		icon_state = "hair_tajspikyt"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_ears_messy
		name = "Tajara Messy (brown)"
		icon_state = "hair_messyt"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0


/datum/sprite_accessory/facial_hair

	taj_sideburns
		name = "Tajara Sideburns"
		icon_state = "facial_mutton"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_mutton
		name = "Tajara Mutton"
		icon_state = "facial_mutton"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_pencilstache
		name = "Tajara Pencilstache"
		icon_state = "facial_pencilstache"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_moustache
		name = "Tajara Moustache"
		icon_state = "facial_moustache"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_goatee
		name = "Tajara Goatee"
		icon_state = "facial_goatee"
		species_allowed = list("Tajaran")
		do_colouration = 0

	taj_smallstache
		name = "Tajara Smallsatche"
		icon_state = "facial_smallstache"
		species_allowed = list("Tajaran")
		do_colouration = 0

/datum/sprite_accessory/facial_hair

//black tajaran shit goes here

	tajb_sideburns
		name = "Tajara Sideburns (black)"
		icon_state = "facial_muttonb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_mutton
		name = "Tajara Mutton (black)"
		icon_state = "facial_muttonb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_pencilstache
		name = "Tajara Pencilstache (black)"
		icon_state = "facial_pencilstacheb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_moustache
		name = "Tajara Moustache (black)"
		icon_state = "facial_moustacheb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_goatee
		name = "Tajara Goatee (black)"
		icon_state = "facial_goateeb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

	tajb_smallstache
		name = "Tajara Smallsatche (black)"
		icon_state = "facial_smallstacheb"
		species_allowed = list("Tajaran (Black)")
		do_colouration = 0

//orange tajaran shit goes here

	tajo_sideburns
		name = "Tajara Sideburns (orange)"
		icon_state = "facial_muttono"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_mutton
		name = "Tajara Mutton (orange)"
		icon_state = "facial_muttono"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_pencilstache
		name = "Tajara Pencilstache (orange)"
		icon_state = "facial_pencilstacheo"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_moustache
		name = "Tajara Moustache (orange)"
		icon_state = "facial_moustacheo"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_goatee
		name = "Tajara Goatee (orange)"
		icon_state = "facial_goateeo"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

	tajo_smallstache
		name = "Tajara Smallsatche (orange)"
		icon_state = "facial_smallstacheo"
		species_allowed = list("Tajaran (Orange)")
		do_colouration = 0

//siamese tajaran shit goes here

	tajs_sideburns
		name = "Tajara Sideburns (light)"
		icon_state = "facial_muttons"
		species_allowed = list("Tajaran")
		do_colouration = 0

	tajs_mutton
		name = "Tajara Mutton (light)"
		icon_state = "facial_muttons"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_pencilstache
		name = "Tajara Pencilstache (light)"
		icon_state = "facial_pencilstaches"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_moustache
		name = "Tajara Moustache (light)"
		icon_state = "facial_moustaches"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_goatee
		name = "Tajara Goatee (light)"
		icon_state = "facial_goatees"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

	tajs_smallstache
		name = "Tajara Smallsatches (light)"
		icon_state = "facial_smallstache"
		species_allowed = list("Tajaran (Siamese)")
		do_colouration = 0

//russian blue tajaran shit goes here

	tajl_sideburns
		name = "Tajara Sideburns (blue)"
		icon_state = "facial_muttonl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_mutton
		name = "Tajara Mutton (blue)"
		icon_state = "facial_muttonl"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_pencilstache
		name = "Tajara Pencilstache (blue)"
		icon_state = "facial_pencilstachel"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_moustache
		name = "Tajara Moustache (blue)"
		icon_state = "facial_moustachel"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_goatee
		name = "Tajara Goatee (blue)"
		icon_state = "facial_goateel"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

	tajl_smallstache
		name = "Tajara Smallsatche (blue)"
		icon_state = "facial_smallstachel"
		species_allowed = list("Tajaran (Blue)")
		do_colouration = 0

//brown tabby tajaran shit goes here

	tajt_sideburns
		name = "Tajara Sideburns (brown)"
		icon_state = "facial_muttont"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_mutton
		name = "Tajara Mutton (brown)"
		icon_state = "facial_muttont"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_pencilstache
		name = "Tajara Pencilstache (brown)"
		icon_state = "facial_pencilstachet"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_moustache
		name = "Tajara Moustache (brown)"
		icon_state = "facial_moustachet"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_goatee
		name = "Tajara Goatee (brown)"
		icon_state = "facial_goateet"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0

	tajt_smallstache
		name = "Tajara Smallsatche (brown)"
		icon_state = "facial_smallstachet"
		species_allowed = list("Tajaran (Brown)")
		do_colouration = 0




//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now
/datum/sprite_accessory/skin
	icon = 'icons/mob/human_races/r_human.dmi'

	human
		name = "Default human skin"
		icon_state = "default"
		species_allowed = list("Human")

	human_tatt01
		name = "Tatt01 human skin"
		icon_state = "tatt1"
		species_allowed = list("Human")

	tajaran
		name = "Default tajaran skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_tajaran.dmi'
		species_allowed = list("Tajaran")

	unathi
		name = "Default Unathi skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_lizard.dmi'
		species_allowed = list("Unathi")

	skrell
		name = "Default skrell skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_skrell.dmi'
		species_allowed = list("Skrell")