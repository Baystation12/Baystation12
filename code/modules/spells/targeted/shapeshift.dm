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

	cast_sound = 'sound/weapons/emitter2.ogg'
	var/revert_sound = 'sound/weapons/emitter.ogg' //the sound that plays when something gets turned back.
	var/share_damage = 1 //do we want the damage we take from our new form to move onto our real one? (Only counts for finite duration)
	var/drop_items = 1 //do we want to drop all our items when we transform?

/spell/targeted/shapeshift/cast(var/list/targets, mob/user)
	playsound(get_turf(user),cast_sound,50,1)
	for(var/mob/living/M in targets)
		if(M.stat == DEAD)
			to_chat(user, "[name] can only transform living targets.")
			continue
		if(M.buckled)
			M.buckled.unbuckle_mob()
		var/new_mob = pick(possible_transformations)

		var/mob/living/trans = new new_mob(get_turf(M))
		for(var/varName in newVars) //stolen shamelessly from Conjure
			if(varName in trans.vars)
				trans.vars[varName] = newVars[varName]

		trans.name = "[trans.name] ([M])"
		if(istype(M,/mob/living/carbon/human) && drop_items)
			for(var/obj/item/I in M.contents)
				if(istype(I,/obj/item/organ))
					continue
				M.drop_from_inventory(I)
		if(M.mind)
			M.mind.transfer_to(trans)
		else
			trans.key = M.key
		var/atom/movable/overlay/effect = new /atom/movable/overlay(get_turf(M))
		effect.set_density(0)
		effect.anchored = 1
		effect.icon = 'icons/effects/effects.dmi'
		effect.layer = 3
		flick("summoning",effect)
		spawn(10)
			qdel(effect)
		if(!duration)
			qdel(M)
		else
			M.forceMove(trans) //move inside the new dude to hide him.
			M.status_flags |= GODMODE //dont want him to die or breathe or do ANYTHING
			spawn(duration)
				M.status_flags &= ~GODMODE //no more godmode.
				var/ratio = trans.health/trans.maxHealth
				if(ratio <= 0) //if he dead dont bother transforming them.
					qdel(M)
					return
				if(share_damage)
					var/damage = M.maxHealth - round(M.maxHealth*(trans.health/trans.maxHealth))
					for(var/i in 1 to ceil(damage/10))
						M.adjustBruteLoss(10) //Spreads the damage out, rather than putting it on one limb only.
				if(trans.mind)
					trans.mind.transfer_to(M)
				else
					M.key = trans.key
				playsound(get_turf(M),revert_sound,50,1)
				M.forceMove(get_turf(trans))
				qdel(trans)

/spell/targeted/shapeshift/baleful_polymorph
	name = "Baleful Polymorth"
	desc = "This spell transforms its target into a small, furry animal."
	feedback = "BP"
	possible_transformations = list(/mob/living/simple_animal/lizard,/mob/living/simple_animal/mouse,/mob/living/simple_animal/corgi)

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
	possible_transformations = list(/mob/living/simple_animal/parrot)

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