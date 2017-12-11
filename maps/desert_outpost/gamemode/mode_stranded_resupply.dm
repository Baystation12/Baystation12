
/obj/effect/landmark/scavenge_spawn
	name = "resupply spawn marker"
	icon_state = "x3"
	invisibility = 0

/datum/game_mode/stranded/proc/process_resupply()
	if(world.time > time_next_resupply)
		time_next_resupply = world.time + interval_resupply

		var/turf/center_turf = locate(world.maxx/2, world.maxy/2, 1)
		var/obj/effect/landmark/scavenge_spawn/S = pick(available_resupply_points)
		available_resupply_points -= S
		var/turf/drop_turf = get_turf(S)
		var/dir_text = "<span class='em'>[dir2text(get_dir(center_turf, S))]</span> of your base"

		//work out what message
		var/pilot_message
		var/impact_text
		if(prob(50))
			pilot_message = "A clump of debris from your ship has crashed down to the [dir_text]. See if you can salvage it for resources."
			impact_text = "a massive impact"
			spawn(0)
				spawn_ship_debris(drop_turf)
		else
			pilot_message = "Supply run completed, I've dropped off my cargo to the [dir_text]. Good luck!"
			impact_text = "multiple thudding impacts"
			spawn(0)
				spawn_resupply(drop_turf)

		// ripped from proc/explosion() see code/game/objects/exposion.dm
		var/close_range = 14
		var/turf/epicenter = get_turf(S)
		var/frequency = get_rand_frequency()
		for(var/mob/M in GLOB.player_list)
			if(M.z == epicenter.z)
				var/turf/M_turf = get_turf(M)
				var/dist = get_dist(M_turf, epicenter)
				// If inside the blast radius + world.view - 2
				if(dist <= close_range)
					M.playsound_local(epicenter, get_sfx("explosion"), 100, 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound
					to_chat(M, "<span class='warning'>You hear [impact_text] to the [dir2text(get_dir(M, S))].</span>")
				else
					var/far_volume = Clamp(world.maxx, 30, 50) // Volume is based on explosion size and dist
					far_volume += (dist <= world.maxx * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
					M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', far_volume, 1, frequency, falloff = 5)

		//tell the players
		to_world("\
			<span class='radio'>\
				<span class='name'>GA-TL1 Longsword Pilot</span> \
				<b>\[UNSC Emergency Freq\]</b> \
				<span class='message'>\"[pilot_message]\"</span>\
			</span>")

		qdel(S)

var/list/supply_crate_procs = list(\
	/datum/game_mode/stranded/proc/spawn_gun_crate,\
	/datum/game_mode/stranded/proc/spawn_heavygun_crate,\
	/datum/game_mode/stranded/proc/spawn_sniper_crate,\
	/datum/game_mode/stranded/proc/spawn_armour_crate,\
	/datum/game_mode/stranded/proc/spawn_medic_crate,\
	/datum/game_mode/stranded/proc/spawn_turret_crate,\
	/datum/game_mode/stranded/proc/spawn_misc_crate,\
	/datum/game_mode/stranded/proc/spawn_material_crate)

/obj/structure/closet/crate/verb/call_all_spawns()
	while(supply_crate_procs.len)
		var/chosen_proc = pick(supply_crate_procs)
		supply_crate_procs -= chosen_proc
		call(src, chosen_proc)(get_turf(usr))

var/debris_structures = list(\
	/obj/structure/girder,\
	/obj/structure/girder/displaced,\
	/obj/structure/grille,\
	/obj/structure/grille/broken,\
	/obj/structure/foamedmetal,\
	/obj/structure/lattice,\
	/obj/structure/barrel)

var/debris_objs = list(\
	/obj/item/stack/material/steel/ten,\
	/obj/item/stack/rods,\
	/obj/item/stack/material/steel/ten,\
	/obj/item/stack/rods,\
	/obj/item/stack/material/steel/ten,\
	/obj/item/stack/rods,\
	/obj/item/stack/cable_coil/random,\
	/obj/item/weapon/weldingtool,\
	/obj/item/weapon/wrench)

/datum/game_mode/stranded/proc/spawn_ship_debris(var/turf/epicentre)
	var/max_dist = 10
	for(var/turf/spawn_turf in range(max_dist, epicentre))
		//closer to the center has more goodies
		var/spawn_chance = 100 * (max_dist - (get_dist(epicentre, spawn_turf)))
		spawn_chance = Clamp(spawn_chance, 0, 100)
		if(prob(spawn_chance))
			//low chance to spawn a useful supply crate
			if(prob(2))
				var/chosen_proc = pick(supply_crate_procs)
				call(src, chosen_proc)(spawn_turf)
			else
				//spawn some random crap
				var/spawn_type = pick(debris_structures + debris_objs)
				new spawn_type(spawn_turf)
				if(prob(10))
					spawn_type = pick(debris_objs)
					new spawn_type(spawn_turf)

/datum/game_mode/stranded/proc/spawn_resupply(var/turf/epicentre)
	var/num_crates = rand(3,5)
	var/failed_attempts = 0
	spawn_gun_crate(epicentre)
	while(num_crates > 0)
		var/turf/spawn_turf = pick(range(5, epicentre))

		//make sure we dont double up turfs
		if(locate(/obj/structure/closet/crate) in spawn_turf)
			failed_attempts++
			if(failed_attempts > 10)
				break
			continue

		//spawn a crate
		var/chosen_proc = pick(supply_crate_procs)
		call(src, chosen_proc)(spawn_turf)
		//supply_crate_procs -= chosen_proc
		num_crates -= 1

/datum/game_mode/stranded/proc/spawn_gun_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/C = new(spawn_turf)
	C.name = "weapons crate"
	C.icon_state = "weaponcrate"
	C.icon_opened = "weaponcrateopen"
	C.icon_closed = "weaponcrate"

	var/list/random_weapons = list(/obj/item/weapon/gun/projectile/m6d_magnum = /obj/item/ammo_magazine/m127_saphe,\
		/obj/item/weapon/gun/projectile/ma5b_ar = /obj/item/ammo_magazine/m762_ap,\
		/obj/item/weapon/gun/projectile/m7_smg = /obj/item/ammo_magazine/m5,\
		/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = /obj/item/weapon/storage/box/shotgunshells)

	for(var/i=0,i<3,i++)
		var/picked_weapon = pick(random_weapons)
		new picked_weapon(C)
		var/picked_ammo = random_weapons[picked_weapon]
		new picked_ammo(C)
		new picked_ammo(C)

/datum/game_mode/stranded/proc/spawn_heavygun_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/C = new(spawn_turf)
	C.name = "heavy weapons crate"
	C.icon_state = "weaponcrate"
	C.icon_opened = "weaponcrateopen"
	C.icon_closed = "weaponcrate"

	var/list/random_weapons = list(
		/obj/item/weapon/gun/projectile/br85 = /obj/item/ammo_magazine/m95_sap,\
		/obj/item/weapon/gun/projectile/m392_dmr = /obj/item/ammo_magazine/m762_ap,\
		/obj/item/weapon/gun/projectile/m739_lmg = /obj/item/ammo_magazine/a762_box_ap)

	for(var/i=0,i<2,i++)
		var/picked_weapon = pick(random_weapons)
		new picked_weapon(C)
		var/picked_ammo = random_weapons[picked_weapon]
		new picked_ammo(C)
		new picked_ammo(C)

/datum/game_mode/stranded/proc/spawn_sniper_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/C = new(spawn_turf)
	C.name = "marksman crate"
	C.icon_state = "weaponcrate"
	C.icon_opened = "weaponcrateopen"
	C.icon_closed = "weaponcrate"

	new /obj/item/weapon/gun/projectile/srs99_sniper(C)
	new /obj/item/ammo_magazine/m145_ap(C)
	new /obj/item/ammo_magazine/m145_ap(C)

/datum/game_mode/stranded/proc/spawn_armour_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/C = new(spawn_turf)
	C.name = "armour crate"
	C.icon_state = "hydrocrate"
	C.icon_opened = "hydrocrateopen"
	C.icon_closed = "hydrocrate"

	if(prob(50))
		new /obj/item/clothing/head/helmet/marine(C)
	else
		new /obj/item/clothing/head/helmet/marine/visor(C)

	new /obj/item/clothing/suit/armor/marine(C)

	if(prob(50))
		var/obj/item/weapon/storage/belt/B = new /obj/item/weapon/storage/belt/marine_ammo(C)
		new /obj/item/weapon/gun/projectile/m6d_magnum(B)
		new /obj/item/ammo_magazine/m127_saphe(B)
		new /obj/item/ammo_magazine/m127_saphe(B)
	else
		var/obj/item/weapon/storage/belt/B = new /obj/item/weapon/storage/belt/marine_medic(C)
		new /obj/item/weapon/storage/firstaid/unsc(B)

/datum/game_mode/stranded/proc/spawn_turret_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/C = new(spawn_turf)
	C.name = "turret crate"
	C.icon_state = "secgearcrate"
	C.icon_opened = "secgearcrateopen"
	C.icon_closed = "secgearcrate"

	if(prob(50))
		new /obj/item/turret_deploy_kit/HMG(C)
	else
		new /obj/item/turret_deploy_kit/chaingun(C)

/datum/game_mode/stranded/proc/spawn_medic_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/C = new(spawn_turf)
	C.name = "medical crate"
	C.icon_state = "medicalcrate"
	C.icon_opened = "medicalcrateopen"
	C.icon_closed = "medicalcrate"

	new /obj/item/weapon/storage/firstaid/unsc(C)
	new /obj/item/weapon/storage/firstaid/unsc(C)
	new /obj/item/weapon/storage/firstaid/unsc(C)
	new /obj/item/weapon/storage/firstaid/unsc(C)

	new /obj/item/weapon/storage/firstaid/surgery(C)
	new /obj/item/weapon/storage/firstaid/surgery(C)

/datum/game_mode/stranded/proc/spawn_misc_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/C = new(spawn_turf)
	new /obj/item/weapon/melee/combat_knife(C)
	new /obj/item/weapon/melee/combat_knife(C)

	new /obj/item/device/flashlight/flare(C)
	new /obj/item/device/flashlight/flare(C)
	new /obj/item/device/flashlight/flare(C)
	new /obj/item/device/flashlight(C)

	new /obj/item/weapon/storage/box/m9_frag(C)

/datum/game_mode/stranded/proc/spawn_tool_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/C = new(spawn_turf)
	C.name = "tool crate"
	C.icon_state = "phoroncrate"
	C.icon_opened = "phoroncrateopen"
	C.icon_closed = "phoroncrate"

	new /obj/item/weapon/storage/toolbox/mechanical(C)
	new /obj/item/weapon/storage/toolbox/mechanical(C)
	new /obj/item/weapon/material/hatchet(C)
	new /obj/item/weapon/shovel(C)
	new /obj/item/weapon/storage/belt/utility/full(C)
	new /obj/item/weapon/storage/belt/utility/full(C)

/datum/game_mode/stranded/proc/spawn_material_crate(var/turf/spawn_turf)
	var/obj/structure/closet/crate/C = new(spawn_turf)
	C.name = "sheet materials crate"
	C.icon_state = "largemetal"
	C.icon_opened = "largemetalopen"
	C.icon_closed = "largemetal"

	new /obj/item/stack/material/cloth(C, 50)
	new /obj/item/stack/material/cloth(C, 50)
	new /obj/item/stack/material/wood(C, 50)
	new /obj/item/stack/material/steel(C, 50)
	new /obj/item/stack/material/steel(C, 50)
	new /obj/item/stack/material/steel(C, 50)
