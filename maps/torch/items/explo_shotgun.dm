/obj/item/weapon/gun/projectile/shotgun/pump/exploration
	name = "ballistic launcher"
	desc = "As the user's handbook will tell you, the Xynergy XP-3 is /not/ a shotgun, it just launches payloads of same caliber at high speed towards targets. Nicknamed 'Boomstick' for the way it behaves when full-power ammunition is loaded."
	icon = 'maps/torch/icons/obj/explshotgun.dmi'
	icon_state = "expshotgun0"
	starts_loaded = 0
	req_access = list(access_hop)
	authorized_modes = list(UNAUTHORIZED)

/obj/item/weapon/gun/projectile/shotgun/pump/exploration/on_update_icon()
	icon_state = "expshotgun[!!chambered]"
	..()
	
/obj/item/weapon/gun/projectile/shotgun/pump/exploration/free_fire()
	var/my_z = get_z(src)
	if(!GLOB.using_map.station_levels.Find(my_z))
		return TRUE
	return ..()

/obj/item/weapon/gun/projectile/shotgun/pump/exploration/special_check()
	if(chambered && chambered.BB && prob(80))
		var/damage = chambered.BB.get_structure_damage()
		if(istype(chambered.BB, /obj/item/projectile/bullet/pellet))
			var/obj/item/projectile/bullet/pellet/PP = chambered.BB
			damage = PP.damage*PP.pellets
		if(damage > 30)
			var/mob/living/carbon/C = loc
			if(istype(loc))
				C.visible_message("<span class='danger'>[src] explodes in [C]'s hands!</span>", "<span class='danger'>[src] explodes in your face!</span>")
				C.drop_from_inventory(src)
				for(var/zone in list(BP_L_HAND, BP_R_HAND, BP_HEAD))
					C.apply_damage(rand(10,20), def_zone=zone, blocked=C.run_armor_check(zone))
			else
				visible_message("<span class='danger'>[src] explodes!</span>")
			explosion(get_turf(src), -1, -1, 1)
			qdel(src)
			return FALSE
	return ..()

/obj/item/ammo_magazine/shotholder/net
	name = "net shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/net
	matter = list(MATERIAL_STEEL = 720)
	marking_color = COLOR_PALE_PURPLE_GRAY

/obj/item/ammo_casing/shotgun/net
	name = "net shell"
	desc = "A net shell."
	icon_state = "netshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag/net
	matter = list(MATERIAL_STEEL = 180)

/obj/item/projectile/bullet/shotgun/beanbag/net
	name = "netshell"
	damage = 5
	agony = 10

/obj/item/projectile/bullet/shotgun/beanbag/net/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	var/obj/item/weapon/energy_net/safari/net = new(loc)
	net.throw_impact(target)
	return TRUE

/obj/item/weapon/storage/box/ammo/explo_shells
	name = "box of utility shells"
	startswith = list(/obj/item/ammo_magazine/shotholder/beanbag = 1,
					  /obj/item/ammo_magazine/shotholder/net = 1,
					  /obj/item/ammo_magazine/shotholder/flash = 1)

/obj/structure/closet/secure_closet/explo_gun
	name = "gun locker"
	desc = "Wall locker holding the boomstick."
	req_access = list(access_expedition_shuttle_helm)
	closet_appearance = /decl/closet_appearance/wall/explo_gun
	density = 0
	anchored = 1
	storage_types = CLOSET_STORAGE_ITEMS

/obj/structure/closet/secure_closet/explo_gun/WillContain()
	return list(
		/obj/item/weapon/storage/box/ammo/explo_shells = 3,
		/obj/item/weapon/gun/projectile/shotgun/pump/exploration
	)

/decl/closet_appearance/wall/explo_gun
	color = COLOR_GRAY20
	decals = null
	can_lock = 1
	extra_decals = list(
		"stripe_outer" = COLOR_PURPLE
	)