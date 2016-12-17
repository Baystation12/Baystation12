/datum/technomancer/spell/illusion
	name = "Illusion"
	desc = "Allows you to create and control a holographic illusion, that can take the form of most object or entities."
	enhancement_desc = "Illusions will be made of hard light, allowing the interception of attacks, appearing more realistic."
	cost = 25
	obj_path = /obj/item/weapon/spell/illusion
	ability_icon_state = "tech_illusion"
	category = UTILITY_SPELLS

/obj/item/weapon/spell/illusion
	name = "illusion"
	icon_state = "illusion"
	desc = "Now you can toy with the minds of the whole colony."
	aspect = ASPECT_LIGHT
	cast_methods = CAST_RANGED | CAST_USE
	var/atom/movable/copied = null
	var/mob/living/simple_animal/illusion/illusion = null

/obj/item/weapon/spell/illusion/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		if(pay_energy(500))
			copied = AM
			update_icon()
			to_chat(user,"<span class='notice'>You've copied \the [AM]'s appearance.</span>")
			sound_to(user,'sound/weapons/flash.ogg')
			return 1
	else if(istype(hit_atom, /turf))
		var/turf/T = hit_atom
		if(!illusion)
			if(!copied)
				copied = user
			if(pay_energy(1000)) // 4
				illusion = new(T)
				illusion.copy_appearance(copied)
				if(ishuman(copied))
					var/mob/living/carbon/human/H = copied
					// This is to try to have the illusion move at the same rate the real mob world.
					illusion.step_delay = max(H.movement_delay() + 4, 3)
				to_chat(user,"<span class='notice'>An illusion of \the [copied] is made on \the [T].</span>")
				sound_to(user,'sound/effects/pop.ogg')
				return 1
		else
			if(pay_energy(300))
				spawn(1)
					illusion.walk_loop(T)

/obj/item/weapon/spell/illusion/on_use_cast(mob/user)
	if(illusion)
		var/choice = alert(user, "Would you like to have \the [illusion] speak, or do an emote?", "Illusion", "Speak","Emote","Cancel")
		switch(choice)
			if("Cancel")
				return
			if("Speak")
				var/what_to_say = input(user, "What do you want \the [illusion] to say?","Illusion Speak") as null|text
				//what_to_say = sanitize(what_to_say) //Sanitize occurs inside say() already.
				if(what_to_say)
					illusion.say(what_to_say)
			if("Emote")
				var/what_to_emote = input(user, "What do you want \the [illusion] to do?","Illusion Emote") as null|text
				if(what_to_emote)
					illusion.emote(what_to_emote)

/obj/item/weapon/spell/illusion/Destroy()
	if(illusion)
		qdel(illusion)
	return ..()

// Makes a tiny overlay of the thing the player has copied, so they can easily tell what they currently have.
/obj/item/weapon/spell/illusion/update_icon()
	overlays.Cut()
	if(copied)
		var/image/temp_image = image(copied)
		var/matrix/M = matrix()
		M.Scale(0.5, 0.5)
		temp_image.transform = M
//		temp_image.pixel_y = 8
		src.overlays.Add(temp_image)


/mob/living/simple_animal/illusion
	name = "illusion" // gets overwritten
	desc = "If you can read me, the game broke.  Please report this to a coder."
	resistance = 1000 // holograms are tough
	wander = 0
	response_help   = "pushes a hand through"
	response_disarm = "tried to disarm"
	response_harm   = "tried to punch"
	var/atom/movable/copying = null
	universal_speak = 1
	var/realistic = 0
	var/list/path = list() //Used for AStar pathfinding.
	var/walking = 0
	var/step_delay = 10

/mob/living/simple_animal/illusion/proc/copy_appearance(var/atom/movable/thing_to_copy)
	if(!thing_to_copy)
		return 0
	name = thing_to_copy.name
	desc = thing_to_copy.desc
	gender = thing_to_copy.gender
	appearance = thing_to_copy.appearance
	copying = thing_to_copy
	return 1

// We use special movement code for illusions, because BYOND's default pathfinding will use diagonal movement if it results
// in the shortest path.  As players are incapable of moving in diagonals, we must do this or else illusions will not be convincing.
/mob/living/simple_animal/illusion/proc/calculate_path(var/turf/targeted_loc)
	if(!path.len || !path)
		spawn(0)
			path = AStar(loc, targeted_loc, /turf/proc/CardinalTurfs, /turf/proc/Distance, 0, 10, id = null)
			if(!path)
				path = list()
		return

/mob/living/simple_animal/illusion/proc/walk_path(var/turf/targeted_loc)
	if(path && path.len)
		step_to(src, path[1])
		path -= path[1]
		return
	else
		if(targeted_loc)
			calculate_path(targeted_loc)

/mob/living/simple_animal/illusion/proc/walk_loop(var/turf/targeted_loc)
	if(walking) //Already busy moving somewhere else.
		return 0
	walking = 1
	calculate_path(targeted_loc)
	if(!targeted_loc)
		walking = 0
		return 0
	if(path.len == 0)
		calculate_path(targeted_loc)
	while(loc != targeted_loc)
		walk_path(targeted_loc)
		sleep(step_delay)
	walking = 0
	return 1

// Because we can't perfectly duplicate some examine() output, we directly examine the AM it is copying.  It's messy but
// this is to prevent easy checks from the opposing force.
/mob/living/simple_animal/illusion/examine(mob/user)
	if(copying)
		copying.examine(user)
		return
	..()

/mob/living/simple_animal/illusion/bullet_act(var/obj/item/projectile/P)
	if(!P)
		return

	if(realistic)
		return ..()

	return PROJECTILE_FORCE_MISS

/mob/living/simple_animal/illusion/attack_hand(mob/living/carbon/human/M)
	if(!realistic)
		playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		visible_message("<span class='warning'>[M]'s hand goes through \the [src]!</span>")
		return
	else
		switch(M.a_intent)

			if(I_HELP)
				M.visible_message("<span class='notice'>[M] hugs [src] to make \him feel better!</span>", \
				"<span class='notice'>You hug [src] to make \him feel better!</span>")
				playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

			if(I_DISARM)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<span class='danger'>[M] attempted to disarm [src]!</span>")
				M.do_attack_animation(src)

			if(I_GRAB)
				..()

			if(I_HURT)
				adjustBruteLoss(harm_intent_damage)
				M.visible_message("<span class='warning'>[M] [response_harm] \the [src]</span>")
				M.do_attack_animation(src)

	return

/mob/living/simple_animal/illusion/ex_act()
	return
