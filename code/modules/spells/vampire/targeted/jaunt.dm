// Enables the vampire to be untouchable and walk through walls and other solid things.
/spell/targeted/vampire/jaunt
	name = "Toggle Veil Walking (80)"
	desc = "You enter the veil, leaving only an incorporeal manifestation of you visible to the others."
	spell_flags = Z2NOCAST | NEEDSVAMPIRE
	school = "vampirism"
	charge_max = 12 SECONDS
	blood_cost = 80

/spell/targeted/vampire/jaunt/cast()
	var/datum/vampire/vampire = usr.mind.vampire_power(0, 0, 1)
	if(!vampire)
		return

	if(vampire.holder)
		vampire.holder.deactivate()
		var/obj/effect/dummy/veil_walk/holder = new /obj/effect/dummy/veil_walk(get_turf(loc))
		holder.activate(src)

		log_and_message_admins("activated veil walk.")

// Veilwalk's dummy holder
/obj/effect/dummy/veil_walk
	name = "a red ghost"
	desc = "A red, shimmering presence."
	icon = 'icons/mob/mob.dmi'
	icon_state = "blank"
	density = 0

	var/last_valid_turf = null
	var/can_move = 1
	var/mob/owner_mob = null
	var/datum/vampire/owner_vampire = null
	var/warning_level = 0

/obj/effect/dummy/veil_walk/Destroy()
	eject_all()
	return ..()

/obj/effect/dummy/veil_walk/proc/eject_all()
	for (var/atom/movable/A in src)
		A.forceMove(loc)
		if(ismob(A))
			var/mob/M = A
			M.reset_view(null)

/obj/effect/dummy/veil_walk/relaymove(var/mob/user, direction)
	if(!can_move)
		return

	var/turf/new_loc = get_step(src, direction)
	if(new_loc.flags & NOJAUNT || newloc.blessed)
		to_chat(usr, "<span class='warning'>Some strange aura is blocking the way!</span>")
		return

	forceMove(new_loc)
	var/turf/T = get_turf(loc)
	if(!T.contains_dense_objects())
		last_valid_turf = T

	can_move = 0
	sleep(2)
	can_move = 1

/obj/effect/dummy/veil_walk/Process()
	set waitfor = 0
	if(owner_mob.stat)
		if(owner_mob.stat == UNCONSCIOUS)
			to_chat(owner_mob, "<span class='warning'>You cannot maintain this form while unconcious.</span>")
			sleep(10)
			if(owner_mob && owner_mob.stat == UNCONSCIOUS)
				to_chat(owner_mob, "<span class='danger'>You are ejected from the Veil.</span>")
				deactivate()
		else
			deactivate()
			return

	if(owner_vampire.blood_usable >= 5)
		owner_vampire.use_blood(5)

		switch(warning_level)
			if(0)
				if(owner_vampire.blood_usable <= 5 * 20)
					to_chat(owner_mob, "<span class='notice'>Your pool of blood is diminishing. You cannot stay in the veil for too long.</span>")
					warning_level = 1
			if(1)
				if(owner_vampire.blood_usable <= 5 * 10)
					to_chat(owner_mob, "<span class='warning'>You will be ejected from the veil soon, as your pool of blood is running dry.</span>")
					warning_level = 2
			if(2)
				if(owner_vampire.blood_usable <= 5 * 5)
					to_chat(owner_mob, "<span class='danger'>You cannot sustain this form for any longer!</span>")
					warning_level = 3
	else
		deactivate()

/obj/effect/dummy/veil_walk/proc/activate(var/mob/owner)
	if(!owner)
		qdel(src)
		return

	owner_mob = owner
	owner_vampire = owner.vampire_power()
	if(!owner_vampire)
		qdel(src)
		return

	owner_vampire.holder = src

	owner.vampire_phase_out(get_turf(owner.loc))

	icon_state = "veil_ghost"

	last_valid_turf = get_turf(owner.loc)
	owner.loc = src

	desc += " Its features look faintly alike [owner.name]'s."

	START_PROCESSING(SSprocessing, src)

/obj/effect/dummy/veil_walk/proc/deactivate()


	can_move = 0

	icon_state = "blank"

	owner_mob.vampire_phase_in(get_turf(loc))

	eject_all()

	owner_mob = null

	owner_vampire.holder = null
	owner_vampire = null
	STOP_PROCESSING(SSprocessing, src)

	qdel(src)

/obj/effect/dummy/veil_walk/proc/kick_unconcious()
	if(owner_mob && owner_mob.stat == UNCONSCIOUS)
		to_chat(owner_mob, "<span class='danger'>You are ejected from the Veil.</span>")
		deactivate()
		return

/obj/effect/dummy/veil_walk/ex_act(vars)
	return

/obj/effect/dummy/veil_walk/bullet_act(vars)
	return