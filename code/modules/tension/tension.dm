// This code is used to give a very rough estimate of how screwed an individual player might be at any given moment when fighting monsters.
// You could use this to have an effect trigger when someone is in serious danger, or as a means for an AI to guess which mob needs to die first.
// The idea and the code structure was taken from Dungeon Crawl Stone Soup.

/atom/movable/proc/get_threat(var/mob/living/threatened)
	return 0


/atom/movable/proc/guess_threat_level(var/mob/living/threatened)
	return 0

/mob/living/simple_animal
	var/threat_level = null // Set this if you want an explicit danger rating.

/mob/living/simple_animal/guess_threat_level(var/mob/living/threatened)
	if(threat_level) // If they have a predefined number, use it.
		return threat_level
	// Otherwise we need to guess how scary this thing is.
	var/threat_guess = 0

	// First lets consider their attack ability.
	var/will_point_blank = FALSE
	if(has_AI())
		will_point_blank = ai_holder.pointblank

	var/potential_damage = 0
	if(!projectiletype || ( ( get_dist(src, threatened) >= 1) && !will_point_blank ) ) // Melee damage.
		potential_damage = (natural_weapon.force) / 2

		// Treat potential_damage as estimated DPS. If the enemy attacks twice as fast as usual, it will double the number.
		potential_damage *= 1 SECOND / (base_attack_cooldown + melee_attack_delay)
	else
		var/obj/item/projectile/P = new projectiletype(src)
		if(P.nodamage) // Tasers are somewhat less scary.
			potential_damage = P.agony / 2
		else
			potential_damage = P.damage
			if(P.damage_type == PAIN) // Not sure if any projectiles do this, but can't be too safe. TODO: i dont think pain is a dmg type
				potential_damage /= 2
			// Rubber bullets, I guess.
			potential_damage += P.agony / 2
		qdel(P)

		potential_damage *= 1 SECOND / (base_attack_cooldown + ranged_attack_delay)

	// Special attacks are ultra-specific to the mob so a generic threat assessment isn't really possible.

	threat_guess += potential_damage

	// Then consider their defense.
	threat_guess += getMaxHealth() / 5 // 100 health translates to 20 threat.

	return threat_guess

/mob/living/get_threat(var/mob/living/threatened)
	if(stat)
		return 0


/mob/living/simple_animal/get_threat(var/mob/living/threatened)
	. = ..()

	if(has_AI())
		if(!ai_holder.hostile)
			return 0 // Can't hurt anyone.

	if(incapacitated(INCAPACITATION_DISABLED))
		return 0 // Can't currently hurt you if it's stunned.

	var/friendly = threatened.faction == faction

	var/threat = guess_threat_level(threatened)

	// Hurt entities contribute less tension.
	threat *= health
	threat /= getMaxHealth()

	// Allies reduce tension instead of adding.
	if(friendly)
		threat = -threat

	else
		if(threatened.invisibility > see_invisible)
			threat /= 2 // Target cannot be seen by src.
		if(invisibility > threatened.see_invisible)
			threat *= 2 // Target cannot see src.

	// Handle statuses.
	if(confused)
		threat /= 2

	// if(has_modifier_of_type(/datum/modifier/berserk))
	// 	threat *= 2

	// Handle ability to harm.
	// Being five tiles away from some spiders is a lot less scary than being in melee range of five spiders at once.
	if(!projectiletype)
		threat /= max(get_dist(src, threatened), 1)

	return threat

// Carbon / mostly Human threat check.
/mob/living/carbon/get_threat(var/mob/living/threatened)
	. = ..()

	if(has_AI())
		if(!ai_holder.hostile)
			return 0

	if(incapacitated(INCAPACITATION_DISABLED))
		return 0

	var/friendly = (IIsAlly(threatened) && a_intent == I_HELP)

	var/threat = guess_threat_level(threatened)

	threat *= health
	threat /= getMaxHealth()

	// Allies reduce tension instead of adding.
	if(friendly)
		threat = -threat

	else
		if(threatened.invisibility > see_invisible)
			threat /= 2 // Target cannot be seen by src.
		if(invisibility > threatened.see_invisible)
			threat *= 2 // Target cannot see src.

	// Handle statuses.
	if(confused)
		threat /= 2

	// if(has_modifier_of_type(/datum/modifier/berserk))
	// 	threat *= 2

	return threat

/mob/living/carbon/guess_threat_level(var/mob/living/threatened)
	var/threat_guess = 0

	// First lets consider their attack ability.
	var/will_point_blank = FALSE
	if(has_AI())
		will_point_blank = ai_holder.pointblank

	. = ..()

	var/obj/item/I = get_active_hand()
	if(!I || !istype(I))
		var/damage_guess = 0
		if(ishuman(src) && ishuman(threatened))
			var/mob/living/carbon/human/H = src
			var/datum/unarmed_attack/attack = H.get_unarmed_attack(threatened, BP_CHEST)
			if(!attack)
				damage_guess += 5

			var/punch_damage = attack.get_unarmed_damage(H)
			if(H.gloves)
				if(istype(H.gloves, /obj/item/clothing/gloves))
					var/obj/item/clothing/gloves/G = H.gloves
					punch_damage += G.force

			damage_guess += punch_damage

		else
			damage_guess += 5

		threat_guess += damage_guess

	else
		var/weapon_attack_speed = DEFAULT_ATTACK_COOLDOWN / (1 SECOND)
		var/weapon_damage = I.force

		if(istype(I, /obj/item/gun))
			will_point_blank = TRUE
			var/obj/item/gun/projectile/G = I

			if (istype(G))
				var/obj/item/ammo_casing/A = G.ammo_type
				var/obj/item/projectile/P = new A.projectile_type

				if(P) // Does the gun even have a projectile type?
					weapon_damage = P.damage
					if(will_point_blank && a_intent == I_HURT)
						weapon_damage *= 1.5
					weapon_attack_speed = G.fire_delay / (1 SECOND)
					qdel(P)

		var/average_damage = weapon_damage / weapon_attack_speed

		threat_guess += average_damage

	// Consider intent.
	switch(a_intent)
		if(I_HELP) // Not likely to fight us.
			threat_guess *= 0.4
		if(I_DISARM) // Might engage us, but unlikely to be with the intent to kill.
			threat_guess *= 0.8
		if(I_GRAB) // May try to restrain us. This is here for reference, or later tweaking if needed.
			threat_guess *= 1
		if(I_HURT) // May try to hurt us.
			threat_guess *= 1.25

	// Then consider their defense.
	threat_guess += getMaxHealth() / 5 // 100 health translates to 20 threat.

	return threat_guess

// Gives a rough idea of how much danger someone is in. Meant to be used for PvE things since PvP has too many unknown variables.
/mob/living/proc/get_tension()
	var/tension = 0
	var/list/potential_threats = list()

	// First, get everything threatening to us.
	for(var/thing in view(src))
		if(isliving(thing))
			potential_threats += thing
		if(istype(thing, /obj/machinery/porta_turret))
			potential_threats += thing

	var/danger = FALSE
	// Now to get all the threats.
	for(var/atom/movable/AM in potential_threats)
		var/tension_from_AM = AM.get_threat(src)
		tension += tension_from_AM
		if(tension_from_AM > 0)
			danger = TRUE

	if(!danger)
		return 0

	// Tension is roughly doubled when about to fall into crit.
	var/max_health = getMaxHealth()
	tension *= 2 * max_health / (health + max_health)

	// Being unable to act is really tense.
	if(incapacitated(INCAPACITATION_DISABLED) && !lying)
		tension *= 10
		return tension

	if(confused)
		tension *= 2

	return tension
