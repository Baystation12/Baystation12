
/datum/sprite_accessory/
	var/extra = 0

/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair/eros

	drillruru2
		drillruru2
		name = "Drillruru2"
		icon_state = "drillruru2"

	poofy2
		poofy2
		name = "Poofy2"
		icon_state = "poofy2"

	ponytail6
		ponytail6
		name = "Ponytail6"
		icon_state = "ponytail6"

	modern
		modern
		name = "Modern"
		icon_state = "modern"

	asymmetric_cut
		asymmetric_cut
		name = "Asymmetric cut"
		icon_state = "asymmetric_cut"

	wisp
		name = "Wisp"
		icon_state = "hair_wisp"

	longemo
		name = "Long Emo"
		icon_state = "hair_emolong"

	fringeemo
		name = "Emo Fringe"
		icon_state = "hair_emofringe"

	nia
		name = "Nia"
		icon_state = "hair_nia"

	eighties
		name = "80's"
		icon_state = "hair_80s"

	spikyponytail
		name = "Spiky Ponytail"
		icon_state = "hair_spikyponytail"
/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair/eros

	gender = NEUTER

/*
/////////////////////////////
/  =---------------------=  /
/  == Dicks Definitions ==  /
/  =---------------------=  /
/////////////////////////////
*/

/datum/sprite_accessory/dicks
	icon = 'icons/eros/mob/extras/dicks.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox","Machine","Akula","Lamia", "Drider","Resomi","Promethean")

	dik_normal
		name = "Normal Dick"
		icon_state = "normal"

	dik_circumcised
		name = "Circumcised Dick"
		icon_state = "cut"

	dik_big
		name = "Big Dick"
		icon_state = "big"

	dik_big2
		name = "Bigger Dick"
		icon_state = "big2"

	dik_small
		name = "Small Dick"
		icon_state = "small"

	dik_knotteds
		name = "Knotted Small Dick"
		icon_state = "knotted_small"

	dik_knotted
		name = "Knotted Dick"
		icon_state = "knotted"

	dik_knottedl
		name = "Knotted Large Dick"
		icon_state = "knotted_large"

	dik_knotbs
		name = "Knotted, Barbed Small Dick"
		icon_state = "barbknot_small"

	dik_knotb
		name = "Knotted, Barbed Dick"
		icon_state = "barbknot"

	dik_knotbl
		name = "Knotted, Barbed Large Dick"
		icon_state = "barbknot_large"

	dik_tapereds
		name = "Tapered Small Dick"
		icon_state = "tapered_small"

	dik_tapered
		name = "Tapered Dick"
		icon_state = "tapered"

	dik_taperedl
		name = "Tapered Large Dick"
		icon_state = "tapered_large"

	dik_flareds
		name = "Flared Small Dick"
		icon_state = "flared_small"

	dik_flared
		name = "Flared Dick"
		icon_state = "flared"

	dik_flaredl
		name = "Flared Large Dick"
		icon_state = "flared_large"

	dik_feline
		name = "Feline Dick"
		icon_state = "feline"

	dik_tentacle
		name = "Tentacle Dicks"
		icon_state = "tentacle"

	dik_tentacle2
		name = "Tentacle Big Dicks"
		icon_state = "tentacle_big"

	dik_hemi
		name = "Hemipenes / Claspers"
		icon_state = "hemi"

	dik_normal_slime
		name = "Slime Normal Dick"
		icon_state = "normal_slime"
		species_allowed = list ("Promethean")

	dik_small_slime
		name = "Slime Small Dick"
		icon_state = "small_slime"
		species_allowed = list ("Promethean")

	dik_big2_slime
		name = "Slime Bigger Dick"
		icon_state = "big2_slime"
		species_allowed = list ("Promethean")

	dik_amputed
		name = "Amputed Dick"
		icon_state = "amputed"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_bishop
		name = "Bishop Synthpenis"
		icon_state = "robo-bishop"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_hesphiastos
		name = "Hesphiastos Synthpenis"
		icon_state = "robo-hesphiastos"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_morpheus
		name = "Morpheus Synthpenis"
		icon_state = "robo-morpheus"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_wardtakahashi
		name = "Ward-Takahashi Synthpenis"
		icon_state = "robo-wardtakahashi"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_zenghu
		name = "Zeng-hu Synthpenis"
		icon_state = "robo-zenghu"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_xion
		name = "Xion Synthpenis"
		icon_state = "robo-xion"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_nt
		name = "NanoTrasen Synthpenis"
		icon_state = "robo-nanotrasen"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_morpheus
		name = "Morpheus Synthpenis"
		icon_state = "robo-morpheus"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_scorpius
		name = "Scorpius Synthpenis"
		icon_state = "robo-scorpius"
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	dik_unbranded
		name = "Unbranded Synthpenis"
		icon_state = "robo-unbranded"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

/*
//////////////////////////////
/  =----------------------=  /
/  == Vagina Definitions ==  /
/  =----------------------=  /
//////////////////////////////
*/

/datum/sprite_accessory/vaginas
	icon = 'icons/eros/mob/extras/vaginas.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	vag_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox","Machine","Akula","Lamia", "Drider", "Slime", "Resomi")

	vag_normal
		name = "Normal Vagina"
		icon_state = "normal"

	vag_hairy
		name = "Hairy Vagina"
		icon_state = "hairy"

	vag_gaping
		name = "Gaping Vagina"
		icon_state = "gaping"

	vag_dripping
		name = "Dripping Vagina"
		icon_state = "dripping"

	vag_tentacle
		name = "Tentacle Vagina"
		icon_state = "tentacles"

	vag_dentata
		name = "Vagina Dentata"
		icon_state = "dentata"
		do_colouration = 0

	vag_normal_slime
		name = "Slime Normal Vagina"
		icon_state = "normal_slime"
		species_allowed = list ("Promethean")

	vag_gaping_slime
		name = "Slime Gaping Vagina"
		icon_state = "gaping_slime"
		species_allowed = list ("Promethean")

	vag_dripping_slime
		name = "Slime Dripping Vagina"
		icon_state = "dripping_slime"
		species_allowed = list ("Promethean")

	vag_bishop
		name = "Bishop Synthvagina"
		icon_state = "robo-bishop"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	vag_hesphiastos
		name = "Hesphiastos Synthvagina"
		icon_state = "robo-hesphiastos"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	vag_morpheus
		name = "Morpheus Synthvagina"
		icon_state = "robo-morpheus"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	vag_wardtakahashi
		name = "Ward-Takahashi Synthvagina"
		icon_state = "robo-wardtakahashi"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	vag_zenghu
		name = "Zeng-hu Synthvagina"
		icon_state = "robo-zenghu"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	vag_xion
		name = "Xion Synthvagina"
		icon_state = "robo-xion"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	vag_nanotrasen
		name = "NanoTrasen Synthvagina"
		icon_state = "robo-nanotrasen"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	vag_scorpius
		name = "Scorpius Synthvagina"
		icon_state = "robo-scorpius"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	vag_unbranded
		name = "Unbranded Synthvagina"
		icon_state = "robo-unbranded"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

/*
///////////////////////////////
/  =-----------------------=  /
/  == Breasts Definitions ==  /
/  =-----------------------=  /
///////////////////////////////
*/

/datum/sprite_accessory/breasts
	icon = 'icons/eros/mob/extras/breasts.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	brt_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox","Machine","Akula","Lamia", "Drider", "Promethean", "Resomi")

	brt_normala
		name = "Tiny Breasts"
		icon_state = "normal_a"

	brt_normalb
		name = "Small Breasts"
		icon_state = "normal_b"

	brt_normalc
		name = "Normal Breasts"
		icon_state = "normal_c"

	brt_normald
		name = "Big Breasts"
		icon_state = "normal_d"

	brt_normale
		name = "Very Big Breasts"
		icon_state = "normal_e"

	brt_slimea
		name = "Slime Tiny Breasts"
		icon_state = "slime_a"
		species_allowed = list ("Promethean")

	brt_slimeb
		name = "Slime Small Breasts"
		icon_state = "slime_b"
		species_allowed = list ("Promethean")

	brt_slimec
		name = "Slime Normal Breasts"
		icon_state = "slime_c"
		species_allowed = list ("Promethean")

	brt_slimed
		name = "Slime Big Breasts"
		icon_state = "slime_d"
		species_allowed = list ("Promethean")

	brt_slimee
		name = "Slime Very Big Breasts"
		icon_state = "slime_e"
		species_allowed = list ("Promethean")


	brt_bishop
		name = "Bishop Synthbreasts"
		icon_state = "robo-bishop"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	brt_hesphiastos
		name = "Hesphiastos Synthbreasts"
		icon_state = "robo-hesphiastos"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	brt_wardtakahashi
		name = "Ward-Takahashi Synthbreasts"
		icon_state = "robo-wardtakahashi"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	brt_zenghu
		name = "Zeng-hu Synthbreasts"
		icon_state = "robo-zenghu"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	brt_xion
		name = "Xion Synthbreasts"
		icon_state = "robo-xion"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	brt_nt
		name = "NanoTrasen Synthbreasts"
		icon_state = "robo-nanotrasen"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	brt_scorpius
		name = "Scorpius Synthbreasts"
		icon_state = "robo-scorpius"
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	brt_morpheus
		name = "Morpheus Synthbreasts"
		icon_state = "robo-morpheus"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	brt_unbranded
		name = "Unbranded Synthbreasts"
		icon_state = "robo-unbranded"
		do_colouration = 0
		species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")


/*
///////////////////////////////
/  =-----------------------=  /
/  == Ears	  Definitions ==  /
/  =-----------------------=  /
///////////////////////////////
*/

/datum/sprite_accessory/ears
	icon = 'icons/eros/mob/extras/ears.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	ear_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Machine","Akula","Lamia", "Drider", "Resomi", "Machine", "Vox")

	ear_bear
		name = "Bear Ears"
		icon_state = "bear"

	ear_bee
		name = "Bee Antenae"
		icon_state = "bee"
		do_colouration = 0

	ear_bee_c
		name = "Bee Antenae (Colorable)"
		icon_state = "bee_c"

	ear_bunny
		name = "Bunny Ears"
		icon_state = "bunny"

	ear_cat
		name = "Cat Ears"
		icon_state = "kitty"
		extra = 1

	ear_tiger
		name = "Tiger Ears"
		icon_state = "tiger"
		extra = 1

	ear_deathclaw
		name = "Deathclaw Ears"
		icon_state = "deathclaw"
		do_colouration = 0

	ear_deathclaw_c
		name = "Deathclaw Ears (Colorable)"
		icon_state = "deathclaw_c"

	ear_horn_oni
		name = "Oni Horns"
		icon_state = "horns_oni"

	ear_horn_demon
		name = "Demon Horns"
		icon_state = "horns_demon"

	ear_horn_curled
		name = "Curled Horns"
		icon_state = "horns_curled"

	ear_horn_ram
		name = "Ram Horns"
		icon_state = "horns_ram"

	ear_horn_curled
		name = "Short Horns"
		icon_state = "horns_short"

	ear_kitsune_colour
		name = "Kitsune Ears"
		icon_state = "kitsune"
		extra = 1

	ear_mouse
		name = "Mouse Ears"
		icon_state = "mouse"
		extra = 1

	ear_squirrel
		name = "Squirrel Ears"
		icon_state = "squirrel"

	ear_wolf
		name = "Wolf Ears"
		icon_state = "wolf"
		extra = 1

	ear_dog
		name = "Dog Ears"		// Citadel
		icon_state = "lab"

	ear_cow
		name = "Cow Ears + Horns"		// Citadel
		icon_state = "cow"
		extra = 1

	ear_lop
		name = "Lop Bunny Ears"		// Citadel
		icon_state = "lop"

	ear_angler
		name = "Angler Lure"		// /tg/
		icon_state = "angler"

	ear_deer1
		name = "Deer Ears"		// Citadel
		icon_state = "deer1"

	ear_deer2
		name = "Deer Ears + Antlers"		// Citadel
		icon_state = "deer2"
		extra = 1

	ear_antlers
		name = "Antlers (Brown)"		// Citadel
		icon_state = "antlers"
		do_colouration = 0

	ear_antlers_c
		name = "Antlers (Colorable)"		// Citadel
		icon_state = "antlers_c"

/*
///////////////////////////////
/  =-----------------------=  /
/  == Wings	  Definitions ==  /
/  =-----------------------=  /
///////////////////////////////
*/

/datum/sprite_accessory/wings
	icon = 'icons/eros/mob/extras/wings.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	wng_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell", "Machine","Akula","Lamia", "Drider", "Resomi", "Machine", "Vox")

	wng_angel
		name = "Angel Wings"
		icon_state = "angel"

	wng_bee
		name = "Bee Wings"
		icon_state = "bee"

	wng_bee
		name = "Bee Wings (Uncolored)"
		icon_state = "bee"
		do_colouration = 0

	wng_bat
		name = "Bat Wings"
		icon_state = "bat"

	wng_feathered
		name = "Feathered Wings"
		icon_state = "feathered"

	wng_succubus
		name = "Succubus Wings"
		icon_state = "succubus"

	wng_smallfairy
		name = "Small Fairy Wings"		// /vg/
		icon_state = "smallfairy"

	wng_turtle
		name = "Turtle Shell"		// Citadel
		icon_state = "turtle"

	wng_tentacles
		name = "Back Tentacles"		// Citadel
		icon_state = "tentacle"

	wng_deathclawspines
		name = "Deathclaw Spines"
		icon_state = "deathclawspines"

	wng_resomi
		name = "Resomi Feathers"
		icon_state = "resomi"
		species_allowed = list("Resomi")

/*
///////////////////////////////
/  =-----------------------=  /
/  == Tails	  Definitions ==  /
/  =-----------------------=  /
///////////////////////////////
*/

/datum/sprite_accessory/tails
	icon = 'icons/eros/mob/extras/tails.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia", "Drider", "Machine")

	tal_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell", "Machine","Akula", "Resomi", "Machine", "Vox")

	tal_bunny
		name = "Bunny Tail"
		icon_state = "bunny"

	tal_bear
		name = "Bear Tail"
		icon_state = "bear"

	tal_cat_down
		name = "Cat Tail, Down"
		icon_state = "kittydown"

	tal_cat_up
		name = "Cat Tail, Up"
		icon_state = "kittyup"

	tal_mouse
		name = "Mouse Tail"
		icon_state = "mouse"

	tal_spiny
		name = "Spiny Tail"
		icon_state = "spiny"
		extra = 1

	tal_kitsune
		name = "Kitsune Tails"
		icon_state = "kitsune"
		extra = 1

	tal_kitsune/extra
		name = "Kitsune Tails,(full color)"
		extra = 0

	tal_squirrel
		name = "Squirrel Tail"
		icon_state = "squirrel"

	tal_squirrel/alt
		name = "Squirrel Tail, (alternate)"
		icon_state = "squirrel_alt"

	tal_tiger
		name = "Tiger Tail"
		icon_state = "tiger"
		extra = 1

	tal_tiger/alt
		name = "Tiger Tail, (alternate)"
		icon_state = "tiger_alt"
		extra = 0

	tal_wolf
		name = "Wolf Tail"
		icon_state = "wolf"

	tal_wolf/fluffy
		name = "Wolf Tail, (fluffy)"
		icon_state = "wolf_fluffy"

	tal_fox
		name = "Fox Tail"
		icon_state = "fox"
		extra = 1

	tal_fox/fluffy
		name = "Fox Tail, (fluffy)"
		icon_state = "fox_fluffy"

	tal_fox/alt
		name = "Fox Tail, (alternate)"
		icon_state = "fox_alt"
		extra = 0

	tal_corgi
		name = "Corgi Tail"
		icon_state = "corgi"

	tal_tajara
		name = "Tajara Tail"
		icon_state = "tajara"

	tal_lizard
		name = "Unathi Tail"
		icon_state = "unathi"

	tal_sharktail
		name = "Akula Tail"
		icon_state = "sharktail"

	tal_bee
		name = "Bee Stinger"
		icon_state = "bee"

	tal_feathers
		name = "Feathers"		// Citadel
		icon_state = "feathers"

	tal_cow
		name = "Cow Tail"		// Citadel
		icon_state = "cow"

	tal_deer
		name = "Deer Tail"		// Citadel
		icon_state = "deer"

	tal_demon
		name = "Demon Tail"
		icon_state = "demon"

	tal_scorpius
		name = "Scorpius FBP Tail"
		icon_state = "scorpius"

	tal_resomi
		name = "Resomi Tail"
		icon_state = "resomi"
		species_allowed = list("Resomi")