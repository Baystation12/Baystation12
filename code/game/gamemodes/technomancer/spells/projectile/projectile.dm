/obj/item/weapon/spell/projectile
	name = "projectile template"
	icon_state = "generic"
	desc = "This is a generic template that shoots projectiles.  If you can read this, the game broke!"
	cast_methods = CAST_RANGED
	var/obj/item/projectile/spell_projectile = null
	var/energy_cost_per_shot = 0
	var/instability_per_shot = 0
	var/pre_shot_delay = 0
	var/fire_sound = null

/obj/item/weapon/spell/projectile/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(set_up(hit_atom, user))
		var/obj/item/projectile/new_projectile = new spell_projectile(get_turf(user))
		new_projectile.launch(hit_atom)
		log_and_message_admins("has casted [src] at \the [hit_atom].")
		if(fire_sound)
			playsound(get_turf(src), fire_sound, 75, 1)
		adjust_instability(instability_per_shot)
		return 1
	return 0

/obj/item/weapon/spell/projectile/proc/set_up(atom/hit_atom, mob/living/user)
	if(spell_projectile)
		if(pay_energy(energy_cost_per_shot))
			if(pre_shot_delay)
				var/image/target_image = image(icon = 'icons/obj/spells.dmi', loc = get_turf(hit_atom), icon_state = "target")
				image_to(user,target_image)
				user.Stun(pre_shot_delay / 10)
				sleep(pre_shot_delay)
				qdel(target_image)
				if(owner)
					return TRUE
				return FALSE // We got dropped before the firing occured.
			return TRUE // No delay, no need to check.
	return FALSE