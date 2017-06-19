/obj/item/gun_component/accessory
	name = "accessory"
	component_type = COMPONENT_ACCESSORY
	weapon_type = null
	projectile_type = null
	icon = 'icons/obj/gun_components/accessories.dmi'

	var/installs_into
	var/installed_dam_type = GUN_TYPE_BALLISTIC
	var/installed_gun_type = GUN_PISTOL
	var/melee_max

/obj/item/gun_component/accessory/update_icon()
	if(model)
		icon = model.accessory_icon
	else
		icon = initial(icon)
	icon_state = "[installed_dam_type]_[installed_gun_type]_[initial(icon_state)]"

/obj/item/gun_component/accessory/apply_mod(var/obj/item/weapon/gun/composite/gun)
	..()
	// Apply sharpness.
	if(melee_max)
		gun.force = min(gun.force, melee_max)
	if(sharp)
		gun.sharp = sharp
	if(edge)
		gun.edge = edge
	if(sharp || edge)
		gun.attack_verb = list("stabbed", "slashed", "pierced")


/obj/item/gun_component/accessory/installed(var/obj/item/weapon/gun/composite/gun, var/mob/user)
	if(istype(user))
		user.unEquip(src)
		user << "<span class='notice'>You affix \the [src] to \the [installs_into] of \the [gun].</span>"
	if(loc != gun)
		src.forceMove(gun)
	holder = gun
	installed_dam_type = gun.dam_type
	installed_gun_type = gun.gun_type
	update_icon()
	return

/obj/item/gun_component/accessory/proc/removed_from(var/obj/item/gun, var/mob/user)
	installed_dam_type = initial(installed_dam_type)
	installed_gun_type = initial(installed_gun_type)
	holder = null
	update_icon()
	src.forceMove(get_turf(src))
	if(user)
		user.put_in_hands(src)
		user << "<span class='notice'>You remove \the [src] from \the [installs_into] of \the [gun].</span>"
	return
