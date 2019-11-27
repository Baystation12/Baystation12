
//RECON//

#define NET_SCAN_L2_NODESCAN_LOWER 5
#define NET_SCAN_L2_NODESCAN_UPPER 10

/datum/cyberwarfare_command/network_scan
	name = "Network Scan (L1)"
	desc = "Scans your current network for foreign AIs."
	category = "Recon"
	cpu_cost = 5
	requires_target = 0
	var/scan_level = 1

/datum/cyberwarfare_command/network_scan/send_command(var/irrelevant_var)
	. = ..()
	if(!.)
		return 0
	to_chat(our_ai,"<span class = 'notice'>Commencing a Level [scan_level] system scan.</span>")
	if(scan_level > 1)
		our_ai.do_network_alert("Level [scan_level] system scan detected on network \[[our_ai.network]\]")
	var/list/ais_in_net = get_ais_in_network(our_ai.network,our_ai.native_network)
	switch(scan_level)
		if(1)
			ais_in_net -= our_ai
			var/msg = "Foreign artificial intelligence detected in network \[[our_ai.network]\]"
			if(ais_in_net.len == 0)
				msg = "No foreign artificial intelligences detected in network \[[our_ai.network]\]"
			to_chat(our_ai,"<span class = 'notice'>[msg]</span>")
		if(2)
			for(var/ai_untyped in ais_in_net)
				if(ai_untyped == our_ai)
					continue
				var/mob/living/silicon/ai/ai = ai_untyped
				to_chat(our_ai,"<span class = 'notice'>Artificial Intelligence Detected: [ai.name]\nScan strength failed to discover all nodes. Displaying found access nodes:</span>")
				var/list/node_accessed_tmp = ai.nodes_accessed.Copy()
				for(var/i = 0,i<=rand(NET_SCAN_L2_NODESCAN_LOWER,NET_SCAN_L2_NODESCAN_LOWER),i++)
					if(node_accessed_tmp.len == 0)
						break
					var/obj/structure/ai_routing_node/picked = pick(node_accessed_tmp)
					node_accessed_tmp -= picked
					to_chat(our_ai,"<span class = 'notice'>[picked.name] at [picked.loc.loc.name], access level [picked.get_access_for_ai(ai)].</span>")

		if(3)
			for(var/ai_untyped in ais_in_net)
				if(ai_untyped == our_ai)
					continue
				var/mob/living/silicon/ai/ai = ai_untyped
				to_chat(our_ai,"<span class = 'notice'>Artificial Intelligence Detected: [ai.name]. Terminal Located at [ai.our_terminal.loc.loc.name]\nDisplaying found access nodes:</span>")
				for(var/n in ai.nodes_accessed)
					var/obj/structure/ai_routing_node/node = n
					to_chat(our_ai,"<span class = 'notice'>[node.name] at [node.loc.loc.name], access level [node.get_access_for_ai(ai)].</span>")

	to_chat(our_ai,"<span class = 'notice'>Level [scan_level] system scan finished.</span>")
	expire()

/datum/cyberwarfare_command/network_scan/l2
	name = "Network Scan (L2)"
	desc = "Scans your current network for foreign AIs, displaying some of their obtained nodes and the accesses on those nodes."
	category = "Recon"
	cpu_cost = 15
	scan_level = 2
	do_alert = 1

/datum/cyberwarfare_command/network_scan/l3
	name = "Network Scan (L3)"
	desc = "Scans your current network for foreign AIs, displaying all of their obtained nodes and the accesses on those nodes."
	category = "Recon"
	cpu_cost = 30
	scan_level = 3
	do_alert = 1

/datum/cyberwarfare_command/investigate_node
	name = "Investigate Routing Node"
	desc = "Scans a routing node, providing you with a readout of all accesses stored. This will also disarm active traps, however, this action will cause the hostile AI to be alerted."
	category = "Recon"
	cpu_cost = 10

/datum/cyberwarfare_command/investigate_node/is_target_valid(var/obj/structure/ai_routing_node/node)
	if(istype(node))
		return 1
	return 0

/datum/cyberwarfare_command/investigate_node/send_command(var/obj/structure/ai_routing_node/node)
	. = ..()
	if(!.)
		return 0
	for(var/a in node.ais_to_access_levels)
		var/mob/ai = a
		var/access = node.get_access_for_ai(ai)
		if(access > 0)
			to_chat(our_ai,"<span class = 'notice'>AI: [ai.name]\nAccess:[access]</span>")
			our_ai.process_trap_trigger(node,1)

//OFFENSIVE//

#define LEVEL_1_MULT 1
#define LEVEL_2_MULT 1.5
#define LEVEL_3_MULT 2
#define LEVEL_4_MULT 4

/datum/cyberwarfare_command/hack_routing_node
	name = "Hack Routing Node"
	desc = "Gain access to or increase your access level in an access routing node. Increasing access beyond minimal access (Level 1) causes a system alert."
	category = "Offense"
	cpu_cost = 8

/datum/cyberwarfare_command/hack_routing_node/is_target_valid(var/obj/structure/ai_routing_node/node)
	if(istype(node))
		if(node.get_access_for_ai(our_ai) >= 4)
			to_chat(our_ai,"<span class = 'notice'>You already have the maximum access level on this node.</span>")
			return 0
		return 1

/datum/cyberwarfare_command/hack_routing_node/send_command(var/obj/structure/ai_routing_node/node)
	var/curr_access = node.get_access_for_ai(our_ai)
	var/cpu_mult = 0
	switch(curr_access)
		if(0)
			cpu_mult = LEVEL_1_MULT
		if(1)
			cpu_mult = LEVEL_2_MULT
		if(2)
			do_alert = 1
			cpu_mult = LEVEL_3_MULT
		if(3)
			do_alert = 1
			cpu_mult = LEVEL_4_MULT
	var/cost_with_mult = cpu_cost * cpu_mult
	if(!drain_cpu(cost_with_mult))
		return 0
	if(command_sfx)
		sound_to(our_ai,command_sfx)
	if(node.modify_access_levels(our_ai,1))
		node.attack_ai(our_ai)
		to_chat(our_ai,"<span class = 'notice'>Access level increased.</span>")
		if(curr_access >= 2) // uses >= instead of > because our curr_access is the pre-increased access value.
			our_ai.do_network_alert("An AI has brute-forced level [curr_access + 1] access on [node] at [node.loc.loc.name]!")
	our_ai.process_trap_trigger(node)

#undef LEVEL_1_MULT
#undef LEVEL_2_MULT
#undef LEVEL_3_MULT
#undef LEVEL_4_MULT

#define LOCKDOWN_TIME 20 SECONDS

/datum/cyberwarfare_command/node_lockdown
	name = "Lockdown Routing Node"
	desc = "Stop incoming connections to this routing node for 20 seconds, including your own. Requires access level 2 or greater on the targeted node."
	category = "Offense"
	cpu_cost = 15 //Slightly less than getting to lvl 2 access.
	command_delay = 5 SECONDS
	do_alert = 1

/datum/cyberwarfare_command/node_lockdown/is_target_valid(var/obj/structure/ai_routing_node/node)
	if(istype(node))
		if(node.get_access_for_ai(our_ai) < 2)
			to_chat(our_ai,"<span class = 'notice'>Insufficient access to enact a node lockdown.</span>")
			return 0
		if(world.time < node.lockdown_until)
			to_chat(our_ai,"<span class = 'notice'>A lockdown on this node is still ongoing.</span>")
			return 0
		return 1
	return 0

/datum/cyberwarfare_command/node_lockdown/send_command(var/obj/structure/ai_routing_node/node)
	. = ..()
	if(!.)
		return 0
	node.lockdown_until = world.time + LOCKDOWN_TIME
	to_chat(our_ai,"<span class = 'notice'>Routing Node lockdown enacted.</span>")
	our_ai.do_network_alert("An AI has enacted a connection lockdown on a routing node.")
	our_ai.process_trap_trigger(node)
	expire()

#undef LOCKDOWN_TIME
#define SHOCK_DAMAGE 20

/datum/cyberwarfare_command/shock_terminal
	name = "Shock Terminal"
	desc = "Flood an AI terminal with garbage data, causing the AI inside to lose CPU power."
	category = "Offense"
	cpu_cost = 25
	command_delay = 7 SECONDS
	do_alert = 1
	var/damage = SHOCK_DAMAGE
	var/siphon = 0 //If set, we "steal" this amount from the hostile AI.

/datum/cyberwarfare_command/shock_terminal/is_target_valid(var/obj/structure/ai_terminal/term)
	if(istype(term))
		return 1
	return 0

/datum/cyberwarfare_command/shock_terminal/send_command(var/obj/structure/ai_terminal/term)
	. = ..()
	if(!.)
		return 0
	if(term.held_ai)
		if(term.held_ai.spend_cpu(SHOCK_DAMAGE))
			to_chat(our_ai,"<span class = 'warning'>Attack successful. AI processing capability damaged.</span>")
		else
			to_chat(our_ai,"<span class = 'warning'>Attack successful. AI has been stunned and is awaiting manual extraction from terminal.</span>")
		to_chat(term.held_ai,"<span class = 'danger'>A surge of garbage data fills your processing feeds, sapping your CPU processing ability!</span>")
		if(siphon)
			our_ai.spend_cpu(-siphon)
			to_chat(our_ai,"<span class = 'notice'>Attack has cleared some input streams. CPU processing ability bolstered.</span>")
	else
		to_chat(our_ai,"<span class = 'warning'>No AI detected in terminal. Attack had no effect.</span>")

#undef SHOCK_DAMAGE

#define SIPHON_DAMAGE 10
/datum/cyberwarfare_command/shock_terminal/siphon
	name = "Clear Terminal Datastreams"
	desc = "Flood an AI terminal with garbage data, causing the AI inside to lose CPU power. If successful, you will siphon some of their CPU."
	category = "Offense"
	command_delay = 7 SECONDS
	cpu_cost = 30
	damage = 10
	siphon = 35
#undef SIPHON_DAMAGE

/datum/cyberwarfare_command/flash_network
	name = "Network wide disconnect"
	desc = "Fills your current network with disconnect commands, doing no damage but shunting AIs back to their cores. If no AI is effected by this, feedback will cause the effect to happen to you."
	category = "Offense"
	command_delay = 1 SECONDS
	cpu_cost = 10
	do_alert = 1
	requires_target = 0

/datum/cyberwarfare_command/flash_network/send_command(var/unused)
	. = ..()
	if(!.)
		return 0
	var/hit_someone = 0
	for(var/a in get_ais_in_network(our_ai.network,our_ai.native_network))
		if(a == our_ai)
			continue
		var/mob/living/silicon/ai/ai = a
		if(locate(/datum/cyberwarfare_command/disconnect_protect) in ai.active_cyberwarfare_effects)
			continue
		hit_someone = 1
		ai.flash_eyes(FLASH_PROTECTION_MAJOR,1,1)
		ai.cancel_camera()

	if(!hit_someone)
		to_chat(our_ai,"<span class = 'notice'>ERROR: DISCONNECT FLOOD FEEDBACK.</span>")
		our_ai.flash_eyes(FLASH_PROTECTION_MAJOR,1,1)
		our_ai.cancel_camera()

	to_chat(our_ai,"<span class = 'notice'>Disconnect flood sent. Reminder: Some AIs may resist this effect.</span>")
	expire()

/datum/cyberwarfare_command/nuke_node
	name = "Wipe Routing Node"
	desc = "Wipes all accesses on a routing terminal, including your own. Requires access level 3."
	category = "Offense"
	cpu_cost = 35
	command_delay = 8 SECONDS
	do_alert = 1

/datum/cyberwarfare_command/nuke_node/is_target_valid(var/obj/structure/ai_routing_node/node)
	if(istype(node))
		if(node.get_access_for_ai(our_ai) < 3)
			to_chat(our_ai,"<span class = 'notice'>You need access level 3 on that node to do this.</span>")
			return 0
		return 1
	return 0

/datum/cyberwarfare_command/nuke_node/send_command(var/obj/structure/ai_routing_node/node)
	. = ..()
	if(!.)
		return 0
	for(var/a in node.ais_to_access_levels)
		node.ais_to_access_levels[a] = 0
	our_ai.do_network_alert("An AI has wiped the access routing node at [node.loc.loc.name].!")
	expire()

//TRAPS//
/datum/cyberwarfare_command/trap
	name = "DONOTADD"
	desc = "A precoursor define for a /trap subtype."
	category = "Trap"
	lifespan = -1 //CHANGE ON EACH TRAP

	var/obj/trap_target
	var/trap_damage = 0

/datum/cyberwarfare_command/trap/proc/tripped(var/mob/living/silicon/ai/ai,var/do_disarm)
	if(do_disarm)
		to_chat(ai,"<span class = 'warning'>Trap found on node and disarmed.</span>")
		expire()
		return 0
	return 1

/datum/cyberwarfare_command/trap/send_command(var/atom/A)
	. = ..()
	if(!.)
		return 0
	trap_target = A
	set_expire()
	return 1

/datum/cyberwarfare_command/trap/logic_bomb
	name = "Routing Node Logic Bomb"
	desc = "Injects a fragment of code into the access routines of a Routing Node. Many attacks against a routing node will trigger this 40 CPU bomb."
	cpu_cost = 30 //High cost, but this lingers in a node.
	lifespan = 2 MINUTES
	trap_damage = 40

/datum/cyberwarfare_command/trap/logic_bomb/is_target_valid(var/obj/structure/ai_routing_node/node)
	if(istype(node))
		return 1
	return 0

/datum/cyberwarfare_command/trap/logic_bomb/tripped(var/mob/living/silicon/ai/ai,var/do_disarm)
	. = ..()
	if(!.)
		return 0
	to_chat(our_ai,"<span class = 'warning'>[ai] just tripped your [name] on [trap_target] at [trap_target.loc.loc.name].</span>")
	to_chat(ai,"<span class = 'danger'>A hidden fragment of malicious code disrupts your core routines, stripping you of processing power!</span>")
	ai.spend_cpu(trap_damage)
	expire()

/datum/cyberwarfare_command/trap/terminal_tripwire
	name = "Terminal Tripwire"
	desc = "Injects a fragment of code into the consciousness transfer routines of a terminal, causing you to be alerted when an AI enters that terminal."
	lifespan = 3 MINUTES
	cpu_cost = 20

/datum/cyberwarfare_command/terminal_tripwire/is_target_valid(var/obj/structure/ai_terminal/term)
	if(istype(term))
		return 1
	return 0

/datum/cyberwarfare_command/trap/terminal_tripwire/tripped(var/mob/living/silicon/ai/ai,var/do_disarm)
	. = ..()
	if(!.)
		return 0
	to_chat(our_ai,"<span class = 'warning'>[ai] has just entered [trap_target] at [trap_target.loc.loc.name].</span>")

//DEFENSIVE//
#define AI_HIDE_DURATION 2 SECONDS

/datum/cyberwarfare_command/ai_hide
	name = "Temporary Terminal Disconnect"
	desc = "Disconnect yourself from your current terminal for a short duration. This can hide you from system wide scans and flashes."
	category = "Defense"
	lifespan = AI_HIDE_DURATION
	cpu_cost = 15
	command_delay = 0.5 SECONDS
	requires_target = 0
	var/obj/structure/ai_terminal/saved_terminal

/datum/cyberwarfare_command/ai_hide/send_command(var/unused)
	. = ..()
	if(!.)
		return 0
	if(!our_ai.our_terminal)
		to_chat(our_ai,"<span class = 'notice'>You need to be in a terminal to do that.</span>")
		return
	set_expire()
	our_ai.Stun(2)
	saved_terminal = our_ai.our_terminal
	saved_terminal.held_ai = null
	to_chat(our_ai,"<span class = 'notice'>You disconnect yourself from your terminal.</span>")

/datum/cyberwarfare_command/ai_hide/command_process()
	our_ai.Stun(2)
	. = ..()

/datum/cyberwarfare_command/ai_hide/expire()
	if(saved_terminal.held_ai)
		to_chat(our_ai,"<span class = 'notice'>As you try to reconnect to your old terminal, the connection is unexpectedly severed and you lose your connection to the material world...</span>")
		our_ai.death()
		. = ..()
		return
	saved_terminal.held_ai = our_ai
	to_chat(our_ai,"<span class = 'notice'>You reconnect to your saved terminal.</span>")
	. = ..()

#undef AI_HIDE_DURATION

/datum/cyberwarfare_command/switch_terminal
	name = "Switch Terminal (Brute Force)"
	desc = "Transfer your consciousness to another AI terminal. Sends a system-wide alert due to the brute force nature, but is faster."
	category = "Defense"
	cpu_cost = 10
	command_delay = 4 SECONDS
	do_alert = 1

/datum/cyberwarfare_command/switch_terminal/is_target_valid(var/obj/structure/ai_terminal/term)
	if(istype(term) && !istype(our_ai.loc,/obj/item/weapon/aicard))
		return 1
	return 0

/datum/cyberwarfare_command/switch_terminal/send_command(var/obj/structure/ai_terminal/term)
	. = ..()
	if(!.)
		return 0
	if(our_ai.our_terminal != term && term.held_ai != our_ai)
		var/obj/structure/ai_terminal/old_term = our_ai.our_terminal
		if(term.check_move_to(our_ai))
			if(!isnull(old_term))
				old_term.ai_exit_node(our_ai)
			term.pre_move_to_node(our_ai)
			our_ai.cancel_camera()
		our_ai.process_trap_trigger(term)

/datum/cyberwarfare_command/switch_terminal/stealth
	name = "Switch Terminal (Infiltration)"
	desc = "Transfer your consciousness to another AI terminal. Utilises software and hardware vulnerabilities to bypass the usual system alert, but is slower and more expensive."
	category = "Defense"
	cpu_cost = 15
	command_delay = 8 SECONDS
	do_alert = 0

/datum/cyberwarfare_command/disconnect_protect
	name = "Establish disconnect bypass"
	desc = "Create a system node that protects against network-wide disconnect commands"
	category = "Defense"
	cpu_cost = 15
	command_delay = 1 SECONDS
	lifespan = 60 SECONDS
	requires_target = 0

/datum/cyberwarfare_command/disconnect_protect/send_command(var/unused)
	. = ..()
	if(!.)
		return 0
	set_expire()
	to_chat(our_ai,"<span class = 'notice'>Disconnect bypass established. Will remain active for [lifespan/10] seconds.</span>")
