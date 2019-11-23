
/datum/cyberwarfare_command
	var/name = "CyberWarfare Command"
	var/desc = "CyberWarfare Description"
	var/category = "" //Offense or Defense

	var/mob/living/silicon/ai/our_ai

	var/cpu_cost = 0 //The cost of CPU points.
	var/maint_cost = 0 //Whilst active, lower our max CPU count by this.
	var/command_delay = 2 SECONDS //The do_after delay for sending out a command via AI OnClick
	var/do_alert = 0 //Perform a network wide alert when this command is run. Some commands will override this.

	var/lifespan = -1 //If -1, we don't apply a lifespan.
	var/expire_at = -1
	var/atom/movable/stored_target = null

/datum/cyberwarfare_command/proc/is_target_valid(var/atom/targ)
	return 1

/datum/cyberwarfare_command/proc/set_expire()
	if(lifespan == -1)
		expire_at = -1
	else
		expire_at = world.time + lifespan

/datum/cyberwarfare_command/proc/expire()
	if(our_ai.prepped_command == src)
		our_ai.prepped_command = null
		qdel(src)

/datum/cyberwarfare_command/proc/command_process()
	check_command_expire()

/datum/cyberwarfare_command/proc/prime_command(var/owner_ai)
	if(isnull(owner_ai))
		expire()
		return
	our_ai = owner_ai
	var/msg = "Command \[[name]\] prepped."
	if(our_ai.prepped_command)
		msg = "Prepped command \[[our_ai.prepped_command.name]\] wiped and replaced with \[[name]\]."
		our_ai.prepped_command.expire()
	to_chat(our_ai,"<span class = 'notice'>[msg]</span>")
	our_ai.prepped_command = src

/datum/cyberwarfare_command/proc/check_command_expire()
	return (world.time > expire_at && expire_at != -1)

/datum/cyberwarfare_command/proc/drain_cpu(var/amount,var/show_messages = 1)
	if(!our_ai.spend_cpu(amount,1))
		if(show_messages)
			to_chat(our_ai,"<span class = 'notice'>Insufficient CPU processing power to perform this action.</span>")
		return 0
	our_ai.spend_cpu(amount)
	return 1

/datum/cyberwarfare_command/proc/send_command(var/atom/target)
	if(!drain_cpu(cpu_cost)) //This is a fallback, mostly.
		return 0
	set_expire()
	return 1