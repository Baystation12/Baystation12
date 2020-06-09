
//humans slap AI stuff with this to do things with the dumb AI

/obj/item/dumb_ai_chip
	name = "Dumb AI Chip"
	desc = "A chip with a hardcoded dumb AI, used to counter smart AI hacking."
	icon = 'code/modules/halo/overmap/nav_computer.dmi'
	icon_state = "nav_data_chip"

	var/mob/living/silicon/ai/dumb_ai/ai
	var/command_use_name
	var/working = 0

/obj/item/dumb_ai_chip/examine(var/examiner)
	. = ..()
	if(ai)
		to_chat(examiner,"AI CPU: [ai.cpu_points]")
	if(command_use_name)
		to_chat(examiner,"It is primed to send the [command_use_name] command")
	else
		to_chat(examiner,"It is not primed to send any command.")

/obj/item/dumb_ai_chip/attack_self(var/mob/user)
	if(!ai)
		ai = new(null,null,null,1)
	var/list/command_names = list()
	for(var/i = 1 to ai.cyberwarfare_commands.len)
		var/datum/cyberwarfare_command/command = ai.cyberwarfare_commands[i]
		if(!command)
			continue
		if(!command.our_ai)
			command.output_to = src
			command.our_ai = ai
		command_names[command.name] = command
	var/choice = input(user,"Prime for what command?","Command priming","Cancel") in command_names + list("Cancel")
	if(choice == "Cancel")
		return
	command_use_name = choice
	var/datum/cyberwarfare_command/picked = command_names[choice]
	ai.prepped_command = new picked.type (ai)
	to_chat(user,"<span class = 'notice'>Dumb AI primed to deploy [command_use_name] command. Interface with a valid command target to deploy.</span>")

/obj/item/dumb_ai_chip/resolve_attackby(atom/A, mob/user, var/click_params)
	if(ai && ai.prepped_command)
		if(working)
			to_chat(user,"<span class = 'notice'>[src] is working...</span>")
			return
		if(!ai.prepped_command.is_target_valid(A))
			visible_message("<span class = 'notice'>[src] beeps: Invalid target for command.</span>")
			return
		working = 1
		user.visible_message("<span class = 'notice'>[user] starts preparing [src] to deploy a command to [A]</span>")
		if(do_after(user,ai.prepped_command.command_delay,A,needhand = 0,same_direction = 1))
			ai.prepped_command.send_command(A)
		working = 0
	add_fingerprint(user)
	return A.attackby(src, user, click_params)

/obj/item/dumb_ai_chip/cov
	icon_state = "nav_data_chip_cov"
