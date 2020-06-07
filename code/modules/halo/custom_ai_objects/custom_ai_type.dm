
/mob/living/silicon/ai/gravemind
	name = "Corrupted AI Mind"
	network = "FloodNet"
	native_network = "FloodNet"
	cyberwarfare_commands = newlist(\
	/datum/cyberwarfare_command/designate_build/wall,
	/datum/cyberwarfare_command/designate_build/floor,
	/datum/cyberwarfare_command/designate_build/window,
	/datum/cyberwarfare_command/designate_build/door,
	/datum/cyberwarfare_command/overmind_command/flood
	)

/mob/living/silicon/ai/dumb_ai
	name = "Dumb AI"
	cpu_points_max = 60
	cpu_points = 60
	cyberwarfare_commands = newlist(\
	/datum/cyberwarfare_command/investigate_node,
	/datum/cyberwarfare_command/hack_routing_node,
	/datum/cyberwarfare_command/node_lockdown,
	/datum/cyberwarfare_command/nuke_node,
	/datum/cyberwarfare_command/shock_terminal,
	/datum/cyberwarfare_command/trap/logic_bomb,
	/datum/cyberwarfare_command/trap/terminal_tripwire,
	)