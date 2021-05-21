
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

/obj/item/device/flashlight/flare/g40mm
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	name = "illumination shell"
	brightness_on = 7
	light_color = "#ffff99"
	icon_state = "40mm_shell_illumination"
	item_state = null

/obj/item/device/flashlight/flare/g40mm/New()
	..()
	turn_on()

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
		src.fragmentate(get_turf(loc), 100, 7, list(/obj/item/projectile/bullet/pellet/fragment = 1)) //Loc not target, we don't explode *in* them we explode *on* them
		qdel(src)

/obj/item/projectile/bullet/g40mm/smoke
	damage = 30
	arming_range = 1

/obj/item/projectile/bullet/g40mm/smoke/launch(atom/target, var/target_zone, var/x_offset=0, var/y_offset=0, var/angle_offset=0)
	. = ..()
	kill_count = get_dist(get_turf(loc),get_turf(target))

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

/obj/item/projectile/bullet/g40mm/illumination/launch(atom/target, var/target_zone, var/x_offset=0, var/y_offset=0, var/angle_offset=0)
	. = ..()
	kill_count = get_dist(get_turf(loc),get_turf(target))

/obj/item/projectile/bullet/g40mm/illumination/on_impact(var/atom/target)
	. = ..()
	var/mob/living/m = target
	if(istype(m))
		m.adjust_fire_stacks(1)
		if(!m.on_fire)
			m.IgniteMob()
	new /obj/item/device/flashlight/flare/g40mm(get_turf(target))

//Boxes of 40mm ammo for supplypacks

/obj/item/weapon/storage/box/g40mm_he
	name = "box of M301 40mm HE grenades"
	startswith = list(/obj/item/ammo_casing/g40mm/he = 7)

/obj/item/weapon/storage/box/g40mm_frag
	name = "box of M301 40mm Fragmentation grenades"
	startswith = list(/obj/item/ammo_casing/g40mm/frag = 7)

/obj/item/weapon/storage/box/g40mm_smoke
	name = "box of M301 40mm Smoke grenades"
	startswith = list(/obj/item/ammo_casing/g40mm/smoke = 7)

/obj/item/weapon/storage/box/g40mm_misc
	name = "box of Misc M301 40mm grenades"
	startswith = list(/obj/item/ammo_casing/g40mm = 3,
					  /obj/item/ammo_casing/g40mm/illumination = 3)