/obj/item/clothing/under/scp_uniform
	name = "SCP guard uniform"
	desc = "It's dark grey uniform made of a slightly sturdier material than standard jumpsuits, to allow for good protection.\nThis uniform has SCP tags on shoulders, terran organization of NT asset protection."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "scp_uniform"
	item_state = "scp_uniform"
	worn_state = "scp_uniform"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/zpci_uniform
	name = "ZPCI uniform"
	desc = "This is a standard model of the ZPCI uniform."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "zpci_uniform"
	item_state = "zpci_uniform"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) //it's security uniform's stats
	siemens_coefficient = 0.9
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/unathi/onmob_under_unathi.dmi'
	)

/obj/item/clothing/under/rank/security/saarecombat
	name = "\improper SAARE combat uniform"
	desc = "Tight-fitting dark uniform with a bright-green SAARE patch on the shoulder. The perfect outfit in which to kick doors out and teeth in."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "saarecombat"
	item_state = "saarecombat"
	worn_state = "saarecombat"
	gender_icons = 1
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/unathi/onmob_under_unathi.dmi'
	)

// SIERRA TO DO: Cleanup icons from unused loadout

/obj/item/clothing/under/gray_camo
	name = "camo uniform"
	desc = "It's camo unifrom made of a slightly sturdier material than standard jumpsuits, to allow for good protection and military style."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "gray_camo"
	item_state = "gray_camo"
	worn_state = "gray_camo"

// Retro

/obj/item/clothing/under/retro/security
	desc = "A retro corporate security jumpsuit. Although it provides same protection as modern jumpsuits do, wearing this almost feels like being wrapped in tarp."
	name = "retro security officer's uniform"
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "retro_sec"
	item_state = "retro_sec"
	siemens_coefficient = 0.9
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)

/obj/item/clothing/under/retro/medical
	desc = "A biologically resistant retro medical uniform with high-vis reflective stripes."
	name = "retro medical officer's uniform"
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "retro_med"
	item_state = "retro_med"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/retro/engineering
	desc = "A faded grimy engineering jumpsuit and overall combo. It craves for being soiled with oil, dust, and grit this damn instant."
	name = "retro engineering uniform"
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "retro_eng"
	item_state = "retro_eng"
	armor = list(
		rad = ARMOR_RAD_MINOR
		)

/obj/item/clothing/under/retro/science
	desc = "A faded polo and set of brown slacks with distinctive pink stripes. What a ridiculous tie."
	name = "retro science officer's uniform"
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "retro_sci"
	item_state = "retro_sci"
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/blueshift_uniform
	desc = "Blue shirt with robust jeans from robust materials. Still standard issue equipment for long clam blue shifts."
	name = "research division security uniform"
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "blueshift"
	item_state = "blueshift"

/obj/item/clothing/under/scg_expeditonary
	name = "Expeditionary Corps uniform"
	desc = "The utility uniform of the SCG Expeditionary Corps, made from biohazard resistant material. This one has silver trim."
	icon = 'maps/torch/icons/obj/obj_under_solgov.dmi'
	item_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_under_solgov.dmi')
	icon_state = "blackutility_crew"
	item_state = "bl_suit"
	worn_state = "blackutility_crew"
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_under_solgov_unathi.dmi'
	)
	siemens_coefficient = 0.8
	gender_icons = 1

/obj/item/clothing/under/scg_expeditonary/officer
	name = "Expeditionary Corps officer's uniform"
	desc = "The utility uniform of the SCG Expeditionary Corps, made from biohazard resistant material. This one has gold trim."
	icon_state = "blackutility_com"
	worn_state = "blackutility_com"
	
// Unathi garnments

/obj/item/clothing/under/medic/paramedic
	name = "first responder uniform"
	desc = "Light and bulky paramedic jumpsuit with bright markings. It's too big to fit anyone, but unathi."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/onmob_under.dmi'
	)
	species_restricted  = list(SPECIES_UNATHI)
	icon_state = "unathi_paramedic"
	item_state = "unathi_paramedic"
	worn_state = "unathi_paramedic"

/obj/item/clothing/under/security/desert
	name = "desert jumpsuit"
	desc = "A bulky and light jumpsuit designed for use in the desert. Unathi use it to withstand scorhing heat rays when \"Burning Mother\" at it's zenith, something that their scales cannot handle. It's too big to fit anyone, but unathi."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/onmob_under.dmi'
	)
	species_restricted  = list(SPECIES_UNATHI)
	icon_state = "desertuniform"
	item_state = "desertuniform"
	worn_state = "desertuniform"
	rolled_sleeves = 0  //0 = unrolled, 1 = rolled, -1 = cannot be toggled

/obj/item/clothing/under/security/officer
	name = "large security uniform"
	desc = "An aftermarket modification of a regular desert jumpsuit, favored by unathi mercenaries. This one provides a bit more physical protection as if unathi ever needed that. It's too big to fit anyone, but unathi."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/onmob_under.dmi'
	)
	species_restricted  = list(SPECIES_UNATHI)
	icon_state = "unsecuniform"
	item_state = "unsecuniform"
	worn_state = "unsecuniform"
	rolled_sleeves = 0  //0 = unrolled, 1 = rolled, -1 = cannot be toggled

// Avalon

/obj/item/clothing/under/avalon
	name = "antiquated skirt"
	desc = "Some really old fashioned skirt. Presumably a piece of Avalonian craftsmanship."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "antiquated_skirt"
	item_state = "antiquated_skirt"

/obj/item/clothing/under/avalon/noble
	name = "artsy suit"
	desc = "A piece of exceptional work, for Avalonian artisan. Nobles from up there tend to be fond of wearing this."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "noble"
	item_state = "noble"

// Expencive

/* SIERRA TODO: Переспрайтить и сделать отдельный розовый жакет + шлем Для костюма Джекета то же самое
/obj/item/clothing/under/biker
	name = "biker"
	desc = "For when you craving for some dead meat."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "biker"
	item_state = "biker"

/obj/item/clothing/under/jacket
	name = "old style jacket"
	desc = "You know it damn well here."
	desc = "For when you craving for some dead meat."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "jacket"
	item_state = "jacket"

*/

// Cuttop

/obj/item/clothing/under/cuttop
	name = "grey cuttop"
	desc = "Loose fitting grey shirt with a broad neckline, accompained with some skinny jeans. Obviously worn by women."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "cuttop"
	item_state = "cuttop"
	worn_state = "cuttop"

/obj/item/clothing/under/cuttop/red
	name = "red cuttop"
	desc = "Loose fitting red shirt with a broad neckline, accompained with some skinny jeans. Obviously worn by women."
	icon_state = "cuttop_red"
	item_state = "cuttop_red"
	worn_state = "cuttop_red"

// Checkered

/obj/item/clothing/under/checkered
	name = "pinstripe"
	desc = "You ain't one to be afraid of 18 karat of bad luck."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "pinstripe"
	item_state = "pinstripe"

/obj/item/clothing/under/checkered/red
	name = "red checkered shirt"
	desc = "Incredibly comfy and warm flannel shirt in red checkered pattern."
	icon_state = "stripped_shirt"
	item_state = "stripped_shirt"
	worn_state = "stripped_shirt"

// Gotsis?

/obj/item/clothing/under/dress/gotsis_red
	name = "red gotsis dress"
	desc = "Welcome to cabaret, lolly jolly~~"
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "gotsis_dress_1"
	item_state = "gotsis_dress_1"
	worn_state = "gotsis_dress_1"
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/unathi/onmob_under_unathi.dmi'
	)

/obj/item/clothing/under/dress/gotsis_orange
	name = "orange gotsis dress"
	desc = "Welcome to cabaret, lolly jolly~~"
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "gotsis_dress_2"
	item_state = "gotsis_dress_2"
	worn_state = "gotsis_dress_2"
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/unathi/onmob_under_unathi.dmi'
	)

// Spotrs

/obj/item/clothing/under/sport
	name = "faln trousers"
	desc = "These athletic pants are truly a masterpiece as they perfectly fit for any type of figure."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "papaleroy_faln_trousers"
	item_state = "papaleroy_faln_trousers"

/obj/item/clothing/under/sport/olympic
	name = "olympic clothes"
	desc = "A set of tracksuit and trackpants in gaudy coloration. Incredibly comfy for wearing and exercising, but this contrast of colors make your eyes melt."
	icon_state = "olympic"
	item_state = "olympic"

// Formal

/obj/item/clothing/under/formal
	name = "white black"
	desc = "White top, dark bottom. Too default."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "white_black"
	item_state = "white_black"

/obj/item/clothing/under/formal/vest
	name = "formal vest"
	desc = "A standard set with a beige necktie."
	icon_state = "formalvest"
	item_state = "formalvest"

/obj/item/clothing/under/formal/classic_suit
	name = "classic suit"
	desc = "Classic suit for really special occasions. It demands for regard, so treat it accordingly."
	icon_state = "classic_suit"
	item_state = "classic_suit"

/obj/item/clothing/under/formal/chain_with_shirt
	name = "black and white with style"
	desc = "Some weird combination of starched shirt and studded jeans with a chain hanging off the belt."
	icon_state = "chain_with_shirt"
	item_state = "chain_with_shirt"
	worn_state = "chain_with_shirt"

/obj/item/clothing/under/formal/aristo
	name = "aristo uniform"
	desc = "Delicately sewn, this suit is magnificently fine and very expensive. Not for just any bourgeois."
	icon_state = "papaleroy_aristo_suit"
	item_state = "papaleroy_aristo_suit"

/obj/item/clothing/under/formal/callum
	name = "callum vest"
	desc = "A quite sleek vest."
	icon_state = "callum"
	item_state = "callum"

/obj/item/clothing/under/formal/hm_suit
	name = "charcoal vest"
	desc = "A woven charcoal suit and an azure necktie."
	icon_state = "hm_suit"
	item_state = "hm_suit"

/obj/item/clothing/under/formal/red_n_black
	name = "red 'n black suit"
	desc = "A set of black slacks and red shirt."
	icon_state = "detective"
	item_state = "detective"
	worn_state = "detective"

/obj/item/clothing/under/formal/rubywhite
	name = "rubywhite uniform"
	desc = "Scarlet shirt accompained with white slacks held with suspenders."
	icon_state = "papaleroy_rubywhite"
	item_state = "papaleroy_rubywhite"
	worn_state = "papaleroy_rubywhite"
	gender_icons = 1

// Informal

/obj/item/clothing/under/informal
	name = "harper uniform"
	desc = "A maggy tank top and denim cargo pants with some knee protection sewn onto them. Seems like a perfect outfit for some garage dweller."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "harper_uniform"
	item_state = "harper_uniform"

/obj/item/clothing/under/informal/vice
	name = "vice uniform"
	desc = "Casual set of black suit and red t-shirt."
	icon_state = "vice2"
	item_state = "vice2"

/obj/item/clothing/under/informal/lify
	name = "lify"
	desc = "Here's some childish style, I dunno. Like who the hell would wear tank top with buttons?."
	icon_state = "lify"
	item_state = "lify"

/obj/item/clothing/under/informal/denimvest
	name = "denim vest"
	desc = "Slightly bleached out denim vest with rebellic emblems drawn on its back."
	icon_state = "denimvest"
	item_state = "denimvest"

/obj/item/clothing/under/informal/cuban_suit
	name = "rhumba outfit"
	desc = "A satin shirt and high-waisted pants, worn by dancers in the Rhumba style. It smells oddly like... sulfur?"
	icon_state = "cuban_suit"
	item_state = "cuban_suit"

// Mafia

/obj/item/clothing/under/mafia
	name = "mafia outfit"
	desc = "The business of the mafia is business."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "mafia_suit"
	item_state = "mafia_suit"

/obj/item/clothing/under/mafia/vest
	name = "mafia vest"
	desc = "Extreme problems often require extreme solutions."
	icon_state = "mafia_vest"
	item_state = "mafia_vest"

/obj/item/clothing/under/mafia/white
	name = "white mafia outfit"
	desc = "The best defense against the treacherous is treachery."
	icon_state = "mafia_white"
	item_state = "mafia_white"

// Cursed

/obj/item/clothing/under/maid
	name = "maid dress"
	desc = "Cliche product of Japan."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "meido"
	item_state = "meido"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

// Service uniforms

/obj/item/clothing/under/service
	name = "dark service uniform"
	desc = "A set of service clothes in military style. Largely available in many of surplus stores."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "blackservice"
	item_state = "blackservice"

/obj/item/clothing/under/service/brown
	name = "brown service uniform"
	desc = "A set of service clothes in military style. Largely available in many of surplus stores."
	icon_state = "blackserviceof"
	item_state = "blackserviceof"

/obj/item/clothing/under/service/white
	name = "white service uniform"
	desc = "A set of service clothes in military style. This one is purposed for special occasions."
	icon_state = "whiteservice"
	item_state = "whiteservice"

/obj/item/clothing/under/service/female
	name = "white female service uniform"
	desc = "A set of service clothes in military style. This one is purposed for special occasions."
	icon_state = "whiteservicefem"
	item_state = "whiteservicefem"

/obj/item/clothing/under/service/milsim
	name = "milsim uniform"
	desc = "Set of milsim navy fatigues which is very common in many of surplus stores."
	icon_state = "papaleroy_milsim"
	item_state = "papaleroy_milsim"

// Victorian Dresses. We're still a research vessel...

/obj/item/clothing/under/dress/victorian
	name = "black victorian dress"
	desc = "A victorian style dress, fancy!"
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "victorian_dress"
	item_state = "victorian_dress"
	worn_state = "victorian_dress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/unathi/onmob_under_unathi.dmi'
	)

/obj/item/clothing/under/dress/victorian/red
	name = "red victorian dress"
	desc = "A victorian style dress, fancy!"
	icon_state = "victorian_reddress"
	item_state = "victorian_reddress"
	worn_state = "victorian_reddress"

// Victorian Suits. Vampire fangs not included

/obj/item/clothing/under/formal/victorian
	name = "victorian suit"
	desc = "A victorian style suit, fancy!"
	icon_state = "victorian_black"
	item_state = "victorian_black"

/obj/item/clothing/under/formal/victorian/black_red
	name = "red and black victorian suit"
	icon_state = "victorian_redblack"
	item_state = "victorian_redblack"

/obj/item/clothing/under/formal/victorian/red
	name = "red victorian suit"
	icon_state = "victorian_redvest"
	item_state = "victorian_redvest"

/obj/item/clothing/under/formal/victorian/twilight
	name = "dark victorian suit"
	icon_state = "victorian_twilight"
	item_state = "victorian_twilight"

/obj/item/clothing/under/rank/adjutant
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/unathi/onmob_under_unathi.dmi'
	)
