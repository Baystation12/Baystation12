/obj/item/gun_component
	name = "gun component"
	desc = "A mysterious gun component."
	w_class = 2
	randpixel = 0

	var/weapon_type = GUN_PISTOL             // What kind of weapon does this fit into?
	var/component_type = COMPONENT_BARREL    // What part of the gun is this?
	var/projectile_type = GUN_TYPE_BALLISTIC // What is this component designed to help fire?
	var/obj/item/weapon/gun/composite/holder // Reference to composite gun that this is part of.
	var/decl/weapon_model/model              // Does this component have a particular model/manufacturer?
	var/accepts_accessories                  // Can this component have accessories installed?

	var/has_user_interaction                 // Can this component be interacted with via gun attack_self()?
	var/has_alt_interaction                  // Can this component be interacted with via gun AltClick()?

	var/two_handed = 0
	var/fire_rate_mod = 0
	var/accuracy_mod = 0
	var/recoil_mod = 0
	var/weight_mod =    0

/obj/item/gun_component/proc/get_extra_examine_info()
	return

/obj/item/gun_component/proc/apply_mod(var/obj/item/weapon/gun/composite/gun)
	// Apply misc mods.
	if(fire_rate_mod) gun.fire_delay += fire_rate_mod
	if(accuracy_mod)  gun.accuracy   += accuracy_mod
	if(recoil_mod)    gun.recoil     += recoil_mod
	if(two_handed)    gun.one_hand_penalty++
	if(weight_mod)    gun.w_class    += weight_mod

/obj/item/gun_component/proc/remove_mod(var/obj/item/weapon/gun/composite/gun)
	// Apply misc mods.
	if(fire_rate_mod) gun.fire_delay -= fire_rate_mod
	if(accuracy_mod)  gun.accuracy   -= accuracy_mod
	if(recoil_mod)    gun.recoil     -= recoil_mod
	if(two_handed)    gun.one_hand_penalty--
	if(weight_mod)    gun.w_class    -= weight_mod

/obj/item/gun_component/Destroy()
	holder = null
	return ..()

/obj/item/gun_component/New(var/newloc, var/weapontype, var/componenttype, var/use_model)
	..(newloc)
	if(weapontype)    weapon_type = weapontype
	if(componenttype) component_type = componenttype
	if(use_model)
		model = get_gun_model_by_path(use_model)
	update_icon()
	update_strings()

/obj/item/gun_component/proc/empty()
	for(var/obj/item/I in contents)
		I.forceMove(get_turf(src))

/obj/item/gun_component/proc/update_strings()

	name = "[initial(name)]"
	if(weapon_type)
		name = "[weapon_type] [name]"
	if(projectile_type == GUN_TYPE_LASER)
		name = "laser [name]"

	if(model)
		desc = "The casing is stamped with '[model.model_name]'. [initial(desc)]"
		if(model.produced_by.manufacturer_short != "unbranded")
			name = "[model.produced_by.manufacturer_short] [name]"
			desc += " This one seems like it was produced by [model.produced_by.manufacturer_name]."
	else
		desc = "[initial(desc)]"

/obj/item/gun_component/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/gun_assembly))
		var/obj/item/gun_assembly/GA = thing
		GA.attackby(src, user)
		return
	return ..()


/obj/item/gun_component/proc/installed()
	return

/obj/item/gun_component/proc/uninstalled()
	return

/obj/item/gun_component/proc/do_user_interaction(var/mob/user)
	return

/obj/item/gun_component/proc/do_user_alt_interaction(var/mob/user)
	return

/obj/item/gun_component/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/weapon/screwdriver))
		var/offset = input(user,"New vertical offset:","Part offset",pixel_y)
		pixel_y = Clamp(offset,-world.icon_size,world.icon_size)
		offset = input(user,"New horizontal offset:","Part offset",pixel_x)
		pixel_x = Clamp(offset,-world.icon_size,world.icon_size)
	else
		..()

/obj/item/gun_component/proc/get_examine_text()
	return ""