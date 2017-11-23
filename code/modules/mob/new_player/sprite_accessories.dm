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
	var/list/species_allowed = list(SPECIES_HUMAN)

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
	var/flags

/datum/sprite_accessory/hair/bald
	name = "Bald"
	icon_state = "bald"
	gender = MALE
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI)
	flags = VERY_SHORT

/datum/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
	flags = VERY_SHORT

/datum/sprite_accessory/hair/twintail
	name = "Twintail"
	icon_state = "hair_twintail"

/datum/sprite_accessory/hair/short2
	name = "Short Hair 2"
	icon_state = "hair_shorthair3"

/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "hair_c"
	flags = VERY_SHORT

/datum/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "hair_flair"

/datum/sprite_accessory/hair/long
	name = "Shoulder-length Hair"
	icon_state = "hair_b"

/datum/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "hair_vlong"

/datum/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "hair_longest"

/datum/sprite_accessory/hair/longfringe
	name = "Long Fringe"
	icon_state = "hair_longfringe"

/datum/sprite_accessory/hair/longestalt
	name = "Longer Fringe"
	icon_state = "hair_vlongfringe"

/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "hair_halfbang"

/datum/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair Alt"
	icon_state = "hair_halfbang_alt"

/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail 1"
	icon_state = "hair_ponytail"

/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "hair_pa"
	gender = FEMALE

/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "hair_ponytail3"

/datum/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	icon_state = "hair_ponytail4"
	gender = FEMALE

/datum/sprite_accessory/hair/ponytail5
	name = "Ponytail 5"
	icon_state = "hair_ponytail5"
	gender = FEMALE

/datum/sprite_accessory/hair/ponytail6
	name = "Ponytail 6"
	icon_state = "hair_ponytail6"
	gender = FEMALE

/datum/sprite_accessory/hair/sideponytail
	name = "Side Ponytail"
	icon_state = "hair_stail"
	gender = FEMALE

/datum/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "hair_parted"

/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "hair_pompadour"
	gender = MALE

/datum/sprite_accessory/hair/sleeze
	name = "Sleeze"
	icon_state = "hair_sleeze"
	flags = VERY_SHORT

/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "hair_quiff"
	gender = MALE

/datum/sprite_accessory/hair/bedhead
	name = "Bedhead"
	icon_state = "hair_bedhead"

/datum/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	icon_state = "hair_bedheadv2"

/datum/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	icon_state = "hair_bedheadv3"

/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "hair_beehive"
	gender = FEMALE

/datum/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "hair_beehive2"
	gender = FEMALE

/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "hair_bobcurl"
	gender = FEMALE
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI)

/datum/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "hair_bobcut"
	gender = FEMALE
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI)

/datum/sprite_accessory/hair/bobcutalt
	name = "Chin Length Bob"
	icon_state = "hair_bobcutalt"
	gender = FEMALE
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI)

/datum/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "hair_bowlcut"
	gender = MALE

/datum/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "hair_buzzcut"
	gender = MALE
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI)
	flags = VERY_SHORT

/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "hair_crewcut"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "hair_combover"
	gender = MALE

/datum/sprite_accessory/hair/father
	name = "Father"
	icon_state = "hair_father"
	gender = MALE

/datum/sprite_accessory/hair/reversemohawk
	name = "Reverse Mohawk"
	icon_state = "hair_reversemohawk"
	gender = MALE

/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "hair_devilock"

/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "hair_dreads"

/datum/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "hair_curls"

/datum/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "hair_afro"

/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "hair_afro2"

/datum/sprite_accessory/hair/afro_large
	name = "Big Afro"
	icon_state = "hair_bigafro"
	gender = MALE

/datum/sprite_accessory/hair/rows
	name = "Rows"
	icon_state = "hair_rows1"
	flags = VERY_SHORT

/datum/sprite_accessory/hair/rows2
	name = "Rows 2"
	icon_state = "hair_rows2"
	flags = VERY_SHORT

/datum/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "hair_sargeant"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "hair_emo"

/datum/sprite_accessory/hair/emo2
	name = "Emo Alt"
	icon_state = "hair_emo2"

/datum/sprite_accessory/hair/longemo
	name = "Long Emo"
	icon_state = "hair_emolong"
	gender = FEMALE

/datum/sprite_accessory/hair/shortovereye
	name = "Overeye Short"
	icon_state = "hair_shortovereye"

/datum/sprite_accessory/hair/longovereye
	name = "Overeye Long"
	icon_state = "hair_longovereye"

/datum/sprite_accessory/hair/fag
	name = "Flow Hair"
	icon_state = "hair_f"

/datum/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "hair_feather"

/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hair_hitop"
	gender = MALE

/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "hair_d"
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI)

/datum/sprite_accessory/hair/jensen
	name = "Adam Jensen Hair"
	icon_state = "hair_jensen"
	gender = MALE

/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "hair_gelled"
	gender = FEMALE

/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "hair_gentle"
	gender = FEMALE

/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "hair_spikey"
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI)

/datum/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	icon_state = "hair_kusanagi"

/datum/sprite_accessory/hair/kagami
	name = "Pigtails"
	icon_state = "hair_kagami"
	gender = FEMALE

/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "hair_himecut"
	gender = FEMALE

/datum/sprite_accessory/hair/shorthime
	name = "Short Hime Cut"
	icon_state = "hair_shorthime"
	gender = FEMALE

/datum/sprite_accessory/hair/grandebraid
	name = "Grande Braid"
	icon_state = "hair_grande"
	gender = FEMALE

/datum/sprite_accessory/hair/mbraid
	name = "Medium Braid"
	icon_state = "hair_shortbraid"
	gender = FEMALE

/datum/sprite_accessory/hair/braid2
	name = "Long Braid"
	icon_state = "hair_hbraid"
	gender = FEMALE

/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	icon_state = "hair_braid"
	gender = FEMALE
	flags = HAIR_TRIPPABLE

/datum/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "hair_odango"
	gender = FEMALE

/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "hair_ombre"
	gender = FEMALE

/datum/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "hair_updo"
	gender = FEMALE

/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "hair_skinhead"
	flags = VERY_SHORT

/datum/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "hair_e"
	gender = MALE // turnoff!
	flags = VERY_SHORT

/datum/sprite_accessory/hair/familyman
	name = "The Family Man"
	icon_state = "hair_thefamilyman"
	gender = MALE

/datum/sprite_accessory/hair/mahdrills
	name = "Drillruru"
	icon_state = "hair_drillruru"
	gender = FEMALE

/datum/sprite_accessory/hair/fringetail
	name = "Fringetail"
	icon_state = "hair_fringetail"
	gender = FEMALE

/datum/sprite_accessory/hair/dandypomp
	name = "Dandy Pompadour"
	icon_state = "hair_dandypompadour"
	gender = MALE

/datum/sprite_accessory/hair/poofy
	name = "Poofy"
	icon_state = "hair_poofy"
	gender = FEMALE

/datum/sprite_accessory/hair/crono
	name = "Chrono"
	icon_state = "hair_toriyama"
	gender = MALE

/datum/sprite_accessory/hair/vegeta
	name = "Vegeta"
	icon_state = "hair_toriyama2"
	gender = MALE

/datum/sprite_accessory/hair/cia
	name = "CIA"
	icon_state = "hair_cia"
	gender = MALE

/datum/sprite_accessory/hair/mulder
	name = "Mulder"
	icon_state = "hair_mulder"
	gender = MALE

/datum/sprite_accessory/hair/scully
	name = "Scully"
	icon_state = "hair_scully"
	gender = FEMALE

/datum/sprite_accessory/hair/nitori
	name = "Nitori"
	icon_state = "hair_nitori"
	gender = FEMALE

/datum/sprite_accessory/hair/joestar
	name = "Joestar"
	icon_state = "hair_joestar"
	gender = MALE

/datum/sprite_accessory/hair/volaju
	name = "Volaju"
	icon_state = "hair_volaju"

/datum/sprite_accessory/hair/longeralt2
	name = "Long Hair Alt 2"
	icon_state = "hair_longeralt2"

/datum/sprite_accessory/hair/shortbangs
	name = "Short Bangs"
	icon_state = "hair_shortbangs"

/datum/sprite_accessory/hair/halfshaved
	name = "Half-Shaved Emo"
	icon_state = "hair_halfshaved"

/datum/sprite_accessory/hair/bun
	name = "Low Bun"
	icon_state = "hair_bun"

/datum/sprite_accessory/hair/bun2
	name = "High Bun"
	icon_state = "hair_bun2"

/datum/sprite_accessory/hair/doublebun
	name = "Double-Bun"
	icon_state = "hair_doublebun"

/datum/sprite_accessory/hair/lowfade
	name = "Low Fade"
	icon_state = "hair_lowfade"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/medfade
	name = "Medium Fade"
	icon_state = "hair_medfade"

/datum/sprite_accessory/hair/highfade
	name = "High Fade"
	icon_state = "hair_highfade"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/baldfade
	name = "Balding Fade"
	icon_state = "hair_baldfade"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/nofade
	name = "Regulation Cut"
	icon_state = "hair_nofade"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/trimflat
	name = "Trimmed Flat Top"
	icon_state = "hair_trimflat"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/shaved
	name = "Shaved"
	icon_state = "hair_shaved"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/trimmed
	name = "Trimmed"
	icon_state = "hair_trimmed"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/tightbun
	name = "Tight Bun"
	icon_state = "hair_tightbun"
	gender = FEMALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/coffeehouse
	name = "Coffee House Cut"
	icon_state = "hair_coffeehouse"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/undercut
	name = "Undercut"
	icon_state = "hair_undercut"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/partfade
	name = "Parted Fade"
	icon_state = "hair_shavedpart"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/hightight
	name = "High and Tight"
	icon_state = "hair_hightight"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/rowbun
	name = "Row Bun"
	icon_state = "hair_rowbun"
	gender = FEMALE

/datum/sprite_accessory/hair/rowdualbraid
	name = "Row Dual Braid"
	icon_state = "hair_rowdualtail"
	gender = FEMALE

/datum/sprite_accessory/hair/rowbraid
	name = "Row Braid"
	icon_state = "hair_rowbraid"
	gender = FEMALE

/datum/sprite_accessory/hair/regulationmohawk
	name = "Regulation Mohawk"
	icon_state = "hair_shavedmohawk"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/topknot
	name = "Topknot"
	icon_state = "hair_topknot"
	gender = MALE

/datum/sprite_accessory/hair/ronin
	name = "Ronin"
	icon_state = "hair_ronin"
	gender = MALE

/datum/sprite_accessory/hair/bowlcut2
	name = "Bowl2"
	icon_state = "hair_bowlcut2"
	gender = MALE

/datum/sprite_accessory/hair/thinning
	name = "Thinning"
	icon_state = "hair_thinning"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	icon_state = "hair_thinningfront"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/thinningback
	name = "Thinning Back"
	icon_state = "hair_thinningrear"
	gender = MALE
	flags = VERY_SHORT

/datum/sprite_accessory/hair/manbun
	name = "Manbun"
	icon_state = "hair_manbun"
	gender = MALE

/datum/sprite_accessory/hair/leftsidecut
	name = "Left Sidecut"
	icon_state = "hair_leftside"

/datum/sprite_accessory/hair/rightsidecut
	name = "Right Sidecut"
	icon_state = "hair_rightside"

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair

	icon = 'icons/mob/human_face.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix /w beards :P)

/datum/sprite_accessory/facial_hair/shaved
	name = "Shaved"
	icon_state = "bald"
	gender = NEUTER
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_VOX,SPECIES_IPC)

/datum/sprite_accessory/facial_hair/watson
	name = "Watson Mustache"
	icon_state = "facial_watson"

/datum/sprite_accessory/facial_hair/hogan
	name = "Hulk Hogan Mustache"
	icon_state = "facial_hogan" //-Neek

/datum/sprite_accessory/facial_hair/vandyke
	name = "Van Dyke Mustache"
	icon_state = "facial_vandyke"

/datum/sprite_accessory/facial_hair/chaplin
	name = "Square Mustache"
	icon_state = "facial_chaplin"

/datum/sprite_accessory/facial_hair/selleck
	name = "Selleck Mustache"
	icon_state = "facial_selleck"

/datum/sprite_accessory/facial_hair/neckbeard
	name = "Neckbeard"
	icon_state = "facial_neckbeard"

/datum/sprite_accessory/facial_hair/fullbeard
	name = "Full Beard"
	icon_state = "facial_fullbeard"

/datum/sprite_accessory/facial_hair/longbeard
	name = "Long Beard"
	icon_state = "facial_longbeard"

/datum/sprite_accessory/facial_hair/vlongbeard
	name = "Very Long Beard"
	icon_state = "facial_wise"

/datum/sprite_accessory/facial_hair/elvis
	name = "Elvis Sideburns"
	icon_state = "facial_elvis"
	species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI)

/datum/sprite_accessory/facial_hair/abe
	name = "Abraham Lincoln Beard"
	icon_state = "facial_abe"

/datum/sprite_accessory/facial_hair/chinstrap
	name = "Chinstrap"
	icon_state = "facial_chin"

/datum/sprite_accessory/facial_hair/hip
	name = "Hipster Beard"
	icon_state = "facial_hip"

/datum/sprite_accessory/facial_hair/gt
	name = "Goatee"
	icon_state = "facial_gt"

/datum/sprite_accessory/facial_hair/jensen
	name = "Adam Jensen Beard"
	icon_state = "facial_jensen"

/datum/sprite_accessory/facial_hair/volaju
	name = "Volaju"
	icon_state = "facial_volaju"

/datum/sprite_accessory/facial_hair/dwarf
	name = "Dwarf Beard"
	icon_state = "facial_dwarf"

/datum/sprite_accessory/facial_hair/threeOclock
	name = "3 O'clock Shadow"
	icon_state = "facial_3oclock"

/datum/sprite_accessory/facial_hair/threeOclockstache
	name = "3 O'clock Shadow and Moustache"
	icon_state = "facial_3oclockmoustache"

/datum/sprite_accessory/facial_hair/fiveOclock
	name = "5 O'clock Shadow"
	icon_state = "facial_5oclock"

/datum/sprite_accessory/facial_hair/fiveOclockstache
	name = "5 O'clock Shadow and Moustache"
	icon_state = "facial_5oclockmoustache"

/datum/sprite_accessory/facial_hair/sevenOclock
	name = "7 O'clock Shadow"
	icon_state = "facial_7oclock"

/datum/sprite_accessory/facial_hair/sevenOclockstache
	name = "7 O'clock Shadow and Moustache"
	icon_state = "facial_7oclockmoustache"

/datum/sprite_accessory/facial_hair/mutton
	name = "Mutton Chops"
	icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hair/muttonstache
	name = "Mutton Chops and Moustache"
	icon_state = "facial_muttonmus"

/datum/sprite_accessory/facial_hair/walrus
	name = "Walrus Moustache"
	icon_state = "facial_walrus"

/datum/sprite_accessory/facial_hair/croppedbeard
	name = "Full Cropped Beard"
	icon_state = "facial_croppedfullbeard"

/datum/sprite_accessory/facial_hair/chinless
	name = "Chinless Beard"
	icon_state = "facial_chinlessbeard"

/datum/sprite_accessory/facial_hair/braided
	name = "Braided Beard"
	icon_state = "facial_biker"

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/hair/una_spines_long
	name = "Long Unathi Spines"
	icon_state = "soghun_longspines"
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/hair/una_spines_short
	name = "Short Unathi Spines"
	icon_state = "soghun_shortspines"
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/hair/una_frills_long
	name = "Long Unathi Frills"
	icon_state = "soghun_longfrills"
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/hair/una_frills_short
	name = "Short Unathi Frills"
	icon_state = "soghun_shortfrills"
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/hair/una_horns
	name = "Unathi Horns"
	icon_state = "soghun_horns"
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/hair/skr_tentacle_m
	name = "Skrell Male Tentacles"
	icon_state = "skrell_hair_m"
	species_allowed = list(SPECIES_SKRELL)
	gender = MALE

/datum/sprite_accessory/hair/skr_tentacle_f
	name = "Skrell Female Tentacles"
	icon_state = "skrell_hair_f"
	species_allowed = list(SPECIES_SKRELL)
	gender = FEMALE

/datum/sprite_accessory/hair/taj_ears
	name = "Tajaran Ears"
	icon_state = "ears_plain"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_clean
	name = "Tajara Clean"
	icon_state = "hair_clean"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_bangs
	name = "Tajara Bangs"
	icon_state = "hair_bangs"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_braid
	name = "Tajara Braid"
	icon_state = "hair_tbraid"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_shaggy
	name = "Tajara Shaggy"
	icon_state = "hair_shaggy"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_mohawk
	name = "Tajaran Mohawk"
	icon_state = "hair_mohawk"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_plait
	name = "Tajara Plait"
	icon_state = "hair_plait"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_straight
	name = "Tajara Straight"
	icon_state = "hair_straight"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_long
	name = "Tajara Long"
	icon_state = "hair_long"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_rattail
	name = "Tajara Rat Tail"
	icon_state = "hair_rattail"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_spiky
	name = "Tajara Spiky"
	icon_state = "hair_tajspiky"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_messy
	name = "Tajara Messy"
	icon_state = "hair_messy"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_curls
	name = "Tajara Curly"
	icon_state = "hair_curly"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_wife
	name = "Tajara Housewife"
	icon_state = "hair_wife"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_victory
	name = "Tajara Victory Curls"
	icon_state = "hair_victory"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_bob
	name = "Tajara Bob"
	icon_state = "hair_tbob"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/taj_ears_fingercurl
	name = "Tajara Finger Curls"
	icon_state = "hair_fingerwave"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/hair/vox_quills_long
	name = "Long Vox Quills"
	icon_state = "vox_longquills"
	species_allowed = list(SPECIES_VOX)

//facial hair

/datum/sprite_accessory/facial_hair/taj_sideburns
	name = "Tajara Sideburns"
	icon_state = "facial_sideburns"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/facial_hair/taj_mutton
	name = "Tajara Mutton"
	icon_state = "facial_mutton"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/facial_hair/taj_pencilstache
	name = "Tajara Pencilstache"
	icon_state = "facial_pencilstache"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/facial_hair/taj_moustache
	name = "Tajara Moustache"
	icon_state = "facial_moustache"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/facial_hair/taj_goatee
	name = "Tajara Goatee"
	icon_state = "facial_goatee"
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/facial_hair/taj_smallstache
	name = "Tajara Smallsatche"
	icon_state = "facial_smallstache"
	species_allowed = list(SPECIES_TAJARA)

//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now
/datum/sprite_accessory/skin
	icon = 'icons/mob/human_races/r_human.dmi'

/datum/sprite_accessory/skin/human
	name = "Default human skin"
	icon_state = "default"
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/skin/human_tatt01
	name = "Tatt01 human skin"
	icon_state = "tatt1"
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/skin/tajaran
	name = "Default tajaran skin"
	icon_state = "default"
	icon = 'icons/mob/human_races/r_tajaran.dmi'
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/skin/unathi
	name = "Default Unathi skin"
	icon_state = "default"
	icon = 'icons/mob/human_races/r_lizard.dmi'
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/skin/skrell
	name = "Default skrell skin"
	icon_state = "default"
	icon = 'icons/mob/human_races/r_skrell.dmi'
	species_allowed = list(SPECIES_SKRELL)

/*
////////////////////////////
/  =--------------------=  /
/  ==  Body Markings   ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/marking
	icon = 'icons/mob/human_races/markings.dmi'
	do_colouration = 1 //Almost all of them have it, COLOR_ADD

	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajara inner-ear coloring overlay stuff.
	species_allowed = list()

	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN,BP_HEAD

/datum/sprite_accessory/marking/tat_heart
	name = "Tattoo (Heart, Torso)"
	icon_state = "tat_heart"
	body_parts = list(BP_CHEST)
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/marking/tat_hive
	name = "Tattoo (Hive, Back)"
	icon_state = "tat_hive"
	body_parts = list(BP_CHEST)
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/marking/tat_nightling
	name = "Tattoo (Nightling, Back)"
	icon_state = "tat_nightling"
	body_parts = list(BP_CHEST)
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/marking/tat_campbell
	name = "Tattoo (Campbell, R.Arm)"
	icon_state = "tat_campbell"
	body_parts = list(BP_R_ARM)
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/marking/tat_campbell/left
	name = "Tattoo (Campbell, L.Arm)"
	body_parts = list(BP_L_ARM)
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/marking/tat_tiger
	name = "Tattoo (Tiger Stripes, Body)"
	icon_state = "tat_tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/marking/taj_paw_socks
	name = "Socks Coloration (Taj)"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/paw_socks
	name = "Socks Coloration (Generic)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/belly_hands_feet
	name = "Hands/Feet/Belly Color (Minor)"
	icon_state = "bellyhandsfeetsmall"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/hands_feet_belly_full
	name = "Hands/Feet/Belly Color (Major)"
	icon_state = "bellyhandsfeet"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/hands_feet_belly_full_female
	name = "Hands,Feet,Belly Color (Major, Female)"
	icon_state = "bellyhandsfeet_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/patches
	name = "Color Patches"
	icon_state = "patches"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/patchesface
	name = "Color Patches (Face)"
	icon_state = "patchesface"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/bands
	name = "Color Bands"
	icon_state = "bands"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)

/datum/sprite_accessory/marking/bandsface
	name = "Color Bands (Face)"
	icon_state = "bandsface"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tiger_stripes
	name = "Tiger Stripes"
	icon_state = "tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN)
	species_allowed = list(SPECIES_TAJARA) //There's a tattoo for non-cats

/datum/sprite_accessory/marking/tigerhead
	name = "Tiger Stripes (Head, Minor)"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/tigerface
	name = "Tiger Stripes (Head, Major)"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJARA) //There's a tattoo for non-cats

/datum/sprite_accessory/marking/backstripe
	name = "Back Stripe"
	icon_state = "backstripe"
	body_parts = list(BP_CHEST)

//Taj specific stuff
/datum/sprite_accessory/marking/taj_belly
	name = "Belly Fur (Taj)"
	icon_state = "taj_belly"
	body_parts = list(BP_CHEST)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/taj_bellyfull
	name = "Belly Fur Wide (Taj)"
	icon_state = "taj_bellyfull"
	body_parts = list(BP_CHEST)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/taj_earsout
	name = "Outer Ear (Taj)"
	icon_state = "taj_earsout"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/taj_earsin
	name = "Inner Ear (Taj)"
	icon_state = "taj_earsin"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/taj_nose
	name = "Nose Color (Taj)"
	icon_state = "taj_nose"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/taj_crest
	name = "Chest Fur Crest (Taj)"
	icon_state = "taj_crest"
	body_parts = list(BP_CHEST)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/taj_muzzle
	name = "Muzzle Color (Taj)"
	icon_state = "taj_muzzle"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/taj_face
	name = "Cheeks Color (Taj)"
	icon_state = "taj_face"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/taj_all
	name = "All Taj Head (Taj)"
	icon_state = "taj_all"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJARA)
