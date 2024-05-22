//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/ladder
	name = "ladder"
	desc = "A ladder. You can climb it up and down."
	icon_state = "ladder01"
	icon = 'icons/obj/structures/structures.dmi'
	density = FALSE
	opacity = 0
	anchored = TRUE
	obj_flags = OBJ_FLAG_NOFALL

	var/const/climb_time = 2 SECONDS

	var/static/list/climbsounds = list('sound/effects/ladder.ogg','sound/effects/ladder2.ogg','sound/effects/ladder3.ogg','sound/effects/ladder4.ogg')

	var/allowed_directions = DOWN
	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down

	/// Used by the BSD Instability event. If TRUE, it may cause the user to be teleported to a random other ladder.
	var/bluespace_affected = FALSE

	///Chance for a person climbing the ladder to be teleported to a random other ladder while bluespace affected.
	var/displacement_chance = 15


/obj/structure/ladder/Initialize()
	. = ..()
	// the upper will connect to the lower
	if(allowed_directions & DOWN) //we only want to do the top one, as it will initialize the ones before it.
		for(var/obj/structure/ladder/L in GetBelow(src))
			if(L.allowed_directions & UP)
				target_down = L
				L.target_up = src
				var/turf/T = get_turf(src)
				T.ReplaceWithLattice()
				return
	update_icon()


	set_extension(src, /datum/extension/turf_hand)


/obj/structure/ladder/Destroy()
	if(target_down)
		target_down.target_up = null
		target_down = null
	if(target_up)
		target_up.target_down = null
		target_up = null
	return ..()


/obj/structure/ladder/use_tool(obj/item/tool, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	climb(user, tool)


/turf/hitby(atom/movable/AM)
	if(isobj(AM))
		var/obj/structure/ladder/L = locate() in contents
		if(L)
			L.hitby(AM)
			return
	..()

/obj/structure/ladder/hitby(obj/item/I)
	if (istype(src, /obj/structure/ladder/up))
		return

	if(!has_gravity())
		return

	var/atom/blocker
	var/turf/landing = get_turf(target_down)
	for(var/atom/A in landing)
		if(!A.CanPass(I, I.loc, 1.5, 0))
			blocker = A
			break
	if(blocker)
		visible_message(SPAN_WARNING("\The [I] fails to go down \the [src], blocked by the [blocker]!"))
	else
		visible_message(SPAN_WARNING("\The [I] goes down \the [src]!"))
		I.forceMove(landing)
		landing.visible_message(SPAN_WARNING("\The [I] falls from the top of \the [target_down]!"))

/obj/structure/ladder/attack_hand(mob/M)
	climb(M)

/obj/structure/ladder/attack_ai(mob/M)
	var/mob/living/silicon/ai/ai = M
	if(!istype(ai))
		return
	var/mob/observer/eye/AIeye = ai.eyeobj
	if(istype(AIeye))
		instant_climb(AIeye)

/obj/structure/ladder/attack_robot(mob/M)
	climb(M)

/obj/structure/ladder/proc/instant_climb(mob/M)
	var/atom/target_ladder = getTargetLadder(M)
	if(target_ladder)
		M.dropInto(target_ladder.loc)

/obj/structure/ladder/proc/climb(mob/M, obj/item/I = null)
	if(!M.may_climb_ladders(src))
		return

	add_fingerprint(M)
	var/obj/structure/ladder/target_ladder = getTargetLadder(M)
	if(!target_ladder)
		return
	if (bluespace_affected && prob(displacement_chance))
		var/list/obj/structure/ladder/other_ladders= list()
		var/list/zlevels = GetConnectedZlevels(z)
		for (var/obj/structure/ladder/ladder)
			if (src != ladder && (ladder.z in zlevels))
				other_ladders += ladder
		target_ladder = pick(other_ladders)
	if(!M.Move(get_turf(src)))
		to_chat(M, SPAN_NOTICE("You fail to reach \the [src]."))
		return

	for (var/obj/item/grab/G in M)
		G.adjust_position()

	var/direction = target_ladder == target_up ? "up" : "down"

	M.visible_message(SPAN_NOTICE("\The [M] begins climbing [direction] \the [src]!"),
	"You begin climbing [direction] \the [src]!",
	"You hear the grunting and clanging of a metal ladder being used.")

	target_ladder.audible_message(SPAN_NOTICE("You hear something coming [direction] \the [src]"))

	if(do_after(M, climb_time, src, DO_PUBLIC_UNIQUE))
		climbLadder(M, target_ladder, I)
		if (bluespace_affected && prob(20))
			to_chat(M, SPAN_WARNING("You feel like you didn't end up where you were supposed to..."))

		for (var/obj/item/grab/G in M)
			G.adjust_position(force = 1)

/obj/structure/ladder/attack_ghost(mob/M)
	instant_climb(M)

/obj/structure/ladder/proc/getTargetLadder(mob/M)
	if((!target_up && !target_down) || (target_up && !istype(target_up.loc, /turf/simulated/open) || (target_down && !istype(target_down.loc, /turf))))
		to_chat(M, SPAN_NOTICE("\The [src] is incomplete and can't be climbed."))
		return

	if(target_down && target_up)
		var/direction = alert(M,"Do you want to go up or down?", "Ladder", "Up", "Down", "Cancel")

		if(direction == "Cancel")
			return

		if(!M.may_climb_ladders(src))
			return

		switch(direction)
			if("Up")
				return target_up
			if("Down")
				return target_down
	else
		return target_down || target_up

/mob/proc/may_climb_ladders(ladder)
	if(!Adjacent(ladder))
		to_chat(src, SPAN_WARNING("You need to be next to \the [ladder] to start climbing."))
		return FALSE
	if(incapacitated())
		to_chat(src, SPAN_WARNING("You are physically unable to climb \the [ladder]."))
		return FALSE

	var/carry_count = 0
	for(var/obj/item/grab/G in src)
		if(!G.ladder_carry())
			to_chat(src, SPAN_WARNING("You can't carry [G.affecting] up \the [ladder]."))
			return FALSE
		else
			carry_count++
	if(carry_count > 1)
		to_chat(src, SPAN_WARNING("You can't carry more than one person up \the [ladder]."))
		return FALSE

	return TRUE

/mob/observer/ghost/may_climb_ladders(ladder)
	return TRUE

/obj/structure/ladder/proc/climbLadder(mob/user, target_ladder, obj/item/I = null)
	var/turf/T = get_turf(target_ladder)
	for(var/atom/A in T)
		if(!A.CanPass(user, user.loc, 1.5, 0))
			to_chat(user, SPAN_NOTICE("\The [A] is blocking \the [src]."))

			//We cannot use the ladder, but we probably can remove the obstruction
			var/atom/movable/M = A
			if(istype(M) && M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
				if(isnull(I))
					M.attack_hand(user)
				else
					M.use_tool(I, user)

			return FALSE

	playsound(src, pick(climbsounds), 50)
	playsound(target_ladder, pick(climbsounds), 50)
	return user.Move(T)

/obj/structure/ladder/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/ladder/on_update_icon()
	icon_state = "ladder[!!(allowed_directions & UP)][!!(allowed_directions & DOWN)]"

/obj/structure/ladder/up
	allowed_directions = UP
	icon_state = "ladder10"

/obj/structure/ladder/updown
	allowed_directions = UP|DOWN
	icon_state = "ladder11"

/obj/structure/stairs
	name = "stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon = 'icons/obj/structures/stairs.dmi'
	icon_state = "above"
	density = FALSE
	opacity = 0
	anchored = TRUE
	layer = RUNE_LAYER

	///Used by the BSD instability event. Causes users to sometimes randomly appear on the wrong stairs
	var/bluespace_affected = FALSE

	/// Chance of a user being displaced to a random set of stairs while its bluespace affected.
	var/displacement_chance = 15


/obj/structure/stairs/Initialize()
	for(var/turf/turf in locs)
		var/turf/simulated/open/above = GetAbove(turf)
		if(!above)
			warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
			return INITIALIZE_HINT_QDEL
		if(!istype(above))
			above.ChangeTurf(/turf/simulated/open)
	. = ..()

/obj/structure/stairs/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(get_dir(loc, target) == dir && upperStep(mover.loc))
		return FALSE
	return ..()

/obj/structure/stairs/Bumped(atom/movable/A)
	var/turf/above = GetAbove(A)
	if (above)
		var/turf/target = get_step(above, dir)
		var/turf/source = A.loc
		if(above.CanZPass(source, UP) && target.Enter(A, src))
			if (bluespace_affected)
				var/list/obj/structure/other_stairs= list()
				for (var/obj/structure/stairs/stair)
					if (src != stair && (stair.z in GetConnectedZlevels(above.z)))
						other_stairs += stair
				var/obj/structure/stairs/other_stair = pick(other_stairs)
				if (prob(displacement_chance))
					target = get_turf(other_stair)
					if (prob(20))
						to_chat(A, SPAN_WARNING("You feel turned around..."))
			A.forceMove(target)
			if(isliving(A))
				var/mob/living/L = A
				if(L.pulling)
					L.pulling.forceMove(target)
			if(ishuman(A))
				var/mob/living/carbon/human/H = A
				if(H.has_footsteps())
					playsound(source, 'sound/effects/stairs_step.ogg', 50)
					playsound(target, 'sound/effects/stairs_step.ogg', 50)
		else
			to_chat(A, SPAN_WARNING("Something blocks the path."))
	else
		to_chat(A, SPAN_NOTICE("There is nothing of interest in this direction."))

/obj/structure/stairs/proc/upperStep(turf/T)
	return (T == loc)

/obj/structure/stairs/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

// type paths to make mapping easier.
/obj/structure/stairs/north
	dir = NORTH
	bound_height = 64
	bound_y = -32
	pixel_y = -32

/obj/structure/stairs/south
	dir = SOUTH
	bound_height = 64

/obj/structure/stairs/east
	dir = EAST
	bound_width = 64
	bound_x = -32
	pixel_x = -32

/obj/structure/stairs/west
	dir = WEST
	bound_width = 64

/obj/structure/stairs/short
	bound_height = 32
	bound_width = 32

/obj/structure/stairs/short/west
	dir = WEST
