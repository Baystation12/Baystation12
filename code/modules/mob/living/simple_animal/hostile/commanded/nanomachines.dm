#define COMMANDED_HEAL 8//we got healing powers yo
#define COMMANDED_HEALING 9

/mob/living/simple_animal/hostile/commanded/nanomachine
	name = "swarm"
	desc = "a cloud of tiny, tiny robots."
	icon = 'icons/mob/simple_animal/critter.dmi'
	icon_state = "blobsquiggle_grey"
	attacktext = "swarmed"
	health = 10
	maxHealth = 10
	var/regen_time = 0
	melee_damage_lower = 1
	melee_damage_upper = 2
	can_escape = TRUE
	var/emergency_protocols = 0
	known_commands = list("stay", "stop", "attack", "follow", "heal", "emergency protocol")

	response_help = "waves their hands through"
	response_harm = "hits"
	response_disarm = "fans at"

/mob/living/simple_animal/hostile/commanded/nanomachine/Life()
	regen_time++
	if(regen_time == 2 && health < maxHealth) //slow regen
		regen_time = 0
		health++
	. = ..()
	if(.)
		switch(stance)
			if(COMMANDED_HEAL)
				if(!target_mob)
					target_mob = FindTarget(COMMANDED_HEAL)
				move_to_heal()
			if(COMMANDED_HEALING)
				heal()

/mob/living/simple_animal/hostile/commanded/nanomachine/death(gibbed, deathmessage, show_dead_message)
	..(null, "dissipates into thin air", "You have been destroyed.")
	qdel(src)

/mob/living/simple_animal/hostile/commanded/nanomachine/proc/move_to_heal()
	if(!target_mob)
		return 0
	walk_to(src,target_mob,1,move_to_delay)
	if(Adjacent(target_mob))
		stance = COMMANDED_HEALING

/mob/living/simple_animal/hostile/commanded/nanomachine/proc/heal()
	if(health <= 3 && !emergency_protocols) //dont die doing this.
		return 0
	if(!target_mob)
		return 0
	if(!Adjacent(target_mob) || SA_attackable(target_mob))
		stance = COMMANDED_HEAL
		return 0
	if(target_mob.stat || target_mob.health >= target_mob.maxHealth) //he's either dead or healthy, move along.
		allowed_targets -= target_mob
		target_mob = null
		stance = COMMANDED_HEAL
		return 0
	src.visible_message("\The [src] glows green for a moment, healing \the [target_mob]'s wounds.")
	health -= 3
	target_mob.adjustBruteLoss(-5)
	target_mob.adjustFireLoss(-5)

/mob/living/simple_animal/hostile/commanded/nanomachine/misc_command(var/mob/speaker,var/text)
	if(stance != COMMANDED_HEAL || stance != COMMANDED_HEALING) //dont want attack to bleed into heal.
		allowed_targets = list()
		target_mob = null
	if(findtext(text,"heal")) //heal shit pls
		if(findtext(text,"me")) //assumed want heals on master.
			target_mob = speaker
			stance = COMMANDED_HEAL
			return 1
		var/list/targets = get_targets_by_name(text)
		if(targets.len > 1 || !targets.len)
			src.say("ERROR. TARGET COULD NOT BE PARSED.")
			return 0
		target_mob = targets[1]
		stance = COMMANDED_HEAL
		return 1
	if(findtext(text,"emergency protocol"))
		if(findtext(text,"deactivate"))
			if(emergency_protocols)
				src.say("EMERGENCY PROTOCOLS DEACTIVATED.")
			emergency_protocols = 0
			return 1
		if(findtext(text,"activate"))
			if(!emergency_protocols)
				src.say("EMERGENCY PROTOCOLS ACTIVATED.")
			emergency_protocols = 1
			return 1
		if(findtext(text,"check"))
			src.say("EMERGENCY PROTOCOLS [emergency_protocols ? "ACTIVATED" : "DEACTIVATED"].")
			return 1
	return 0