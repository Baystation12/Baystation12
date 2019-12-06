//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/ladder
	name = "ladder"
	desc = "A ladder. You can climb it up and down."
	icon_state = "ladder01"
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1
	obj_flags = OBJ_FLAG_NOFALL

	var/allowed_directions = DOWN
	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down

	var/const/climb_time = 2 SECONDS
	var/static/list/climbsounds = list('sound/effects/ladder.ogg','sound/effects/ladder2.ogg','sound/effects/ladder3.ogg','sound/effects/ladder4.ogg')

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

/obj/structure/ladder/attackby(obj/item/I, mob/user)
	climb(user, I)

/turf/hitby(atom/movable/AM)
	if(isobj(AM))
		var/obj/structure/ladder/L = locate() in contents
		if(L)
			L.hitby(AM)
			return
	..()

/obj/structure/ladder/hitby(obj/item/I)
	var/area/room = get_area(src)
	if(!room.has_gravity())
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

/obj/structure/ladder/attack_hand(var/mob/M)
	climb(M)

/obj/structure/ladder/attack_ai(var/mob/M)
	var/mob/living/silicon/ai/ai = M
	if(!istype(ai))
		return
	var/mob/observer/eye/AIeye = ai.eyeobj
	if(istype(AIeye))
		instant_climb(AIeye)

/obj/structure/ladder/attack_robot(var/mob/M)
	climb(M)

/obj/structure/ladder/proc/instant_climb(var/mob/M)
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
	if(!M.Move(get_turf(src)))
		to_chat(M, "<span class='notice'>You fail to reach \the [src].</span>")
		return

	for (var/obj/item/grab/G in M)
		G.adjust_position()

	var/direction = target_ladder == target_up ? "up" : "down"

	M.visible_message("<span class='notice'>\The [M] begins climbing [direction] \the [src]!</span>",
	"You begin climbing [direction] \the [src]!",
	"You hear the grunting and clanging of a metal ladder being used.")

	target_ladder.audible_message("<span class='notice'>You hear something coming [direction] \the [src]</span>")

	if(do_after(M, climb_time, src))
		climbLadder(M, target_ladder, I)
		for (var/obj/item/grab/G in M)
			G.adjust_position(force = 1)

/obj/structure/ladder/attack_ghost(var/mob/M)
	instant_climb(M)

/obj/structure/ladder/proc/getTargetLadder(var/mob/M)
	if((!target_up && !target_down) || (target_up && !istype(target_up.loc, /turf/simulated/open) || (target_down && !istype(target_down.loc, /turf))))
		to_chat(M, "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>")
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

/mob/proc/may_climb_ladders(var/ladder)
	if(!Adjacent(ladder))
		to_chat(src, "<span class='warning'>You need to be next to \the [ladder] to start climbing.</span>")
		return FALSE
	if(incapacitated())
		to_chat(src, "<span class='warning'>You are physically unable to climb \the [ladder].</span>")
		return FALSE

	var/carry_count = 0
	for(var/obj/item/grab/G in src)
		if(!G.ladder_carry())
			to_chat(src, "<span class='warning'>You can't carry [G.affecting] up \the [ladder].</span>")
			return FALSE
		else
			carry_count++
	if(carry_count > 1)
		to_chat(src, "<span class='warning'>You can't carry more than one person up \the [ladder].</span>")
		return FALSE

	return TRUE

/mob/observer/ghost/may_climb_ladders(var/ladder)
	return TRUE

/obj/structure/ladder/proc/climbLadder(mob/user, target_ladder, obj/item/I = null)
	var/turf/T = get_turf(target_ladder)
	for(var/atom/A in T)
		if(!A.CanPass(user, user.loc, 1.5, 0))
			to_chat(user, "<span class='notice'>\The [A] is blocking \the [src].</span>")

			//We cannot use the ladder, but we probably can remove the obstruction
			var/atom/movable/M = A
			if(istype(M) && M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
				if(isnull(I))
					M.attack_hand(user)
				else
					M.attackby(I, user)

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
	icon = 'icons/obj/stairs.dmi'
	density = 0
	opacity = 0
	anchored = 1
	layer = RUNE_LAYER

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
	var/turf/target = get_step(GetAbove(A), dir)
	var/turf/source = A.loc
	var/turf/above = GetAbove(A)
	if(above.CanZPass(source, UP) && target.Enter(A, src))
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
		to_chat(A, "<span class='warning'>Something blocks the path.</span>")

/obj/structure/stairs/proc/upperStep(var/turf/T)
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