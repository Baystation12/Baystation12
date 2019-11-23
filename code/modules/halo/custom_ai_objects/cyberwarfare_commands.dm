
#define NET_SCAN_L2_NODESCAN_LOWER 5
#define NET_SCAN_L2_NODESCAN_UPPER 10

/datum/cyberwarfare_command/network_scan
	name = "Network Scan (L1)"
	desc = "Scans your current network for foreign AIs."
	category = "Recon"
	cpu_cost = 5
	var/scan_level = 1 //1 - 3

/datum/cyberwarfare_command/network_scan/prime_command(var/owner_ai)
	. = ..()
	send_command()

/datum/cyberwarfare_command/network_scan/send_command(var/irrelevant_var)
	if(!drain_cpu(cpu_cost))
		return 0
	to_chat(our_ai,"<span class = 'notice'>Commencing a Level [scan_level] system scan.</span>")
	if(scan_level > 1)
		our_ai.do_network_alert("Level [scan_level] system scan detected on network \[[our_ai.network]\]")
	var/list/ais_in_net = our_ai.get_ais_in_network(our_ai.network)
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
					var/obj/picked = pick(node_accessed_tmp)
					node_accessed_tmp -= picked
					to_chat(our_ai,"<span class = 'notice'>[picked.name] at [picked.loc.loc.name].<span>")

		if(3)
			for(var/ai_untyped in ais_in_net)
				if(ai_untyped == our_ai)
					continue
				var/mob/living/silicon/ai/ai = ai_untyped
				to_chat(our_ai,"<span class = 'notice'>Artificial Intelligence Detected: [ai.name]\nDisplaying found access nodes:</span>")
				for(var/obj/node in ai.nodes_accessed)
					to_chat(our_ai,"<span class = 'notice'>[node.name] at [node.loc.loc.name].<span>")

	to_chat(our_ai,"<span class = 'notice'>Level [scan_level] system scan finished.<span>")
	expire()

/datum/cyberwarfare_command/network_scan/l2
	name = "Network Scan (L2)"
	desc = "Scans your current network for foreign AIs, displaying some of their obtained nodes and the accesses on those nodes."
	category = "Recon"
	cpu_cost = 10
	scan_level = 2

/datum/cyberwarfare_command/network_scan/l3
	name = "Network Scan (L3)"
	desc = "Scans your current network for foreign AIs, displaying all of their obtained nodes and the accesses on those nodes."
	category = "Recon"
	cpu_cost = 20
	scan_level = 3

#define LEVEL_1_MULT 1
#define LEVEL_2_MULT 1.5
#define LEVEL_3_MULT 2
#define LEVEL_4_MULT 4

/datum/cyberwarfare_command/hack_routing_node
	name = "Hack Routing Node"
	desc = "Gain access to or increase your access level in an access routing node."
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
	if(node.modify_access_levels(our_ai,1))
		node.attack_ai(our_ai)
		to_chat(our_ai,"<span class = 'notice'>Access level increased.<span>")
		if(curr_access >= 2) // uses >= instead of > because our curr_access is the pre-increased access value.
			our_ai.do_network_alert("An AI has brute-forced greater-than-standard access on a routing node!")
		expire()

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

/datum/cyberwarfare_command/node_lockdown/is_target_valid(var/obj/structure/ai_routing_node/node)
	if(istype(node))
		if(node.get_access_for_ai(our_ai) < 2)
			to_chat(our_ai,"<span class = 'notice'>Insufficient access to enact a node lockdown.</span>")
			return 0
		if(world.time < node.lockdown_until)
			to_chat(our_ai,"<span class = 'notice'>A lockdown on this node is still ongoing.<span>")
			return 0
		return 1
	return 0

/datum/cyberwarfare_command/node_lockdown/send_command(var/obj/structure/ai_routing_node/node)
	if(!drain_cpu(cpu_cost))
		return 0
	node.lockdown_until = world.time + LOCKDOWN_TIME
	to_chat(our_ai,"<span class = 'notice'>Routing Node lockdown enacted.</span>")
	our_ai.do_network_alert("An AI has enacted a connection lockdown on a routing node.")
	expire()