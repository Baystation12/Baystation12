
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

/mob/living/silicon/getRollDist()
	return 0

/mob/living/carbon/human/getRollDist()
	return species.roll_distance

/mob/living/carbon/human/getPerRollDelay()
	return species.per_roll_delay

/mob/living/proc/rollDir(var/dir)
	if(world.time < next_roll_at)
		to_chat(src,"<span class = 'notice'>You can't dodge roll again just yet!</span>")
		return 0
	var/roll_dist = getRollDist()
	var/roll_delay = getPerRollDelay()
	if(roll_dist <= 0 || incapacitated())
		to_chat(src,"<span class = 'notice'>You can't dodge roll in your current state.</span>")
		return 0
	var/obj/vehicles/v = loc
	if(istype(v))
		v.exit_vehicle(src)
	next_roll_at = world.time + ((roll_delay * roll_dist) + DODGE_ROLL_BASE_COOLDOWN)
	to_chat(src,"<span class = 'warning'>[name] performs a dodge roll!</span>")
	var/tableroll = 1
	if(pass_flags & PASSTABLE)
		tableroll = 0
	if(tableroll)
		pass_flags |= PASSTABLE
	for(var/i = 0,i < roll_dist,i++)
		var/turf/step_to = get_step(loc,dir)
		if(step_to.density == 1 || !step(src,dir))
			visible_message("<span class = 'warning'>[name] rolls into [step_to].</span>")
			if(tableroll)
				pass_flags &= ~PASSTABLE
			break
		var/matrix/m
		if(isnull(transform))
			m = matrix()
		else
			m = transform
		animate(src,transform = turn(m,359/(roll_dist)),time = 2) //We use 359 instead of 360 to ensure the flip-vertically animation doesn't happen
		setClickCooldown(2)
		if(client)
			client.move_delay = max(client.move_delay,world.time + 2)
		sleep(2)
	animate(src,transform = null,time = 1)
	if(tableroll)
		pass_flags &= ~PASSTABLE
	return 1

#undef DODGE_ROLL_BASE_COOLDOWN
