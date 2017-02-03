/datum/gear/head
	display_name = "bandana, pirate-red"
	path = /obj/item/clothing/head/bandana
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/bandana_green
	display_name = "bandana, green"
	path = /obj/item/clothing/head/greenbandana

/datum/gear/head/bandana_orange
	display_name = "bandana, orange"
	path = /obj/item/clothing/head/orangebandana

/datum/gear/head/beret
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret

/datum/gear/head/beret/bsec
	display_name = "beret, navy (officer)"
	path = /obj/item/clothing/head/beret/sec/navy/officer
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/head/beret/bsec_warden
	display_name = "beret, navy (warden)"
	path = /obj/item/clothing/head/beret/sec/navy/warden
	allowed_roles = list("Head of Security","Warden")

/datum/gear/head/beret/bsec_hos
	display_name = "beret, navy (hos)"
	path = /obj/item/clothing/head/beret/sec/navy/hos
	allowed_roles = list("Head of Security")

/datum/gear/head/beret/eng
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/engineering

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/beret/sec
	display_name = "beret, red (security)"
	path = /obj/item/clothing/head/beret/sec
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/head/cap/black
	display_name = "cap, black"
	path = /obj/item/clothing/head/soft/black

/datum/gear/head/cap/blue
	display_name = "cap, blue"
	path = /obj/item/clothing/head/soft/blue

/datum/gear/head/cap/mailman
	display_name = "cap, blue station"
	path = /obj/item/clothing/head/mailman

/datum/gear/head/cap/flat
	display_name = "cap, brown-flat"
	path = /obj/item/clothing/head/flatcap

/datum/gear/head/cap/corp
	display_name = "cap, corporate (Security)"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/head/cap/green
	display_name = "cap, green"
	path = /obj/item/clothing/head/soft/green

/datum/gear/head/cap/grey
	display_name = "cap, grey"
	path = /obj/item/clothing/head/soft/grey

/datum/gear/head/cap/orange
	display_name = "cap, orange"
	path = /obj/item/clothing/head/soft/orange

/datum/gear/head/cap/purple
	display_name = "cap, purple"
	path = /obj/item/clothing/head/soft/purple

/datum/gear/head/cap/rainbow
	display_name = "cap, rainbow"
	path = /obj/item/clothing/head/soft/rainbow

/datum/gear/head/cap/red
	display_name = "cap, red"
	path = /obj/item/clothing/head/soft/red

/datum/gear/head/cap/sec
	display_name = "cap, security (Security)"
	path = /obj/item/clothing/head/soft/sec
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/head/cap/yellow
	display_name = "cap, yellow"
	path = /obj/item/clothing/head/soft/yellow

/datum/gear/head/cap/white
	display_name = "cap, white"
	path = /obj/item/clothing/head/soft/mime

/datum/gear/head/hairflower
	display_name = "hair flower pin, red"
	path = /obj/item/clothing/head/hairflower

/datum/gear/head/hairflower/yellow
	display_name = "hair flower pin, yellow"
	path = /obj/item/clothing/head/hairflower/yellow

/datum/gear/head/hairflower/pink
	display_name = "hair flower pin, pink"
	path = /obj/item/clothing/head/hairflower/pink

/datum/gear/head/hairflower/blue
	display_name = "hair flower pin, blue"
	path = /obj/item/clothing/head/hairflower/blue

/datum/gear/head/hardhat
	display_name = "hardhat, yellow"
	path = /obj/item/clothing/head/hardhat
	cost = 2

/datum/gear/head/hardhat/blue
	display_name = "hardhat, blue"
	path = /obj/item/clothing/head/hardhat/dblue

/datum/gear/head/hardhat/orange
	display_name = "hardhat, orange"
	path = /obj/item/clothing/head/hardhat/orange

/datum/gear/head/hardhat/red
	display_name = "hardhat, red"
	path = /obj/item/clothing/head/hardhat/red

/datum/gear/head/boater
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat

/datum/gear/head/bowler
	display_name = "hat, bowler"
	path = /obj/item/clothing/head/bowler

/datum/gear/head/cowboy_hat
	display_name = "hat, cowboy"
	path = /obj/item/clothing/head/cowboy_hat

/datum/gear/head/fez
	display_name = "hat, fez"
	path = /obj/item/clothing/head/fez

/datum/gear/head/tophat
	display_name = "hat, tophat"
	path = /obj/item/clothing/head/that

/datum/gear/head/philosopher_wig
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig

/datum/gear/head/ushanka
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka

/datum/gear/head/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = "Tajara"

/datum/gear/head/hijab
	display_name = "hijab"
	path = /obj/item/clothing/head/hijab
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/kippa
	display_name = "kippa"
	path = /obj/item/clothing/head/kippa
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/turban
	display_name = "turban"
	path = /obj/item/clothing/head/turban
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/welding
	display_name = "welding mask selection"
	path = /obj/item/clothing/head/welding
	allowed_roles = list("Roboticist","Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/head/welding/New()
	..()
	var/welding_masks = list()
	welding_masks += /obj/item/clothing/head/welding/demon
	welding_masks += /obj/item/clothing/head/welding/engie
	welding_masks += /obj/item/clothing/head/welding/fancy
	welding_masks += /obj/item/clothing/head/welding/knight
	welding_masks += /obj/item/clothing/head/welding/carp
	gear_tweaks += new/datum/gear_tweak/path(assoc_by_proc(welding_masks, /proc/get_initial_name))
