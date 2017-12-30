/datum/gear/head
	path = /obj/item/clothing/head
	slot = slot_head
	sort_category = "Hats and Headwear"
	category = /datum/gear/head

/datum/gear/head/beret
	allowed_roles = NON_MILITARY_ROLES
	display_name = "beret, colour select"
	path = /obj/item/clothing/head/beret/plaincolor
	flags = GEAR_HAS_COLOR_SELECTION
	description = "A simple, solid color beret. This one has no emblems or insignia on it."

/datum/gear/head/solberet
	display_name = "SolGov beret selection"
	description = "A beret denoting service in an organization within SolGov."
	path = /obj/item/clothing/head/beret/solgov
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/solberet/New()
	..()
	var/berets = list()
	berets["peacekeeper beret"] = /obj/item/clothing/head/beret/solgov
	berets["home guard beret"] = /obj/item/clothing/head/beret/solgov/homeguard
	berets["gateway administration beret"] = /obj/item/clothing/head/beret/solgov/gateway
	berets["customs and trade beret"] = /obj/item/clothing/head/beret/solgov/customs
	berets["government research beret"] = /obj/item/clothing/head/beret/solgov/research
	berets["health service beret"] = /obj/item/clothing/head/beret/solgov/health
	berets["diplomatic security beret"] = /obj/item/clothing/head/beret/solgov/diplomatic
	berets["border security beret"] = /obj/item/clothing/head/beret/solgov/borderguard
	gear_tweaks += new/datum/gear_tweak/path(berets)

/datum/gear/head/whitentberet
	display_name = "beret, NanoTrasen security"
	path = /obj/item/clothing/head/beret/guard
	allowed_roles = list(/datum/job/guard)

/datum/gear/head/veteranhat
	display_name = "veteran hat"
	path = /obj/item/clothing/head/soft/solgov/veteranhat
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing/head
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/bandana/New()
	..()
	var/bandanas = list()
	bandanas["green bandana"] = /obj/item/clothing/head/greenbandana
	bandanas["orange bandana"] = /obj/item/clothing/head/orangebandana
	bandanas["pirate bandana"] = /obj/item/clothing/head/bandana
	gear_tweaks += new/datum/gear_tweak/path(bandanas)

/datum/gear/head/bow
	display_name = "hair bow, colour select"
	path = /obj/item/clothing/head/hairflower/bow
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/cap
	display_name = "cap selection"
	path = /obj/item/clothing/head
	allowed_roles = NON_MILITARY_ROLES

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
	caps["major bill's shipping cap"] = /obj/item/clothing/head/soft/mbill
	gear_tweaks += new/datum/gear_tweak/path(caps)

/datum/gear/head/hairflower
	display_name = "hair flower pin"
	path = /obj/item/clothing/head/hairflower
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/hardhat
	display_name = "hardhat selection"
	path = /obj/item/clothing/head/hardhat
	cost = 2
	allowed_roles = TECHNICAL_ROLES

/datum/gear/head/hardhat/New()
	..()
	var/hardhats = list()
	hardhats["blue hardhat"] = /obj/item/clothing/head/hardhat/dblue
	hardhats["orange hardhat"] = /obj/item/clothing/head/hardhat/orange
	hardhats["red hardhat"] = /obj/item/clothing/head/hardhat/red
	hardhats["yellow hardhat"] = /obj/item/clothing/head/hardhat
	gear_tweaks += new/datum/gear_tweak/path(hardhats)

/datum/gear/head/formalhat
	display_name = "formal hat selection"
	path = /obj/item/clothing/head
	allowed_roles = FORMAL_ROLES

/datum/gear/head/formalhat/New()
	..()
	var/formalhats = list()
	formalhats["boatsman hat"] = /obj/item/clothing/head/boaterhat
	formalhats["bowler hat"] = /obj/item/clothing/head/bowler
	formalhats["fedora"] = /obj/item/clothing/head/fedora //m'lady
	formalhats["feather trilby"] = /obj/item/clothing/head/feathertrilby
	formalhats["fez"] = /obj/item/clothing/head/fez
	formalhats["top hat"] = /obj/item/clothing/head/that
	formalhats["fedora, brown"] = /obj/item/clothing/head/det
	formalhats["fedora, grey"] = /obj/item/clothing/head/det/grey
	gear_tweaks += new/datum/gear_tweak/path(formalhats)

/datum/gear/head/informalhat
	display_name = "informal hat selection"
	path = /obj/item/clothing/head
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/head/informalhat/New()
	..()
	var/informalhats = list()
	informalhats["cowboy hat"] = /obj/item/clothing/head/cowboy_hat
	informalhats["ushanka"] = /obj/item/clothing/head/ushanka
	informalhats["TCC ushanka"] = /obj/item/clothing/head/ushanka/tcc
	gear_tweaks += new/datum/gear_tweak/path(informalhats)

/datum/gear/head/hairflower/New()
	..()
	var/pins = list()
	pins["blue pin"] = /obj/item/clothing/head/hairflower/blue
	pins["pink pin"] = /obj/item/clothing/head/hairflower/pink
	pins["red pin"] = /obj/item/clothing/head/hairflower
	pins["yellow pin"] = /obj/item/clothing/head/hairflower/yellow
	gear_tweaks += new/datum/gear_tweak/path(pins)

/datum/gear/head/hijab
	display_name = "hijab, colour select"
	path = /obj/item/clothing/head/hijab
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/kippa
	display_name = "kippa, colour select"
	path = /obj/item/clothing/head/kippa
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/turban
	display_name = "turban, colour select"
	path = /obj/item/clothing/head/turban
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/taqiyah
	display_name = "taqiyah, colour select"
	path = /obj/item/clothing/head/taqiyah
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/welding
	display_name = "welding mask selection"
	path = /obj/item/clothing/head/welding
	allowed_roles = TECHNICAL_ROLES

/datum/gear/head/solhat
	display_name = "sol central government hat"
	path = /obj/item/clothing/head/soft/solgov
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/fleethat
	display_name = "fleet cap"
	path = /obj/item/clothing/head/soft/solgov/fleet
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/fleetfur
	display_name = "fleet fur hat"
	path = /obj/item/clothing/head/ushanka/solgov/fleet
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/fleetberet
	display_name = "fleet beret selection"
	path = /obj/item/clothing/head/beret/solgov
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/fleetberet/New()
	..()
	var/fleetberets = list()
	fleetberets["fleet beret"] = /obj/item/clothing/head/beret/solgov/fleet
	fleetberets["fleet security beret"] = /obj/item/clothing/head/beret/solgov/fleet/security
	fleetberets["fleet medical beret"] = /obj/item/clothing/head/beret/solgov/fleet/medical
	fleetberets["fleet engineering beret"] = /obj/item/clothing/head/beret/solgov/fleet/engineering
	fleetberets["fleet supply beret"] = /obj/item/clothing/head/beret/solgov/fleet/supply
	fleetberets["fleet service beret"] = /obj/item/clothing/head/beret/solgov/fleet/service
	fleetberets["fleet exploration beret"] = /obj/item/clothing/head/beret/solgov/fleet/exploration
	fleetberets["fleet officer's beret"] = /obj/item/clothing/head/beret/solgov/fleet/command
	gear_tweaks  += new/datum/gear_tweak/path(fleetberets)

/datum/gear/head/marinehat
	display_name = "marine cap"
	path = /obj/item/clothing/head/solgov/utility/marine
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/marinefur
	display_name = "marine fur hat"
	path = /obj/item/clothing/head/ushanka/solgov/marine
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/marinegreenfur
	display_name = "green marine fur hat"
	path = /obj/item/clothing/head/ushanka/solgov/marine/green
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/echat
	display_name = "EC cap"
	path = /obj/item/clothing/head/soft/solgov/expedition
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/ecberet
	display_name = "EC beret selection"
	path = /obj/item/clothing/head/beret/solgov
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/ecberet/New()
	..()
	var/ecberets = list()
	ecberets["expeditionary beret"] = /obj/item/clothing/head/beret/solgov/expedition
	ecberets["expeditionary security beret"] = /obj/item/clothing/head/beret/solgov/expedition/security
	ecberets["expeditionary medical beret"] = /obj/item/clothing/head/beret/solgov/expedition/medical
	ecberets["expeditionary engineering beret"] = /obj/item/clothing/head/beret/solgov/expedition/engineering
	ecberets["expeditionary supply beret"] = /obj/item/clothing/head/beret/solgov/expedition/supply
	ecberets["expeditionary service beret"] = /obj/item/clothing/head/beret/solgov/expedition/service
	ecberets["expeditionary exploration beret"] = /obj/item/clothing/head/beret/solgov/expedition/exploration
	ecberets["expeditionary officer's beret"] = /obj/item/clothing/head/beret/solgov/expedition/command
	gear_tweaks += new/datum/gear_tweak/path(ecberets)

/datum/gear/head/ecfur
	display_name = "EC fur hat"
	path = /obj/item/clothing/head/ushanka/solgov
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/surgical
	display_name = "standard surgical caps"
	path = /obj/item/clothing/head/surgery
	allowed_roles = STERILE_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/head/surgical/custom
	display_name = "surgical cap, colour select"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/veteranhat
	display_name = "veteran hat"
	path = /obj/item/clothing/head/soft/solgov/veteranhat
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/welding/New()
	..()
	var/welding_masks = list()
	welding_masks += /obj/item/clothing/head/welding/demon
	welding_masks += /obj/item/clothing/head/welding/engie
	welding_masks += /obj/item/clothing/head/welding/fancy
	welding_masks += /obj/item/clothing/head/welding/knight
	welding_masks += /obj/item/clothing/head/welding/carp
	gear_tweaks += new/datum/gear_tweak/path(assoc_by_proc(welding_masks, /proc/get_initial_name))
