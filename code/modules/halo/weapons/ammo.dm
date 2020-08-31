#define SINGLE_CASING 	1
#define SPEEDLOADER 	2
#define MAGAZINE 		4

//used by: M7 submachine gun
//todo: these are not supposed to eject spent shell casings on firing, so figure out a way to disable that
/obj/item/ammo_magazine/m5
	name = "magazine (5mm) M443 Caseless FMJ"
	desc = "5x23mm M443 Caseless Full Metal Jacket magazine. Fun sized with no pesky casing!"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "m7mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/m5
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "5mm"
	max_ammo = 60
	multiple_sprites = 1

/obj/item/ammo_magazine/m5/rubber
	name = "magazine (5mm) M443 Caseless Rubber"
	desc = "Rubber bullets for riot suppression."
	ammo_type = /obj/item/ammo_casing/m5/rubber

/obj/item/ammo_casing/m5
	desc = "A 5mm bullet casing."
	caliber = "5mm"
	projectile_type = /obj/item/projectile/bullet/m5

/obj/item/ammo_casing/m5/rubber
	desc = "A 5mm bullet casing."
	caliber = "5mm"
	projectile_type = /obj/item/projectile/bullet/m5/rubber

/obj/item/projectile/bullet/m5
	damage = 20
	shield_damage = 20

/obj/item/projectile/bullet/m5/rubber //"rubber" bullets
	name = "rubber bullet"
	check_armour = "melee"
	damage = 5
	shield_damage = 0
	agony = 20
	embed = 0
	sharp = 0


/obj/item/weapon/storage/box/m5
	name = "box of 5mm M443 magazines"
	startswith = list(/obj/item/ammo_magazine/m5 = 7)

//SDSS PROJECTILE
/obj/item/projectile/SDSS_proj
	name = "hard sound wave"
	desc = "It's a wave of sound that's also suprisingly dense."
	step_delay = 0.1
	icon = null //No icon on purpose, it's a sound wave.
	icon_state = ""
	damtype = PAIN
	damage = 40
	//NOTE: Life() calls happen every two seconds, and life() reduces dizziness by one
	var/stun_time = 4 //This is in ticks
	var/suppress_intensity = 8
	var/disorient_time = 6

/obj/item/projectile/SDSS_proj/on_hit(var/mob/living/carbon/human/L, var/blocked = 0, var/def_zone = null)
	. = ..()
	if(!istype(L) || !isliving(L) || isanimal(L))
		return 0

	L.Weaken(stun_time)
	L.confused += disorient_time
	shake_camera(L,disorient_time,2)
	L.overlay_fullscreen("supress",/obj/screen/fullscreen/oxy, suppress_intensity)
	return 1

//M41 rocket launcher
/obj/item/ammo_magazine/spnkr
	name = "M19 SPNKr"
	desc = "A dual tube of M19 102mm HEAT rockets for the M41 SSR."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SPNKr"
	mag_type = MAGAZINE
	slot_flags = SLOT_BELT | SLOT_MASK //Shhh it's a joke
	ammo_type = /obj/item/ammo_casing/spnkr
	caliber = "spnkr"
	max_ammo = 2
	w_class = ITEM_SIZE_HUGE

/obj/item/ammo_casing/spnkr
	caliber = "spnkr"
	projectile_type = /obj/item/projectile/bullet/ssr

/obj/item/projectile/bullet/ssr
	name = "rocket"
	icon_state = "ssr"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	check_armour = "bomb"
	step_delay = 1.2
	shield_damage = 200 //just below elite minor shields, meaning subsequent explosion and guaranteed damage will collapse it.

/obj/item/projectile/bullet/ssr/on_impact(var/atom/target)
	explosion(get_turf(target), 1, 1, 2, 4,guaranteed_damage = 50,guaranteed_damage_range = 2)
	..()

/obj/item/weapon/storage/box/spnkr
	name = "102mm HEAT SPNKr crate"
	desc = "UNSC certified crate containing four tubes of SPNKr rockets for a total of six rockets to be loaded in the M41 SSR."
	icon = 'code/modules/halo/icons/objs/halohumanmisc.dmi'
	icon_state = "ssrcrate"
	max_storage_space = base_storage_capacity(12)
	startswith = list(/obj/item/ammo_magazine/spnkr = 3)
	can_hold = list(/obj/item/ammo_magazine/spnkr)
	slot_flags = SLOT_BACK | SLOT_BELT
	max_w_class = ITEM_SIZE_HUGE

//ACL-55 rocket launcher
/obj/item/ammo_magazine/m26
	name = "M-26 Bottle Rocket"
	desc = "A single tube of M-26 102mm HEAT rockets for the ACL-55."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "m26_exp"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/m26
	caliber = "m26"
	max_ammo = 1
	w_class = ITEM_SIZE_HUGE

/obj/item/ammo_casing/m26
	caliber = "rocket_used"
	projectile_type = /obj/item/projectile/bullet/m26

/obj/item/projectile/bullet/m26
	name = "bottle rocket"
	icon_state = "m26"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	check_armour = "bomb"
	step_delay = 1.2
	shield_damage = 200

/obj/item/projectile/bullet/m26/on_impact(var/atom/target)
	explosion(get_turf(target), 0, 1, 2, 4,guaranteed_damage = 50,guaranteed_damage_range = 2)
	..()

/obj/item/weapon/storage/box/m26
	name = "M-26 Bottle Rocket crate"
	desc = "URF certified crate containing two four of M-26 Bottle Rocket rockets for a total of four rockets to be loaded in the ACL-55."
	icon = 'code/modules/halo/icons/objs/halohumanmisc.dmi'
	icon_state = "m26crate"
	max_storage_space = base_storage_capacity(6)
	startswith = list(/obj/item/ammo_magazine/m26 = 2)
	can_hold = list(/obj/item/ammo_magazine/m26)
	slot_flags = SLOT_BACK
	max_w_class = ITEM_SIZE_HUGE

/obj/item/ammo_magazine/kv32
	name = "magazine (12 gauge) Buckshot"
	desc = "12 gauge magazine containing 4 rounds. Fits the KV-32."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "kv_mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	caliber = "shotgun"
	max_ammo = 4
	multiple_sprites = 1

//40mm grenade
/obj/item/ammo_casing/g40mm
	name = "40mm grenade (Practice)"
	desc = "A 40mm grenade shell. This one appears to be a Practice round."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "40mm_shell"
	spent_icon = "40mm_shell-spent"
	caliber = "g40mm"
	projectile_type = /obj/item/projectile/bullet/g40mm
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 500)

/obj/item/ammo_casing/g40mm/he
	name = "40mm grenade (HE)"
	desc = "A 40mm grenade shell. This one appears to be a High Explosive round. Warning!: Arming range 2."
	icon_state = "40mm_shell_HE"
	projectile_type = /obj/item/projectile/bullet/g40mm/he

/obj/item/ammo_casing/g40mm/frag
	name = "40mm grenade (Fragmentation)"
	desc = "A 40mm grenade shell. This one appears to be a Fragmentation round. Warning!: Arming range 2."
	icon_state = "40mm_shell_frag"
	projectile_type = /obj/item/projectile/bullet/g40mm/frag

/obj/item/ammo_casing/g40mm/smoke
	name = "40mm grenade (Smoke)"
	desc = "A 40mm grenade shell. This one appears to be a Smoke round."
	icon_state = "40mm_shell_smoke"
	projectile_type = /obj/item/projectile/bullet/g40mm/smoke

/obj/item/ammo_casing/g40mm/illumination
	name = "40mm grenade (Illumination)"
	desc = "A 40mm grenade shell. This one appears to be an Illumination round."
	icon_state = "40mm_shell_illumination"
	projectile_type = /obj/item/projectile/bullet/g40mm/illumination

/obj/item/projectile/bullet/g40mm
	name = "shell"
	fire_sound = 'code/modules/halo/sounds/Grenade 1.ogg'
	damage = 60 //it's less dangerous than a shotgun slug with its low AP, but 40mm grenades do obliterate unarmoured flesh
	armor_penetration = 5
	step_delay = 0.9
	var/arming_range = 0

/obj/item/projectile/bullet/g40mm/on_impact(var/atom/target)
	if(arming_range && get_dist(starting,loc) <= arming_range)
		return 0
	return 1

/obj/item/projectile/bullet/g40mm/he
	damage = 20 //explosive is lower mass than a chunk of practice ammo
	armor_penetration = 0 //likewise no room for AP in a regular old bomb
	shield_damage = 100 //less than half minor shields but the explosion will put it pretty low
	check_armour = "bomb"
	arming_range = 2

/obj/item/projectile/bullet/g40mm/he/on_impact(var/atom/target)
	. = ..()
	if (.)
		explosion(get_turf(target), -1, 0, 2, 3, 1) //adminlog for testing purposes
		qdel(src)

/obj/item/projectile/bullet/g40mm/frag
	damage = 5 //this thing will be releasing a load of shrapnel anyway so damage should be appropriately low
	armor_penetration = 0
	arming_range = 2

/obj/item/projectile/bullet/g40mm/frag/on_impact(var/atom/target)
	. = ..()
	if (.)
		playsound(src.loc, 'sound/effects/explosion1.ogg', 30, 1, -3)
		src.fragmentate(get_turf(loc), 50, 7, list(/obj/item/projectile/bullet/pellet/fragment = 1)) //Loc not target, we don't explode *in* them we explode *on* them
		qdel(src)

/obj/item/projectile/bullet/g40mm/smoke
	damage = 30
	armor_penetration = 5
	arming_range = 1

/obj/item/projectile/bullet/g40mm/smoke/on_impact(var/atom/target)
	var/datum/effect/effect/system/smoke_spread/bad/smoke
	smoke = new  /datum/effect/effect/system/smoke_spread/bad()
	smoke.attach(src)
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	smoke.set_up(10, 0, usr.loc)
	spawn(0)
	smoke.start()
	sleep(1)
	smoke.start()
	..()

/obj/item/projectile/bullet/g40mm/illumination
	damage = 30
	armor_penetration = 5

//this is empty for now
/obj/item/projectile/bullet/g40mm/illumination/on_impact(var/atom/target)
	. = ..()
