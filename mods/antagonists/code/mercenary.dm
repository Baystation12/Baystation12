
/datum/uplink_category/mercenary
	name = "Mercenary Kits"

/datum/uplink_item/item/mercenary
	category = /datum/uplink_category/mercenary

/*
Mercenary Kits
Used for quick dress-up. Also comes with several discount
*/

/datum/uplink_item/item/mercenary/bioterror
	name = "Bioterror Kit"
	desc = "Kit, filled with bioweaponery. It contains: Voidsuit, sprayer with bioterror mix, bioterror grenade and military pistol. Don't forget to turn your internals on!"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/bioterror

/datum/uplink_item/item/mercenary/pyro
	name = "Pyro Kit"
	desc = "Kit, used for making FIRES! It contains: Special pyro voidsuit, flamethrower with 4 napalm canisters, 2 incendiary grenades and military pistol."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/pyro

/datum/uplink_item/item/mercenary/classic
	name = "Classic Kit"
	desc = "Old and faithful kit. It contains: Heavy armor, assault rifle, cryptographic sequencer and grenade."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/classic

/datum/uplink_item/item/mercenary/stealthy
	name = "Stealthy Kit"
	desc = "A special kit for stealthy operations. It contains: Chameleon kit, fake crew annoncement, freedom implant, cryptographic sequencer, plastic surgery kit, silensed pistol and clerical kit."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/stealthy

/datum/uplink_item/item/mercenary/sniper
	name = "Sniper Kit"
	desc = "Fashionable kit for fashionable operatives. It contains: Cool-looking armor vest, disguised as a suit, thermal googles and sniper rifle with ammo."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/sniper

/datum/uplink_item/item/mercenary/breacher
	name = "Breacher Kit"
	desc = "You're leading the assault. It contains: Heavy armor, 3 C-4 explosives, drum-fed shotgun and cryptographic sequencer."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/breacher

/datum/uplink_item/item/mercenary/saboteur
	name = "Saboteur Kit"
	desc = "You want to sabotage ship systems? This kit is specially for you. It contains: Heavy armor, military pistol, flashdark, chameleon projector, cryptographic sequencer and some C-4 explosives."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/saboteur

/datum/uplink_item/item/mercenary/medic
	name = "Field Medic Kit"
	desc = "This kit can provide almost everything for combat medic. It contains: Heavy armor, military pistol, combat medkit, combat defibrilator and surgery kit."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/medic

/datum/uplink_item/item/mercenary/heavy
	name = "Heavy Kit"
	desc = "This kit is for heavy gunners. It contains: Heavy armor, energy shield, grenade and L6 Saw machinegun."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT * 2
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/heavy

/datum/uplink_item/item/mercenary/netrunner
	name = "Netrunner Kit"
	desc = "This kit is can provide some help in hacking of ship systems. It contains: Hacker rig, camera MIU, some computers and cryptographic sequencer."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	antag_roles = list(MODE_MERCENARY)
	path = /obj/structure/closet/crate/mercenary/netrunner

// What's inside the box

/singleton/closet_appearance/crate/mercenary
	color = COLOR_DARK_GUNMETAL
	decals = list(
		"crate_stripes" = COLOR_MAROON
	)

/obj/structure/closet/crate/mercenary
	name = "gorlex marauders crate"
	desc = "A mercenary equipment crate."

/obj/structure/closet/crate/mercenary/bioterror

/obj/structure/closet/crate/mercenary/bioterror/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/merc,
		/obj/item/clothing/head/helmet/merc,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/tank/oxygen_emergency_double,
		/obj/item/reagent_containers/spray/chemsprayer/bioterror,
		/obj/item/reagent_containers/glass/beaker/insulated/large/bioterror = 3,
		/obj/item/grenade/chem_grenade/bioterror,
		/obj/item/gun/projectile/pistol/optimus
		)

/obj/structure/closet/crate/mercenary/pyro

/obj/structure/closet/crate/mercenary/pyro/WillContain()
	return list(
		/obj/item/clothing/suit/space/void/merc/heavy/prepared,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/tank/oxygen_emergency_double,
		/obj/item/flamethrower/full/loaded,
		/obj/item/reagent_containers/glass/beaker/insulated/large/napalm = 3,
		/obj/item/grenade/chem_grenade/fuelspray = 2,
		/obj/item/gun/projectile/pistol/optimus
		)

/obj/structure/closet/crate/mercenary/classic

/obj/structure/closet/crate/mercenary/classic/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/merc,
		/obj/item/clothing/head/helmet/merc,
		/obj/item/gun/projectile/automatic/assault_rifle,
		/obj/item/grenade/frag/high_yield,
		/obj/item/card/emag
		)

/obj/structure/closet/crate/mercenary/stealthy

/obj/structure/closet/crate/mercenary/stealthy/WillContain()
	return list(
		/obj/item/storage/box/syndie_kit/chameleon = 2,
		/obj/item/storage/box/syndie_kit/silenced,
		/obj/item/storage/box/syndie_kit/spy,
		/obj/item/clothing/mask/chameleon/voice,
		/obj/item/device/cosmetic_surgery_kit,
		/obj/item/stamp/chameleon,
		/obj/item/pen/chameleon,
		/obj/item/storage/box/syndie_kit/imp_freedom,
		/obj/item/device/uplink_service/fake_crew_announcement,
		/obj/item/card/emag
		)

/obj/structure/closet/crate/mercenary/sniper

/obj/structure/closet/crate/mercenary/sniper/WillContain()
	return list(
		/obj/item/clothing/under/det,
		/obj/item/clothing/suit/storage/leather_jacket/armored,
		/obj/item/gun/projectile/heavysniper,
		/obj/item/storage/box/ammo/sniperammo,
		/obj/item/clothing/glasses/thermal/syndi
		)

/obj/structure/closet/crate/mercenary/breacher

/obj/structure/closet/crate/mercenary/breacher/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/merc,
		/obj/item/clothing/head/helmet/merc,
		/obj/item/gun/projectile/shotgun/magshot,
		/obj/item/ammo_magazine/shotgunmag/shot,
		/obj/item/ammo_magazine/shotgunmag,
		/obj/item/plastique = 3,
		/obj/item/card/emag
		)

/obj/structure/closet/crate/mercenary/saboteur

/obj/structure/closet/crate/mercenary/saboteur/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/merc,
		/obj/item/clothing/head/helmet/merc,
		/obj/item/device/flashlight/flashdark,
		/obj/item/device/chameleon,
		/obj/item/gun/projectile/pistol/optimus,
		/obj/item/plastique = 2,
		/obj/item/card/emag
		)

/obj/structure/closet/crate/mercenary/medic

/obj/structure/closet/crate/mercenary/medic/WillContain()
	return list(
		/obj/item/clothing/suit/armor/pcarrier/merc,
		/obj/item/clothing/head/helmet/merc,
		/obj/item/storage/firstaid/combat,
		/obj/item/storage/firstaid/surgery,
		/obj/item/defibrillator/compact/combat/loaded,
		/obj/item/gun/projectile/pistol/optimus,
		)

/obj/structure/closet/crate/mercenary/heavy

/obj/structure/closet/crate/mercenary/heavy/WillContain()
	return list(
		/obj/item/clothing/suit/space/void/merc/heavy/prepared,
		/obj/item/gun/projectile/automatic/l6_saw,
		/obj/item/ammo_magazine/box/machinegun = 3,
		/obj/item/grenade/frag/high_yield,
		/obj/item/shield/energy
		)

/obj/structure/closet/crate/mercenary/netrunner

/obj/structure/closet/crate/mercenary/netrunner/WillContain()
	return list(
		/obj/item/rig/light/hacker/runner,
		/obj/item/modular_computer/laptop/preset/custom_loadout/advanced,
		/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,
		/obj/item/modular_computer/pda/syndicate,
		/obj/item/clothing/glasses/hud/it,
		/obj/item/clothing/mask/ai,
		/obj/item/device/multitool/hacktool,
		/obj/item/card/emag = 2
		)


// Items

/obj/item/reagent_containers/glass/beaker/insulated/large/napalm

/obj/item/reagent_containers/glass/beaker/insulated/large/napalm/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/napalm, 120)


/obj/item/reagent_containers/glass/beaker/insulated/large/bioterror

/obj/item/reagent_containers/glass/beaker/insulated/large/bioterror/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drugs/hextro, volume / 10)
	reagents.add_reagent(/datum/reagent/drugs/mindbreaker, volume / 10)
	reagents.add_reagent(/datum/reagent/toxin/carpotoxin, volume / 10)
	reagents.add_reagent(/datum/reagent/mutagen, volume / 10)
	reagents.add_reagent(/datum/reagent/toxin/amatoxin, volume / 10)
	reagents.add_reagent(/datum/reagent/toxin/phoron, volume / 10)
	reagents.add_reagent(/datum/reagent/impedrezene, volume / 10)
	reagents.add_reagent(/datum/reagent/toxin/potassium_chlorophoride, volume / 10)
	reagents.add_reagent(/datum/reagent/acid/polyacid, volume / 10)
	reagents.add_reagent(/datum/reagent/radium, volume / 10)

// Bioterror Chem sprayer

/obj/item/reagent_containers/spray/chemsprayer/bioterror
	name = "bioterror chem sprayer"
	desc = "This chem sprayer is filled with mix, that will melt, mutate and irradiate everything."

/obj/item/reagent_containers/spray/chemsprayer/bioterror/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drugs/hextro, volume / 60)
	reagents.add_reagent(/datum/reagent/drugs/mindbreaker, volume / 60)
	reagents.add_reagent(/datum/reagent/toxin/carpotoxin, volume / 60)
	reagents.add_reagent(/datum/reagent/mutagen, volume / 60)
	reagents.add_reagent(/datum/reagent/toxin/amatoxin, volume / 60)
	reagents.add_reagent(/datum/reagent/toxin/phoron, volume / 60)
	reagents.add_reagent(/datum/reagent/impedrezene, volume / 60)
	reagents.add_reagent(/datum/reagent/toxin/potassium_chlorophoride, volume / 60)
	reagents.add_reagent(/datum/reagent/acid/polyacid, volume / 60)
	reagents.add_reagent(/datum/reagent/radium, volume / 60)

// Grenades

/obj/item/grenade/chem_grenade/bioterror
	name = "bioterror grenade"
	desc = "Used for clearing rooms of living things."
	path = 1
	stage = 2

/obj/item/grenade/chem_grenade/bioterror/Initialize()
		. = ..()
		var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
		var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

		B1.reagents.add_reagent(/datum/reagent/phosphorus, 26)
		B1.reagents.add_reagent(/datum/reagent/sugar, 14)
		B2.reagents.add_reagent(/datum/reagent/sugar, 14)
		B2.reagents.add_reagent(/datum/reagent/potassium, 26)
		B1.reagents.add_reagent(/datum/reagent/drugs/hextro,20)
		B2.reagents.add_reagent(/datum/reagent/toxin/carpotoxin, 20)
		B1.reagents.add_reagent(/datum/reagent/drugs/mindbreaker, 20)
		B2.reagents.add_reagent(/datum/reagent/toxin/amatoxin, 20)
		B2.reagents.add_reagent(/datum/reagent/acid/polyacid, 20)
		B1.reagents.add_reagent(/datum/reagent/toxin/phoron, 20)
		B1.reagents.add_reagent(/datum/reagent/mutagen, 20)
		B2.reagents.add_reagent(/datum/reagent/acid/polyacid, 20)
		B2.reagents.add_reagent(/datum/reagent/impedrezene, 20)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2
		icon_state = initial(icon_state) +"_locked"

/obj/item/grenade/chem_grenade/fuelspray
	name = "napalm mix release grenade"
	desc = "Used for reliasing lots of napalm mix."
	path = 1
	stage = 2

/obj/item/grenade/chem_grenade/fuelspray/Initialize()
		. = ..()
		var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
		var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

		B1.reagents.add_reagent(/datum/reagent/potassium, 26)
		B1.reagents.add_reagent(/datum/reagent/sugar, 14)
		B2.reagents.add_reagent(/datum/reagent/sugar, 14)
		B2.reagents.add_reagent(/datum/reagent/phosphorus, 26)
		B1.reagents.add_reagent(/datum/reagent/napalm, 40)
		B2.reagents.add_reagent(/datum/reagent/napalm, 40)
		B1.reagents.add_reagent(/datum/reagent/toxin/phoron/oxygen, 40)
		B2.reagents.add_reagent(/datum/reagent/fuel, 40)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2
		icon_state = initial(icon_state) +"_locked"


// Elite Voidsuit

/obj/item/clothing/head/helmet/space/void/merc/heavy
	name = "elite tactical voidsuit helmet"
	desc = "A heavy tactical void helm designed for combat under heavy enemy fire and in extreme conditions. Property of Gorlex Marauders."

	icon = 'maps/sierra/icons/obj/clothing/obj_head.dmi'
	item_icons = list(slot_head_str = 'maps/sierra/icons/mob/onmob/onmob_head.dmi')
	icon_state = "syndie_helm"
	action_button_name = "Toggle Combat Mode"

	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	siemens_coefficient = 0.3
	species_restricted = list(SPECIES_HUMAN, SPECIES_IPC)
	camera = /obj/machinery/camera/network/mercenary
	light_overlay = "yellow_double_light"
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	tint = 1

/obj/item/clothing/suit/space/void/merc/heavy
	name = "elite tactical voidsuit"
	desc = "A heavy tactical voidsuit designed for combat under heavy enemy fire and in extreme conditions. Property of Gorlex Marauders."

	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'

	item_icons = list(
		slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi',
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_spacesuits.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_spacesuits.dmi',)


	item_state_slots = list(slot_l_hand_str = "syndie_voidsuit",
							slot_r_hand_str = "syndie_voidsuit",
							slot_wear_suit_str = "syndie_voidsuit")
	icon_state = "syndie_voidsuit"

	w_class = ITEM_SIZE_LARGE
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.3
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_IPC)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	var/mode = 0

	var/armor_normal = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)

	var/armor_combat = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)

/obj/item/clothing/suit/space/void/merc/heavy/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1.5
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/space/void/merc/heavy/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/merc/heavy
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/oxygen

/obj/item/clothing/suit/space/void/merc/heavy/verb/toggle_mode()

	set name = "Toggle Combat Mode"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	if(!helmet)
		to_chat(usr, "There is no helmet installed.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H)) return
	if(H.incapacitated()) return
	if(H.wear_suit != src) return

	if(H.head == helmet)
		if(mode)
			to_chat(usr, "You disengaged combat mode on your suit. Now you will be much faster, but your suit will offer less protection.")
			slowdown_per_slot[slot_wear_suit] = 1.5
			helmet.armor = armor_normal
			armor = armor_normal
			mode = 0
		else
			to_chat(usr, "You engaged combat mode on your suit. It will give you much more protection in cost of speed.")
			slowdown_per_slot[slot_wear_suit] = 7.5
			helmet.armor = armor_combat
			armor = armor_combat
			mode = 1
	else
		to_chat(usr, "You can't toggle combat mode while your helmet is disengaged.")
		return
	helmet.update_light(H)

// Netrunner stuff

/obj/item/rig/light/hacker/runner

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/chem_dispenser/ninja,
		/obj/item/rig_module/mounted/energy/ion,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/cooling_unit
		)
