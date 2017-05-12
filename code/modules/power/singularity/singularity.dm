//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/singularity/
	name = "gravitational singularity"
	desc = "A gravitational singularity."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"
	anchored = 1
	density = 1
	plane = EFFECTS_BELOW_LIGHTING_PLANE
	layer = SINGULARITY_LAYER
	light_range = 6
	unacidable = 1 //Don't comment this out.

	var/current_size = 1
	var/allowed_size = 1
	var/contained = 1 //Are we going to move around?
	var/energy = 100 //How strong are we?
	var/dissipate = 1 //Do we lose energy over time?
	var/dissipate_delay = 10
	var/dissipate_track = 0
	var/dissipate_strength = 1 //How much energy do we lose?
	var/move_self = 1 //Do we move on our own?
	var/grav_pull = 4 //How many tiles out do we pull?
	var/consume_range = 0 //How many tiles out do we eat.
	var/event_chance = 15 //Prob for event each tick.
	var/target = null //Its target. Moves towards the target if it has one.
	var/last_failed_movement = 0 //Will not move in the same dir if it couldnt before, will help with the getting stuck on fields thing.
	var/last_warning

	var/chained = 0//Adminbus chain-grab

/obj/singularity/New(loc, var/starting_energy = 50, var/temp = 0)
	//CARN: admin-alert for chuckle-fuckery.
	admin_investigate_setup()
	energy = starting_energy

	if (temp)
		spawn (temp)
			qdel(src)

	..()
	processing_objects += src
	for(var/obj/machinery/power/singularity_beacon/singubeacon in machines)
		if(singubeacon.active)
			target = singubeacon
			break

/obj/singularity/Destroy()
	processing_objects -= src
	..()

/obj/singularity/attack_hand(mob/user as mob)
	consume(user)
	return 1

/obj/singularity/ex_act(severity)
	if(current_size == STAGE_SUPER)//IT'S UNSTOPPABLE
		return
	switch(severity)
		if(1.0)
			if(prob(25))
				investigate_log("has been destroyed by an explosion.", I_SINGULO)
				qdel(src)
				return
			else
				energy += 50
		if(2.0 to 3.0)
			energy += round((rand(20,60)/2),1)
			return

/obj/singularity/bullet_act(obj/item/projectile/P)
	return 0 //Will there be an impact? Who knows. Will we see it? No.

/obj/singularity/Bump(atom/A)
	consume(A)

/obj/singularity/Bumped(atom/A)
	consume(A)

/obj/singularity/process()
	eat()
	dissipate()
	check_energy()

	if (current_size >= STAGE_TWO)
		move()
		pulse()

		if (prob(event_chance)) //Chance for it to run a special event TODO: Come up with one or two more that fit.
			event()

/obj/singularity/attack_ai() //To prevent ais from gibbing themselves when they click on one.
	return

/obj/singularity/proc/admin_investigate_setup()
	last_warning = world.time
	var/count = locate(/obj/machinery/containment_field) in orange(30, src)

	if (!count)
		message_admins("A singulo has been created without containment fields active ([x], [y], [z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>).")

	investigate_log("was created. [count ? "" : "<font color='red'>No containment fields were active.</font>"]", I_SINGULO)

/obj/singularity/proc/dissipate()
	if (!dissipate)
		return

	if(dissipate_track >= dissipate_delay)
		energy -= dissipate_strength
		dissipate_track = 0
	else
		dissipate_track++

/obj/singularity/proc/expand(var/force_size = 0, var/growing = 1)
	if(current_size == STAGE_SUPER)//if this is happening, this is an error
		message_admins("expand() was called on a super singulo. This should not happen. Contact a coder immediately!")
		return
	var/temp_allowed_size = allowed_size

	if (force_size)
		temp_allowed_size = force_size

	switch (temp_allowed_size)
		if (STAGE_ONE)
			name = "gravitational singularity"
			desc = "A gravitational singularity."
			current_size = STAGE_ONE
			icon = 'icons/obj/singularity.dmi'
			icon_state = "singularity_s1"
			pixel_x = 0
			pixel_y = 0
			grav_pull = 4
			consume_range = 0
			dissipate_delay = 10
			dissipate_track = 0
			dissipate_strength = 1
			overlays = 0
			if(chained)
				overlays = "chain_s1"
			visible_message("<span class='notice'>The singularity has shrunk to a rather pitiful size.</span>")
		if (STAGE_TWO) //1 to 3 does not check for the turfs if you put the gens right next to a 1x1 then its going to eat them.
			name = "gravitational singularity"
			desc = "A gravitational singularity."
			current_size = STAGE_TWO
			icon = 'icons/effects/96x96.dmi'
			icon_state = "singularity_s3"
			pixel_x = -32
			pixel_y = -32
			grav_pull = 6
			consume_range = 1
			dissipate_delay = 5
			dissipate_track = 0
			dissipate_strength = 5
			overlays = 0
			if(chained)
				overlays = "chain_s3"
			if(growing)
				visible_message("<span class='notice'>The singularity noticeably grows in size.</span>")
			else
				visible_message("<span class='notice'>The singularity has shrunk to a less powerful size.</span>")
		if (STAGE_THREE)
			if ((check_turfs_in(1, 2)) && (check_turfs_in(2, 2)) && (check_turfs_in(4, 2)) && (check_turfs_in(8, 2)))
				name = "gravitational singularity"
				desc = "A gravitational singularity."
				current_size = STAGE_THREE
				icon = 'icons/effects/160x160.dmi'
				icon_state = "singularity_s5"
				pixel_x = -64
				pixel_y = -64
				grav_pull = 8
				consume_range = 2
				dissipate_delay = 4
				dissipate_track = 0
				dissipate_strength = 20
				overlays = 0
				if(chained)
					overlays = "chain_s5"
				if(growing)
					visible_message("<span class='notice'>The singularity expands to a reasonable size.</span>")
				else
					visible_message("<span class='notice'>The singularity has returned to a safe size.</span>")
		if(STAGE_FOUR)
			if ((check_turfs_in(1, 3)) && (check_turfs_in(2, 3)) && (check_turfs_in(4, 3)) && (check_turfs_in(8, 3)))
				name = "gravitational singularity"
				desc = "A gravitational singularity."
				current_size = STAGE_FOUR
				icon = 'icons/effects/224x224.dmi'
				icon_state = "singularity_s7"
				pixel_x = -96
				pixel_y = -96
				grav_pull = 10
				consume_range = 3
				dissipate_delay = 10
				dissipate_track = 0
				dissipate_strength = 10
				overlays = 0
				if(chained)
					overlays = "chain_s7"
				if(growing)
					visible_message("<span class='warning'>The singularity expands to a dangerous size.</span>")
				else
					visible_message("<span class='notice'>Miraculously, the singularity reduces in size, and can be contained.</span>")
		if(STAGE_FIVE) //This one also lacks a check for gens because it eats everything.
			name = "gravitational singularity"
			desc = "A gravitational singularity."
			current_size = STAGE_FIVE
			icon = 'icons/effects/288x288.dmi'
			icon_state = "singularity_s9"
			pixel_x = -128
			pixel_y = -128
			grav_pull = 10
			consume_range = 4
			dissipate = 0 //It cant go smaller due to e loss.
			overlays = 0
			if(chained)
				overlays = "chain_s9"
			if(growing)
				visible_message("<span class='danger'><font size='2'>The singularity has grown out of control!</font></span>")
			else
				visible_message("<span class='warning'>The singularity miraculously reduces in size and loses its supermatter properties.</span>")
		if(STAGE_SUPER)//SUPERSINGULO
			name = "super gravitational singularity"
			desc = "A gravitational singularity with the properties of supermatter. <b>It has the power to destroy worlds.</b>"
			current_size = STAGE_SUPER
			icon = 'icons/effects/352x352.dmi'
			icon_state = "singularity_s11"//uh, whoever drew that, you know that black holes are supposed to look dark right? What's this, the clown's singulo?
			pixel_x = -160
			pixel_y = -160
			grav_pull = 16
			consume_range = 5
			dissipate = 0 //It cant go smaller due to e loss
			event_chance = 25 //Events will fire off more often.
			if(chained)
				overlays = "chain_s9"
			visible_message("<span class='sinister'><font size='3'>You witness the creation of a destructive force that cannot possibly be stopped by human hands.</font></span>")

	if (current_size == allowed_size)
		investigate_log("<font color='red'>grew to size [current_size].</font>", I_SINGULO)
		return 1
	else if (current_size < (--temp_allowed_size) && current_size != STAGE_SUPER)
		expand(temp_allowed_size)
	else
		return 0

/obj/singularity/proc/check_energy()
	if (energy <= 0)
		investigate_log("collapsed.", I_SINGULO)
		qdel(src)
		return 0

	switch (energy) //Some of these numbers might need to be changed up later -Mport.
		if (1 to 199)
			allowed_size = STAGE_ONE
		if (200 to 499)
			allowed_size = STAGE_TWO
		if (500 to 999)
			allowed_size = STAGE_THREE
		if (1000 to 1999)
			allowed_size = STAGE_FOUR
		if(2000 to 49999)
			allowed_size = STAGE_FIVE
		if(50000 to INFINITY)
			allowed_size = STAGE_SUPER

	if (current_size != allowed_size && current_size != STAGE_SUPER)
		expand(null, current_size < allowed_size)
	return 1

/obj/singularity/proc/eat()
	for(var/atom/X in orange(grav_pull, src))
		var/dist = get_dist(X, src)
		var/obj/singularity/S = src
		if(!istype(src))
			return
		if(dist > consume_range)
			X.singularity_pull(S, current_size)
		else if(dist <= consume_range)
			consume(X)

	//for (var/turf/T in trange(grav_pull, src)) //TODO: Create a similar trange for orange to prevent snowflake of self check.
	//	consume(T)

	return

/obj/singularity/proc/consume(const/atom/A)
	src.energy += A.singularity_act(src, current_size)
	return

/obj/singularity/proc/move(var/force_move = 0)
	if(!move_self)
		return 0

	var/movement_dir = pick(GLOB.alldirs - last_failed_movement)

	if(force_move)
		movement_dir = force_move

	if(target && prob(60))
		movement_dir = get_dir(src,target) //moves to a singulo beacon, if there is one

	if(current_size >= 9)//The superlarge one does not care about things in its way
		spawn(0)
			step(src, movement_dir)
		spawn(1)
			step(src, movement_dir)
		return 1
	else if(check_turfs_in(movement_dir))
		last_failed_movement = 0 // Reset this because we moved
		spawn(0)
			step(src, movement_dir)
		return 1
	else
		last_failed_movement = movement_dir
	return 0

/obj/singularity/proc/check_turfs_in(var/direction = 0, var/step = 0)
	if(!direction)
		return 0
	var/steps = 0
	if(!step)
		switch(current_size)
			if(1)
				steps = 1
			if(3)
				steps = 3//Yes this is right
			if(5)
				steps = 3
			if(7)
				steps = 4
			if(9)
				steps = 5
			if(11)
				steps = 6
	else
		steps = step
	var/list/turfs = list()
	var/turf/T = src.loc
	for(var/i = 1 to steps)
		T = get_step(T,direction)
	if(!isturf(T))
		return 0
	turfs.Add(T)
	var/dir2 = 0
	var/dir3 = 0
	switch(direction)
		if(NORTH||SOUTH)
			dir2 = 4
			dir3 = 8
		if(EAST||WEST)
			dir2 = 1
			dir3 = 2
	var/turf/T2 = T
	for(var/j = 1 to steps)
		T2 = get_step(T2,dir2)
		if(!isturf(T2))
			return 0
		turfs.Add(T2)
	for(var/k = 1 to steps)
		T = get_step(T,dir3)
		if(!isturf(T))
			return 0
		turfs.Add(T)
	for(var/turf/T3 in turfs)
		if(isnull(T3))
			continue
		if(!can_move(T3))
			return 0
	return 1

/obj/singularity/proc/can_move(const/turf/T)
	if (!isturf(T))
		return 0

	if ((locate(/obj/machinery/containment_field) in T) || (locate(/obj/machinery/shieldwall) in T))
		return 0
	else if (locate(/obj/machinery/field_generator) in T)
		var/obj/machinery/field_generator/G = locate(/obj/machinery/field_generator) in T

		if (G && G.active)
			return 0
	else if (locate(/obj/machinery/shieldwallgen) in T)
		var/obj/machinery/shieldwallgen/S = locate(/obj/machinery/shieldwallgen) in T

		if (S && S.active)
			return 0
	return 1

/obj/singularity/proc/event()
	var/numb = pick(1, 2, 3, 4, 5, 6)

	switch (numb)
		if (1) //EMP.
			emp_area()
		if (2, 3) //Tox damage all carbon mobs in area.
			toxmob()
		if (4) //Stun mobs who lack optic scanners.
			mezzer()
		else
			return 0
	if(current_size == 11)
		smwave()
	return 1


/obj/singularity/proc/toxmob()
	var/toxrange = 10
	var/toxdamage = 4
	var/radiation = 15
	if (src.energy>200)
		toxdamage = round(((src.energy-150)/50)*4,1)
		radiation = round(((src.energy-150)/50)*5,1)
	radiation_repository.radiate(src, radiation) //Always radiate at max, so a decent dose of radiation is applied
	for(var/mob/living/M in view(toxrange, src.loc))
		if(M.status_flags & GODMODE)
			continue
		toxdamage = (toxdamage - (toxdamage*M.getarmor(null, "rad")))
		M.apply_effect(toxdamage, TOX)
	return


/obj/singularity/proc/mezzer()
	for(var/mob/living/carbon/M in oviewers(8, src))
		if(istype(M, /mob/living/carbon/brain)) //Ignore brains
			continue
		if(M.status_flags & GODMODE)
			continue
		if(M.stat == CONSCIOUS)
			if (istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(istype(H.glasses,/obj/item/clothing/glasses/meson) && current_size != 11)
					to_chat(H, "<span class=\"notice\">You look directly into The [src.name], good thing you had your protective eyewear on!</span>")
					return
				else
					to_chat(H, "<span class=\"warning\">You look directly into The [src.name], but your eyewear does absolutely nothing to protect you from it!</span>")
		to_chat(M, "<span class='danger'>You look directly into The [src.name] and feel [current_size == 11 ? "helpless" : "weak"].</span>")
		M.apply_effect(3, STUN)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("<span class='danger'>[] stares blankly at The []!</span>", M, src), 1)

/obj/singularity/proc/emp_area()
	if(current_size != 11)
		empulse(src, 8, 10)
	else
		empulse(src, 12, 16)

/obj/singularity/proc/smwave()
	for(var/mob/living/M in view(10, src.loc))
		if(prob(67))
			to_chat(M, "<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")
			to_chat(M, "<span class=\"notice\">Miraculously, it fails to kill you.</span>")
		else
			to_chat(M, "<span class=\"danger\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")
			to_chat(M, "<span class=\"danger\">You don't even have a moment to react as you are reduced to ashes by the intense radiation.</span>")
			M.dust()
	radiation_repository.radiate(src, rand(energy))
	return

/obj/singularity/proc/pulse()
	for(var/obj/machinery/power/rad_collector/R in rad_collectors)
		if (get_dist(R, src) <= 15) //Better than using orange() every process.
			R.receive_pulse(energy)

/obj/singularity/proc/on_capture()
	chained = 1
	overlays = 0
	move_self = 0
	switch (current_size)
		if(1)
			overlays += image('icons/obj/singularity.dmi',"chain_s1")
		if(3)
			overlays += image('icons/effects/96x96.dmi',"chain_s3")
		if(5)
			overlays += image('icons/effects/160x160.dmi',"chain_s5")
		if(7)
			overlays += image('icons/effects/224x224.dmi',"chain_s7")
		if(9)
			overlays += image('icons/effects/288x288.dmi',"chain_s9")

/obj/singularity/proc/on_release()
	chained = 0
	overlays = 0
	move_self = 1

/obj/singularity/singularity_act(S, size)
    if(current_size <= size)
        var/gain = (energy/2)
        var/dist = max((current_size - 2), 1)
        explosion(src.loc,(dist),(dist*2),(dist*4))
        spawn(0)
            qdel(src)
        return gain
