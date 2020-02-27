
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