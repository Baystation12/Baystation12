/obj/item/gun_component/barrel
	name = "barrel"
	component_type = COMPONENT_BARREL
	projectile_type = GUN_TYPE_BALLISTIC
	weapon_type = null
	icon = 'icons/obj/gun_components/barrel.dmi'

	var/caliber
	var/fire_sound = 'sound/weapons/gunshot/gunshot.ogg'
	var/variable_projectile = 1
	var/override_name
	var/list/firemodes
	var/shortened_icon = null
	recoil_mod = 1

/obj/item/gun_component/barrel/update_strings()
	..()
	if(model && model.produced_by.manufacturer_short != "unbranded")
		name = "[model.produced_by.manufacturer_short] [override_name ? override_name : caliber] [weapon_type] [initial(name)]"
	else
		name = "[override_name ? override_name : caliber] [weapon_type] [initial(name)]"

/obj/item/gun_component/barrel/proc/get_projectile_type()
	return

/obj/item/gun_component/barrel/proc/update_from_caliber()
	return

/obj/item/gun_component/barrel/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/weapon/circular_saw) || istype(thing, /obj/item/weapon/melee/energy) || istype(thing, /obj/item/weapon/wirecutters))
		if(shortened_icon && icon_state != shortened_icon)
			user << "<span class='notice'>You begin to shorten \the [src].</span>"
			if(do_after(user, 30))
				user << "<span class='warning'>You shorten \the [src]!</span>"
				icon_state = shortened_icon
				w_class = max(1,w_class-1)
				accepts_accessories = 0
				recoil_mod++
				accuracy_mod--
				weight_mod--
				if(initial(override_name))
					override_name = "shortened [initial(override_name)]"
				else
					override_name = "shortened [caliber]"
				update_strings()
				return
		else
			user << "<span class='warning'>You cannot shorten \the [src] any further!</span>"
	..()