	///////////////
	//GUNCABINETS//
	///////////////

/obj/structure/closet/secure_closet/guncabinet/patrol
	name = "tempest group cabinet"
	req_access = list(access_away_cavalry_captain)

/obj/structure/closet/secure_closet/guncabinet/patrol/energy/WillContain()
	return list(
		/obj/item/gun/energy/ionrifle/small  = 1,
		/obj/item/gun/energy/plasmastun = 1,
		/obj/item/gun/energy/laser = 3,
		/obj/item/gun/energy/sniperrifle = 1
	)

/obj/structure/closet/secure_closet/guncabinet/patrol/assault/WillContain()
	return list(
		/obj/item/ammo_magazine/mil_rifle/light = 15,
		/obj/item/gun/projectile/automatic/bullpup_rifle/light = 3,
		/obj/item/ammo_magazine/machine_pistol = 5,
		/obj/item/gun/projectile/automatic/machine_pistol = 1
	)

/obj/structure/closet/secure_closet/guncabinet/patrol/carabine/WillContain()
	return list(
		/obj/item/ammo_magazine/mil_rifle/heavy = 5,
		/obj/item/gun/projectile/automatic/bullpup_rifle = 1,
		/obj/item/clothing/accessory/storage/bandolier = 1,
		/obj/item/gun/projectile/shotgun/pump/combat = 1,
		/obj/item/gun/projectile/pistol/m22f = 3
	)

/obj/structure/closet/secure_closet/guncabinet/patrol/utility/WillContain()
	return list(
		/obj/item/storage/box/teargas = 1,
		/obj/item/storage/box/frags = 1,
		/obj/item/storage/box/fragshells = 2,
		/obj/item/storage/box/smokes = 2,
		/obj/item/storage/box/ammo/flashshells = 2,
		/obj/item/storage/box/ammo/shotgunshells = 2,
		/obj/item/storage/box/ammo/shotgunammo = 2,
		/obj/item/storage/box/ammo/stunshells = 2,
		/obj/item/plastique = 6
	)

	///////////
	//CLOSETS//
	///////////

/obj/structure/closet/secure_closet/patrol
	name = "trooper locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/sol/two/dark
	req_access = list(access_away_cavalry_ops)

/obj/structure/closet/secure_closet/patrol/WillContain()
	return list(
		/obj/item/storage/belt/holster/security/tactical,
		/obj/item/melee/telebaton,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/clothing/glasses/tacgoggles,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/gloves/thick/combat,
		/obj/item/device/flashlight/maglight,
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/clothing/mask/balaclava,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/accessory/storage/holster/thigh,
		/obj/item/clothing/accessory/armor_plate/merc,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/storage/backpack/satchel/leather/black
	)


/obj/structure/closet/secure_closet/patrol/marine_lead
	name = "squad leader locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/sol/two/dark
	req_access = list(access_away_cavalry_captain)


/obj/structure/closet/secure_closet/patrol/marine_lead/WillContain()
	return list(
		/obj/item/storage/belt/holster/security/tactical,
		/obj/item/melee/telebaton,
		/obj/item/clothing/glasses/hud/security/prot/aviators,
		/obj/item/clothing/glasses/tacgoggles,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/gloves/thick/combat,
		/obj/item/device/flashlight/maglight,
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/device/megaphone,
		/obj/item/clothing/mask/balaclava,
		//obj/item/clothing/accessory/armor/tag/solgov/com,
		/obj/item/storage/fancy/smokable/cigar,
		/obj/item/flame/lighter/zippo/gunmetal,
		/obj/item/clothing/mask/gas/swat,
		/obj/item/clothing/gloves/wristwatch,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/accessory/storage/holster/thigh,
		/obj/item/clothing/accessory/armor_plate/merc,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/storage/backpack/satchel/leather/black
	)

/obj/structure/closet/secure_closet/patrol/fleet
	name = "fleet pilot cabinet"
	closet_appearance = /singleton/closet_appearance/secure_closet/sol
	req_access = list(access_away_cavalry)

/obj/structure/closet/secure_closet/patrol/fleet/WillContain()
	return list(
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/under/solgov/utility/fleet/polopants/command,
		/obj/item/clothing/head/solgov/dress/fleet,
		/obj/item/clothing/head/beret/solgov/fleet/command,
		/obj/item/clothing/accessory/solgov/department/command/fleet,
		/obj/item/clothing/suit/storage/solgov/service/fleet/officer
	)

/obj/structure/closet/secure_closet/patrol/fleet/engi
	name = "fleet technician cabinet"
	closet_appearance = /singleton/closet_appearance/secure_closet/sol
	req_access = list(access_away_cavalry)

/obj/structure/closet/secure_closet/patrol/fleet/engi/WillContain()
	return list(
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/clothing/mask/gas,
		/obj/item/storage/belt/utility/full,
		/obj/item/device/multitool,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/clothing/head/hardhat/orange,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/head/beret/solgov/fleet/engineering,
		/obj/item/clothing/head/solgov/dress/fleet/garrison,
		/obj/item/clothing/under/solgov/utility/fleet/polopants,
		/obj/item/clothing/accessory/solgov/department/engineering/fleet,
		/obj/item/clothing/suit/storage/solgov/service/fleet
	)

/obj/structure/closet/secure_closet/patrol/fleet/med
	name = "fleet corpsman cabinet"
	closet_appearance = /singleton/closet_appearance/secure_closet/sol
	req_access = list(access_away_cavalry)

/obj/structure/closet/secure_closet/patrol/fleet/med/WillContain()
	return list(
		/obj/item/storage/firstaid/sleekstab,
		/obj/item/clothing/mask/gas,
		/obj/item/storage/belt/medical,
		/obj/item/clothing/head/beret/solgov/fleet/medical,
		/obj/item/storage/firstaid/adv,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/gloves/latex/nitrile,
		/obj/item/clothing/under/rank/medical/scrubs/black,
		/obj/item/clothing/head/surgery/black,
		/obj/item/clothing/suit/storage/hazardvest/white,
		/obj/item/clothing/head/solgov/dress/fleet,
		/obj/item/clothing/under/solgov/utility/fleet/polopants/command,
		/obj/item/clothing/accessory/solgov/department/medical/fleet,
		/obj/item/clothing/suit/storage/solgov/service/fleet/officer
	)

/obj/structure/closet/secure_closet/patrol/fleet_com
	name = "fleet commander cabinet"
	closet_appearance = /singleton/closet_appearance/secure_closet/sol
	req_access = list(access_away_cavalry, access_away_cavalry_commander)

/obj/structure/closet/secure_closet/patrol/fleet_com/WillContain()
	return list(
		/obj/item/melee/telebaton,
		/obj/item/gun/projectile/pistol/m22f,
		/obj/item/device/megaphone,
		//obj/item/clothing/accessory/armor/tag/solgov/com,
		/obj/item/clothing/mask/gas,
		/obj/item/storage/chewables/rollable/rollingkit,
		/obj/item/storage/fancy/smokable/cigar,
		/obj/item/flame/lighter/zippo/gunmetal,
		/obj/item/clothing/head/beret/solgov/fleet/command,
		/obj/item/clothing/under/solgov/utility/fleet/polopants/command,
		/obj/item/gun/projectile/revolver/medium,
		/obj/item/clothing/gloves/wristwatch/gold,
		/obj/item/clothing/head/solgov/dress/fleet,
		/obj/item/clothing/accessory/solgov/department/command/fleet,
		/obj/item/clothing/suit/storage/solgov/service/fleet/officer
	)


/obj/structure/closet/wardrobe/patrol
	name = "military attire closet"
	closet_appearance = /singleton/closet_appearance/tactical


/obj/structure/closet/wardrobe/patrol/desert
	name = "desert attire closet"
	closet_appearance = /singleton/closet_appearance/tactical

/obj/structure/closet/wardrobe/patrol/desert/WillContain()
	return list(
	/obj/item/clothing/under/scga/utility/tan = 3,
	/obj/item/clothing/head/scga/utility/tan = 3,
	/obj/item/clothing/shoes/tactical = 3,
	/obj/item/clothing/gloves/thick/combat = 3
	)

/obj/structure/closet/wardrobe/patrol/army
	name = "woodland attire closet"
	closet_appearance = /singleton/closet_appearance/tactical

/obj/structure/closet/wardrobe/patrol/army/WillContain()
	return list(
	/obj/item/clothing/under/scga/utility  = 3,
	/obj/item/clothing/head/scga/utility = 3,
	/obj/item/clothing/shoes/scga/utility = 3,
	/obj/item/clothing/gloves/thick/combat = 3
	)

/obj/structure/closet/wardrobe/patrol/urban
	name = "urban attire closet"
	closet_appearance = /singleton/closet_appearance/tactical

/obj/structure/closet/wardrobe/patrol/urban/WillContain()
	return list(
	/obj/item/clothing/under/solgov/utility  = 3,
	/obj/item/clothing/head/solgov/utility = 3,
	/obj/item/clothing/shoes/dutyboots = 3,
	/obj/item/clothing/gloves/thick/combat = 3
	)

	////////
	//MISC//
	////////

/obj/machinery/door/airlock/autoname/command
	req_access = list(access_away_cavalry)

/obj/machinery/door/airlock/autoname/engineering
	req_access = list(access_away_cavalry)

/obj/machinery/door/airlock/autoname/marine
	req_access = list(access_away_cavalry)

/obj/machinery/vending/away_solpatrol_uniform
	name = "Fleet uniform dispenser"
	desc = "A specialized vending machine with nice and fresh navy-blue clothing inside. For military personnel only."
	icon = 'mods/_maps/sentinel/icons/fleet_vendomat.dmi'
	icon_state = "uniform_fleet"
	icon_deny = "uniform_fleet-deny"
	icon_vend = "uniform_fleet-vend"
	req_access = list(access_away_cavalry)
	products = list(/obj/item/clothing/head/beret/solgov/fleet/branch/fifth = 5,
					/obj/item/clothing/head/soft/solgov/fleet = 5,
					/obj/item/clothing/head/ushanka/solgov/fleet = 5,
					/obj/item/clothing/under/solgov/utility/fleet = 5,
					/obj/item/clothing/under/solgov/utility/fleet/combat = 5,
					/obj/item/clothing/under/solgov/service/fleet = 5,
					/obj/item/clothing/under/solgov/pt/fleet = 5,
					/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet = 5,
					/obj/item/clothing/shoes/dutyboots = 5,
					/obj/item/clothing/shoes/dress = 5,
					/obj/item/clothing/shoes/black = 5,
					/obj/item/clothing/gloves/thick = 5,
					/obj/item/storage/belt/holster/security = 5,
					/obj/item/storage/backpack/satchel/leather/navy = 5,
					/obj/item/clothing/accessory/storage/black_drop = 5,
					/obj/item/clothing/accessory/solgov/fleet_patch/fifth = 5,
					)
/* Voidsuit Storage Unit
 * ====
 */

/obj/machinery/suit_storage_unit/away_cavalry_med
	name = "Corpsman Voidsuit Storage Unit"
	suit= /obj/item/clothing/suit/space/void/medical/alt/sol/prepared
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/oxygen
	req_access = list(access_away_cavalry)
	islocked = 1

/obj/machinery/suit_storage_unit/away_cavalry_eng
	name = "Technician Voidsuit Storage Unit"
	suit= /obj/item/clothing/suit/space/void/engineering/alt/sol/prepared
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/oxygen
	req_access = list(access_away_cavalry)
	islocked = 1

/obj/machinery/suit_storage_unit/away_cavalry_com
	name = "Officer Voidsuit Storage Unit"
	suit= /obj/item/clothing/suit/space/void/command/prepared
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/oxygen
	req_access = list(access_away_cavalry, access_away_cavalry_commander)
	islocked = 1

/obj/machinery/suit_storage_unit/away_cavalry_fly
	name = "Pilot Voidsuit Storage Unit"
	suit= /obj/item/clothing/suit/space/void/pilot/sol/prepared
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/oxygen
	req_access = list(access_away_cavalry)
	islocked = 1

// BOSNIAN ARTILLERY SECTION //

/obj/machinery/computer/ship/disperser/military
	name = "impulse cannon control"

/obj/item/stock_parts/circuitboard/disperser/military
	name = "circuit board (impulse cannon control)"
	build_path = /obj/machinery/computer/ship/disperser/military
	origin_tech = list(TECH_ENGINEERING = 6, TECH_COMBAT = 6, TECH_BLUESPACE = 6)

/obj/structure/ship_munition/disperser_charge/fire/military
	name = "M1050-NPLM"
	desc = "A charge to power the military impulse gun. This charge is designed to release a localised fire on impact."
	chargedesc = "NPLM"

/obj/structure/ship_munition/disperser_charge/fire/military/fire(turf/target, strength, range, shield_active_EM, shield_active_KTC)
	if(shield_active_EM && shield_active_KTC)
		return
	var/datum/reagent/napalm/napalm_liquid = new /datum/reagent/napalm
	napalm_liquid.volume = 5 * strength
	for(var/atom/A in view(range, target))
		if(ismob(A))
			napalm_liquid.touch_mob(A, 10 * strength)
		if(isturf(A))
			napalm_liquid.touch_turf(A, TRUE)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, target)
	addtimer(new Callback(s, /datum/effect/effect/system/proc/start), 0.1 SECONDS | TIMER_STOPPABLE)

/obj/structure/ship_munition/disperser_charge/emp/military
	name = "M850-EM"
	desc = "A charge to power the military impulse gun. This charge is designed to release a blast of electromagnetic pulse on impact."
	chargedesc = "EMS"

/obj/structure/ship_munition/disperser_charge/emp/military/fire(turf/target, strength, range, shield_active_EM, shield_active_KTC)
	var/shield_mod = 1
	if(shield_active_EM)
		shield_mod = 0.5
	empulse(target, strength * range / 2 * shield_mod , strength * range * 1.5 * shield_mod)

/obj/structure/ship_munition/disperser_charge/explosive/military
	name = "M950-HE"
	desc = "A charge to power the military impulse gun. This charge is designed to explode on impact."
	chargedesc = "HES"

/obj/structure/ship_munition/disperser_charge/explosive/military/fire(turf/target, strength, range, shield_active_EM, shield_active_KTC)
	var/shield_mod = 1
	if(shield_active_KTC)
		shield_mod = 0.75
	explosion(target,max(1,strength * range / 8 * shield_mod),strength * range / 6 * shield_mod,strength * range / 4 * shield_mod)
