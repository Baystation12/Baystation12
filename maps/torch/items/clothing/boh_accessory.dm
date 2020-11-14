// marine patch
/obj/item/clothing/accessory/solgov/smc_patch
	name = "\improper Marine Corps patch"
	desc = "A robust shoulder patch, carrying the symbol of the Solar Marine Corps, or SMC for short."
	icon = 'maps/torch/icons/obj/obj_accessories_boh.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_boh.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_boh.dmi')
	icon_state = "smcpatch"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_INSIGNIA
	check_codex_val = FACTION_MARINES

/obj/item/clothing/accessory/solgov/smc_patch/xeno
	name = "\improper Xenoic Division of Marine Corps patch"
	desc = "A robust shoulder patch, carrying the symbol-mascot of Xenoic division, yellow-eyed devil dog."
	icon_state = "smcpatch13"

// Sixth Fleet Patch, as for bonus
/obj/item/clothing/accessory/solgov/fleet_patch/sixth
	name = "\improper Sixth Fleet patch"
	desc = "A robust shoulder patch carrying insignia of Sixth Fleet."
	icon = 'maps/torch/icons/obj/obj_accessories_boh.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_boh.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_boh.dmi')
	icon_state = "fleetpatch6"
	on_rolled = list("down" = "none")

// Modular version for NT Patch
/obj/item/clothing/accessory/armor/tag/nt/dagon
	name = "\improper NANOTRASEN patch"
	desc = "An armor tag with the words NANOTRASEN printed in bottle green lettering on it."

// Dog Tags badge string rename, plus added for SMC and NTEF.
/obj/item/clothing/accessory/badge/solgov/tags
	badge_string = "NTSS Dagon"

/obj/item/clothing/accessory/badge/solgov/tags/fleet
	badge_string = "NTEF"

/obj/item/clothing/accessory/badge/solgov/tags/marine
	badge_string = "SMC"

// custom ribbon for loadout
/obj/item/clothing/accessory/ribbon/solgov/custom
	icon_state = "ribbon_custom"
	icon = 'maps/torch/icons/obj/obj_accessories_boh.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_boh.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_boh.dmi')

/obj/item/clothing/accessory/ribbon/solgov/custom/color
	icon_state = "ribbon_custom_color"

// explorer ranks and spec pin
/obj/item/clothing/accessory/solgov/specialty/enlisted/explorer
	name = "explorer qualification pin"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted
	name = "ranks (E-1 recruit explorer)"
	desc = "Insignia denoting the rank of Recruit Explorer."

/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e2
	name = "ranks (E-2 junior explorer)"
	desc = "Insignia denoting the rank of Junior Explorer."

// NTEF ranks. Icon overrides for now (useless on-mob, but good for in-hand/dropped or on examine).
/obj/item/clothing/accessory/solgov/rank/fleet
	icon_state = "FE0"
	overlay_state = "fleetrank_enlisted"
	icon = 'maps/torch/icons/obj/obj_accessories_boh.dmi'

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted
	icon_state = "FE1"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e2
	icon_state = "FE2"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e3
	icon_state = "FE3"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e4
	icon_state = "FE4"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e5
	icon_state = "FE5"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e6
	icon_state = "FE6"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e7
	icon_state = "FE7"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e8
	icon_state = "FE8"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9
	icon_state = "FE9"

// Damn it, Bay. Why you put alts not as object subpath for easier icon handling?
/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt1
	icon_state = "FE9"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt2
	icon_state = "FE9"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt3
	icon_state = "FE9"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt4
	icon_state = "FE9"

/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer
	icon_state = "FW0"
	overlay_state = "fleetrank_warrant_gold"

/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w1
	icon_state = "FW1"
	name = "ranks (W-1 junior warrant officer"
	desc = "Insignia denoting the rank of Junior Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w2
	icon_state = "FW2"
	name = "ranks (W-2 chief warrant officer"
	desc = "Insignia denoting the rank of Chief Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w3
	icon_state = "FW3"
	overlay_state = "fleetrank_warrant_silver"
	name = "ranks (W-3 senior chief warrant officer"
	desc = "Insignia denoting the rank of Senior Chief Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w4
	icon_state = "FW4"
	overlay_state = "fleetrank_warrant_silver"
	name = "ranks (W-4 master chief warrant officer"
	desc = "Insignia denoting the rank of Master Chief Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w5
	icon_state = "FW5"
	overlay_state = "fleetrank_warrant_stripe"
	name = "ranks (W-5 command master chief warrant officer"
	desc = "Insignia denoting the rank of Command Master Chief Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/fleet/officer
	icon_state = "FO1"
	overlay_state = "fleetrank_officer"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/wo1_monkey
	icon_state = "MO1"
	name = "makeshift ranks (MO-1 monkey officer second class)"
	desc = "Insignia denoting the rank of Monkey Officer Second Class. It looks to be upside down."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o2
	icon_state = "FO2"
	name = "ranks (O-2 lieutenant junior-grade)"
	desc = "Insignia denoting the rank of Lieutenant Junior-Grade."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o3
	icon_state = "FO3"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o4
	icon_state = "FO4"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o5
	icon_state = "FO5"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o6
	icon_state = "FO6"
	overlay_state = "fleetrank_command"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o7
	icon_state = "FO7"
	overlay_state = "fleetrank_command"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o8
	icon_state = "FO8"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o9
	icon_state = "FO9"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10
	icon_state = "FO10"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10_alt
	icon_state = "FO10"

// ranks - proper marines and now with actual individal insignias
/obj/item/clothing/accessory/solgov/rank/marine_corps
	icon_state = "ME0"
	name = "marine ranks"
	desc = "Insignia denoting marine rank of some kind. These appear blank."
	overlay_state = "armyrank_enlisted"
	icon = 'maps/torch/icons/obj/obj_accessories_boh.dmi'

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted
	icon_state = "ME1"
	name = "ranks (E-1 private)"
	desc = "Insignia denoting the rank of Private."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e2
	icon_state = "ME2"
	name = "ranks (E-2 private first class)"
	desc = "Insignia denoting the rank of Private First Class."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e3
	icon_state = "ME3"
	name = "ranks (E-3 lance corporal)"
	desc = "Insignia denoting the rank of Lance Corporal."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e4
	icon_state = "ME4"
	name = "ranks (E-4 corporal)"
	desc = "Insignia denoting the rank of Corporal."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e5
	icon_state = "ME5"
	name = "ranks (E-5 sergeant)"
	desc = "Insignia denoting the rank of Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e6
	icon_state = "ME6"
	name = "ranks (E-6 staff sergeant)"
	desc = "Insignia denoting the rank of Staff Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e7
	icon_state = "ME7"
	name = "ranks (E-7 gunnery sergeant)"
	desc = "Insignia denoting the rank of Gunnery Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e8
	icon_state = "ME8"
	name = "ranks (E-8 master sergeant)"
	desc = "Insignia denoting the rank of Master Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e8_alt
	icon_state = "ME8A"
	name = "ranks (E-8 first sergeant)"
	desc = "Insignia denoting the rank of First Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e9
	icon_state = "ME9"
	name = "ranks (E-9 master gunnery sergeant)"
	desc = "Insignia denoting the rank of Master Gunnery Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e9_alt
	icon_state = "ME9A"
	name = "ranks (E-9 sergeant major)"
	desc = "Insignia denoting the rank of Sergeant Major."

/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e9_alt2
	icon_state = "ME9B"
	name = "ranks (E-9 sergeant major of the marine Corps)"
	desc = "Insignia denoting the rank of Sergeant Major of the Marine Corps."

/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer
	icon_state = "MW0"
	overlay_state = "armyrank_warrant_gold"

/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w1
	icon_state = "MW1"
	name = "ranks (W-1 warrant officer)"
	desc = "Insignia denoting the rank of Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w2
	icon_state = "MW2"
	name = "ranks (W-2 second warrant officer"
	desc = "Insignia denoting the rank of Second Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w3
	icon_state = "MW3"
	overlay_state = "armyrank_warrant_silver"
	name = "ranks (W-3 first warrant officer)"
	desc = "Insignia denoting the rank of First Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w4
	icon_state = "MW4"
	name = "ranks (W-4 major warrant officer)"
	overlay_state = "armyrank_warrant_silver"
	desc = "Insignia denoting the rank of Major Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w5
	icon_state = "MW5"
	overlay_state = "armyrank_warrant_stripe"
	name = "ranks (W-5 general warrant officer)"
	desc = "Insignia denoting the rank of General Warrant Officer"

/obj/item/clothing/accessory/solgov/rank/marine_corps/officer
	icon_state = "MO1A"
	overlay_state = "armyrank_officer"
	name = "ranks (O-1 second lieutenant)"
	desc = "Insignia denoting the rank of Second Lieutenant."

/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o2
	icon_state = "MO2"
	name = "ranks (O-2 first lieutenant)"
	desc = "Insignia denoting the rank of First Lieutenant."

/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o3
	icon_state = "MO3"
	name = "ranks (O-3 captain)"
	desc = "Insignia denoting the rank of Captain."

/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o3_alt
	icon_state = "MO3"
	name = "ranks (O-3 Marine captain)"
	desc = "Insignia denoting the rank of Marine Captain."

/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o3_alt2
	icon_state = "MO3"
	name = "ranks (O-3 specialist captain)"
	desc = "Insignia denoting the rank of Specialist Captain."

/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o4
	icon_state = "MO4"
	name = "ranks (O-4 major)"
	desc = "Insignia denoting the rank of Major."

/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o5
	icon_state = "MO5"
	name = "ranks (O-5 lieutenant colonel)"
	desc = "Insignia denoting the rank of Lieutenant Colonel."

/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o6
	icon_state = "MO6"
	name = "ranks (O-6 colonel)"
	desc = "Insignia denoting the rank of Colonel."

/obj/item/clothing/accessory/solgov/rank/marine_corps/flag
	icon_state = "MO7"
	overlay_state = "armyrank_command"
	name = "ranks (O-7 brigadier general)"
	desc = "Insignia denoting the rank of Brigadier General."
	icon_state = "armyrank_command"

/obj/item/clothing/accessory/solgov/rank/marine_corps/flag/o8
	icon_state = "MO8"
	name = "ranks (O-8 major general)"
	desc = "Insignia denoting the rank of Major General."

/obj/item/clothing/accessory/solgov/rank/marine_corps/flag/o9
	icon_state = "MO9"
	name = "ranks (O-9 lieutenant general)"
	desc = "Insignia denoting the rank of Lieutenant General."

/obj/item/clothing/accessory/solgov/rank/marine_corps/flag/o10
	icon_state = "MO10"
	name = "ranks (O-10 general)"
	desc = "Insignia denoting the rank of General."
