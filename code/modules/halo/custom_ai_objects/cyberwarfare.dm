
/datum/cyberwarfare_command
	var/name = "CyberWarfare Command"
	var/desc = "CyberWarfare Description"
	var/category = "" //Offense or Defense

	var/mob/living/silicon/ai/our_ai

	var/output_to

	var/working = 0 //Are we currently doing anything (used for onclick stopping spamming)

	var/cpu_cost = 0 //The cost of CPU points.
	var/maint_cost = 0 //Whilst active, lower our max CPU count by this.
	var/command_delay = 2 SECONDS //The do_after delay for sending out a command via AI OnClick
	var/requires_target = 1
	var/do_alert = 0 //Perform a network wide alert when this command is run, occurring before the do_after completes.

	var/command_sfx = null

	var/lifespan = -1 //If -1, we don't apply a lifespan.
	var/expire_at = -1
	var/atom/movable/stored_target = null

/datum/cyberwarfare_command/proc/output_message(message)
	if(!ismob(output_to))
		var/obj/o = output_to
		o.visible_message(message)
	else
		to_chat(output_to,message)

/datum/cyberwarfare_command/proc/show_desc(var/mob/display_to)
	to_chat(display_to,"<span class = 'notice'>\[[name]\]\n[desc]\nActivation Time:[command_delay/10] seconds\n[lifespan == -1 ? "" : "Lifespan:[lifespan/10] seconds"]\nCost:[cpu_cost]</span>")

/datum/cyberwarfare_command/proc/is_target_valid(var/atom/targ)
	return 1

/datum/cyberwarfare_command/proc/set_expire()
	if(lifespan == -1)
		expire_at = -1
	else
		expire_at = world.time + lifespan
		our_ai.active_cyberwarfare_effects |= src
		our_ai.prepped_command = null //If we've added this to our effects, then we need to make sure the player can't switch it out for another command and thus end the effect early.

/datum/cyberwarfare_command/proc/expire()
	if(our_ai.prepped_command == src)
		our_ai.prepped_command = null
	our_ai.active_cyberwarfare_effects -= src
	qdel(src)

/datum/cyberwarfare_command/proc/command_process()
	if(check_command_expire())
		expire()

/datum/cyberwarfare_command/proc/prime_command(var/owner_ai)
	if(isnull(owner_ai))
		expire()
		return
	our_ai = owner_ai
	output_to = our_ai
	var/msg = "Command \[[name]\] prepped."
	if(our_ai.prepped_command)
		msg = "Prepped command \[[our_ai.prepped_command.name]\] wiped and replaced with \[[name]\]."
		our_ai.prepped_command.expire()
	output_message("<span class = 'notice'>[msg]</span>")
	our_ai.prepped_command = src
	if(!our_ai.prepped_command.requires_target) //If we don't need a target, trigger this command instantly.
		our_ai.ClickOn(our_ai)

/datum/cyberwarfare_command/proc/check_command_expire()
	return (world.time > expire_at)

/datum/cyberwarfare_command/proc/drain_cpu(var/amount,var/show_messages = 1)
	if(!our_ai.spend_cpu(amount,1))
		if(show_messages)
			output_message("<span class = 'notice'>Insufficient CPU processing power to perform this action.</span>")
		return 0
	our_ai.spend_cpu(amount)
	return 1

/datum/cyberwarfare_command/proc/send_command(var/atom/target)
	if(!drain_cpu(cpu_cost))
		return 0
	if(command_sfx)
		sound_to(our_ai,command_sfx)
	return 1