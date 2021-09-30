#define NEEDLER_EMBED_PROB 60
#define NEEDLER_SHARD_DET_TIME 10 SECONDS
#define NEEDLER_SHRAPNEL_AP 50
#define NEEDLER_SUPERCOMBINE_SHRAPNEL_DAMAGE_MULT 3
#define FUEL_ROD_IRRADIATE_RANGE 2
#define FUEL_ROD_IRRADIATE_AMOUNT 10

 // need icons for all projectiles and magazines
/obj/item/projectile/bullet/covenant
	name = "Plasma Bolt"
	desc = "A searing hot bolt of plasma."
	check_armour = "energy"
	embed = 0
	sharp = 0
	muzzle_type = /obj/effect/projectile/muzzle/cov_blue
	var/use_covenant_burndam_override = 1

/obj/item/projectile/bullet/covenant/attack_mob()
	if(use_covenant_burndam_override)
		damage_type = BURN
		damtype = BURN
	return ..()

/obj/item/projectile/bullet/covenant/trainingpistol
	armor_penetration = 0
	nodamage = 1
	agony = 10
	damage_type = PAIN
	penetrating = 0
	icon_state = "Trainingpistol Shot"
	muzzle_type = /obj/effect/projectile/muzzle/cov_green

/obj/item/projectile/bullet/covenant/plasmapistol
	damage = 45
	armor_penetration = 15
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "Plasmapistol Shot"
	muzzle_type = /obj/effect/projectile/muzzle/cov_green

/obj/item/projectile/bullet/covenant/plasmapistol/fastfire
	damage = 20

/obj/item/projectile/bullet/covenant/plasmapistol/overcharge
	damage = 55
	shield_damage = -50 //EMP does most of the work.
	armor_penetration = 20 //Slightly lower AP than the magnum baseline due to slightly higher base damage.
	icon_state = "Overcharged_Plasmapistol shot"

/obj/item/projectile/bullet/covenant/plasmapistol/overcharge/on_impact(var/atom/impacted)
	..()
	empulse(impacted.loc,0,1)

/obj/item/projectile/bullet/covenant/plasmapistol/overcharge/fastfire
	damage = 30

/obj/item/projectile/bullet/covenant/plasmarifle
	damage = 30
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "Plasmarifle Shot"

/obj/item/projectile/bullet/covenant/plasmarepeater
	damage = 30
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "plasma_repeater"
	muzzle_type = /obj/effect/projectile/muzzle/cov_cyan

/obj/item/projectile/bullet/covenant/plasmarifle/brute
	damage = 25
	icon_state = "heavy_plas_cannon"
	muzzle_type = /obj/effect/projectile/muzzle/cov_red

/obj/item/projectile/bullet/covenant/beamrifle
	name = "energy beam"
	desc = ""
	damage = 55
	armor_penetration = 60
	penetrating = 1
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "beam_rifle_trail"
	tracer_type = /obj/effect/projectile/beam_rifle
	tracer_delay_time = 1.5 SECONDS
	shield_damage = 210
	step_delay = 0
	muzzle_type = /obj/effect/projectile/muzzle/cov_cyan

/obj/item/projectile/bullet/covenant/beamrifle/attack_mob(var/mob/living/carbon/human/L)
	if(!istype(L))
		. = ..()
		return
	L.rad_act(3)
	. = ..()

/obj/effect/projectile/beam_rifle
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "beam_rifle_trail"
	alpha = 160

//Covenant Magazine-Fed defines//

/obj/item/ammo_magazine/needles
	name = "Needles"
	desc = "A small pack of crystalline needles."
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "needlerpack"
	max_ammo = 30
	ammo_type = /obj/item/ammo_casing/needles
	caliber = "needler"
	mag_type = MAGAZINE

/obj/item/ammo_casing/needles
	name = "Needle"
	desc = "A small crystalline needle"
	caliber = "needler"
	projectile_type = /obj/item/projectile/bullet/covenant/needles
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "needle"

/obj/item/weapon/material/shard/shrapnel/needleshrap
	var/die_at = 0
	var/our_dam = 0

/obj/item/weapon/material/shard/shrapnel/needleshrap/process()
	if(world.time >= die_at)
		var/mob/living/m = loc
		if(istype(m))
			m.apply_damage(our_dam, BURN, null, m.run_armor_check(null, "energy", NEEDLER_SHRAPNEL_AP))
			m.embedded -= src
			m.pinned -= src
			if(m.pinned.len == 0)
				m.anchored = 0
			m.contents -= src
			forceMove(get_turf(m))//And placing it on the ground below
		qdel(src)
		return

/obj/item/projectile/bullet/covenant/needles
	name = "Needle"
	desc = "A sharp, pink crystalline shard"
	damage = 25 // Low damage, special effect would do the most damage.
	shield_damage = 20
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "Needler Shot"
	embed = 1
	sharp = 1
	var/max_track_steps = 5
	var/shards_to_explode = 6
	var/shard_name = "Needle shrapnel"
	var/mob/locked_target
	var/shrapnel_damage = 5
	use_covenant_burndam_override = 0
	muzzle_type = /obj/effect/projectile/muzzle/cov_red

/obj/item/projectile/bullet/covenant/needles/on_hit(var/mob/living/carbon/human/L, var/blocked, var/def_zone )
	if(!istype(L))
		. = ..()
		return
	var/list/embedded_shards = list()
	for(var/obj/shard in L.embedded)
		if(shard.name == shard_name)
			embedded_shards += shard
		if(embedded_shards.len >=shards_to_explode)
			explosion(get_turf(L),-1,-1,2,5,guaranteed_damage = 35,guaranteed_damage_range = 1)
			for(var/obj/I in embedded_shards)
				var/obj/item/weapon/material/shard/shrapnel/needleshrap/needle = I
				if(istype(needle))
					needle.our_dam *= NEEDLER_SUPERCOMBINE_SHRAPNEL_DAMAGE_MULT
					needle.die_at = 0
					needle.process()
				else
					L.embedded -= I
					L.pinned -= I
					if(L.pinned.len == 0)
						L.anchored = 0
					L.contents -= I
					I.forceMove(get_turf(L))//And placing it on the ground below
					qdel(I)
	if(prob(NEEDLER_EMBED_PROB)) //Most of the weapon's damage comes from embedding. This is here to make it more common.
		var/obj/item/weapon/material/shard/shrapnel/needleshrap/shard = new
		shard.name = shard_name
		shard.die_at = world.time + NEEDLER_SHARD_DET_TIME
		GLOB.processing_objects += shard
		shard.our_dam = shrapnel_damage
		//We're doing some speshul things here with out embed, so let's not do the usual damage.
		L.contents += shard
		L.embedded += shard
		visible_message("<span class = 'warning'>[src] embeds into [L]</span>")
	. = ..()

/obj/item/projectile/bullet/covenant/needles/launch_from_gun(var/atom/target)
	if(ismob(target))
		locked_target = target //Setting target directly if we've clicked on them.
	if(isturf(target))
		for(var/mob/living/M in target.contents)//Otherwise search the contents of the clicked turf, and take the first mob we find as a target.
			locked_target = M
			break
	. = ..()

/obj/item/projectile/bullet/covenant/needles/attack_mob()
	. = ..()
	locked_target = null //No more homing if we miss.

/obj/item/projectile/bullet/covenant/needles/Move()
	. = ..()
	if(locked_target)
		redirect(locked_target, starting)
		dir = get_dir(loc,locked_target)
	if(initial(kill_count) - kill_count >= max_track_steps)
		locked_target = null

/obj/item/ammo_magazine/type51mag
	name = "Type-51 Carbine magazine"
	desc = "A magazine containing 18 rounds for the Type-51 Carbine."
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_magazine"
	max_ammo = 18
	ammo_type = /obj/item/ammo_casing/type51carbine
	caliber = "cov_carbine"
	mag_type = MAGAZINE

/obj/item/ammo_casing/type51carbine
	name = "Type-51 Carbine round"
	desc = "A faintly glowing round that leaves a green trail in its wake."
	caliber = "cov_carbine"
	projectile_type = /obj/item/projectile/bullet/covenant/type51carbine
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_casing"

/obj/item/projectile/bullet/covenant/type51carbine
	name = "Glowing Projectile"
	desc = "This projectile leaves a green trail in its wake."
	damage = 25 //A lot less rounds in a mag than the counterpart BR.
	shield_damage = 10
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_casing"
	check_armour = "energy"
	tracer_type = /obj/effect/projectile/type51carbine
	tracer_delay_time = 1.5 SECONDS
	invisibility = 61
	embed = 1
	sharp = 1
	use_covenant_burndam_override = 0
	muzzle_type = /obj/effect/projectile/muzzle/cov_green
	steps_between_delays = 3

/obj/item/projectile/bullet/covenant/type51carbine/attack_mob(var/mob/living/carbon/human/L)
	if(!istype(L))
		. = ..()
		return
	L.rad_act(1)
	. = ..()

/obj/effect/projectile/type51carbine
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_trail"
	alpha = 160

/obj/item/ammo_magazine/rifleneedlepack
	name = "Rifle Needles"
	desc = "A pack of fewer, larger crystalline needles. For T-31 rifle."
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "needlerpack"
	max_ammo = 21
	ammo_type = /obj/item/ammo_casing/rifleneedle
	caliber = "needle_rifle"
	mag_type = MAGAZINE

/obj/item/ammo_casing/rifleneedle
	name = "Rifle Needle"
	desc = "A large crystalline needle"
	caliber = "needle_rifle"
	projectile_type = /obj/item/projectile/bullet/covenant/needles/rifleneedle
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "needle"

/obj/item/projectile/bullet/covenant/needles/rifleneedle
	name = "Rifle Needle"
	damage = 35
	armor_penetration = 40
	shield_damage = 5
	shrapnel_damage = 10
	shards_to_explode = 3
	shard_name = "Rifle Needle shrapnel"
	tracer_type = /obj/effect/projectile/bullet/covenant/needles/rifleneedle
	tracer_delay_time = 0.5 SECONDS
	invisibility = 101
	max_track_steps = 2
	muzzle_type = /obj/effect/projectile/muzzle/cov_red
	steps_between_delays = 3

/obj/effect/projectile/bullet/covenant/needles/rifleneedle
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "needlerifle_trail"
	alpha = 160

/obj/item/ammo_magazine/fuel_rod
	name = "Type-33 Light Anti-Armor Weapon Magazine"
	desc = "Contains a maximum of 5 fuel rods."
	icon = 'code/modules/halo/weapons/icons/fuel_rod_cannon.dmi'
	icon_state = "fuel_rod_mag"
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BELT | SLOT_POCKET
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/fuel_rod
	caliber = "fuel rod"
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_casing/fuel_rod
	icon = 'code/modules/halo/weapons/icons/fuel_rod_cannon.dmi'
	icon_state = "fuel_rod_casing"
	caliber = "fuel rod"
	projectile_type = /obj/item/projectile/bullet/fuel_rod

/obj/item/projectile/bullet/fuel_rod
	name = "fuel rod"
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "Overcharged_Plasmapistol shot"
	check_armour = "bomb"
	damage_type = "bomb"
	damtype = "bomb"
	step_delay = 1.3
	kill_count = 21
	shield_damage = 100
	damage = 50
	armor_penetration = 50
	muzzle_type = /obj/effect/projectile/muzzle/cov_green

/obj/item/projectile/bullet/fuel_rod/throw_impact(atom/hit_atom)
	return on_impact(hit_atom)

/obj/item/projectile/bullet/fuel_rod/on_impact(var/atom/A)
	new /obj/effect/plasma_explosion/green(get_turf(src))
	explosion(get_turf(A),-1,1,2,4,guaranteed_damage = 30, guaranteed_damage_range = 2)
	for(var/mob/living/l in range(FUEL_ROD_IRRADIATE_RANGE,loc))
		l.rad_act(FUEL_ROD_IRRADIATE_AMOUNT)
	. = ..()
	qdel(src)

/obj/item/ammo_magazine/concussion_rifle
	name = "Type-50 Directed Energy Rifle / Heavy Magazine"
	desc = "Contains a maximum of 6 shots."
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "concussion_mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/concussion_rifle
	caliber = "plasConcRifle"
	max_ammo = 6

/obj/item/ammo_casing/concussion_rifle
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "concussion_casing"
	caliber = "plasConcRifle"
	projectile_type = /obj/item/projectile/bullet/covenant/concussion_rifle

/obj/item/projectile/bullet/covenant/concussion_rifle
	name = "heavy plasma round"
	damage = 35
	armor_penetration = 30
	shield_damage = 50
	step_delay = 0.75 //slower than most
	icon = 'code/modules/halo/weapons/icons/Covenant_Projectiles.dmi'
	icon_state = "pulse0"
	muzzle_type = /obj/effect/projectile/muzzle/cov_red

/obj/item/projectile/bullet/covenant/concussion_rifle/launch(atom/target, var/target_zone, var/x_offset=0, var/y_offset=0, var/angle_offset=0)
	. = ..()
	kill_count = get_dist(loc,target)

/obj/item/projectile/bullet/covenant/concussion_rifle/on_impact(var/atom/A)
	playsound(A, 'code/modules/halo/sounds/conc_rifle_explode.ogg', 100, 1)
	for(var/atom/movable/m in range(1,A))
		if(m.anchored)
			continue
		if(istype(m,/obj/effect))
			continue
		var/turf/lastloc = loc
		var/dir_move = get_dir(loc,m)
		if(A.loc == m.loc || loc == m.loc)
			var/list/cardinals_pickfrom = GLOB.cardinal
			if(starting)
				var/dir_to_start = get_dir(loc,starting)
				cardinals_pickfrom -= list(dir_to_start,turn(45,dir_to_start),turn(-45,dir_to_start))
			dir_move = pick(cardinals_pickfrom)
		if(dir_move in GLOB.cardinal)
			lastloc = get_edge_target_turf(m, dir_move)
		else
			for(var/i = 0 to world.view - 2)
				var/turf/newloc = get_step(lastloc,dir_move)
				if(newloc.density == 1)
					break
				lastloc = newloc
		spawn()
			m.throw_at(lastloc,3,1,firer)
	. = ..()
	qdel(src)

/obj/item/ammo_magazine/concussion_rifle/jumper_mag
	ammo_type = /obj/item/ammo_casing/concussion_rifle/jumper

/obj/item/ammo_casing/concussion_rifle/jumper
	projectile_type = /obj/item/projectile/bullet/covenant/concussion_rifle/jumper

/obj/item/projectile/bullet/covenant/concussion_rifle/jumper
	damage = 0
	armor_penetration = 0
	shield_damage = 0

#undef FUEL_ROD_IRRADIATE_RANGE
#undef FUEL_ROD_IRRADIATE_AMOUNT
#undef FUEL_ROD_MAX_OVERSHOOT
#undef NEEDLER_EMBED_PROB
#undef NEEDLER_SHRAPNEL_AP
#undef NEEDLER_SHARD_DET_TIME
