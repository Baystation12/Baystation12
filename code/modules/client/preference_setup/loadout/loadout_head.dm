/datum/gear/head
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/bandana_red
	display_name = "bandana, pirate-red"
	path = /obj/item/clothing/head/bandana

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
	caps["Expeditionary Corps cap"] = /obj/item/clothing/head/soft/sol/expedition
	caps["fleet cap"] = /obj/item/clothing/head/soft/sol/fleet

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
	pins["violet pin"] = /obj/item/clothing/head/hairflower/violet
	gear_tweaks += new/datum/gear_tweak/path(pins)

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


// EROS BEGIN

/datum/gear/head/cap/black
	display_name = "cap,black"
	path = /obj/item/clothing/head/soft/black

/datum/gear/head/hairribbon
	display_name = "white hair ribbon"
	path = /obj/item/clothing/head/hairribbon

/datum/gear/head/hairribbonred
	display_name = "red hair ribbon"
	path = /obj/item/clothing/head/hairribbon/red

/datum/gear/head/headbow
	display_name = "bow"
	path = /obj/item/clothing/head/hairribbon/color
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/froghat
	display_name = "froggie hat"
	path = /obj/item/clothing/head/froghat

/datum/gear/head/maidhat
	display_name = "maid headband"
	path = /obj/item/clothing/head/maidhat

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

/datum/gear/head/beret/csec
	display_name = "beret, corporate (officer)"
	path = /obj/item/clothing/head/beret/sec/corporate/officer
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/head/beret/csec_warden
	display_name = "beret, corporate (warden)"
	path = /obj/item/clothing/head/beret/sec/corporate/warden
	allowed_roles = list("Head of Security","Warden")

/datum/gear/head/beret/csec_hos
	display_name = "beret, corporate (hos)"
	path = /obj/item/clothing/head/beret/sec/corporate/hos
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

/datum/gear/head/santa
	display_name = "santa hat, red"
	path = /obj/item/clothing/head/santa

/datum/gear/head/santa/green
	display_name = "santa hat, green"
	path = /obj/item/clothing/head/santa/green

/datum/gear/head/beanie
	display_name = "beanie"
	path = /obj/item/clothing/head/beanie
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/beanie_loose
	display_name = "beanie, loose"
	path = /obj/item/clothing/head/beanie_loose
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/sombrero
	display_name = "sombrero"
	path = /obj/item/clothing/head/sombrero

/datum/gear/head/cowboy_hat/cowboy/wide
	display_name = "cowboy hat, wide-brimmed"
	path = /obj/item/clothing/head/cowboy_hat/cowboywide

/datum/gear/head/cowboy_hat/cowboy/black
	display_name = "cowboy hat, black"
	path = /obj/item/clothing/head/cowboy_hat/black

/datum/gear/head/cowboy_hat/cowboy/alt
	display_name = "cowboy hat, alt"
	path = /obj/item/clothing/head/cowboy_hat/cowboy2
//EROS END
