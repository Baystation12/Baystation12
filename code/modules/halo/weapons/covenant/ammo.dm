 // need icons for all projectiles and magazines
/obj/item/projectile/covenant
	name = "Plasma Bolt"
	desc = "A searing hot bolt of plasma."

/obj/item/projectile/covenant/plasmapistol
	damage = 25
	accuracy = -1
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
	damage = 15 // Low damage, special effect would do the most damage.
	accuracy = 0
	icon = 'code/modules/halo/icons/Covenant_Projectiles.dmi'
	icon_state = "Needler Shot"
	embed = 1
	sharp = 1

/obj/item/projectile/bullet/covenant/needles/attack_mob(var/mob/living/carbon/human/L)
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
	if(prob(20)) //Most of the weapon's damage comes from embedding. This is here to make it more common.
		var/obj/shard = new /obj/item/weapon/material/shard/shrapnel
		var/obj/item/organ/external/embed_organ = pick(L.organs)
		shard.name = "Needle shrapnel"
		embed_organ.embed(shard)
	..()
