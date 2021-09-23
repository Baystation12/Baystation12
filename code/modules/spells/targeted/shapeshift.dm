//basic transformation spell. Should work for most simple_animals

/spell/targeted/shapeshift
	name = "Shapeshift"
	desc = "This spell transforms the target into something else for a short while."

	school = "transmutation"

	charge_type = Sp_RECHARGE
	charge_max = 600

	duration = 0 //set to 0 for permanent.

	var/list/possible_transformations = list()
	var/list/newVars = list() //what the variables of the new created thing will be.

	cast_sound = 'sound/magic/charge.ogg'
	var/revert_sound = 'sound/magic/charge.ogg' //the sound that plays when something gets turned back.
	var/share_damage = 1 //do we want the damage we take from our new form to move onto our real one? (Only counts for finite duration)
	var/drop_items = 1 //do we want to drop all our items when we transform?
	var/toggle = 0 //Can we toggle this?
	var/list/transformed_dudes = list() //Who we transformed. Transformed = Transformation. Both mobs.

/spell/targeted/shapeshift/cast(var/list/targets, mob/user)
	for(var/m in targets)
		var/mob/living/M = m
		if(M.stat == DEAD)
			to_chat(user, "[name] can only transform living targets.")
			continue
		if(M.buckled)
			M.buckled.unbuckle_mob()
		if(toggle && transformed_dudes.len && stop_transformation(M))
			continue
		var/new_mob = pick(possible_transformations)

		var/mob/living/trans = new new_mob(get_turf(M))
		for(var/varName in newVars) //stolen shamelessly from Conjure
			if(varName in trans.vars)
				trans.vars[varName] = newVars[varName]
		//Give them our languages
		for(var/l in M.languages)
			var/datum/language/L = l
			trans.add_language(L.name)

		trans.SetName("[trans.name] ([M])")
		if(istype(M,/mob/living/carbon/human) && drop_items)
			for(var/obj/item/I in M.contents)
				M.drop_from_inventory(I)
		if(M.mind)
			M.mind.transfer_to(trans)
		else
			trans.key = M.key
		new /obj/effect/temporary(get_turf(M), 5, 'icons/effects/effects.dmi', "summoning")

		M.forceMove(trans) //move inside the new dude to hide him.
		M.status_flags |= GODMODE //don't want him to die or breathe or do ANYTHING
		transformed_dudes[trans] = M
		GLOB.death_event.register(trans,src,/spell/targeted/shapeshift/proc/stop_transformation)
		GLOB.destroyed_event.register(trans,src,/spell/targeted/shapeshift/proc/stop_transformation)
		GLOB.destroyed_event.register(M, src, /spell/targeted/shapeshift/proc/destroyed_transformer)
		if(duration)
			spawn(duration)
				stop_transformation(trans)

/spell/targeted/shapeshift/proc/destroyed_transformer(var/mob/target) //Juuuuust in case
	var/mob/current = transformed_dudes[target]
	to_chat(current, "<span class='danger'>You suddenly feel as if this transformation has become permanent...</span>")
	remove_target(target)

/spell/targeted/shapeshift/proc/stop_transformation(var/mob/living/target)
	var/mob/living/transformer = transformed_dudes[target]
	if(!transformer)
		return FALSE
	transformer.status_flags &= ~GODMODE
	if(share_damage)
		var/ratio = target.health/target.maxHealth
		var/damage = transformer.maxHealth - round(transformer.maxHealth*(ratio))
		for(var/i in 1 to ceil(damage/10))
			transformer.adjustBruteLoss(10)
	if(target.mind)
		target.mind.transfer_to(transformer)
	else
		transformer.key = target.key
	playsound(get_turf(target), revert_sound, 50, 1)
	transformer.forceMove(get_turf(target))
	remove_target(target)
	qdel(target)
	return TRUE

/spell/targeted/shapeshift/proc/remove_target(var/mob/living/target)
	var/mob/current = transformed_dudes[target]
	GLOB.destroyed_event.unregister(target,src)
	GLOB.death_event.unregister(current,src)
	GLOB.destroyed_event.unregister(current,src)
	transformed_dudes[target] = null
	transformed_dudes -= target

/spell/targeted/shapeshift/baleful_polymorph
	name = "Baleful Polymorth"
	desc = "This spell transforms its target into a small, furry animal."
	feedback = "BP"
	possible_transformations = list(/mob/living/simple_animal/passive/lizard,/mob/living/simple_animal/passive/mouse,/mob/living/simple_animal/passive/corgi)

	share_damage = 0
	invocation = "Yo'balada!"
	invocation_type = SpI_SHOUT
	spell_flags = NEEDSCLOTHES | SELECTABLE
	range = 3
	duration = 150 //15 seconds.
	cooldown_min = 200 //20 seconds

	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 2, Sp_POWER = 2)

	newVars = list("health" = 50, "maxHealth" = 50)

	hud_state = "wiz_poly"


/spell/targeted/shapeshift/baleful_polymorph/empower_spell()
	if(!..())
		return 0

	duration += 50

	return "Your target will now stay in their polymorphed form for [duration/10] seconds."

/spell/targeted/shapeshift/avian
	name = "Polymorph"
	desc = "This spell transforms the wizard into the common parrot."
	feedback = "AV"
	possible_transformations = list(/mob/living/simple_animal/hostile/retaliate/parrot)

	drop_items = 0
	share_damage = 0
	invocation = "Poli'crakata!"
	invocation_type = SpI_SHOUT
	spell_flags = INCLUDEUSER
	range = -1
	duration = 150
	charge_max = 600
	cooldown_min = 300
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 1, Sp_POWER = 0)
	hud_state = "wiz_parrot"

/spell/targeted/shapeshift/corrupt_form
	name = "Corrupt Form"
	desc = "This spell shapes the wizard into a terrible, terrible beast."
	feedback = "CF"
	possible_transformations = list(/mob/living/simple_animal/hostile/faithless)

	invocation = "mutters something dark and twisted as their form begins to twist..."
	invocation_type = SpI_EMOTE
	spell_flags = INCLUDEUSER
	range = -1
	duration = 150
	charge_max = 1200
	cooldown_min = 600

	drop_items = 0
	share_damage = 0
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 2, Sp_POWER = 2)

	newVars = list("name" = "corrupted soul")

	hud_state = "wiz_corrupt"
	cast_sound = 'sound/magic/disintegrate.ogg'

/spell/targeted/shapeshift/corrupt_form/empower_spell()
	if(!..())
		return 0

	switch(spell_levels[Sp_POWER])
		if(1)
			duration *= 2
			return "You will now stay corrupted for [duration/10] seconds."
		if(2)
			newVars = list("name" = "\proper corruption incarnate",
						"melee_damage_upper" = 25,
						"resistance" = 6,
						"health" = 125,
						"maxHealth" = 125)
			duration = 0
			return "You revel in the corruption. There is no turning back."

/spell/targeted/shapeshift/familiar
	name = "Transform"
	desc = "Transform into a familiar form. Literally."
	feedback = "FA"
	possible_transformations = list()
	drop_items = 0
	invocation_type = SpI_EMOTE
	invocation = "'s body dissipates into a pale mass of light, then reshapes!"
	range = -1
	spell_flags = INCLUDEUSER
	duration = 0
	charge_max = 2 MINUTES
	toggle = 1

	hud_state = "wiz_carp"
