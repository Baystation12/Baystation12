#define NEEDLER_EMBED_PROB 33

 // need icons for all projectiles and magazines
/obj/item/projectile/bullet/covenant
	name = "Plasma Bolt"
	desc = "A searing hot bolt of plasma."
	check_armour = "energy"
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/covenant/attack_mob()
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

/obj/item/projectile/bullet/covenant/plasmapistol
	damage = 45
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Plasmapistol Shot"

/obj/item/projectile/bullet/covenant/plasmapistol/overcharge
	damage = 60
	icon_state = "Overcharged_Plasmapistol shot"

/obj/item/projectile/bullet/covenant/plasmapistol/overcharge/on_impact(var/atom/impacted)
	..()
	empulse(impacted.loc,0,1)

/obj/item/projectile/bullet/covenant/plasmarifle
	damage = 35 // more damage than MA5B.
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Plasmarifle Shot"

/obj/item/projectile/bullet/covenant/plasmarepeater
	damage = 30 //The repeater does enough, thank you.
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Plasmarifle Shot"

/obj/item/projectile/bullet/covenant/plasmarifle/brute
	damage = 30
	icon_state = "heavy_plas_cannon"

/obj/item/projectile/bullet/covenant/beamrifle
	name = "energy beam"
	desc = ""
	damage = 55
	armor_penetration = 65
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_casing"
	step_delay = 0
	tracer_type = /obj/effect/projectile/beam_rifle
	tracer_delay_time = 1.25 SECONDS
	penetrating = 2
	invisibility = 101

/obj/item/projectile/bullet/covenant/beamrifle/attack_mob(var/mob/living/carbon/human/L)
	if(!istype(L))
		. = ..()
		return
	L.radiation += 10
	. = ..()

/obj/effect/projectile/beam_rifle
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "beam_rifle_trail"

//Covenant Magazine-Fed defines//

/obj/item/ammo_magazine/needles
	name = "Needles"
	desc = "A small pack of crystalline needles."
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
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
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "needle"

/obj/item/projectile/bullet/covenant/needles
	name = "Needle"
	desc = "A sharp, pink crystalline shard"
	damage = 20 // Low damage, special effect would do the most damage.
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Needler Shot"
	embed = 1
	sharp = 1
	armor_penetration = 20
	var/shards_to_explode = 6
	var/shard_name = "Needle shrapnel"
	var/mob/locked_target

/obj/item/projectile/bullet/covenant/needles/on_hit(var/mob/living/carbon/human/L, var/blocked, var/def_zone )
	if(!istype(L))
		. = ..()
		return
	var/list/embedded_shards[0]
	for(var/obj/shard in L.contents )
		if(!istype(shard,/obj/item/weapon/material/shard))
			continue
		if (shard.name == shard_name)
			embedded_shards += shard
		if(embedded_shards.len >=shards_to_explode)
			explosion(L.loc,-1,1,2,5)
			for(var/I in embedded_shards)
				qdel(I)
	if(prob(NEEDLER_EMBED_PROB)) //Most of the weapon's damage comes from embedding. This is here to make it more common.
		var/obj/shard = new /obj/item/weapon/material/shard/shrapnel
		var/obj/item/organ/external/embed_organ = pick(L.organs)
		shard.name = shard_name
		embed_organ.embed(shard)
	. = ..()

/obj/item/projectile/bullet/covenant/needles/launch_from_gun(var/atom/target)
	if(ismob(target))
		locked_target = target //Setting target directly if we've clicked on them.
	if(isturf(target))
		for(var/mob/M in target.contents)//Otherwise search the contents of the clicked turf, and take the first mob we find as a target.
			locked_target = M
			break
	. = ..()

/obj/item/projectile/bullet/covenant/needles/attack_mob()
	. = ..()
	locked_target = null //No more homing if we miss.

/obj/item/projectile/bullet/covenant/needles/Move()
	. = ..()
	if(kill_count % 2 == 0)
		return
	if(locked_target)
		redirect(locked_target, loc)
		dir = get_dir(loc,locked_target)

/obj/item/ammo_magazine/type51mag
	name = "Type-51 Carbine magazine"
	desc = "A magazine containing 18 rounds for the Type-51 Carbine."
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
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
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_casing"

/obj/item/projectile/bullet/covenant/type51carbine
	name = "Glowing Projectile"
	desc = "This projectile leaves a green trail in its wake."
	damage = 40
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_casing"
	check_armour = "energy"
	tracer_type = /obj/effect/projectile/type51carbine
	tracer_delay_time = 1.5 SECONDS
	invisibility = 101
	embed = 1
	sharp = 1

/obj/item/projectile/bullet/covenant/type51carbine/attack_mob(var/mob/living/carbon/human/L)
	if(!istype(L))
		. = ..()
		return
	L.radiation += 7
	. = ..()

/obj/effect/projectile/type51carbine
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_trail"

/obj/item/ammo_magazine/rifleneedlepack
	name = "Rifle Needles"
	desc = "A pack of fewer, larger crystalline needles. For T-31 rifle."
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
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
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "needle"

#define RIFLENEEDLE_TRACK_DIST 2

/obj/item/projectile/bullet/covenant/needles/rifleneedle
	name = "Rifle Needle"
	damage = 30
	shards_to_explode = 3
	shard_name = "Rifle Needle shrapnel"
	tracer_type = /obj/effect/projectile/bullet/covenant/needles/rifleneedle
	tracer_delay_time = 0.5 SECONDS
	invisibility = 101
	armor_penetration = 20

/obj/item/projectile/bullet/covenant/needles/rifleneedle/Move()
	if(kill_count - initial(kill_count) > RIFLENEEDLE_TRACK_DIST)
		locked_target = null
	. = ..()

/obj/effect/projectile/bullet/covenant/needles/rifleneedle
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "needlerifle_trail"

#undef RIFLENEEDLE_TRACK_DIST
#define FUEL_ROD_IRRADIATE_RANGE 2
#define FUEL_ROD_IRRADIATE_AMOUNT 15

/obj/item/ammo_magazine/fuel_rod
	name = "Type-33 Light Anti-Armor Weapon Magazine"
	desc = "Contains a maximum of 5 fuel rods."
	icon = 'code/modules/halo/icons/fuel_rod_cannon.dmi'
	icon_state = "fuel_rod_magazine"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/fuel_rod
	caliber = "fuel rod"
	max_ammo = 5
	w_class = ITEM_SIZE_NORMAL

/obj/item/ammo_casing/fuel_rod
	icon = 'code/modules/halo/icons/fuel_rod_cannon.dmi'
	icon_state = "fuel_rod_casing"
	caliber = "fuel rod"
	projectile_type = /obj/item/projectile/bullet/fuel_rod

/obj/item/projectile/bullet/fuel_rod
	name = "fuel rod"
	check_armour = "bomb"
	step_delay = 1.2
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Overcharged_Plasmapistol shot"
	embed = 1

/obj/item/projectile/bullet/fuel_rod/on_impact(var/atom/A)
	. = ..()
	explosion(A,-1,1,2,4,guaranteed_damage = 30, guaranteed_damage_range = 2)
	for(var/mob/living/l in range(FUEL_ROD_IRRADIATE_RANGE,loc))
		l.rad_act(FUEL_ROD_IRRADIATE_AMOUNT)

#undef FUEL_ROD_IRRADIATE_RANGE
#undef FUEL_ROD_IRRADIATE_AMOUNT
#undef NEEDLER_EMBED_PROB
