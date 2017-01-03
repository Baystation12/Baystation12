/datum/gear/head
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing/head/bandana

/datum/gear/head/bandana/New()
	..()
	var/bandanas = list()
	bandanas["green bandana"] = /obj/item/clothing/head/greenbandana
	bandanas["orange bandana"] = /obj/item/clothing/head/orangebandana
	bandanas["pirate bandana"] = /obj/item/clothing/head/bandana
	gear_tweaks += new/datum/gear_tweak/path(bandanas)

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
	display_name = "beret, engineering"
	path = /obj/item/clothing/head/beret/engineering
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician")

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/beret/sec
	display_name = "beret, red (security)"
	path = /obj/item/clothing/head/beret/sec
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/head/cap
	display_name = "cap selection"
	path = /obj/item/clothing/head/soft

/datum/gear/head/cap/New()
	..()
	var/caps = list()
	caps["black cap"] = /obj/item/clothing/head/soft/black
	caps["blue cap"] = /obj/item/clothing/head/soft/blue
	caps["flat cap"] = /obj/item/clothing/head/flatcap
	caps["green cap"] = /obj/item/clothing/head/soft/green
	caps["grey cap"] = /obj/item/clothing/head/soft/grey
	caps["mailman cap"] = /obj/item/clothing/head/mailman
	caps["orange cap"] = /obj/item/clothing/head/soft/orange
	caps["purple cap"] = /obj/item/clothing/head/soft/purple
	caps["rainbow cap"] = /obj/item/clothing/head/soft/rainbow
	caps["red cap"] = /obj/item/clothing/head/soft/red
	caps["white cap"] = /obj/item/clothing/head/soft/mime
	caps["yellow cap"] = /obj/item/clothing/head/soft/yellow
	gear_tweaks += new/datum/gear_tweak/path(caps)

/datum/gear/head/seccap
	display_name = "cap, security"
	path = /obj/item/clothing/head/soft/sec
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/head/seccap/corp
	display_name = "cap, corporate security"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/head/hairflower
	display_name = "hair flower pin"
	path = /obj/item/clothing/head/hairflower

/datum/gear/head/hairflower/New()
	..()
	var/pins = list()
	pins["blue pin"] = /obj/item/clothing/head/hairflower/blue
	pins["pink pin"] = /obj/item/clothing/head/hairflower/pink
	pins["red pin"] = /obj/item/clothing/head/hairflower
	pins["yellow pin"] = /obj/item/clothing/head/hairflower/yellow
	gear_tweaks += new/datum/gear_tweak/path(pins)

/datum/gear/head/bow
	display_name = "hair bow"
	path = /obj/item/clothing/head/hairflower/bow
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/hardhat
	display_name = "hardhat selection"
	path = /obj/item/clothing/head/hardhat
	cost = 2

/datum/gear/head/hardhat/New()
	..()
	var/hardhats = list()
	hardhats["blue hardhat"] = /obj/item/clothing/head/hardhat/dblue
	hardhats["orange hardhat"] = /obj/item/clothing/head/hardhat/orange
	hardhats["red hardhat"] = /obj/item/clothing/head/hardhat/red
	hardhats["yellow hardhat"] = /obj/item/clothing/head/hardhat
	gear_tweaks += new/datum/gear_tweak/path(hardhats)

/datum/gear/head/hat
	display_name = "hat selection"
	path = /obj/item/clothing/head/hasturhood

/datum/gear/head/hat/New()
	..()
	var/hats = list()
	hats["boatsman hat"] = /obj/item/clothing/head/boaterhat
	hats["bowler hat"] = /obj/item/clothing/head/bowler
	hats["cowboy hat"] = /obj/item/clothing/head/cowboy_hat
	hats["fedora"] = /obj/item/clothing/head/fedora //m'lady
	hats["feather thrilby"] = /obj/item/clothing/head/feathertrilby
	hats["fez"] = /obj/item/clothing/head/fez
	hats["top hat"] = /obj/item/clothing/head/that
	hats["ushanka"] = /obj/item/clothing/head/ushanka
	gear_tweaks += new/datum/gear_tweak/path(hats)

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
	gear_tweaks += new/datum/gear_tweak/path(assoc_by_proc(welding_masks, /proc/get_initial_name))
