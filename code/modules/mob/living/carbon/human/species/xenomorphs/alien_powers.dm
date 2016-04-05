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

	var/obj/item/organ/xenos/plasmavessel/I = internal_organs_by_name["plasma vessel"]
	if(!istype(I)) return

	if(amount)
		I.stored_plasma += amount
	I.stored_plasma = max(0,min(I.stored_plasma,I.max_plasma))

/mob/living/carbon/human/proc/check_alien_ability(var/cost,var/needs_foundation,var/needs_organ)

	var/obj/item/organ/xenos/plasmavessel/P = internal_organs_by_name["plasma vessel"]
	if(!istype(P))
		src << "<span class='danger'>Your plasma vessel has been removed!</span>"
		return

	if(needs_organ)
		var/obj/item/organ/I = internal_organs_by_name[needs_organ]
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

// this is still a verb because its much easier to right click what you want and use the menu.
/mob/living/carbon/human/proc/pry_open(obj/machinery/door/A in oview(1))
	set name = "Pry Open Airlock"
	set desc = "Pry open an airlock with your claws."
	set category = null

	if(!istype(A))
		return

	if(!A.Adjacent(src))
		src << "<span class='warning'>\The [A] is too far away.</span>"
		return

	if(!A.density)
		return

	src.visible_message("\The [src] begins to pry open \the [A]!")

	if(!do_after(src,120,A))
		return

	src.visible_message("\The [src] slices \the [A]'s controls, ripping it open!")
	A.do_animate("spark")
	sleep(6)
	A.stat |= BROKEN
	A.open(1)


/*********************
* SPELL VERSIONS     *
*********************/

/spell/targeted/alien
	name = "alien"
	panel = "Hive Powers"

/spell/targeted/alien/plasma
	charge_type = Sp_HOLDVAR
	holder_var_type = "Plasma"
	var/requires_turf = 0
	var/required_organ

/spell/targeted/alien/plasma/take_charge(mob/user = user, var/skipcharge)
	return 1
/spell/targeted/alien/plasma/cast_check(skipcharge = 0,mob/user = usr)
	if(!..(skipcharge,user))
		return 0
	if(!skipcharge)
		if(!istype(user,/mob/living/carbon/human))
			return 0
		var/mob/living/carbon/human/H = user
		if(!H.check_alien_ability(holder_var_amount,requires_turf, required_organ))
			return 0
	return 1


/spell/targeted/alien/plasma/evolve
	name = "Evolve"
	desc = "Produce an internal egg sac capable of spawning children. Only one queen can exist at a time."
	spell_flags = INCLUDEUSER
	range = -1

	holder_var_amount = 500

	hud_state = "alien_evolve_drone"

/spell/targeted/alien/plasma/evolve/check_charge(var/skipcharge, mob/user)
	if(alien_queen_exists() && !skipcharge)
		src << "<span class='notice'>We already have an active queen.</span>"
		return 0
	return 1

/spell/targeted/alien/plasma/evolve/cast(var/list/targets, mob/user)
	for(var/mob/M in targets)
		var/mob/living/carbon/human/H = M //we can do this because we check if the target is human in the take_charge proc
		H.visible_message("<span class='alium'><B>[src] begins to twist and contort!</B></span>", "<span class='alium'>You begin to evolve!</span>")
		H.set_species("Xenomorph Queen")

/spell/targeted/alien/plasma/resin
	name = "Secrete Resin"
	desc = "Secrete tough, malleable resin."
	holder_var_amount = 75
	requires_turf = 1
	required_organ = "resin spinner"
	spell_flags = INCLUDEUSER
	range = -1

	hud_state = "alien_resin"
	var/target_type

/spell/targeted/alien/plasma/resin/cast_check(skipcharge = 0, mob/user = usr)
	if(!skipcharge)
		target_type = input("Choose what you wish to shape.","Resin building") as null|anything in list("resin door","resin wall","resin membrane","resin nest") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
		if(!target_type)
			return 0
	return ..()

/spell/targeted/alien/plasma/resin/cast(var/list/targets, mob/user)
	if(!target_type)
		return
	var/mob/target = targets[1]
	target.visible_message("<span class='warning'><B>[target] vomits up a thick purple substance and begins to shape it!</B></span>", "<span class='alium'>You shape a [target_type].</span>")
	switch(target_type)
		if("resin door")
			new /obj/machinery/door/unpowered/simple/resin(get_turf(target))
		if("resin wall")
			new /obj/structure/alien/resin/wall(get_turf(target))
		if("resin membrane")
			new /obj/structure/alien/resin/membrane(get_turf(target))
		if("resin nest")
			new /obj/structure/bed/nest(get_turf(target))

/spell/targeted/alien/plasma/xeno_infest
	name = "Infest"
	desc = "Link a victim to the hivemind."
	range = 1
	spell_flags = SELECTABLE

	holder_var_amount = 500
	required_organ = "egg sac"
	requires_turf = 1

	compatible_mobs = list(/mob/living/carbon/human)
	hud_state = "alien_evolve_praetorian"

/spell/targeted/alien/plasma/xeno_infest/choose_targets(mob/user = usr, var/list/override_targets)
	var/list/possible
	if(override_targets.len)
		possible = override_targets
	else
		possible = ..()

	var/target = possible[1]
	var/mob/living/carbon/human/M = target
	if(!M.mind)
		user << "<span class='warning'>This mindless flesh adds nothing to the hive.</span>"
		return null
	if(M.species.get_bodytype() == "Xenomorph" || !isnull(M.internal_organs_by_name["hive node"]))
		user << "<span class='warning'>They are already part of the hive.</span>"
		return null
	var/obj/item/organ/affecting = M.get_organ("chest")
	if(!affecting || (affecting.status & ORGAN_ROBOT))
		user << "<span class='warning'>This form is not compatible with our physiology.</span>"
		return null

	return list(target)

/spell/targeted/alien/plasma/xeno_infest/cast(var/list/targets, mob/user)
	var/target = targets[1]
	var/mob/living/carbon/human/M = target
	user.visible_message("<span class='danger'>\The [user] crouches over \the [M], extending a hideous protuberance from its head!</span>")

	if(!do_mob(user,M, 150))
		return

	if(!M || !M.Adjacent(user))
		user << "<span class='warning'>They are too far away.</span>"
		return

	var/obj/item/organ/affecting = M.get_organ("chest")
	if(M.species.get_bodytype() == "Xenomorph" || !isnull(M.internal_organs_by_name["hive node"]) || !affecting || (affecting.status & ORGAN_ROBOT)) //BUT WHAT IF THEY MAGICALLY CHANGE INTO ALIEN ROBOT?!?
		return

	user.visible_message("<span class='danger'>\The [user] regurgitates something into \the [M]'s torso!</span>")
	M << "<span class='danger'>A hideous lump of alien mass strains your ribcage as it settles within!</span>"
	var/obj/item/organ/xenos/hivenode/node = new(affecting)
	node.replaced(M,affecting)

/spell/targeted/alien/plasma/plant
	name = "Plant"
	desc = "Plants some alien weeds"
	holder_var_amount = 50
	range = -1
	spell_flags = INCLUDEUSER
	requires_turf = 1
	required_organ = "resin spinner"
	hud_state = "alien_plant"

/spell/targeted/alien/plasma/plant/check_charge(var/skipcharge, mob/user)
	if(locate(/obj/structure/alien/node) in get_turf(user))
		user << "There is already a plant node here."
		return 0
	return 1

/spell/targeted/alien/plasma/plant/cast(var/list/targets, mob/user)
	for(var/mob/M in targets)
		M.visible_message("<span class='alium'><B>[M] has planted some alien weeds!</B></span>")
		new /obj/structure/alien/node(get_turf(M))

/spell/targeted/alien/plasma/lay_egg
	name = "Lay Egg"
	desc = "Lay an egg to produce huggers to impregnate prey with."
	spell_flags = INCLUDEUSER
	range = -1
	holder_var_amount = 75
	requires_turf = 1
	required_organ = "egg sac"
	hud_state = "alien_egg"

/spell/targeted/alien/plasma/lay_egg/check_charge(var/skipcharge, mob/user)
	if(!config.alien_breeding_allowed && !skipcharge)
		user << "You begin to lay an egg, but hesitate. You suspect it isn't allowed."
		user.remove_spell(src)
		return 0

	if(locate(/obj/structure/alien/egg) in get_turf(user))
		user << "There's already an egg here."
		return 0
	return 1


/spell/targeted/alien/plasma/lay_egg/cast(var/list/targets, mob/user)
	for(var/mob/M in targets)
		M.visible_message("<span class='alium'><B>[M] has laid an egg!</B></span>")
		new /obj/structure/alien/egg(get_turf(M))

/spell/hand/alien
	hand_name = "alien ability"
	panel = "Hive Powers"
	spell_delay = 10
	spell_flags = 0
	move_delay = 5
	empty_hand_message = "You must be unarmed! Gripping things distracts you!"
	custom_stat = 1
	charge_max = 0
	var/plasma_cost = 0
	var/organ_requirement
	var/turf_requirement = 0

/spell/hand/alien/get_stat()
	if(!plasma_cost)
		return "Free"
	return "[plasma_cost] Plasma per"

/spell/hand/alien/take_hand_charge(var/mob/user, var/obj/item/magic_hand/hand)
	if(!istype(user,/mob/living/carbon/human))
		return 0
	var/mob/living/carbon/human/H = user
	if(!H.check_alien_ability(plasma_cost,turf_requirement,organ_requirement))
		return 0
	return 1

/spell/hand/alien/neurotoxin
	name = "neurotoxin"
	compatible_targets = list(/atom)
	plasma_cost = 50
	organ_requirement = "acid gland"
	not_ready_message = "You need more time to regenerate acid!"
	hud_state = "alien_neurotoxin"

/spell/hand/alien/neurotoxin/cast_hand(var/atom/A, var/mob/living/user, var/obj/item/magic_hand/hand)
	user.visible_message("<span class='warning'>[user] spits neurotoxin!</span>", "<span class='alium'>You spit neurotoxin.</span>")
	var/obj/item/projectile/energy/neurotoxin/N = new/obj/item/projectile/energy/neurotoxin(user.loc)
	N.launch(A,user.get_organ_target())
	return 1

/spell/hand/alien/corrosive
	name = "Corrosive Acid"
	compatible_targets = list(/obj, /turf)
	plasma_cost = 200
	organ_requirement = "acid gland"
	move_delay = 10
	not_ready_message = "You need more time to regenerate your corrosive acid!"
	range = 1

	hud_state = "alien_acid"

/spell/hand/alien/corrosive/valid_target(var/atom/a,var/mob/user)
	if(!..())
		return 0

	var/can_melt = 1
	if(istype(a,/obj))
		var/obj/O = a
		if(O.unacidable)
			can_melt = 0
	else
		if(istype(a,/turf/simulated/wall))
			var/turf/simulated/wall/W = a
			if(W.material.flags & MATERIAL_UNMELTABLE)
				can_melt = 0
		else if(istype(a,/turf/simulated/floor))
			var/turf/simulated/floor/F = a
			if(F.flooring && (F.flooring.flags & TURF_ACID_IMMUNE))
				can_melt = 0
	if(!can_melt)
		src << "<span class='alium'>You cannot dissolve this object.</span>"
	return can_melt

/spell/hand/alien/corrosive/cast_hand(var/atom/A, var/mob/living/user, var/obj/item/magic_hand/hand)
	new /obj/effect/acid(get_turf(A), A)
	user.visible_message("<span class='alium'><B>[usr] vomits globs of vile stuff all over [A]. It begins to sizzle and melt under the bubbling mess of acid!</B></span>")

/spell/hand/alien/transfer_plasma
	name = "Transfer Plasma"
	desc = "Transfer Plasma to another alien."

	plasma_cost = 20
	range = 1
	spell_delay = 5
	move_delay = 5
	compatible_targets = list(/mob/living/carbon/human)
	hud_state = "alien_transfer"

/spell/hand/alien/transfer_plasma/valid_target(var/atom/a,var/mob/user)
	if(!..())
		return 0
	var/mob/living/carbon/human/target = a
	var/obj/item/organ/xenos/plasmavessel/ves = target.internal_organs_by_name["plasma vessel"]
	if(!istype(ves))
		user << "<span class='alium'>Their plasma vessel is missing!</span>"
		return 0
	return 1

/spell/hand/alien/transfer_plasma/cast_hand(var/atom/A, var/mob/living/user, var/obj/item/magic_hand/hand)
	var/mob/living/carbon/human/target = A
	target.gain_plasma(plasma_cost)
	target << "<span class='alium'>[user] has transfered [plasma_cost] plasma to you.</span>"
	user << "<span class='alium'>You have transferred [plasma_cost] plasma to [target].</span>"