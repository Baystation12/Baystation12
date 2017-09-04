/mob/living/simple_animal/space_worm
	name = "space worm segment"
	desc = "A part of a space worm."
	icon = 'icons/mob/animal.dmi'
	icon_state = "spaceworm"
	icon_living = "spaceworm"
	icon_dead = "spacewormdead"
	status_flags = 0

	speak_emote = list("transmits") //not supposed to be used under AI control
	emote_hear = list("transmits")  //I'm just adding it so it doesn't runtime if controlled by player who speaks

	response_help  = "touches"
	response_disarm = "flails at"
	response_harm   = "punches the"

	harm_intent_damage = 2

	maxHealth = 30
	health = 30

	universal_speak =1

	stop_automated_movement = 1
	animate_movement = SYNC_STEPS

	minbodytemp = 0
	maxbodytemp = 350
	min_gas = null
	max_gas = null

	a_intent = I_HURT //so they don't get pushed around

	environment_smash = 2

	speed = -1

	var/mob/living/simple_animal/space_worm/previous //next/previous segments, correspondingly
	var/mob/living/simple_animal/space_worm/next     //head is the nextest segment

	var/stomachProcessProbability = 50
	var/digestionProbability = 20
	var/flatPlasmaValue = 5 //flat plasma amount given for non-items

	var/atom/currentlyEating //what the worm is currently eating
	var/eatingDuration = 0 //how long he's been eating it for

	head
		name = "space worm head"
		icon_state = "spacewormhead"
		icon_living = "spacewormhead"
		icon_dead = "spacewormdead"

		maxHealth = 20
		health = 20

		melee_damage_lower = 10
		melee_damage_upper = 15
		attacktext = "bitten"

		animate_movement = SLIDE_STEPS

		New(var/location, var/segments = 6)
			..()

			var/mob/living/simple_animal/space_worm/current = src

			for(var/i = 1 to segments)
				var/mob/living/simple_animal/space_worm/newSegment = new /mob/living/simple_animal/space_worm(loc)
				current.Attach(newSegment)
				current = newSegment

		update_icon()
			if(stat == CONSCIOUS || stat == UNCONSCIOUS)
				icon_state = "spacewormhead[previous?1:0]"
				if(previous)
					set_dir(get_dir(previous,src))
			else
				icon_state = "spacewormheaddead"

	Life()
		..()

		if(next && !(next in view(src,1)))
			Detach()

		if(stat == DEAD) //dead chunks fall off and die immediately
			if(previous)
				previous.Detach()
			if(next)
				Detach(1)

		if(prob(stomachProcessProbability))
			ProcessStomach()

		update_icon()

		return

	Destroy() //if a chunk a destroyed, make a new worm out of the split halves
		if(previous)
			previous.Detach()
		. = ..()

	Move()
		var/attachementNextPosition = loc
		if(..())
			if(previous)
				previous.Move(attachementNextPosition)
			update_icon()

	Bump(atom/obstacle)
		if(currentlyEating != obstacle)
			currentlyEating = obstacle
			eatingDuration = 0

		if(!AttemptToEat(obstacle))
			eatingDuration++
		else
			currentlyEating = null
			eatingDuration = 0

		return

	update_icon() //only for the sake of consistency with the other update icon procs
		if(stat == CONSCIOUS || stat == UNCONSCIOUS)
			if(previous) //midsection
				icon_state = "spaceworm[get_dir(src,previous) | get_dir(src,next)]" //see 3 lines below
			else //tail
				icon_state = "spacewormtail"
				set_dir(get_dir(src,next)) //next will always be present since it's not a head and if it's dead, it goes in the other if branch
		else
			icon_state = "spacewormdead"

		return

	proc/AttemptToEat(var/atom/target)
		if(istype(target,/turf/simulated/wall))
			var/turf/simulated/wall/W = target
			if((!W.reinf_material && eatingDuration >= 100) || eatingDuration >= 200) //need 20 ticks to eat an rwall, 10 for a regular one
				W.dismantle_wall()
				return 1
		else if(istype(target,/atom/movable))
			if(istype(target,/mob) || eatingDuration >= 50) //5 ticks to eat stuff like airlocks
				var/atom/movable/objectOrMob = target
				contents += objectOrMob
				return 1

		return 0

	proc/Attach(var/mob/living/simple_animal/space_worm/attachement)
		if(!attachement)
			return

		previous = attachement
		attachement.next = src

		return

	proc/Detach(die = 0)
		var/mob/living/simple_animal/space_worm/newHead = new /mob/living/simple_animal/space_worm/head(loc,0)

		newHead.Attach(src)

		if(die)
			newHead.death()

	proc/ProcessStomach()
		for(var/atom/movable/stomachContent in contents)
			if(prob(digestionProbability))
				if(istype(stomachContent,/obj/item/stack)) //converts to plasma, keeping the stack value
					if(!istype(stomachContent,/obj/item/stack/material/phoron))
						var/obj/item/stack/oldStack = stomachContent
						new /obj/item/stack/material/phoron(src, oldStack.get_amount())
						qdel(oldStack)
						continue
				else if(istype(stomachContent,/obj/item)) //converts to plasma, keeping the w_class
					var/obj/item/oldItem = stomachContent
					new /obj/item/stack/material/phoron(src, oldItem.w_class)
					qdel(oldItem)
					continue
				else
					new /obj/item/stack/material/phoron(src, flatPlasmaValue) //just flat amount
					qdel(stomachContent)
					continue

		if(previous)
			for(var/atom/movable/stomachContent in contents) //transfer it along the digestive tract
				previous.contents += stomachContent
		else
			for(var/atom/movable/stomachContent in contents) //or poop it out
				loc.contents += stomachContent

		return
