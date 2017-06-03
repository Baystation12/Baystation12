/obj/item/gun_component/accessory/chamber
	installs_into = COMPONENT_MECHANISM

/obj/item/gun_component/accessory/chamber/scope
	name = "scope"
	icon_state = "scope"
	weight_mod = 2
	fire_rate_mod = 1
	accuracy_mod = 3
	installs_into = COMPONENT_MECHANISM

/obj/item/gun_component/accessory/chamber/scope/apply_mod(var/obj/item/weapon/gun/composite/gun)
	..()
	gun.verbs |= /obj/item/weapon/gun/composite/proc/scope

/obj/item/gun_component/accessory/chamber/flashlight
	name = "flashlight"
	icon_state = "flashlight"
	weight_mod = 1
	has_alt_interaction = 1
	var/on
	var/brightness_on = 4

/obj/item/gun_component/accessory/chamber/flashlight/do_user_alt_interaction(var/mob/user)
	if(!isturf(user.loc))
		user << "<span class='warning'>You cannot turn the light on while in \the [user.loc].</span>"
		return 1
	on = !on
	update_gun_light()
	return 1

/obj/item/gun_component/accessory/chamber/flashlight/initialize()
	..()
	update_gun_light()

/obj/item/gun_component/accessory/chamber/flashlight/proc/update_gun_light()
	if(on)
		if(holder)
			holder.set_light(brightness_on)
		set_light(brightness_on)
	else
		if(holder)
			holder.set_light(0)
		set_light(0)