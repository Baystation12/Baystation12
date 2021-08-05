
#define DODGE_ROLL_BASE_COOLDOWN 6 SECONDS

/mob/living/verb/rollN()
	set name = "Roll North"
	set category = "IC"

	rollDir(1)

/mob/living/verb/rollS()
	set name = "Roll South"
	set category = "IC"

	rollDir(2)

/mob/living/verb/rollE()
	set name = "Roll East"
	set category = "IC"

	rollDir(4)

/mob/living/verb/rollW()
	set name = "Roll West"
	set category = "IC"

	rollDir(8)

/mob/living/proc/getRollDist()
	return 2

mob/living/proc/getPerRollDelay()
	return 2

/mob/living/proc/getRollCooldown()
	return DODGE_ROLL_BASE_COOLDOWN

/mob/living/silicon/getRollDist()
	return 0

/mob/living/carbon/human/getRollDist()
	return species.roll_distance

/mob/living/carbon/human/getPerRollDelay()
	return species.per_roll_delay

/mob/living/carbon/human/getRollCooldown()
	return species.dodge_roll_delay

/mob/living/proc/rollDir(var/dir_roll)
	if(world.time < next_roll_at)
		to_chat(src,"<span class = 'notice'>You can't dodge roll again just yet!</span>")
		return 0
	var/roll_dist = getRollDist()
	var/roll_delay = getPerRollDelay()
	update_canmove()
	if(roll_dist <= 0 || incapacitated(INCAPACITATION_DISABLED) || incapacitated(INCAPACITATION_KNOCKDOWN))
		to_chat(src,"<span class = 'notice'>You can't dodge roll in your current state.</span>")
		return 0
	var/obj/vehicles/v = loc
	if(istype(v))
		v.exit_vehicle(src)
	var/obj/structure/closet/closet = loc
	if(istype(closet))
		to_chat(src,"<span class = 'notice'>You struggle to dodge roll out of the locker!</span>")
		closet.open()
		return 0
	next_roll_at = world.time + ((roll_delay * roll_dist) + getRollCooldown())
	doRoll(dir_roll,roll_dist,roll_delay)

/mob/living/proc/doRoll(var/dir_roll,var/roll_dist,var/roll_delay)
	to_chat(src,"<span class = 'warning'>[name] performs a dodge roll!</span>")
	var/tableroll = 1
	if(pass_flags & PASSTABLE)
		tableroll = 0
	if(tableroll)
		pass_flags |= PASSTABLE
	fire_stacks = max(0,fire_stacks - 0.8)
	if(fire_stacks <= 0)
		ExtinguishMob()
	for(var/i = 0,i < roll_dist,i++)
		var/turf/step_to = get_step(loc,dir_roll)
		if(step_to.density == 1 || !step(src,dir_roll))
			visible_message("<span class = 'warning'>[name] rolls into [step_to].</span>")
			if(tableroll)
				pass_flags &= ~PASSTABLE
			break
		var/matrix/m
		if(isnull(transform))
			m = matrix()
		else
			m = transform
		if(dir_roll == 2 || dir_roll == 8)	//Rotate in one direction when rolling north or east, the other when south or west
			animate(src,transform = turn(m,-359/(roll_dist)),time = 2) //We use 359 instead of 360 to ensure the flip-vertically animation doesn't happen
		else
			animate(src,transform = turn(m,359/(roll_dist)),time = 2) //We use 359 instead of 360 to ensure the flip-vertically animation doesn't happen
		setClickCooldown(2)
		if(client)
			client.move_delay = max(client.move_delay,world.time + 2)
		sleep(2)
	animate(src,transform = null,time = 1)
	if(tableroll)
		pass_flags &= ~PASSTABLE
	return 1

/mob/living/carbon/human/doRoll(var/dir_roll,var/roll_dist,var/roll_delay)
	if(species.handle_dodge_roll(src,dir_roll,roll_dist,roll_delay))
		return
	. = ..()

/datum/species/proc/handle_dodge_roll(var/mob/roller,var/rolldir)
	return 0

/obj/structure/closet/dump_contents()	// Prevent immediately dodgerolling out of a locker after it opens
	for (var/mob/living/M in src)
		if (istype(M))
			M.next_roll_at = max(M.next_roll_at,world.time + M.getRollCooldown())
	. = ..()
