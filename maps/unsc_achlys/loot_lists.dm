
#define COVGEAR_LOOT list(/obj/item/weapon/gun/projectile/needler,/obj/item/ammo_magazine/needles,/obj/item/weapon/gun/projectile/type51carbine,/obj/item/ammo_magazine/type51mag,/obj/item/ammo_magazine/type51mag,/obj/item/clothing/head/helmet/sangheili/minor/achlys,/obj/item/clothing/suit/armor/special/combatharness/minor/achlys,/obj/item/clothing/shoes/sangheili/minor/achlys,/obj/item/clothing/gloves/thick/sangheili/minor/achlys)

/*
The lists below, to decide the actual amount of loot in said list, have each element inserted into the final loot list
A random number of times between the max and min defined number.
*/
#define ACHLYS_LOOT_RANDMIN 1
#define ACHLYS_LOOT_RANDMAX 4
#define WANDERFLOOD_LOOT_BASE list(/mob/living/simple_animal/hostile/flood/combat_form/prisoner,/mob/living/simple_animal/hostile/flood/combat_form/prisoner/mutated,/mob/living/simple_animal/hostile/flood/combat_form/prisoner/mutated/guard,/mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew,/mob/living/simple_animal/hostile/flood/combat_form/prisoner/guard)
#define TOOL_LOOT_BASE list(/obj/item/weapon/crowbar/red,/obj/item/weapon/weldingtool/mini,/obj/item/weapon/screwdriver,/obj/item/device/multitool)
#define TRAP_LOOT_BASE list(/obj/item/device/landmine/emp/active/low_range,/obj/item/device/landmine/gas/active/low_range,/obj/item/device/landmine/flash/active/low_range,/obj/item/weapon/beartrap/deployed)
#define MELEE_LOOT_BASE list(/obj/item/weapon/material/knife/combat_knife,/obj/item/weapon/material/hatchet/achlys,/obj/item/weapon/scalpel/achlys,/obj/item/device/flashlight/maglight,/obj/item/weapon/material/butterfly)
#define MED_LOOT_BASE list(/obj/item/stack/medical/bruise_pack,/obj/item/stack/medical/ointment,/obj/item/stack/medical/splint/ghetto,/obj/item/weapon/storage/pill_bottle/dylovene)

//Loot Markers//
/obj/effect/loot_marker/potential_evidence
	loot_type = "evidence"

/obj/effect/loot_marker/potential_autolathe
	loot_type = "autolathes"

/obj/effect/loot_marker/wander_flood
	loot_type = "achlysWanderFlood"

/obj/effect/loot_marker/potential_tool
	loot_type = "achlysTools"

/obj/effect/loot_marker/potential_covgear
	loot_type = "achlysCovgear"

/obj/effect/loot_marker/potential_traps
	loot_type = "achlysTraps"

/obj/effect/loot_marker/potential_melee
	loot_type = "achlysMelee"

/obj/effect/loot_marker/potential_lowgrademeds
	loot_type = "achylsMeds"

/obj/effect/overmap/sector/achlys/New()
	. = ..()
	loot_distributor.loot_list["evidence"] = list(/obj/item/weapon/research/sekrits,/obj/item/weapon/research,/obj/item/weapon/research,/obj/item/weapon/research)
	loot_distributor.loot_list["autolathes"] = list(/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked)
	loot_distributor.loot_list["achlysCovgear"] = COVGEAR_LOOT
	var/CurrLootList = list()
	for(var/type in WANDERFLOOD_LOOT_BASE)
		var/num = rand(ACHLYS_LOOT_RANDMIN,ACHLYS_LOOT_RANDMAX)
		for(var/n = 1 to num)
			CurrLootList += type
	loot_distributor.loot_list["achlysWanderFlood"] = CurrLootList
	CurrLootList = list()
	for(var/type in TOOL_LOOT_BASE)
		var/num = rand(ACHLYS_LOOT_RANDMIN,ACHLYS_LOOT_RANDMAX)
		for(var/n = 1 to num)
			CurrLootList += type
	loot_distributor.loot_list["achlysTools"] = CurrLootList
	CurrLootList = list()
	for(var/type in TRAP_LOOT_BASE)
		var/num = rand(ACHLYS_LOOT_RANDMIN,ACHLYS_LOOT_RANDMAX)
		for(var/n = 1 to num)
			CurrLootList += type
	loot_distributor.loot_list["achlysTraps"] = CurrLootList
	CurrLootList = list()
	for(var/type in MELEE_LOOT_BASE)
		var/num = rand(ACHLYS_LOOT_RANDMIN,ACHLYS_LOOT_RANDMAX)
		for(var/n = 1 to num)
			CurrLootList += type
	loot_distributor.loot_list["achlysMelee"] = CurrLootList
	CurrLootList = list()
	for(var/type in MED_LOOT_BASE)
		var/num = rand(ACHLYS_LOOT_RANDMIN,ACHLYS_LOOT_RANDMAX)
		for(var/n = 1 to num)
			CurrLootList += type
	loot_distributor.loot_list["achylsMeds"] = CurrLootList