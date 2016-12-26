/datum/technomancer/spell/overload
	name = "Overload"
	desc = "Fires a bolt of highly unstable energy, that does damaged equal to 0.3% of the technomancer's current reserve of energy.  \
	This energy pierces all known armor."
	cost = 100
	obj_path = /obj/item/weapon/spell/projectile/overload
	ability_icon_state = "tech_overload"
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/projectile/overload
	name = "overload"
	icon_state = "overload"
	desc = "Hope your Core's full."
	cast_methods = CAST_RANGED
	aspect = ASPECT_UNSTABLE
	spell_projectile = /obj/item/projectile/overload
	energy_cost_per_shot = 0 // Handled later
	instability_per_shot = 12
	cooldown = 10
	pre_shot_delay = 4
	fire_sound = 'sound/effects/supermatter.ogg'

/obj/item/projectile/overload
	name = "overloaded bolt"
	icon_state = "bluespace"
	damage_type = BURN
	armor_penetration = 100

/obj/item/weapon/spell/projectile/overload/on_ranged_cast(atom/hit_atom, mob/living/user)
	energy_cost_per_shot = round(core.max_energy * 0.10)
	var/energy_before_firing = core.energy
	if(set_up(hit_atom, user))
		var/obj/item/projectile/overload/P = new spell_projectile(get_turf(user))
		P.launch(hit_atom)
		if(check_for_scepter())
			P.damage = round(energy_before_firing * 0.004) // .4% of their current energy pool.
		else
			P.damage = round(energy_before_firing * 0.003) // .3% of their current energy pool.
		adjust_instability(instability_per_shot)
		return 1