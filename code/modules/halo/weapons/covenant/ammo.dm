 // need icons for all projectiles and magazines
/obj/item/projectile/covenant
	name = "Plasma Bolt"
	desc = "A searing hot bolt of plasma."
	check_armour = "energy"

/obj/item/projectile/covenant/attack_mob()
	damage_type = BURN
	damtype = BURN
	return ..()

/obj/item/projectile/covenant/plasmapistol
	damage = 25
	accuracy = 1
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Plasmapistol Shot"

/obj/item/projectile/covenant/plasmapistol/overcharge
	damage = 75
	icon_state = "Overcharged_Plasmapistol shot"

/obj/item/projectile/covenant/plasmapistol/overcharge/on_impact()
	..()
	empulse(src.loc,1,2)

/obj/item/projectile/covenant/plasmarifle
	damage = 40 // more damage than MA5B.
	accuracy = 1
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Plasmarifle Shot"

/obj/item/projectile/covenant/plasmarifle/brute
	damage = 45
	accuracy = 0.5
	icon_state = "heavy_plas_cannon"

/obj/item/projectile/covenant/beamrifle
	name = "energy beam"
	desc = ""
	damage = 75
	accuracy = 3
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_casing"
	step_delay = 0.1
	tracer_type = /obj/effect/projectile/beam_rifle
	tracer_delay_time = 1 SECOND
	invisibility = 101

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
	accuracy = 1
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Needler Shot"
	embed = 1
	sharp = 1
	var/mob/locked_target

/obj/item/projectile/bullet/covenant/needles/attack_mob(var/mob/living/carbon/human/L)
	if(!istype(L))
		. = ..()
		return
	var/list/embedded_shards[0]
	for(var/obj/shard in L.contents )
		if(!istype(shard,/obj/item/weapon/material/shard))
			continue
		if (shard.name == "Needle shrapnel")
			embedded_shards += shard
		if(embedded_shards.len >5)
			explosion(L.loc,0,1,2,5)
			for(var/I in embedded_shards)
				qdel(I)
	if(prob(30)) //Most of the weapon's damage comes from embedding. This is here to make it more common.
		var/obj/shard = new /obj/item/weapon/material/shard/shrapnel
		var/obj/item/organ/external/embed_organ = pick(L.organs)
		shard.name = "Needle shrapnel"
		embed_organ.embed(shard)
	..()

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

/obj/item/projectile/bullet/covenant/needles/before_move()
	if(locked_target)
		launch(locate(locked_target.x,locked_target.y,locked_target.z))

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
	accuracy = 2
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_casing"
	check_armour = "energy"
	tracer_type = /obj/effect/projectile/type51carbine
	tracer_delay_time = 1.5 SECONDS
	invisibility = 101

/obj/effect/projectile/type51carbine
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "carbine_trail"
