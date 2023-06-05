/mob/living/proc/modify_damage_by_armor(def_zone, damage, damage_type, damage_flags, mob/living/victim, armor_pen, silent = FALSE)
	var/list/armors = get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = args.Copy(2)
	for(var/armor in armors)
		var/datum/extension/armor/armor_datum = armor
		. = armor_datum.apply_damage_modifications(arglist(.))

/mob/living/proc/get_blocked_ratio(def_zone, damage_type, damage_flags, armor_pen, damage)
	var/list/armors = get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = 0
	for(var/armor in armors)
		var/datum/extension/armor/armor_datum = armor
		. = 1 - (1 - .) * (1 - armor_datum.get_blocked(damage_type, damage_flags, armor_pen, damage)) // multiply the amount we let through
	. = min(1, .)

/mob/living/proc/get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = list()
	var/natural_armor = get_extension(src, /datum/extension/armor)
	if(natural_armor)
		. += natural_armor
	if(psi)
		. += get_extension(psi, /datum/extension/armor)

/mob/living/bullet_act(obj/item/projectile/P, def_zone)
	if (status_flags & GODMODE)
		return PROJECTILE_FORCE_MISS

	//Being hit while using a deadman switch
	var/obj/item/device/assembly/signaler/signaler = get_active_hand()
	if(istype(signaler) && signaler.deadman)
		log_and_message_admins("has triggered a signaler deadman's switch")
		visible_message(SPAN_WARNING("[src] triggers their deadman's switch"))
		signaler.signal()

	//Armor
	var/damage = P.damage
	var/flags = P.damage_flags()
	var/damaged
	if(!P.nodamage)
		damaged = apply_damage(damage, P.damage_type, def_zone, flags, P, P.armor_penetration)
		bullet_impact_visuals(P, def_zone, damaged)
	if(damaged || P.nodamage) // Run the block computation if we did damage or if we only use armor for effects (nodamage)
		. = get_blocked_ratio(def_zone, P.damage_type, flags, P.armor_penetration, P.damage)
	P.on_hit(src, ., def_zone)

	if(ai_holder && P.firer)
		ai_holder.react_to_attack(P.firer)

// For visuals and blood splatters etc
/mob/living/proc/bullet_impact_visuals(obj/item/projectile/P, def_zone, damage)
	var/list/impact_sounds = LAZYACCESS(P.impact_sounds, get_bullet_impact_effect_type(def_zone))
	if(length(impact_sounds))
		playsound(src, pick(impact_sounds), 75)

/mob/living/get_bullet_impact_effect_type(def_zone)
	return BULLET_IMPACT_MEAT

/**
 * Checks the mob for auras and interactions of the given type.
 *
 * Calls one of the `aura_check_*` procs for each aura in the mobs `auras` list, based on type provided.
 * All parameters after `type` are passed on to the called proc.
 *
 * **Parameters**:
 * - `type` (String - One of `AURA_TYPE_*`) - The type of check to be performed any any found auras.
 * - Additional parameters depend on aura type:
 *   - `AURA_TYPE_WEAPON (obj/item/weapon, mob/user, click_params)`:
 *     - `weapon` - The item used to attack/interact with the mob.
 *     - `attacker` - The mob performing the attack/interaction.
 *     - `click_params` - List of click parameters.
 *   - `AURA_TYPE_BULLET (obj/item/projectile/proj, def_zone)`:
 *     - `proj` - Projectile impacting the mob.
 *     - `def_zone` - Impacted body part target zone.
 *   - `AURA_TYPE_THROWN (atom/movable/thrown_atom, datum/thrownthing/thrown_datum)`:
 *     - `thrown_atom` - Atom impacting the mob.
 *     - `thrown_datum` - thrownthing datum instance for the throw chain.
 *   - `AURA_TYPE_LIFE` (No additional parameters)
 *
 * Returns boolean - `TRUE` if no auras were found or if no auras passed `AURA_FALSE` in their checks.
 * Generally, a `FALSE` return value means the aura blocks further interaction.
 */
/mob/living/proc/aura_check(type)
	if(!auras)
		return TRUE
	. = TRUE
	var/list/newargs = args - args[1]
	for(var/a in auras)
		var/obj/aura/aura = a
		var/result = EMPTY_BITFIELD
		switch(type)
			if(AURA_TYPE_WEAPON)
				result = aura.aura_check_weapon(arglist(newargs))
			if(AURA_TYPE_BULLET)
				result = aura.aura_check_bullet(arglist(newargs))
			if(AURA_TYPE_THROWN)
				result = aura.aura_check_thrown(arglist(newargs))
			if(AURA_TYPE_LIFE)
				result = aura.aura_check_life()
		if(result & AURA_FALSE)
			. = FALSE
		if(result & AURA_CANCEL)
			break


//Handles the effects of "stun" weapons
/mob/living/proc/stun_effect_act(stun_amount, agony_amount, def_zone, used_weapon=null)
	flash_pain()

	if (stun_amount)
		Stun(stun_amount)
		Weaken(stun_amount)
		apply_effect(stun_amount, EFFECT_STUTTER)
		apply_effect(stun_amount, EFFECT_EYE_BLUR)

	if (agony_amount)
		apply_damage(agony_amount, DAMAGE_PAIN, def_zone, used_weapon = used_weapon)
		apply_effect(agony_amount/10, EFFECT_STUTTER)
		apply_effect(agony_amount/10, EFFECT_EYE_BLUR)

/mob/living/proc/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0, def_zone = null)
	  return FALSE //only carbon liveforms have this proc

/mob/living/emp_act(severity)
	if (status_flags & GODMODE)
		return
	var/list/L = get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)
	..()

/mob/living/proc/resolve_item_attack(obj/item/I, mob/living/user, target_zone)
	return target_zone

//Called when the mob is hit with an item in combat. Returns the blocked result
/mob/living/proc/hit_with_weapon(obj/item/I, mob/living/user, effective_force, hit_zone)
	var/weapon_mention
	if(I.attack_message_name())
		weapon_mention = " with [I.attack_message_name()]"
	visible_message(SPAN_DANGER("\The [src] has been [length(I.attack_verb)? pick(I.attack_verb) : "attacked"][weapon_mention] by \the [user]!"))

	. = standard_weapon_hit_effects(I, user, effective_force, hit_zone)

	if (I.damtype == DAMAGE_BRUTE && prob(33)) // Added blood for whacking non-humans too
		var/turf/simulated/location = get_turf(src)
		if(istype(location)) location.add_blood_floor(src)

	if (ai_holder)
		ai_holder.react_to_attack(user)

///returns false if the effects failed to apply for some reason, true otherwise.
/mob/living/proc/standard_weapon_hit_effects(obj/item/I, mob/living/user, effective_force, hit_zone)
	if(!effective_force)
		return FALSE

	//Apply weapon damage
	var/damage_flags = I.damage_flags()

	return apply_damage(effective_force, I.damtype, hit_zone, damage_flags, used_weapon=I, armor_pen=I.armor_penetration)

//this proc handles being hit by a thrown atom
/mob/living/hitby(atom/movable/AM, datum/thrownthing/TT)

	if(isliving(AM))
		var/mob/living/M = AM
		playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
		if(skill_fail_prob(SKILL_COMBAT, 75))
			Weaken(rand(3,5))
		if(M.skill_fail_prob(SKILL_HAULING, 100))
			M.Weaken(rand(4,8))
		M.visible_message(SPAN_DANGER("\The [M] collides with \the [src]!"))

	if (!aura_check(AURA_TYPE_THROWN, AM, TT))
		return

	if(isobj(AM))
		var/obj/O = AM
		var/dtype = O.damtype
		var/throw_damage = O.throwforce*(TT.speed/THROWFORCE_SPEED_DIVISOR)

		var/miss_chance = max(15*(TT.dist_travelled-2),0)

		if (prob(miss_chance) || (istype(src, /mob/living/exosuit) && prob(miss_chance * 0.75)))
			visible_message(SPAN_NOTICE("\The [O] misses [src] narrowly!"))
			return

		visible_message(SPAN_WARNING("\The [src] has been hit by \the [O]."))
		apply_damage(throw_damage, dtype, null, O.damage_flags(), O)

		if(TT.thrower)
			var/client/assailant = TT.thrower.client
			if(assailant)
				admin_attack_log(TT.thrower, src, "Threw \an [O] at the victim.", "Had \an [O] thrown at them.", "threw \an [O] at")

			if (ai_holder)
				ai_holder.react_to_attack(TT.thrower)

		if(O.can_embed() && (throw_damage > 5*O.w_class)) //Handles embedding for non-humans and simple_animals.
			embed(O)

	process_momentum(AM, TT)

/mob/living/momentum_power(atom/movable/AM, datum/thrownthing/TT)
	if(anchored || buckled)
		return 0

	. = (AM.get_mass()*TT.speed)/(get_mass()*min(AM.throw_speed,2))
	if(has_gravity() || check_space_footing())
		. *= 0.5

/mob/living/momentum_do(power, datum/thrownthing/TT, atom/movable/AM)
	if(power >= 0.75)		//snowflake to enable being pinned to walls
		var/direction = TT.init_dir
		throw_at(get_edge_target_turf(src, direction), min((TT.maxrange - TT.dist_travelled) * power, 10), throw_speed * min(power, 1.5), callback = new Callback(src,/mob/living/proc/pin_to_wall,AM,direction))
		visible_message(SPAN_DANGER("\The [src] staggers under the impact!"),SPAN_DANGER("You stagger under the impact!"))
		return

	. = ..()

/mob/living/proc/pin_to_wall(obj/O, direction)
	if(!istype(O) || O.loc != src || !O.can_embed())//Projectile is suitable for pinning.
		return

	var/turf/T = near_wall(direction,2)

	if(T)
		forceMove(T)
		visible_message(SPAN_DANGER("[src] is pinned to the wall by [O]!"),SPAN_DANGER("You are pinned to the wall by [O]!"))
		src.anchored = TRUE
		src.pinned += O

/mob/living/proc/embed(obj/O, def_zone=null, datum/wound/supplied_wound)
	O.forceMove(src)
	embedded += O
	verbs += /mob/proc/yank_out_object

//This is called when the mob is thrown into a dense turf
/mob/living/proc/turf_collision(turf/T, speed)
	visible_message(SPAN_DANGER("[src] slams into \the [T]"))
	playsound(T, 'sound/effects/bangtaper.ogg', 50, 1, 1)//so it plays sounds on the turf instead, makes for awesome carps to hull collision and such
	apply_damage(speed * 2, DAMAGE_BRUTE)

/mob/living/proc/near_wall(direction,distance=1)
	var/turf/T = get_step(get_turf(src),direction)
	var/turf/last_turf = loc
	var/i = 1

	while(i>0 && i<=distance)
		if(!T || T.density) //Turf is a wall or map edge.
			return last_turf
		i++
		last_turf = T
		T = get_step(T,direction)

	return FALSE

// End BS12 momentum-transfer code.

/mob/living/attack_generic(mob/user, damage, attack_message)

	if(!damage || !istype(user))
		return

	adjustBruteLoss(damage)
	admin_attack_log(user, src, "Attacked", "Was attacked", "attacked")

	visible_message(SPAN_DANGER("\The [user] has [attack_message] \the [src]"))
	user.do_attack_animation(src)
	spawn(1) updatehealth()

	if (ai_holder)
		ai_holder.react_to_attack(user)

/mob/living/proc/IgniteMob()
	if(fire_stacks > 0 && !on_fire)
		on_fire = 1
		set_light(0.6, 0.1, 4, l_color = COLOR_ORANGE)
		update_fire()

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = 0
		fire_stacks = 0
		set_light(0)
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
	fire_stacks = clamp(fire_stacks + add_fire_stacks, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

/mob/living/proc/handle_fire()
	if(fire_stacks < 0)
		fire_stacks = min(0, ++fire_stacks) //If we've doused ourselves in water to avoid fire, dry off slowly

	if(!on_fire)
		return TRUE
	else if(fire_stacks <= 0)
		ExtinguishMob() //Fire's been put out.
		return TRUE

	fire_stacks = max(0, fire_stacks - 0.2) //I guess the fire runs out of fuel eventually

	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(G.get_by_flag(XGM_GAS_OXIDIZER) < 1)
		ExtinguishMob() //If there's no oxygen in the tile we're on, put out the fire
		return TRUE

	var/turf/location = get_turf(src)
	location.hotspot_expose(fire_burn_temperature(), 50, 1)

/mob/living/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (status_flags & GODMODE)
		return
	//once our fire_burn_temperature has reached the temperature of the fire that's giving fire_stacks, stop adding them.
	//allow fire_stacks to go up to 4 for fires cooler than 700 K, since are being immersed in flame after all.
	if(fire_stacks <= 4 || fire_burn_temperature() < exposed_temperature)
		adjust_fire_stacks(2)
	IgniteMob()

/mob/living/proc/get_cold_protection()
	return FALSE

/mob/living/proc/get_heat_protection()
	return FALSE

//Finds the effective temperature that the mob is burning at.
/mob/living/proc/fire_burn_temperature()
	if (fire_stacks <= 0)
		return FALSE

	//Scale quadratically so that single digit numbers of fire stacks don't burn ridiculously hot.
	//lower limit of 700 K, same as matches and roughly the temperature of a cool flame.
	return max(2.25*round(FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE*(fire_stacks/FIRE_MAX_FIRESUIT_STACKS)**2), 700)

/mob/living/proc/reagent_permeability()
	return TRUE

/mob/living/proc/handle_actions()
	//Pretty bad, i'd use picked/dropped instead but the parent calls in these are nonexistent
	for(var/datum/action/A in actions)
		if(A.CheckRemoval(src))
			A.Remove(src)
	for(var/obj/item/I in src)
		if(I.action_button_name)
			if(!I.action)
				I.action = new I.default_action_type
			I.action.name = I.action_button_name
			I.action.SetTarget(I)
			I.action.Grant(src)
	return

/mob/living/update_action_buttons()
	if(!hud_used) return
	if(!client) return

	if(hud_used.hud_shown != 1)	//Hud toggled to minimal
		return

	client.screen -= hud_used.hide_actions_toggle
	for(var/datum/action/A in actions)
		if(A.button)
			client.screen -= A.button

	if(hud_used.action_buttons_hidden)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.UpdateIcon()

		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,1)

		client.screen += hud_used.hide_actions_toggle
		return

	var/button_number = 0
	for(var/datum/action/A in actions)
		button_number++
		if(A.button == null)
			var/obj/screen/movable/action_button/N = new(hud_used)
			N.owner = A
			A.button = N

		var/obj/screen/movable/action_button/B = A.button

		B.UpdateIcon()

		B.SetName(A.UpdateName())

		client.screen += B

		if(!B.moved)
			B.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
			//hud_used.SetButtonCoords(B,button_number)

	if(button_number > 0)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.InitialiseIcon(src)
		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number+1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,button_number+1)
		client.screen += hud_used.hide_actions_toggle

/mob/living/lava_act(datum/gas_mixture/air, temperature, pressure)
	if (status_flags & GODMODE)
		return
	fire_act(air, temperature)
	FireBurn(0.4*vsc.fire_firelevel_multiplier, temperature, pressure)
	. =  (health <= 0) ? ..() : FALSE

// Applies direct "cold" damage while checking protection against the cold.
/mob/living/proc/inflict_cold_damage(amount)
	amount *= 1 - get_cold_protection(50) // Within spacesuit protection.
	if(amount > 0)
		adjustFireLoss(amount)

// Ditto, but for "heat".
/mob/living/proc/inflict_heat_damage(amount)
	amount *= 1 - get_heat_protection(10000) // Within firesuit protection.
	if(amount > 0)
		adjustFireLoss(amount)

// and one for electricity because why not
/mob/living/proc/inflict_shock_damage(amount)
	electrocute_act(amount, null, 1, pick(BP_HEAD, BP_CHEST, BP_GROIN))

// also one for water (most things resist it entirely, except for slimes)
/mob/living/proc/inflict_water_damage(amount)
	amount *= 1
	if(amount > 0)
		adjustToxLoss(amount)

// one for abstracted away ""poison"" (mostly because simplemobs shouldn't handle reagents)
/mob/living/proc/inflict_poison_damage(amount)
	if(isSynthetic())
		return
	amount *= 1
	if(amount > 0)
		adjustToxLoss(amount)
