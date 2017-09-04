/mob/living
	var/hiding

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(incapacitated())
		return

	hiding = !hiding
	if(hiding)
		to_chat(src, "<span class='notice'>You are now hiding.</span>")
	else
		to_chat(src, "<span class='notice'>You have stopped hiding.</span>")
	reset_layer()

/mob/living/proc/breath_death()
	set name = "Breath Death"
	set desc = "Infect others with your very breathe."
	set category = "Abilities"

	if(last_special > world.time)
		return

	last_special = world.time + 1 SECOND

	var/turf/T = get_turf(src)
	var/obj/effect/effect/water/chempuff/chem = new(T)
	chem.create_reagents(10)
	chem.reagents.add_reagent(/datum/reagent/toxin/corrupting,30)
	chem.set_up(get_step(T, dir), 2, 10)
	playsound(T, 'sound/hallucinations/wail.ogg',20,1)

/mob/living/proc/consume()
	set name = "Consume"
	set desc = "Regain life by consuming it from others."
	set category = "Abilities"

	if(last_special > world.time)
		return
	var/mob/living/target
	for(var/mob/living/L in get_turf(src))
		if(L.lying || L.stat == DEAD)
			target = L
			break
	if(!target)
		return

	last_special = world.time + 50

	src.visible_message("<span class='danger'>\The [src] hunkers down over \the [target], tearing into their flesh.</span>")
	if(do_after(src,target,100))
		target.adjustBruteLoss(25)
		if(target.health < -target.maxHealth)
			target.gib()
		src.adjustBruteLoss(-25)