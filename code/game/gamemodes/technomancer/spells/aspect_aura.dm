/datum/technomancer/spell/aspect_aura
	name = "Aspect Aura"
	desc = "This aura function takes on the properties of other functions based on which aspect is introduced to it, applying \
	it to everyone nearby."
	cost = 200
	obj_path = /mob/living/carbon/human/proc/technomancer_aspect_aura

/mob/living/carbon/human/proc/technomancer_aspect_aura()
	place_spell_in_hand(/obj/item/weapon/spell/aspect_aura)

/obj/item/weapon/spell/aspect_aura
	name = "aspect aura"
	desc = "Combine this with another spell to finish the function."
	icon_state = "aspect_bolt"
	cast_methods = CAST_COMBINE
	aspect = ASPECT_CHROMATIC

/obj/item/weapon/spell/aspect_aura/on_combine_cast(obj/item/W, var/mob/living/carbon/human/user)
	if(istype(W, /obj/item/weapon/spell))
		var/obj/item/weapon/spell/spell = W
		if(!spell.aspect || spell.aspect == ASPECT_CHROMATIC)
			to_chat(user,"<span class='warning'>You cannot combine \the [spell] with \the [src], as the aspects are incompatable.</span>")
			return
		user.drop_item(src)
		src.forceMove(null)
		spawn(1)
			switch(spell.aspect)
				if(ASPECT_FIRE)
					user.place_spell_in_hand(/obj/item/weapon/spell/aura/fire)
				if(ASPECT_FROST)
					user.place_spell_in_hand(/obj/item/weapon/spell/aura/frost)
				if(ASPECT_BIOMED)
					user.place_spell_in_hand(/obj/item/weapon/spell/aura/biomed)
		qdel(src)

/obj/item/weapon/spell/aura
	name = "aura template"
	desc = "If you can read me, the game broke!  Yay!"
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_CHROMATIC
	var/glow_color = "#FFFFFF"

/obj/item/weapon/spell/aura/New()
	..()
	set_light(7, 4, l_color = glow_color)
	processing_objects |= src

/obj/item/weapon/spell/aura/Destroy()
	processing_objects -= src
	return ..()

/obj/item/weapon/spell/aura/process()
	return

/obj/item/weapon/spell/aura/fire
	name = "heat aura"
	desc = "Things are starting to heat up."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_FIRE
	glow_color = "#FF6A00"

/obj/item/weapon/spell/aura/fire/process()
	if(!pay_energy(100))
		qdel(src)
	var/list/nearby_mobs = range(4,owner)
	for(var/mob/living/carbon/human/H in nearby_mobs)
		if(H == owner || H.mind && technomancers.is_antagonist(H.mind)) //Don't heat up allies.
			continue

		//We use hotspot_expose() to allow firesuits to protect from this aura.
		var/turf/location = get_turf(H)
		location.hotspot_expose(1000, 50, 1)

	adjust_instability(1)

/obj/item/weapon/spell/aura/frost
	name = "chilling aura"
	desc = "Your enemies will find it hard to chase you if they freeze to death."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_FROST
	glow_color = "#FF6A00"

/obj/item/weapon/spell/aura/frost/process()
	if(!pay_energy(100))
		qdel(src)
	var/list/nearby_mobs = range(4,owner)
	for(var/mob/living/carbon/human/H in nearby_mobs)
		if(H == owner || H.mind && technomancers.is_antagonist(H.mind)) //Don't chill allies.
			continue

		//We use hotspot_expose() to allow firesuits to protect from this aura.
		var/turf/location = get_turf(H)
		location.hotspot_expose(1, 50, 1)

	adjust_instability(1)



/obj/item/weapon/spell/aura/biomed
	name = "restoration aura"
	desc = "Allows everyone, or just your allies, to slowly regenerate."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_BIOMED
	glow_color = "#0000FF"
	var/regen_tick = 0
	var/heal_allies_only = 1

/obj/item/weapon/spell/aura/biomed/process()
	if(!pay_energy(75))
		qdel(src)
	regen_tick++
	if(regen_tick % 5 == 0)
		var/list/nearby_mobs = range(4,owner)
		var/list/mobs_to_heal = list()
		if(heal_allies_only)
			for(var/mob/living/carbon/human/H in nearby_mobs) //Heal our apprentices
				if(H.mind && technomancers.is_antagonist(H.mind))
					mobs_to_heal |= H
			for(var/mob/living/simple_animal/hostile/SAH in nearby_mobs) //Heal our controlled mobs
				if(owner in SAH.friends)
					mobs_to_heal |= SAH
		else
			mobs_to_heal = nearby_mobs //Heal everyone!
		for(var/mob/living/L in mobs_to_heal)
			L.adjustBruteLoss(-5)
			L.adjustFireLoss(-5)
		adjust_instability(2)

/obj/item/weapon/spell/aura/biomed/on_use_cast(mob/living/user)
	heal_allies_only = !heal_allies_only
	to_chat(user,"Your aura will now heal [heal_allies_only ? "your allies" : "everyone"] near you.")