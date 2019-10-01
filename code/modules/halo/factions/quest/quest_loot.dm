
/datum/npc_quest
	var/list/spawn_types
	var/loot_type
	var/list/target_items = list()

/datum/npc_quest/proc/spawn_loot(var/list/loot_turfs)

	//only spawn loot for steal quests
	if(quest_type != OBJ_STEAL)
		return

	switch(loot_type)
		if("coins")
			spawn_types = list(\
				/obj/item/weapon/coin,\
				/obj/item/weapon/coin/gold,\
				/obj/item/weapon/coin/silver,\
				/obj/item/weapon/coin/diamond,\
				/obj/item/weapon/coin/phoron,\
				/obj/item/weapon/coin/uranium,\
				/obj/item/weapon/coin/platinum,\
				/obj/item/weapon/coin/iron)
		if("weapons")
			spawn_types = list(\
				/obj/item/weapon/gun/projectile/automatic/machine_pistol,\
				/obj/item/weapon/gun/projectile/shotgun/pump,\
				/obj/item/weapon/gun/projectile/shotgun/pump/combat,\
				/obj/item/weapon/gun/projectile/shotgun/doublebarrel,\
				/obj/item/weapon/gun/projectile/colt,\
				/obj/item/weapon/gun/projectile/magnum_pistol,\
				/obj/item/weapon/gun/projectile/revolver,\
				/obj/item/weapon/gun/projectile/pistol,\
				/obj/item/weapon/gun/projectile/heavysniper,\
				/obj/item/weapon/gun/projectile/automatic/c20r,\
				/obj/item/weapon/gun/projectile/automatic/sts35,\
				/obj/item/weapon/gun/projectile/automatic/wt550,\
				/obj/item/weapon/gun/projectile/automatic/z8,\
				/obj/item/weapon/gun/projectile/automatic/l6_saw)
		if("armour")
			spawn_types = list(pick(\
				/obj/item/clothing/suit/armor/riot,\
				/obj/item/clothing/suit/armor/bulletproof,\
				/obj/item/clothing/suit/armor/bulletproof/vest,\
				/obj/item/clothing/suit/armor/vest,\
				/obj/item/clothing/suit/armor/vest/press))

	var/loot_amount = round(loot_turfs.len * difficulty)
	for(var/i=0,i<loot_amount,i++)
		var/turf/T = pick(loot_turfs)
		loot_turfs -= T
		var/spawn_type = pick(spawn_types)
		new spawn_type(T)
