/proc/alien_queen_exists(var/ignore_self,var/mob/living/carbon/human/self)
	for(var/mob/living/carbon/human/Q in living_mob_list)
		if(self && ignore_self && self == Q)
			continue
		if(Q.species.name != "Xenomorph Queen")
			continue
		if(!Q.key || !Q.client || Q.stat)
			continue
		return 1
	return 0

/mob/living/carbon/human/proc/gain_plasma(var/amount)

	var/datum/organ/internal/xenos/plasmavessel/I = internal_organs_by_name["plasma vessel"]
	if(!istype(I)) return

	if(amount)
		I.stored_plasma += amount
	I.stored_plasma = max(0,min(I.stored_plasma,I.max_plasma))

/mob/living/carbon/human/proc/check_alien_ability(var/cost,var/needs_foundation,var/needs_organ)

	var/datum/organ/internal/xenos/plasmavessel/P = internal_organs_by_name["plasma vessel"]
	if(!istype(P))
		src << "<span class='danger'>Your plasma vessel has been removed!</span>"
		return

	if(needs_organ)
		var/datum/organ/internal/I = internal_organs_by_name[needs_organ]
		if(!I)
			src << "<span class='danger'>Your [needs_organ] has been removed!</span>"
			return
		else if((I.status & ORGAN_CUT_AWAY) || I.is_broken())
			src << "<span class='danger'>Your [needs_organ] is too damaged to function!</span>"
			return

	if(P.stored_plasma < cost)
		src << "\red You don't have enough phoron stored to do that."
		return 0

	if(needs_foundation)
		var/turf/T = get_turf(src)
		var/has_foundation
		if(T)
			//TODO: Work out the actual conditions this needs.
			if(!(istype(T,/turf/space)))
				has_foundation = 1
		if(!has_foundation)
			src << "\red You need a solid foundation to do that on."
			return 0

	P.stored_plasma -= cost
	return 1

// Free abilities.
/mob/living/carbon/human/proc/transfer_plasma(mob/living/carbon/human/M as mob in oview())
	set name = "Transfer Plasma"
	set desc = "Transfer Plasma to another alien"
	set category = "Abilities"

	if (get_dist(src,M) <= 1)
		src << "\green You need to be closer."
		return

	var/datum/organ/internal/xenos/plasmavessel/I = M.internal_organs_by_name["plasma vessel"]
	if(!istype(I))
		src << "\green Their plasma vessel is missing."
		return

	var/amount = input("Amount:", "Transfer Plasma to [M]") as num
	if (amount)
		amount = abs(round(amount))
		if(check_alien_ability(amount,0,"plasma vessel"))
			M.gain_plasma(amount)
			M << "\green [src] has transfered [amount] plasma to you."
			src << "\green You have transferred [amount] plasma to [M]"
	return

// Queen verbs.
/mob/living/carbon/human/proc/lay_egg()

	set name = "Lay Egg (75)"
	set desc = "Lay an egg to produce huggers to impregnate prey with."
	set category = "Abilities"

	if(!aliens_allowed)
		src << "You begin to lay an egg, but hesitate. You suspect it isn't allowed."
		verbs -= /mob/living/carbon/human/proc/lay_egg
		return

	if(locate(/obj/effect/alien/egg) in get_turf(src))
		src << "There's already an egg here."
		return

	if(check_alien_ability(75,1,"egg sac"))
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>[src] has laid an egg!</B>"), 1)
		new /obj/effect/alien/egg(loc)

	return

// Drone verbs.
/mob/living/carbon/human/proc/evolve()
	set name = "Evolve (500)"
	set desc = "Produce an interal egg sac capable of spawning children. Only one queen can exist at a time."
	set category = "Abilities"

	if(alien_queen_exists())
		src << "<span class='notice'>We already have an active queen.</span>"
		return

	if(check_alien_ability(500))
		src << "\green You begin to evolve!"
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>[src] begins to twist and contort!</B>"), 1)
		src.set_species("Xenomorph Queen")

	return

/mob/living/carbon/human/proc/plant()
	set name = "Plant Weeds (50)"
	set desc = "Plants some alien weeds"
	set category = "Abilities"

	if(check_alien_ability(50,1,"resin spinner"))
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>[src] has planted some alien weeds!</B>"), 1)
		new /obj/effect/alien/weeds/node(loc)
	return

/mob/living/carbon/human/proc/corrosive_acid(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Corrosive Acid (200)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Abilities"

	if(!O in oview(1))
		src << "\green [O] is too far away."
		return

	// OBJ CHECK
	if(isobj(O))
		var/obj/I = O
		if(I.unacidable)	//So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
			src << "\green You cannot dissolve this object."
			return

	// TURF CHECK
	else if(istype(O, /turf/simulated))
		var/turf/T = O
		// R WALL
		if(istype(T, /turf/simulated/wall/r_wall))
			src << "\green You cannot dissolve this object."
			return
		// R FLOOR
		if(istype(T, /turf/simulated/floor/engine))
			src << "\green You cannot dissolve this object."
			return
		else// Not a type we can acid.
			return

	if(check_alien_ability(200,0,"acid gland"))
		new /obj/effect/alien/acid(get_turf(O), O)
		visible_message("\green <B>[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!</B>")

	return

/mob/living/carbon/human/proc/neurotoxin(mob/target as mob in oview())
	set name = "Spit Neurotoxin (50)"
	set desc = "Spits neurotoxin at someone, paralyzing them for a short time if they are not wearing protective gear."
	set category = "Abilities"

	if(!check_alien_ability(50,0,"acid gland"))
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot spit neurotoxin in your current state."
		return

	src << "\green You spit neurotoxin at [target]."

	for(var/mob/O in oviewers())
		if ((O.client && !(O.blinded )))
			O << "\red [src] spits neurotoxin at [target]!"

	//I'm not motivated enough to revise this. Prjectile code in general needs update.
	// Maybe change this to use throw_at? ~ Z
	var/turf/T = loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U,/turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if (U == T)
		usr.bullet_act(new /obj/item/projectile/energy/neurotoxin(usr.loc), get_organ_target())
		return
	if(!istype(U, /turf))
		return

	var/obj/item/projectile/energy/neurotoxin/A = new /obj/item/projectile/energy/neurotoxin(usr.loc)
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	A.process()
	return

/mob/living/carbon/human/proc/resin() // -- TLE
	set name = "Secrete Resin (75)"
	set desc = "Secrete tough malleable resin."
	set category = "Abilities"

	var/choice = input("Choose what you wish to shape.","Resin building") as null|anything in list("resin door","resin wall","resin membrane","resin nest") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
	if(!choice)
		return

	if(!check_alien_ability(75,1,"resin spinner"))
		return

	src << "\green You shape a [choice]."
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] vomits up a thick purple substance and begins to shape it!</B>"), 1)
	switch(choice)
		if("resin door")
			new /obj/structure/mineral_door/resin(loc)
		if("resin wall")
			new /obj/effect/alien/resin/wall(loc)
		if("resin membrane")
			new /obj/effect/alien/resin/membrane(loc)
		if("resin nest")
			new /obj/structure/stool/bed/nest(loc)
	return