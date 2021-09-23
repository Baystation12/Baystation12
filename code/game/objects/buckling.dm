/obj
	var/can_buckle = 0
	var/buckle_movable = 0
	var/buckle_dir = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_pixel_shift = "x=0;y=0;z=0" //where the buckled mob should be pixel shifted to, or null for no pixel shift control
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/mob/living/buckled_mob = null

/obj/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && buckled_mob)
		user_unbuckle_mob(user)

/obj/attack_robot(mob/user)
	. = ..()
	if (can_buckle && buckled_mob)
		user_unbuckle_mob(user)

/obj/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M))
		user_buckle_mob(M, user)

/obj/Destroy()
	unbuckle_mob()
	return ..()


/obj/proc/buckle_mob(mob/living/M)
	if(buckled_mob) //unless buckled_mob becomes a list this can cause problems
		return 0
	if(!istype(M) || (M.loc != loc) || !M.can_be_buckled || M.buckled || M.pinned.len || (buckle_require_restraints && !M.restrained()))
		return 0
	if(ismob(src))
		var/mob/living/carbon/C = src //Don't wanna forget the xenos.
		if(M != src && C.incapacitated())
			return 0

	M.buckled = src
	M.facing_dir = null
	M.set_dir(buckle_dir ? buckle_dir : dir)
	M.UpdateLyingBuckledAndVerbStatus()
	M.update_floating()
	buckled_mob = M

	post_buckle_mob(M)
	return 1

/obj/proc/unbuckle_mob()
	if(buckled_mob && buckled_mob.buckled == src)
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.UpdateLyingBuckledAndVerbStatus()
		buckled_mob.update_floating()
		buckled_mob = null

		post_buckle_mob(.)

/obj/proc/post_buckle_mob(mob/living/M)
	if(buckle_pixel_shift)
		if(M == buckled_mob)
			var/list/pixel_shift = cached_key_number_decode(buckle_pixel_shift)
			animate(M, pixel_x = M.default_pixel_x + pixel_shift["x"], pixel_y = M.default_pixel_y + pixel_shift["y"], pixel_z = M.default_pixel_z + pixel_shift["z"], 4, 1, LINEAR_EASING)
		else
			animate(M, pixel_x = M.default_pixel_x, pixel_y = M.default_pixel_y, pixel_z = M.default_pixel_z, 4, 1, LINEAR_EASING)

/obj/proc/user_buckle_mob(mob/living/M, mob/user)
	if(!user.Adjacent(M) || istype(user, /mob/living/silicon/pai) || (M != user && user.incapacitated()))
		return 0
	if(M == buckled_mob)
		return 0
	if (M.grabbed_by.len)
		to_chat(user, SPAN_WARNING("\The [M] is being grabbed and cannot be buckled."))
		return FALSE
	if (!M.can_be_buckled)
		to_chat(user, SPAN_WARNING("\The [M] cannot be buckled."))
		return FALSE

	add_fingerprint(user)
	unbuckle_mob()

	//can't buckle unless you share locs so try to move M to the obj.
	if(M.loc != src.loc)
		step_towards(M, src)

	. = buckle_mob(M)
	if(.)
		if(M == user)
			M.visible_message(\
				"<span class='notice'>\The [M.name] buckles themselves to \the [src].</span>",\
				"<span class='notice'>You buckle yourself to \the [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			M.visible_message(\
				"<span class='danger'>\The [M.name] is buckled to \the [src] by \the [user.name]!</span>",\
				"<span class='danger'>You are buckled to \the [src] by \the [user.name]!</span>",\
				"<span class='notice'>You hear metal clanking.</span>")

/obj/proc/user_unbuckle_mob(mob/user)
	var/mob/living/M = unbuckle_mob()
	if(M)
		if(M != user)
			M.visible_message(\
				"<span class='notice'>\The [M.name] was unbuckled by \the [user.name]!</span>",\
				"<span class='notice'>You were unbuckled from \the [src] by \the [user.name].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			M.visible_message(\
				"<span class='notice'>\The [M.name] unbuckled themselves!</span>",\
				"<span class='notice'>You unbuckle yourself from \the [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		add_fingerprint(user)
	return M
