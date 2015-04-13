var/global/narsie_behaviour = "CultStation13"
var/global/narsie_cometh = 0
var/global/list/narsie_list = list()

/obj/machinery/singularity/narsie //Moving narsie to a child object of the singularity so it can be made to function differently. --NEO
	name = "Nar-Sie"
	desc = "Your mind begins to bubble and ooze as it tries to comprehend what it sees."
	icon = 'icons/obj/magic_terror.dmi'
	pixel_x = -89
	pixel_y = -85
	current_size = 9 //It moves/eats like a max-size singulo, aside from range. --NEO
	contained = 0 //Are we going to move around?
	dissipate = 0 //Do we lose energy over time?
	move_self = 1 //Do we move on our own?
	grav_pull = 10 //How many tiles out do we pull?
	consume_range = 3 //How many tiles out do we eat
	var/last_boom = 0

/obj/machinery/singularity/narsie/large
	name = "Nar-Sie"
	icon = 'icons/obj/narsie.dmi'
	// Pixel stuff centers Narsie.
	pixel_x = -236
	pixel_y = -256
	current_size = 12
	move_self = 1 //Do we move on our own?
	consume_range = 12 //How many tiles out do we eat

/obj/machinery/singularity/narsie/large/New()
	..()
	narsie_list.Add(src)
	world << "<font size='28' color='red'><b>NAR-SIE HAS RISEN</b></font>"
	if(emergency_shuttle && emergency_shuttle.can_call())
		emergency_shuttle.call_evac()
		emergency_shuttle.launch_time = 0	// Cannot recall

/obj/machinery/singularity/narsie/large/Destroy()
	narsie_list.Remove(src)
	..()

/obj/machinery/singularity/narsie/process()
	eat()
	if(!target || prob(5))
		pickcultist()
	move()
	if(prob(25))
		mezzer()

/obj/machinery/singularity/narsie/consume(var/atom/A) //Has its own consume proc because it doesn't need energy and I don't want BoHs to explode it. --NEO
	if(is_type_in_list(A, uneatable))
		return 0
	if (istype(A,/mob/living))//Mobs get gibbed
		A:gib()
	else if(istype(A,/obj))
		var/obj/O = A
		machines -= O
		processing_objects -= O
		O.loc = null
	else if(isturf(A))
		var/turf/T = A
		if(T.intact)
			for(var/obj/O in T.contents)
				if(O.level != 1)
					continue
				if(O.invisibility == 101)
					src.consume(O)
		A:ChangeTurf(/turf/space)
	if(last_boom + 100 < world.time && prob(5))
		explosion(loc, -1, -1, -1, 1, 0) //Since we're not exploding everything in consume() toss out an explosion effect every now and again
		last_boom = world.time
	return

/obj/machinery/singularity/narsie/ex_act() //No throwing bombs at it either. --NEO
	return

/obj/machinery/singularity/narsie/proc/pickcultist() //Narsie rewards his cultists with being devoured first, then picks a ghost to follow. --NEO
	var/list/cultists = list()
	if(cult && cult.current_antagonists.len)
		for(var/datum/mind/cult_nh_mind in cult.current_antagonists)
			if(!cult_nh_mind.current)
				continue
			if(cult_nh_mind.current.stat)
				continue
			var/turf/pos = get_turf(cult_nh_mind.current)
			if(pos.z != src.z)
				continue
			cultists += cult_nh_mind.current
	if(cultists.len)
		acquire(pick(cultists))
		return
		//If there was living cultists, it picks one to follow.
	for(var/mob/living/carbon/human/food in living_mob_list)
		if(food.stat)
			continue
		var/turf/pos = get_turf(food)
		if(pos.z != src.z)
			continue
		cultists += food
	if(cultists.len)
		acquire(pick(cultists))
		return
		//no living cultists, pick a living human instead.
	for(var/mob/dead/observer/ghost in player_list)
		if(!ghost.client)
			continue
		var/turf/pos = get_turf(ghost)
		if(pos.z != src.z)
			continue
		cultists += ghost
	if(cultists.len)
		acquire(pick(cultists))
		return
		//no living humans, follow a ghost instead.

/obj/machinery/singularity/narsie/proc/acquire(var/mob/food)
	target << "\blue <b>NAR-SIE HAS LOST INTEREST IN YOU</b>"
	target = food
	if(ishuman(target))
		target << "\red <b>NAR-SIE HUNGERS FOR YOUR SOUL</b>"
	else
		target << "\red <b>NAR-SIE HAS CHOSEN YOU TO LEAD HIM TO HIS NEXT MEAL</b>"

//Wizard narsie

/obj/machinery/singularity/narsie/wizard
	grav_pull = 0

/obj/machinery/singularity/narsie/wizard/eat()
	set background = 1
	for(var/atom/X in orange(consume_range,src))
		if(isturf(X) || istype(X, /atom/movable))
			consume(X)
	return
