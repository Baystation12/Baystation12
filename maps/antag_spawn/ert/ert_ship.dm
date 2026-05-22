/datum/map_template/ruin/antag_spawn/ert
	name = "SFV Trident"
	suffixes = list("ert/ert_ship.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/antag/ert)
	apc_test_exempt_areas = list(
		/area/map_template/ert/ship = NO_APC
	)

/datum/map_template/ruin/antag_spawn/ert/after_load(zlevel)
	..(zlevel)
	if(zlevel)
		GLOB.using_map.admin_levels |= GetConnectedZlevels(zlevel)
		GLOB.using_map.escape_levels |= GetConnectedZlevels(zlevel)

	var/obj/machinery/computer/shuttle_control/multi/ert/console = locate() in MACHINES_OF(/obj/machinery/computer/shuttle_control/multi/ert)
	if(console)
		GLOB.ert_announcer.forceMove(get_turf(console))
		GLOB.ert_announcer.simulated = TRUE
	else
		crash_with("[GLOB.ert_announcer.type] was unable to be relocated to the ERT shuttle.")

/obj/overmap/visitable/sector/ert_ship
	name = "SFV Trident"
	desc = "An Orca-Class Escort Carrier, broadcasting SCGF codes.\n<span class='bad'>Its weapons systems appears to be active.</span>"
	color = COLOR_SKY_BLUE
	icon_state = "ship"
	place_near_main = list(1,2)
	sector_flags = OVERMAP_SECTOR_UNTARGETABLE
	hide_from_reports = TRUE
	requires_contact = FALSE
	scannable = FALSE
	sensor_visibility = 22
	invisibility = INVISIBILITY_ABSTRACT

	initial_restricted_waypoints = list(
		"nav_ert_start"
	)

/obj/overmap/visitable/sector/ert_ship/Initialize()
	. = ..()
	if(!unknown_id)
		unknown_id = "[pick(GLOB.phonetic_alphabet)]-[random_id(/obj/overmap, 100, 999)]"

/**
* Hides or shows the ERT ship overmap obj
*
* @param mode utilizes `TRUE` to enable cloak and `FALSE` to disable cloaking
*/
/obj/overmap/visitable/sector/ert_ship/proc/set_cloak(mode = TRUE)
	if(mode)
		scannable = FALSE
		requires_contact = FALSE
		invisibility = INVISIBILITY_ABSTRACT
	else
		scannable = TRUE
		requires_contact = TRUE
		invisibility = INVISIBILITY_OVERMAP

/obj/overmap/aldensaraspova_jump
	name = "\improper Alden-Saraspova Instability"
	desc = "An excessive ammount of unnaturally unstable exotic particles is present in this sector."
	icon_state = "event"
	scannable = TRUE

// Areas

/area/map_template/ert
	name = "ERT"
	icon_state = "yellow"
	lighting_tone = AREA_LIGHTING_COOL

	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_NO_MODIFY | AREA_FLAG_IS_NOT_PERSISTENT

/area/map_template/ert/ship
	name = "SFV Trident"
	requires_power = FALSE
	req_access = list(access_cent_specops)

/area/map_template/ert/ship/prepwing
	name = "SFV Trident - ERT Preparation Wing"
	icon_state = "purple"

/area/map_template/ert/ship/briefing
	name = "SFV Trident - Briefing Room"
	icon_state = "conference"

/area/map_template/ert/ship/armory
	name = "SFV Trident - Armory"
	icon_state = "armory"

/area/map_template/ert/ship/hangar
	name = "SFV Trident - Hangar 5"
	icon_state = "hangar"

/area/map_template/ert/ship/officer
	name = "SFV Trident - Commanding Officer"
	icon_state = "purple"
	req_access = list(access_cent_captain)

// Machinery

/obj/machinery/power/apc/hyper/ert
	req_access = list(access_cent_specops)

/obj/machinery/alarm/ert
	req_access = list(access_cent_specops)

/obj/machinery/door/firedoor/ert
	req_access = list(access_cent_medical)

/obj/item/stock_parts/circuitboard/telecomms/allinone/ert
	build_path = /obj/machinery/telecomms/allinone/ert

/obj/machinery/telecomms/allinone/ert
	listening_freqs = list(ERT_FREQ)
	freq_listening = list(ERT_FREQ)
	channel_color = COMMS_COLOR_CENTCOMM
	channel_name = "ERT"
	circuitboard = /obj/item/stock_parts/circuitboard/telecomms/allinone/ert

/obj/machinery/rotating_alarm/start_on/ert
	name = "alarm"
	desc = "A rotating alarm light."
	icon_state = "code red"
	alarm_light_color = COLOR_RED

// Turfs & Paints

/obj/paint/fleet/sfv_rook
	color = COLOR_GRAY40

// Airlocks
/obj/machinery/door/airlock/external/fleet
	secured_wires = TRUE
	door_color = COLOR_DARK_BLUE_GRAY

/obj/machinery/door/airlock/external/fleet/gunmetal
	door_color = COLOR_GUNMETAL

/obj/machinery/door/airlock/external/fleet/dark_gunmetal
	door_color = COLOR_DARK_GUNMETAL

/obj/machinery/door/airlock/fleet
	secured_wires = TRUE
	door_color = COLOR_DARK_BLUE_GRAY

/obj/machinery/door/airlock/fleet/stripe
	stripe_color = COLOR_SOL

/obj/machinery/door/airlock/fleet/gunmetal
	door_color = COLOR_GUNMETAL

/obj/machinery/door/airlock/fleet/gunmetal/stripe
	stripe_color = COLOR_SOL

/obj/machinery/door/airlock/glass/fleet
	secured_wires = TRUE
	door_color = COLOR_DARK_BLUE_GRAY

/obj/machinery/door/airlock/glass/fleet/stripe
	stripe_color = COLOR_SOL

/obj/machinery/door/airlock/glass/fleet/gunmetal
	door_color = COLOR_GUNMETAL

/obj/machinery/door/airlock/glass/fleet/gunmetal/stripe
	stripe_color = COLOR_SOL

/obj/machinery/door/airlock/multi_tile/glass/fleet
	secured_wires = TRUE
	door_color = COLOR_DARK_BLUE_GRAY

/obj/machinery/door/airlock/multi_tile/glass/fleet/stripe
	stripe_color = COLOR_SOL

/obj/machinery/door/airlock/multi_tile/glass/fleet/gunmetal
	door_color = COLOR_GUNMETAL

/obj/machinery/door/airlock/multi_tile/glass/fleet/gunmetal/stripe
	stripe_color = COLOR_SOL

// Vendors

/obj/machinery/vending/ert
	name = "\improper Blast Zone"
	desc = "The electronic quartermaster for all your field necessities!"
	icon_state = "sec"
	icon_deny = "sec-deny"
	icon_vend = "sec-vend"
	req_access = list(access_ert_responder)
	base_type = /obj/machinery/vending/ert
	products = list(
		/obj/item/handcuffs = 15,
		/obj/item/grenade/flashbang = 8,
		/obj/item/grenade/chem_grenade/teargas = 8,
		/obj/item/melee/baton/loaded = 5,
		/obj/item/melee/telebaton = 5,
		/obj/item/device/flash = 5,
		/obj/item/shield/riot/metal = 5,
		/obj/item/shield/riot = 5,
		/obj/item/material/knife/folding/swiss/tactical = 5,
		/obj/item/reagent_containers/hypospray/autoinjector/combatpain = 8,
		/obj/item/clothing/mask/gas = 5,
		/obj/item/clothing/mask/gas/half = 5,
		/obj/item/clothing/mask/balaclava = 5,
		/obj/item/clothing/glasses/tacgoggles = 5,
		/obj/item/clothing/glasses/eyepatch = 2
	)

/obj/machinery/vending/ert/medical
	name = "\improper Zeng-Hu Lifeline"
	desc = "A fleet's corpsman best and perhaps only friend!"
	icon_state = "med"
	icon_deny = "med-deny"
	icon_vend = "med-vend"
	base_type = /obj/machinery/vending/ert/medical
	products = list(
		/obj/item/reagent_containers/hypospray/vial,
		/obj/item/reagent_containers/syringe = 12,
		/obj/item/device/scanner/health = 5,
		/obj/item/reagent_containers/hypospray/autoinjector = 12,
		/obj/item/reagent_containers/hypospray/autoinjector/combatpain = 8,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 4,
		/obj/item/reagent_containers/glass/bottle/soporific,
		/obj/item/reagent_containers/syringe/antiviral = 4,
		/obj/item/reagent_containers/pill/antitox = 4,
		/obj/item/reagent_containers/glass/beaker = 4,
		/obj/item/reagent_containers/dropper = 2,
		/obj/item/clothing/gloves/latex = 12,
		/obj/item/clothing/gloves/latex/nitrile = 12,
		/obj/item/storage/box/nitrilegloves = 2,
		/obj/item/stack/medical/advanced/bruise_pack = 12,
		/obj/item/stack/medical/advanced/ointment = 12,
		/obj/item/stack/medical/splint = 10,
		/obj/item/reagent_containers/hypospray/autoinjector/pain = 8,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/allergy = 12,
		/obj/item/storage/firstaid/surgery = 2,
		/obj/item/gun/launcher/syringe,
		/obj/item/storage/box/syringegun
	)

/obj/machinery/vending/ert/tool
	name = "\improper YouTool"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "tool"
	icon_deny = "tool-deny"
	icon_vend = "tool-vend"
	base_type = /obj/machinery/vending/ert/tool
	products = list(
		/obj/item/stack/cable_coil = 20,
		/obj/item/rpd = 4,
		/obj/item/rcd = 4,
		/obj/item/rcd_ammo/large = 15,
		/obj/item/crowbar = 5,
		/obj/item/material/twohanded/jack/titanium = 3,
		/obj/item/weldingtool/electric = 7,
		/obj/item/device/multitool = 5,
		/obj/item/swapper/jaws_of_life = 5,
		/obj/item/swapper/power_drill = 5,
		/obj/item/device/scanner/gas = 5,
		/obj/item/device/t_scanner = 5,
		/obj/item/tape_roll = 10,
		/obj/item/storage/toolbox/electrical = 5,
		/obj/item/storage/toolbox/syndicate = 5,
		/obj/item/device/lightreplacer = 3,
		/obj/item/inducer = 4,
		/obj/item/inflatable_dispenser = 6,
		/obj/item/aicard = 3,
		/obj/item/aiModule/purge = 2,
		/obj/item/aiModule/reset = 2,
		/obj/item/aiModule/quarantine = 2,
		/obj/item/aiModule/solgov = 2,
		/obj/item/aiModule/solgov_aggressive = 2,
		/obj/item/aiModule/freeformcore = 2
	)

/obj/machinery/vending/ert/engi
	name = "\improper FixIt"
	desc = "Everything you need for do-it-yourself repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	icon_vend = "engi-vend"
	base_type = /obj/machinery/vending/ert/engi
	products = list(
		/obj/item/airlock_electronics = 20,
		/obj/item/intercom_electronics = 10,
		/obj/item/module/power_control = 20,
		/obj/item/airalarm_electronics = 20,
		/obj/item/stack/cable_coil = 20,
		/obj/item/cell/high = 10,
		/obj/item/storage/box/lights/mixed = 7,
		/obj/item/stock_parts/scanning_module = 5,
		/obj/item/stock_parts/micro_laser/high = 5,
		/obj/item/stock_parts/matter_bin/adv = 5,
		/obj/item/stock_parts/manipulator = 10,
		/obj/item/stock_parts/console_screen = 10,
		/obj/item/stock_parts/capacitor/adv = 10,
		/obj/item/stock_parts/keyboard = 10,
		/obj/item/stock_parts/power/apc/buildable = 5,
		/obj/item/clamp = 10
	)

/obj/machinery/smartfridge/secure/medbay/ert
	req_access = list(access_cent_medical)

/obj/machinery/smartfridge/secure/medbay/ert/shuttle
	startswith = list(
		/obj/item/reagent_containers/ivbag/blood/human/oneg = 5,
		/obj/item/reagent_containers/ivbag/nanoblood = 5,
		/obj/item/reagent_containers/glass/bottle/bicaridine = 4,
		/obj/item/reagent_containers/glass/bottle/dermaline = 4,
		/obj/item/reagent_containers/glass/bottle/dexalinplus = 6,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 4,
		/obj/item/reagent_containers/glass/bottle/dylovene = 4,
		/obj/item/reagent_containers/glass/bottle/peridaxon = 4,
		/obj/item/reagent_containers/glass/bottle/alkysine = 3,
		/obj/item/reagent_containers/glass/bottle/tricordrazine = 2,
		/obj/item/reagent_containers/glass/bottle/oxycodone = 2,
		/obj/item/reagent_containers/glass/bottle/tramadol = 3,
		/obj/item/reagent_containers/glass/bottle/rezadone,
		/obj/item/reagent_containers/glass/bottle/adrenaline,
		/obj/item/reagent_containers/glass/bottle/ryetalyn = 2,
		/obj/item/reagent_containers/glass/bottle/synaptizine = 2,
		/obj/item/storage/pill_bottle/sugariron = 3,
		/obj/item/storage/pill_bottle/spaceacillin = 2,
		/obj/item/storage/pill_bottle/assorted = 5,
		/obj/item/storage/pill_bottle/hyronalin = 2,
		/obj/item/reagent_containers/glass/bottle/ethylredoxrazine = 2,
		/obj/item/reagent_containers/glass/bottle/arithrazine = 2
	)
