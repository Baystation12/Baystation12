/obj/item/modular_computer/examine_damage_state(mob/user)
	. = ..()
	if (damage_broken())
		to_chat(user, SPAN_DANGER("It is completely non-functional from damage."))


/obj/item/modular_computer/handle_death_change(new_death_state)
	. = ..()
	if (new_death_state)
		break_apart()


/obj/item/modular_computer/can_damage_health(damage, damage_type)
	if (!modifiable)
		return FALSE
	. = ..()


/obj/item/modular_computer/post_health_change(health_mod, damage_type)
	. = ..()
	if (damage_broken())
		shutdown_computer()


/// `damage_casing` - Whether or not to pass damage through to the computer itself. If false, skips calling the parent.
/obj/item/modular_computer/damage_health(damage, damage_type, skip_death_state_change, severity, damage_casing = TRUE)
	// "Stun" weapons can cause minor damage to components (short-circuits?)
	// "Burn" damage is equally strong against internal components and exterior casing
	// "Brute" damage mostly damages the casing.
	var/component_probability = 0
	switch (damage_type)
		if (DAMAGE_BRUTE)
			component_probability = damage / 2
		if (DAMAGE_PAIN || DAMAGE_STUN || DAMAGE_SHOCK)
			component_probability = damage / 3
		if (DAMAGE_BURN || DAMAGE_FIRE)
			component_probability = damage / 1.5
		if (DAMAGE_EXPLODE)
			component_probability = 30 / severity
		if (DAMAGE_EMP)
			// Some attacks don't send a severity, such as ion projectiles.
			component_probability = severity ? 30 / severity : 30
			// EMP weapons don't deal direct damage, but do fry the components.
			damage_casing = FALSE

	// Handle component damage
	if (component_probability)
		for (var/obj/item/stock_parts/computer/H in get_all_components())
			if (prob(component_probability))
				H.damage_health(round(damage / 2), damage_type)

	if (!damage_casing)
		. = ..()


/// Handles ejecting components and destroying the computer from damage.
/obj/item/modular_computer/proc/break_apart()
	visible_message(SPAN_DANGER("\The [src] breaks apart!"))
	var/turf/newloc = get_turf(src)
	new /obj/item/stack/material/steel(newloc, round(steel_sheet_cost / 2))
	for (var/obj/item/stock_parts/computer/H in get_all_components())
		uninstall_component(null, H)
		H.forceMove(newloc)
		if(prob(25))
			H.damage_health(rand(10, 30), BRUTE)
	qdel(src)


/// Whether or not the computer's damage is at the broken threshhold. Returns `TRUE` if `get_damage_value()` meets or exceeds `damage_broken`.
/obj/item/modular_computer/proc/damage_broken()
	if (get_damage_value() >= (damage_broken / 100) * get_max_health())
		return TRUE
	return FALSE


// Stronger explosions cause serious damage to internal components
// Minor explosions are mostly mitigitated by casing.
/obj/item/modular_computer/ex_act(severity)
	damage_health(rand(100, 200) / severity, DAMAGE_EXPLODE, severity = severity)


// EMPs are similar to explosions, but don't cause physical damage to the casing. Instead they screw up the components
/obj/item/modular_computer/emp_act(severity)
	damage_health(rand(100, 200) / severity, DAMAGE_EMP, severity = severity, damage_casing = FALSE)


/obj/item/modular_computer/bullet_act(obj/item/projectile/Proj)
	damage_health(Proj.damage, Proj.damage_type)


/obj/item/modular_computer/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	damage_health(round(exposed_temperature / 100), DAMAGE_FIRE) // TODO Test and tweak this value


/obj/item/modular_computer/attackby(obj/item/W, mob/user)
	if (user.a_intent == I_HURT)
		damage_health(W.force, W.damtype)
		return

	. = ..()
