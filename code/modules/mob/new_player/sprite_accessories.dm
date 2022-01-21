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
	var/list/species_allowed = list(SPECIES_HUMAN, SPECIES_ORION)

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
	var/veryshort						//doesn't need to be hidden by BLOCKHEADHAIR hats/helmets

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_ORION)
		veryshort = 1


	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
		veryshort = 1


	twintail
		name = "Twintail"
		icon_state = "hair_twintail"

	short2
		name = "Short Hair 2"
		icon_state = "hair_shorthair3"

	cut
		name = "Cut Hair"
		icon_state = "hair_c"
		veryshort = 1

	flair
		name = "Flaired Hair"
		icon_state = "hair_flair"

	long
		name = "Shoulder-length Hair"
		icon_state = "hair_b"

	/*longish
		name = "Longer Hair"
		icon_state = "hair_b2"*/

	longer
		name = "Long Hair"
		icon_state = "hair_vlong"

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

	ponytail4
		name = "Ponytail 4"
		icon_state = "hair_ponytail4"
		gender = FEMALE

	ponytail5
		name = "Ponytail 5"
		icon_state = "hair_ponytail5"
		gender = FEMALE

	ponytail6
		name = "Ponytail 6"
		icon_state = "hair_ponytail6"
		gender = FEMALE

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

	sleeze
		name = "Sleeze"
		icon_state = "hair_sleeze"
		veryshort = 1

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

	beehive2
		name = "Beehive 2"
		icon_state = "hair_beehive2"
		gender = FEMALE

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"
		gender = FEMALE
		species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_ORION)

	bob
		name = "Bob"
		icon_state = "hair_bobcut"
		gender = FEMALE
		species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_ORION)

	bobcutalt
		name = "Chin Length Bob"
		icon_state = "hair_bobcutalt"
		gender = FEMALE
		species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_ORION)

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"
		gender = MALE

	buzz
		name = "Buzzcut"
		icon_state = "hair_buzzcut"
		gender = MALE
		species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_ORION)
		veryshort = 1

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"
		gender = MALE
		veryshort = 1

	combover
		name = "Combover"
		icon_state = "hair_combover"
		gender = MALE

	father
		name = "Father"
		icon_state = "hair_father"
		gender = MALE

	reversemohawk
		name = "Reverse Mohawk"
		icon_state = "hair_reversemohawk"
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

	rows
		name = "Rows"
		icon_state = "hair_rows1"
		veryshort = 1

	rows2
		name = "Rows 2"
		icon_state = "hair_rows2"
		veryshort = 1

	sargeant
		name = "Flat Top"
		icon_state = "hair_sargeant"
		gender = MALE
		veryshort = 1

	emo
		name = "Emo"
		icon_state = "hair_emo"

	emo2
		name = "Emo Alt"
		icon_state = "hair_emo2"

	longemo
		name = "Long Emo"
		icon_state = "hair_emolong"
		gender = FEMALE

	shortovereye
		name = "Overeye Short"
		icon_state = "hair_shortovereye"

	longovereye
		name = "Overeye Long"
		icon_state = "hair_longovereye"

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
		species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_ORION)
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
		species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_ORION)
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

	shorthime
		name = "Short Hime Cut"
		icon_state = "hair_shorthime"
		gender = FEMALE

	grandebraid
		name = "Grande Braid"
		icon_state = "hair_grande"
		gender = FEMALE

	mbraid
		name = "Medium Braid"
		icon_state = "hair_shortbraid"
		gender = FEMALE

	braid2
		name = "Long Braid"
		icon_state = "hair_hbraid"
		gender = FEMALE

	braid
		name = "Floorlength Braid"
		icon_state = "hair_braid"
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
		veryshort = 1

	balding
		name = "Balding Hair"
		icon_state = "hair_e"
		gender = MALE // turnoff!
		veryshort = 1

	familyman
		name = "The Family Man"
		icon_state = "hair_thefamilyman"
		gender = MALE

	mahdrills
		name = "Drillruru"
		icon_state = "hair_drillruru"
		gender = FEMALE

	fringetail
		name = "Fringetail"
		icon_state = "hair_fringetail"
		gender = FEMALE

	dandypomp
		name = "Dandy Pompadour"
		icon_state = "hair_dandypompadour"
		gender = MALE

	poofy
		name = "Poofy"
		icon_state = "hair_poofy"
		gender = FEMALE

	crono
		name = "Chrono"
		icon_state = "hair_toriyama"
		gender = MALE

	vegeta
		name = "Vegeta"
		icon_state = "hair_toriyama2"
		gender = MALE

	cia
		name = "CIA"
		icon_state = "hair_cia"
		gender = MALE

	mulder
		name = "Mulder"
		icon_state = "hair_mulder"
		gender = MALE

	scully
		name = "Scully"
		icon_state = "hair_scully"
		gender = FEMALE

	nitori
		name = "Nitori"
		icon_state = "hair_nitori"
		gender = FEMALE

	joestar
		name = "Joestar"
		icon_state = "hair_joestar"
		gender = MALE

	volaju
		name = "Volaju"
		icon_state = "hair_volaju"

	longeralt2
		name = "Long Hair Alt 2"
		icon_state = "hair_longeralt2"

	shortbangs
		name = "Short Bangs"
		icon_state = "hair_shortbangs"

	halfshaved
		name = "Half-Shaved Emo"
		icon_state = "hair_halfshaved"

	bun
		name = "Low Bun"
		icon_state = "hair_bun"

	bun2
		name = "High Bun"
		icon_state = "hair_bun2"

	doublebun
		name = "Double-Bun"
		icon_state = "hair_doublebun"

	lowfade
		name = "Low Fade"
		icon_state = "hair_lowfade"
		gender = MALE
		veryshort = 1

	medfade
		name = "Medium Fade"
		icon_state = "hair_medfade"

	highfade
		name = "High Fade"
		icon_state = "hair_highfade"
		gender = MALE
		veryshort = 1

	baldfade
		name = "Balding Fade"
		icon_state = "hair_baldfade"
		gender = MALE
		veryshort = 1

	nofade
		name = "Regulation Cut"
		icon_state = "hair_nofade"
		gender = MALE
		veryshort = 1

	trimflat
		name = "Trimmed Flat Top"
		icon_state = "hair_trimflat"
		gender = MALE
		veryshort = 1

	shaved
		name = "Shaved"
		icon_state = "hair_shaved"
		gender = MALE
		veryshort = 1

	trimmed
		name = "Trimmed"
		icon_state = "hair_trimmed"
		gender = MALE
		veryshort = 1

	tightbun
		name = "Tight Bun"
		icon_state = "hair_tightbun"
		gender = FEMALE
		veryshort = 1

	coffeehouse
		name = "Coffee House Cut"
		icon_state = "hair_coffeehouse"
		gender = MALE
		veryshort = 1

	undercut
		name = "Undercut"
		icon_state = "hair_undercut"
		gender = MALE
		veryshort = 1

	partfade
		name = "Parted Fade"
		icon_state = "hair_shavedpart"
		gender = MALE
		veryshort = 1

	hightight
		name = "High and Tight"
		icon_state = "hair_hightight"
		gender = MALE
		veryshort = 1

	rowbun
		name = "Row Bun"
		icon_state = "hair_rowbun"
		gender = FEMALE

	rowdualbraid
		name = "Row Dual Braid"
		icon_state = "hair_rowdualtail"
		gender = FEMALE

	rowbraid
		name = "Row Braid"
		icon_state = "hair_rowbraid"
		gender = FEMALE

	regulationmohawk
		name = "Regulation Mohawk"
		icon_state = "hair_shavedmohawk"
		gender = MALE
		veryshort = 1

	topknot
		name = "Topknot"
		icon_state = "hair_topknot"
		gender = MALE

	ronin
		name = "Ronin"
		icon_state = "hair_ronin"
		gender = MALE

	bowlcut2
		name = "Bowl2"
		icon_state = "hair_bowlcut2"
		gender = MALE

	thinning
		name = "Thinning"
		icon_state = "hair_thinning"
		gender = MALE
		veryshort = 1

	thinningfront
		name = "Thinning Front"
		icon_state = "hair_thinningfront"
		gender = MALE
		veryshort = 1

	thinningback
		name = "Thinning Back"
		icon_state = "hair_thinningrear"
		gender = MALE
		veryshort = 1

	manbun
		name = "Manbun"
		icon_state = "hair_manbun"
		gender = MALE
/*
///////////////////////////////////
/  =---------------------------=  /
/  == Spartan Hair Definitions==  /
/  =---------------------------=  /
///////////////////////////////////
*/

	spartan_bald
		name = "s_Bald"
		icon = 'icons/mob/Spartan_face.dmi'
		icon_state = "sbald"
		gender = MALE
		species_allowed = list(SPECIES_SPARTAN)

	spartan_short
		name = "s_Short Hair"
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		icon_state = "shair_a"
		veryshort = 1

	spartan_twintail
		name = "s_Twintail"
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		icon_state = "shair_twintail"

	spartan_short2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Short Hair 2"
		icon_state = "shair_shorthair3"

	spartan_cut
		name = "s_Cut Hair"
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		icon_state = "shair_c"
		veryshort = 1

	spartan_flair
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Flaired Hair"
		icon_state = "shair_flair"

	spartan_long
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Shoulder-length Hair"
		icon_state = "shair_b"

	spartan_longer
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Long Hair"
		icon_state = "shair_vlong"

	spartan_longest
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Very Long Hair"
		icon_state = "shair_longest"

	spartan_longfringe
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Long Fringe"
		icon_state = "shair_longfringe"

	spartan_longestalt
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Longer Fringe"
		icon_state = "shair_vlongfringe"

	spartan_halfbang
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Half-banged Hair"
		icon_state = "shair_halfbang"

	spartan_halfbangalt
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Half-banged Hair Alt"
		icon_state = "shair_halfbang_alt"

	spartan_ponytail1
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Ponytail 1"
		icon_state = "shair_ponytail"

	spartan_ponytail2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Ponytail 2"
		icon_state = "shair_pa"
		gender = FEMALE

	spartan_ponytail3
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Ponytail 3"
		icon_state = "shair_ponytail3"

	spartan_ponytail4
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Ponytail 4"
		icon_state = "shair_ponytail4"
		gender = FEMALE

	spartan_ponytail5
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Ponytail 5"
		icon_state = "shair_ponytail5"
		gender = FEMALE

	spartan_ponytail6
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Ponytail 6"
		icon_state = "shair_ponytail6"
		gender = FEMALE

	spartan_sideponytail
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Side Ponytail"
		icon_state = "shair_stail"
		gender = FEMALE

	spartan_parted
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Parted"
		icon_state = "shair_parted"

	spartan_pompadour
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Pompadour"
		icon_state = "shair_pompadour"
		gender = MALE

	spartan_sleeze
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Sleeze"
		icon_state = "shair_sleeze"
		veryshort = 1

	spartan_quiff
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Quiff"
		icon_state = "shair_quiff"
		gender = MALE

	spartan_bedhead
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Bedhead"
		icon_state = "shair_bedhead"

	spartan_bedhead2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Bedhead 2"
		icon_state = "shair_bedheadv2"

	spartan_bedhead3
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Bedhead 3"
		icon_state = "shair_bedheadv3"


	spartan_beehive2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Beehive 2"
		icon_state = "shair_beehive2"
		gender = FEMALE

	spartan_bobcurl
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Bobcurl"
		icon_state = "shair_bobcurl"
		gender = FEMALE

	spartan_bob
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Bob"
		icon_state = "shair_bobcut"
		gender = FEMALE

	spartan_bobcutalt
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Chin Length Bob"
		icon_state = "shair_bobcutalt"
		gender = FEMALE

	spartan_bowl
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Bowl"
		icon_state = "shair_bowlcut"
		gender = MALE

	spartan_buzz
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Buzzcut"
		icon_state = "shair_buzzcut"
		gender = MALE
		veryshort = 1

	spartan_crew
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Crewcut"
		icon_state = "shair_crewcut"
		gender = MALE
		veryshort = 1

	spartan_combover
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Combover"
		icon_state = "shair_combover"
		gender = MALE

	spartan_father
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Father"
		icon_state = "shair_father"
		gender = MALE

	spartan_reversemohawk
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Reverse Mohawk"
		icon_state = "shair_reversemohawk"
		gender = MALE

	spartan_devillock
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Devil Lock"
		icon_state = "shair_devilock"

	spartan_dreadlocks
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Dreadlocks"
		icon_state = "shair_dreads"

	spartan_curls
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Curls"
		icon_state = "shair_curls"

	spartan_afro
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Afro"
		icon_state = "shair_afro"

	spartan_rows
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Rows"
		icon_state = "shair_rows1"
		veryshort = 1

	spartan_rows2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Rows 2"
		icon_state = "shair_rows2"
		veryshort = 1

	spartan_sargeant
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Flat Top"
		icon_state = "shair_sargeant"
		gender = MALE
		veryshort = 1

	spartan_emo
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Emo"
		icon_state = "shair_emo"

	spartan_emo2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Emo Alt"
		icon_state = "shair_emo2"

	spartan_longemo
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Long Emo"
		icon_state = "shair_emolong"
		gender = FEMALE

	spartan_shortovereye
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Overeye Short"
		icon_state = "shair_shortovereye"

	spartan_longovereye
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Overeye Long"
		icon_state = "shair_longovereye"

	spartan_fag
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Flow Hair"
		icon_state = "shair_f"

	spartan_feather
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Feather"
		icon_state = "shair_feather"

	spartan_hitop
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Hitop"
		icon_state = "shair_hitop"
		gender = MALE

	spartan_mohawk
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Mohawk"
		icon_state = "shair_d"

	spartan_jensen
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Adam Jensen Hair"
		icon_state = "shair_jensen"
		gender = MALE

	spartan_gelled
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Gelled Back"
		icon_state = "shair_gelled"
		gender = FEMALE

	spartan_gentle
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Gentle"
		icon_state = "shair_gentle"
		gender = FEMALE

	spartan_spiky
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Spiky"
		icon_state = "shair_spikey"

	spartan_kusangi
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Kusanagi Hair"
		icon_state = "shair_kusanagi"

	spartan_kagami
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Pigtails"
		icon_state = "shair_kagami"
		gender = FEMALE

	spartan_himecut
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Hime Cut"
		icon_state = "shair_himecut"
		gender = FEMALE

	spartan_shorthime
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Short Hime Cut"
		icon_state = "shair_shorthime"
		gender = FEMALE

	spartan_grandebraid
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Grande Braid"
		icon_state = "shair_grande"
		gender = FEMALE

	spartan_mbraid
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Medium Braid"
		icon_state = "shair_shortbraid"
		gender = FEMALE

	spartan_braid2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Long Braid"
		icon_state = "shair_hbraid"
		gender = FEMALE

	spartan_braid
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Floorlength Braid"
		icon_state = "shair_braid"
		gender = FEMALE

	spartan_odango
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Odango"
		icon_state = "shair_odango"
		gender = FEMALE

	spartan_ombre
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Ombre"
		icon_state = "shair_ombre"
		gender = FEMALE

	spartan_skinhead
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Skinhead"
		icon_state = "shair_skinhead"
		veryshort = 1

	spartan_balding
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Balding Hair"
		icon_state = "shair_e"
		gender = MALE
		veryshort = 1

	spartan_familyman
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_The Family Man"
		icon_state = "shair_thefamilyman"
		gender = MALE

	spartan_mahdrills
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Drillruru"
		icon_state = "shair_drillruru"
		gender = FEMALE

	spartan_fringetail
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Fringetail"
		icon_state = "shair_fringetail"
		gender = FEMALE

	spartan_dandypomp
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Dandy Pompadour"
		icon_state = "shair_dandypompadour"
		gender = MALE

	spartan_poofy
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Poofy"
		icon_state = "shair_poofy"
		gender = FEMALE

	spartan_cia
		name = "s_CIA"
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		icon_state = "shair_cia"
		gender = MALE

	spartan_mulder
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Mulder"
		icon_state = "shair_mulder"
		gender = MALE

	spartan_scully
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Scully"
		icon_state = "shair_scully"
		gender = FEMALE

	spartan_nitori
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Nitori"
		icon_state = "shair_nitori"
		gender = FEMALE

	spartan_joestar
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Joestar"
		icon_state = "shair_joestar"
		gender = MALE

	spartan_volaju
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Volaju"
		icon_state = "shair_volaju"

	spartan_longeralt2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Long Hair Alt 2"
		icon_state = "shair_longeralt2"

	spartan_shortbangs
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Short Bangs"
		icon_state = "shair_shortbangs"

	spartan_halfshaved
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Half-Shaved Emo"
		icon_state = "shair_halfshaved"

	spartan_bun
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Low Bun"
		icon_state = "shair_bun"

	spartan_bun2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_High Bun"
		icon_state = "shair_bun2"

	spartan_doublebun
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Double-Bun"
		icon_state = "shair_doublebun"

	spartan_lowfade
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Low Fade"
		icon_state = "shair_lowfade"
		gender = MALE
		veryshort = 1

	spartan_medfade
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Medium Fade"
		icon_state = "shair_medfade"

	spartan_highfade
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_High Fade"
		icon_state = "shair_highfade"
		gender = MALE
		veryshort = 1

	spartan_baldfade
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Balding Fade"
		icon_state = "shair_baldfade"
		gender = MALE
		veryshort = 1

	spartan_nofade
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Regulation Cut"
		icon_state = "shair_nofade"
		gender = MALE
		veryshort = 1

	spartan_trimflat
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Trimmed Flat Top"
		icon_state = "shair_trimflat"
		gender = MALE
		veryshort = 1

	spartan_shaved
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Shaved"
		icon_state = "shair_shaved"
		gender = MALE
		veryshort = 1

	spartan_trimmed
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Trimmed"
		icon_state = "shair_trimmed"
		gender = MALE
		veryshort = 1

	spartan_tightbun
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Tight Bun"
		icon_state = "shair_tightbun"
		gender = FEMALE
		veryshort = 1

	spartan_coffeehouse
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Coffee House Cut"
		icon_state = "shair_coffeehouse"
		gender = MALE
		veryshort = 1

	spartan_undercut
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Undercut"
		icon_state = "shair_undercut"
		gender = MALE
		veryshort = 1

	spartan_partfade
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Parted Fade"
		icon_state = "shair_shavedpart"
		gender = MALE
		veryshort = 1

	spartan_hightight
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_High and Tight"
		icon_state = "shair_hightight"
		gender = MALE
		veryshort = 1

	spartan_rowbun
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Row Bun"
		icon_state = "shair_rowbun"
		gender = FEMALE

	spartan_rowdualbraid
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Row Dual Braid"
		icon_state = "shair_rowdualtail"
		gender = FEMALE

	spartan_rowbraid
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Row Braid"
		icon_state = "shair_rowbraid"
		gender = FEMALE

	spartan_regulationmohawk
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Regulation Mohawk"
		icon_state = "shair_shavedmohawk"
		gender = MALE
		veryshort = 1

	spartan_topknot
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Topknot"
		icon_state = "shair_topknot"
		gender = MALE

	spartan_ronin
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Ronin"
		icon_state = "shair_ronin"
		gender = MALE

	spartan_bowlcut2
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Bowl2"
		icon_state = "shair_bowlcut2"
		gender = MALE

	spartan_thinning
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Thinning"
		icon_state = "shair_thinning"
		gender = MALE
		veryshort = 1

	spartan_thinningfront
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Thinning Front"
		icon_state = "shair_thinningfront"
		gender = MALE
		veryshort = 1

	spartan_thinningback
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Thinning Back"
		icon_state = "shair_thinningrear"
		gender = MALE
		veryshort = 1

	spartan_manbun
		icon = 'icons/mob/Spartan_face.dmi'
		species_allowed = list(SPECIES_SPARTAN)
		name = "s_Manbun"
		icon_state = "shair_manbun"
		gender = MALE


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

	shaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER
		species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_VOX,SPECIES_IPC,SPECIES_ORION)

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
		species_allowed = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_ORION)

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

	volaju
		name = "Volaju"
		icon_state = "facial_volaju"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

	threeOclock
		name = "3 O'clock Shadow"
		icon_state = "facial_3oclock"

	threeOclockstache
		name = "3 O'clock Shadow and Moustache"
		icon_state = "facial_3oclockmoustache"

	fiveOclock
		name = "5 O'clock Shadow"
		icon_state = "facial_5oclock"

	fiveOclockstache
		name = "5 O'clock Shadow and Moustache"
		icon_state = "facial_5oclockmoustache"

	sevenOclock
		name = "7 O'clock Shadow"
		icon_state = "facial_7oclock"

	sevenOclockstache
		name = "7 O'clock Shadow and Moustache"
		icon_state = "facial_7oclockmoustache"

	mutton
		name = "Mutton Chops"
		icon_state = "facial_mutton"

	muttonstache
		name = "Mutton Chops and Moustache"
		icon_state = "facial_muttonmus"

	walrus
		name = "Walrus Moustache"
		icon_state = "facial_walrus"

	croppedbeard
		name = "Full Cropped Beard"
		icon_state = "facial_croppedfullbeard"

	chinless
		name = "Chinless Beard"
		icon_state = "facial_chinlessbeard"

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
		species_allowed = list(SPECIES_UNATHI)

	una_spines_short
		name = "Short Unathi Spines"
		icon_state = "soghun_shortspines"
		species_allowed = list(SPECIES_UNATHI)

	una_frills_long
		name = "Long Unathi Frills"
		icon_state = "soghun_longfrills"
		species_allowed = list(SPECIES_UNATHI)

	una_frills_short
		name = "Short Unathi Frills"
		icon_state = "soghun_shortfrills"
		species_allowed = list(SPECIES_UNATHI)

	una_horns
		name = "Unathi Horns"
		icon_state = "soghun_horns"
		species_allowed = list(SPECIES_UNATHI)

	skr_tentacle_m
		name = "Skrell Male Tentacles"
		icon_state = "skrell_hair_m"
		species_allowed = list(SPECIES_SKRELL)
		gender = MALE

	skr_tentacle_f
		name = "Skrell Female Tentacles"
		icon_state = "skrell_hair_f"
		species_allowed = list(SPECIES_SKRELL)
		gender = FEMALE

	taj_ears
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_clean
		name = "Tajara Clean"
		icon_state = "hair_clean"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_bangs
		name = "Tajara Bangs"
		icon_state = "hair_bangs"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_braid
		name = "Tajara Braid"
		icon_state = "hair_tbraid"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_shaggy
		name = "Tajara Shaggy"
		icon_state = "hair_shaggy"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_mohawk
		name = "Tajaran Mohawk"
		icon_state = "hair_mohawk"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_plait
		name = "Tajara Plait"
		icon_state = "hair_plait"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_straight
		name = "Tajara Straight"
		icon_state = "hair_straight"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_long
		name = "Tajara Long"
		icon_state = "hair_long"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_rattail
		name = "Tajara Rat Tail"
		icon_state = "hair_rattail"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_spiky
		name = "Tajara Spiky"
		icon_state = "hair_tajspiky"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_messy
		name = "Tajara Messy"
		icon_state = "hair_messy"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_curls
		name = "Tajara Curly"
		icon_state = "hair_curly"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_wife
		name = "Tajara Housewife"
		icon_state = "hair_wife"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_victory
		name = "Tajara Victory Curls"
		icon_state = "hair_victory"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_bob
		name = "Tajara Bob"
		icon_state = "hair_tbob"
		species_allowed = list(SPECIES_TAJARA)

	taj_ears_fingercurl
		name = "Tajara Finger Curls"
		icon_state = "hair_fingerwave"
		species_allowed = list(SPECIES_TAJARA)

	vox_quills_long
		name = "Long Vox Quills"
		icon_state = "vox_longquills"
		species_allowed = list(SPECIES_VOX)

/datum/sprite_accessory/facial_hair

	taj_sideburns
		name = "Tajara Sideburns"
		icon_state = "facial_sideburns"
		species_allowed = list(SPECIES_TAJARA)

	taj_mutton
		name = "Tajara Mutton"
		icon_state = "facial_mutton"
		species_allowed = list(SPECIES_TAJARA)

	taj_pencilstache
		name = "Tajara Pencilstache"
		icon_state = "facial_pencilstache"
		species_allowed = list(SPECIES_TAJARA)

	taj_moustache
		name = "Tajara Moustache"
		icon_state = "facial_moustache"
		species_allowed = list(SPECIES_TAJARA)

	taj_goatee
		name = "Tajara Goatee"
		icon_state = "facial_goatee"
		species_allowed = list(SPECIES_TAJARA)

	taj_smallstache
		name = "Tajara Smallsatche"
		icon_state = "facial_smallstache"
		species_allowed = list(SPECIES_TAJARA)

//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now
/datum/sprite_accessory/skin
	icon = 'icons/mob/human_races/r_human.dmi'

	human
		name = "Default human skin"
		icon_state = "default"
		species_allowed = list(SPECIES_HUMAN,SPECIES_ORION)

	human_tatt01
		name = "Tatt01 human skin"
		icon_state = "tatt1"
		species_allowed = list(SPECIES_HUMAN,SPECIES_ORION)

	tajaran
		name = "Default tajaran skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_tajaran.dmi'
		species_allowed = list(SPECIES_TAJARA)

	unathi
		name = "Default Unathi skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_lizard.dmi'
		species_allowed = list(SPECIES_UNATHI)

	skrell
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

	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajara inner-ear coloring overlay stuff.
	species_allowed = list()

	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN,BP_HEAD

/datum/sprite_accessory/marking/tat_heart
	name = "Tattoo (Heart, Torso)"
	icon_state = "tat_heart"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/tat_hive
	name = "Tattoo (Hive, Back)"
	icon_state = "tat_hive"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/tat_nightling
	name = "Tattoo (Nightling, Back)"
	icon_state = "tat_nightling"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/tat_campbell
	name = "Tattoo (Campbell, R.Arm)"
	icon_state = "tat_campbell"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_campbell/left
		name = "Tattoo (Campbell, L.Arm)"
		body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_tiger
	name = "Tattoo (Tiger Stripes, Body)"
	icon_state = "tat_tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)

/datum/sprite_accessory/marking/taj_paw_socks
	name = "Socks Coloration (Taj)"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/paw_socks
	name = "Socks Coloration (Generic)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/belly_hands_feet
	name = "Hands/Feet/Belly Color (Minor)"
	icon_state = "bellyhandsfeetsmall"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/hands_feet_belly_full
	name = "Hands/Feet/Belly Color (Major)"
	icon_state = "bellyhandsfeet"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/hands_feet_belly_full_female
	name = "Hands,Feet,Belly Color (Major, Female)"
	icon_state = "bellyhandsfeet_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_CHEST)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/patches
	name = "Color Patches"
	icon_state = "patches"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/patchesface
	name = "Color Patches (Face)"
	icon_state = "patchesface"
	body_parts = list(BP_HEAD)
	species_allowed = list("Tajara")

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
	species_allowed = list("Tajara") //There's a tattoo for non-cats

/datum/sprite_accessory/marking/tigerhead
	name = "Tiger Stripes (Head, Minor)"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tigerface
	name = "Tiger Stripes (Head, Major)"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)
	species_allowed = list("Tajara") //There's a tattoo for non-cats

/datum/sprite_accessory/marking/backstripe
	name = "Back Stripe"
	icon_state = "backstripe"
	body_parts = list(BP_CHEST)

//Taj specific stuff
/datum/sprite_accessory/marking/taj_belly
	name = "Belly Fur (Taj)"
	icon_state = "taj_belly"
	body_parts = list(BP_CHEST)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/taj_bellyfull
	name = "Belly Fur Wide (Taj)"
	icon_state = "taj_bellyfull"
	body_parts = list(BP_CHEST)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/taj_earsout
	name = "Outer Ear (Taj)"
	icon_state = "taj_earsout"
	body_parts = list(BP_HEAD)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/taj_earsin
	name = "Inner Ear (Taj)"
	icon_state = "taj_earsin"
	body_parts = list(BP_HEAD)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/taj_nose
	name = "Nose Color (Taj)"
	icon_state = "taj_nose"
	body_parts = list(BP_HEAD)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/taj_crest
	name = "Chest Fur Crest (Taj)"
	icon_state = "taj_crest"
	body_parts = list(BP_CHEST)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/taj_muzzle
	name = "Muzzle Color (Taj)"
	icon_state = "taj_muzzle"
	body_parts = list(BP_HEAD)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/taj_face
	name = "Cheeks Color (Taj)"
	icon_state = "taj_face"
	body_parts = list(BP_HEAD)
	species_allowed = list("Tajara")

/datum/sprite_accessory/marking/taj_all
	name = "All Taj Head (Taj)"
	icon_state = "taj_all"
	body_parts = list(BP_HEAD)
	species_allowed = list("Tajara")
