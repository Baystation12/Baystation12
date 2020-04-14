
/datum/npc_quest
	var/defender_amount = 1
	var/mob/living/vip_mob
	var/list/living_defenders = list()
	var/list/dead_defenders = list()
	var/list/defender_types = list()
	var/list/spawn_turfs = list()

/datum/npc_quest/proc/spawn_defender(var/defender_type, var/turf/spawn_turf)
	if(!defender_types.len)
		var/error_msg = "QUEST ERROR: Attempted to spawn defenders for [faction.name] against [enemy_faction] on [map_path] but there are no valid types!"
		message_admins(error_msg)
		return
	defender_type = pickweight(defender_types)

	if(!spawn_turf)
		if(!spawn_turfs.len)
			var/error_msg = "QUEST ERROR: Attempted to spawn defenders for [faction.name] against [enemy_faction] on [map_path] but there are no valid spawnpoints!"
			message_admins(error_msg)
			return
		spawn_turf = pick(spawn_turfs)

	var/mob/living/M = new defender_type(spawn_turf)
	M.name = "[enemy_faction] operative"
	M.faction = enemy_faction
	living_defenders += M
	return M

/datum/npc_quest/proc/spawn_initial_defenders(var/list/defender_turfs, var/difficulty = 1)	//difficulty is from 0 to 1
	spawn_turfs = defender_turfs
	defender_amount = round(difficulty * 10)
	if(defender_amount > spawn_turfs.len)
		num_respawns = defender_amount - spawn_turfs.len
		defender_amount = spawn_turfs.len
	defender_amount = max(defender_amount, 3)
	for(var/i=0,i<defender_amount,i++)
		spawn_defender()

	//spawn a special leader mob
	if(quest_type == OBJ_ASSASSINATE)
		var/obj/effect/landmark/instance_boss/B = locate() in world
		vip_mob = spawn_defender(/mob/living/simple_animal/hostile/syndicate/ranged/instance_boss, B.loc)
		vip_mob.name = "[enemy_faction] Commander"
		vip_mob.faction = enemy_faction

/mob/living/simple_animal/hostile/syndicate/ranged/instance_boss
	name = "Boss"
	icon = 'instance_boss.dmi'
	maxHealth = 500
	health = 500
	ranged = 1
	burst_size = 3
	icon_state = "russian_mob"
	icon_living = "russian_mob"
	icon_dead = "russian_mob_dead"
	casingtype = /obj/item/ammo_casing/a10mm
	projectilesound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol/medium
