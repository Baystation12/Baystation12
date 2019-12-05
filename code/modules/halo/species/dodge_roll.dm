
#define DODGE_ROLL_BASE_COOLDOWN 2 SECONDS

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
	if(roll_dist <= 0)
		to_chat(src,"<span class = 'notice'>You can't dodge roll.</span>")
		return 0
	if(client)
		client.move_delay = max(client.move_delay,world.time + (roll_delay * roll_dist))
	next_roll_at = world.time + ((roll_delay * roll_dist) + DODGE_ROLL_BASE_COOLDOWN)
	animate(src,transform = turn(matrix(),180),time = roll_delay * roll_dist,loop = 2)
	to_chat(src,"<span class = 'warning'>[name] performs a dodge roll!</span>")
	for(var/i = 0,i < roll_dist,i++)
		var/turf/step_to = get_step(loc,dir)
		if(step_to.density == 1)
			visible_message("<span class = 'warning'>[name] rolls into [step_to].</span>")
			break
		step(src,dir)
		sleep(roll_delay)
	return 1

#undef DODGE_ROLL_BASE_COOLDOWN
