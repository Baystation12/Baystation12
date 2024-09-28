/obj/item/gun/projectile/flare
	name = "flare launcher"
	desc = "A single shot polymer flare gun, the XI-54 \"Sirius\" is a reliable way to launch flares away from yourself."
	icon = 'icons/obj/guns/flaregun.dmi'
	icon_state = "flaregun"
	item_state = "flaregun"
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a satisfying 'thump'"
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	w_class = ITEM_SIZE_SMALL
	obj_flags = 0
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	matter = list(MATERIAL_STEEL = 1500, MATERIAL_PLASTIC = 2000)

	caliber = CALIBER_SHOTGUN
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 1
	load_sound = 'sound/weapons/guns/interaction/shotgun_insert.ogg'
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'

/obj/item/gun/projectile/flare/loaded
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/gun/projectile/flare/examine(mob/user, distance)
	. = ..()
	if(distance <= 2 && length(loaded))
		to_chat(user, "\A [loaded[1]] is chambered.")

/obj/item/gun/projectile/flare/special_check()
	if(length(loaded))
		var/obj/item/ammo_casing/casing = loaded[1]
		if(istype(casing) && istype(casing.BB) && !istype(casing, /obj/item/ammo_casing/shotgun/flash))
			var/damage = casing.BB.get_structure_damage()
			if(istype(casing.BB, /obj/item/projectile/bullet/pellet))
				var/obj/item/projectile/bullet/pellet/PP = casing.BB
				damage = PP.damage*PP.pellets
			if(damage > 5)
				var/mob/living/carbon/C = loc
				if(istype(C))
					C.visible_message(SPAN_DANGER("[src] explodes in [C]'s hands!"), SPAN_DANGER("[src] explodes in your face!"))
					C.drop_from_inventory(src)
					for(var/zone in list(BP_L_HAND, BP_R_HAND))
						C.apply_damage(rand(10,20), def_zone=zone)
				else
					visible_message(SPAN_DANGER("[src] explodes!"))
				explosion(get_turf(src), 1, EX_ACT_LIGHT)
				qdel(src)
				return FALSE
	return ..()
