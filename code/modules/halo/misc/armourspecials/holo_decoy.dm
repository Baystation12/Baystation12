
//CaelAislinn - based off the illusion spell from technomancers on Citadel Station 13. Used with thanks

/datum/armourspecials/holo_decoy
	var/duration = 100
	var/cooldown = 200	//deciseconds
	var/time_off_cooldown = 0
	var/time_off_active = 0
	var/mob/living/simple_animal/illusion/decoy_holo
	var/spawn_dir = "Forward"
	var/mob/owner
	var/obj/item/clothing/suit/armor/special/source_item

/datum/armourspecials/holo_decoy/New(var/obj/item/controller)
	..()
	source_item = controller
	source_item.action_button_name = "Activate Holo Decoy"

/datum/armourspecials/holo_decoy/on_equip(var/obj/source_armour)
	owner = source_armour.loc
	source_item = source_armour

/datum/armourspecials/holo_decoy/on_drop(var/obj/source_armour)
	owner = null

/*
/datum/armourspecials/holo_decoy/proc/pick_dir()
	spawn_dir = alert("What direction should the holo decoy move in?","Holo decoy direction","Left","Right","Forward")
*/

/datum/armourspecials/holo_decoy/tryemp(var/severity)
	var/extra_cooldown = max(cooldown * severity, cooldown / 2)
	time_off_cooldown = max(world.time + extra_cooldown, time_off_cooldown)
	if(owner)
		to_chat(user, "<span class='warning'>The EMP temporarily disables the hologram decoy emitter contained in your [source_item]!.</span>")
	if(decoy_holo)
		decoy_holo.emp_act(severity)

/datum/armourspecials/holo_decoy/try_item_action()
	var/mob/living/carbon/human/user = usr

	if(world.time >= time_off_cooldown)
		to_chat(user, "<span class='notice'>You active the hologram decoy emitter contained in your [source_item].</span>")
		GLOB.processing_objects.Add(src)
		time_off_cooldown = world.time + cooldown
		time_off_active = world.time + duration

		if(decoy_holo)
			qdel(decoy_holo)
		decoy_holo = new(get_turf(user))
		decoy_holo.copy_appearance(user)
		// This is to try to have the illusion move at the same rate the real mob world.
		decoy_holo.step_delay = max(user.movement_delay() + 4, 3)

		var/target_dir
		switch(spawn_dir)
			if("Left")
				target_dir = turn(user.dir, -90)
			if("Forward")
				target_dir = user.dir
			if("Right")
				target_dir = turn(user.dir, 90)


		var/turfsleft = 7
		var/turf/target_turf = get_turf(user)
		while(turfsleft > 0)
			turfsleft--
			var/turf/try_turf = get_step(target_turf, target_dir)
			if(isfloor(try_turf))
				target_turf = try_turf
			else
				break

		decoy_holo.walk_loop(target_turf)
	else
		to_chat(user, "<span class='notice'>Your [source_item] is on cooldown for another [(time_off_cooldown - world.time) / 10] seconds.</span>")

/datum/armourspecials/holo_decoy/process()
	if(world.time >= time_off_active)
		GLOB.processing_objects -= src
		if(decoy_holo)
			qdel(decoy_holo)




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

/mob/living/simple_animal/illusion/emp_act(severity)
	Destroy()

/mob/living/simple_animal/illusion/update_icon() // We don't want the appearance changing AT ALL unless by copy_appearance().
	return

/mob/living/simple_animal/illusion/proc/walk_to_random()
	var/list/floors = list()
	for(var/turf/T in view(7,src))
		if(isfloor(T))
			floors.Add(T)
	walk_loop(pick(floors))

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
	spawn(rand(0,20))
		walk_to_random()
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
				var/datum/gender/T = gender_datums[src.get_visible_gender()]
				M.visible_message("<span class='notice'>[M] hugs [src] to make [T.him] feel better!</span>", \
				"<span class='notice'>You hug [src] to make [T.him] feel better!</span>") // slightly redundant as at the moment most mobs still use the normal gender var, but it works and future-proofs it
				playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

			if(I_DISARM)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<span class='danger'>[M] attempted to disarm [src]!</span>")
				M.do_attack_animation(src)

			if(I_GRAB)
				..()

			if(I_HURT)
				adjustBruteLoss(harm_intent_damage)
				M.visible_message("<font color='red'>[M] [response_harm] \the [src]</font>")
				M.do_attack_animation(src)

	return

/mob/living/simple_animal/illusion/ex_act()
	return
