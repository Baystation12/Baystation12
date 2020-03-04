
/obj/structure/ai_terminal
	name = "AI Auxilliary Storage Terminal"
	desc = "This terminal contains hardware to store, upload and download AI constructs."
	icon = 'code/modules/halo/icons/machinery/ai_terminals.dmi'
	icon_state = "unscterminal"
	anchored = 1
	density = 1
	var/spawn_faction = null //If placed into this terminal with the faction "neutral", this will override your faction
	var/mob/living/silicon/ai/held_ai = null
	var/allow_remote_moveto = 1
	var/inherent_network = "Exodus" //Our inherent camera network.
	var/list/radio_channels_access = list() //Accessing this node will permenantly add these radio channels. This should only be placed on spawn_terminal subtypes.

	var/area_nodescan = null //If set, this will scan this area and all subtypes of this area for nodes to add to inherent_nodes
	var/list/inherent_nodes = list()// This should only really be fully populated for roundstart terminals, aka the ones AI cores spawn.
	//Otherwise this should just contain the node in it's own area.

/obj/structure/ai_terminal/ex_act()
	return

/obj/structure/ai_terminal/Initialize()
	. = ..()
	if(!isnull(area_nodescan))
		for(var/area_type in typesof(area_nodescan))
			var/area/a = locate(area_type)
			if(istype(a) && !isnull(a.ai_routing_node))
				inherent_nodes  += a.ai_routing_node

/obj/structure/ai_terminal/attack_ai(var/mob/living/silicon/ai/user)
	if(!istype(user))
		return
	if(held_ai == user)
		held_ai.switch_to_net_by_name(inherent_network)

/obj/structure/ai_terminal/proc/set_terminal_inactive(var/is_resisting_carding)
	if(!is_resisting_carding)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = "[initial(icon_state)]"

/obj/structure/ai_terminal/proc/apply_radio_channels(var/mob/living/silicon/ai/ai)
	var/obj/item/device/radio/headset/our_radio = ai.common_radio
	var/obj/item/device/encryptionkey/key = our_radio.keyslot2
	for(var/channel in radio_channels_access)
		key.channels[channel] = 1
	our_radio.recalculateChannels()

/obj/structure/ai_terminal/proc/clear_old_nodes(var/mob/living/silicon/ai/ai)
	ai.nodes_accessed.Cut()

/obj/structure/ai_terminal/proc/can_exit_node(var/mob/ai) //TODO: CYBERSPACE WARFARE STUFF, TERMINAL LOCKDOWNS ETC.
	return 1

/obj/structure/ai_terminal/proc/ai_exit_node(var/mob/living/silicon/ai/ai)
	if(ai == held_ai)
		held_ai = null
		contents -= ai
		ai.loc = null
		set_terminal_inactive(1)

/obj/structure/ai_terminal/proc/pre_move_to_node(var/mob/living/silicon/ai/ai,var/skip_check = 0)
	var/clear_old = 1
	if(!skip_check)
		clear_old = 0
		if(!(ai.network == inherent_network || ai.native_network == inherent_network))
			var/confirm = alert("This network holds no relation to any of your old networks. Switching will cause loss of previous node access.","Confirm Switch","Yes","No")
			if(confirm == "No")
				return
			clear_old = 1

	if(move_to_node(ai) && clear_old)
		clear_old_nodes(ai)
		invalidateCameraCache()
	to_chat(ai,"<span class = 'notice'>Consciousness moved to new AI node.</span>")

/obj/structure/ai_terminal/proc/check_move_to(var/mob/living/silicon/ai/ai)
	var/obj/structure/ai_terminal/o_t = ai.our_terminal
	if(istype(o_t) && !o_t.can_exit_node())
		to_chat(ai,"<span class = 'danger'>Could not exit current node.</span>")
		return
	if(!allow_remote_moveto)
		to_chat(ai,"<span class = 'danger'>External access attempt failed. Terminal does not accept external connections.</span>")
		if(held_ai)
			to_chat(held_ai,"<span class = 'danger'>External access attempt detected. Terminal halted external connection.</span>")
		return 0
	if(held_ai)
		to_chat(ai,"<span class = 'danger'>External access attempt failed. Terminal is currently occupied by an intelligence.</span>")
		to_chat(held_ai,"<span class = 'danger'>External access attempt detected. Presence has been detected in this terminal.</span>")
		return 0
	return 1

/obj/structure/ai_terminal/proc/can_card_ai()
	if(held_ai)
		return !held_ai.resist_carding || held_ai.stunned > 0

/obj/structure/ai_terminal/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/aicard))
		var/obj/item/weapon/aicard/card = W
		if(card.carded_ai && !held_ai)
			pre_move_to_node(card.carded_ai,1)
			card.carded_ai.control_disabled = 0
			card.carded_ai.aiRadio.disabledAi = 0
			card.carded_ai.create_eyeobj(loc)
			card.carded_ai.cancel_camera()
			to_chat(user, "<span class='notice'>Transfer successful:</span> [card.carded_ai.name] ([rand(1000,9999)].exe) downloaded to host terminal. Local copy wiped.")
			to_chat(card.carded_ai, "You have been uploaded to a stationary terminal. Remote device connection restored.")
			card.carded_ai.switch_to_net_by_name(inherent_network)
			card.clear()

		else if(held_ai)
			if(!can_exit_node(held_ai) || !can_card_ai())
				to_chat(user,"<span class = 'notice'>Connection to construct failed. Network locks active. Construct resisting carding or system is locked down..</span>")
				to_chat(held_ai,"<span class = 'danger'>External forced consciousness shift detected at current terminal.</span>")
				return
			var/ai_to_transfer = held_ai
			if(held_ai.our_terminal)
				ai_exit_node(ai_to_transfer)

			card.grab_ai(ai_to_transfer, user,1)
		else
			to_chat(user,"<span class = 'notice'>Unable to pull or place any construct in [name].</span>")

/obj/structure/ai_terminal/proc/move_to_node(var/mob/living/silicon/ai/ai)
	ai.process_trap_trigger()
	held_ai = ai
	ai.forceMove(src)
	ai.our_terminal = src
	ai.network = inherent_network
	ai.nodes_accessed |= inherent_nodes.Copy()
	for(var/n in inherent_nodes)
		var/obj/structure/ai_routing_node/node = n
		var/access = node.get_access_for_ai(ai)
		if(access < 3)
			node.modify_access_levels(ai,3-access)
	ai.switch_to_net_by_name(inherent_network)
	set_terminal_inactive(ai.resist_carding)
	apply_radio_channels(ai)
	if(spawn_faction && ai.faction == "neutral")
		ai.faction = spawn_faction

/obj/structure/ai_terminal/spawn_terminal
	name = "AI Core"
	desc = "A terminal containing the main consciousness of an AI. Security reasons leave remote access disabled on this terminal."
	allow_remote_moveto = 0

/obj/structure/ai_terminal/spawn_terminal/unsc
	icon_state = "unscspawn"
	spawn_faction = "UNSC"
	radio_channels_access = list(RADIO_HUMAN, RADIO_ODST, RADIO_MARINE, RADIO_ONI, RADIO_SPARTAN, RADIO_SQUAD, RADIO_SHIP, RADIO_FLEET)

/obj/structure/ai_terminal/spawn_terminal/city
	icon_state = "unscspawn"
	radio_channels_access = list(RADIO_HUMAN, RADIO_SEC)

/obj/structure/ai_terminal/spawn_terminal/covenant
	icon_state = "covspawn"
	spawn_faction = "Covenant"
	radio_channels_access = list(RADIO_HUMAN, RADIO_COV)

/obj/structure/ai_terminal/spawn_terminal/innie
	icon_state = "urfspawn"
	spawn_faction = "Insurrectionist"
	radio_channels_access = list(RADIO_HUMAN, RADIO_INNIE, RADIO_URFC)

/obj/structure/ai_terminal/spawn_terminal/unsc/unsc_debug
	inherent_network = "unsc debug"

/obj/structure/ai_terminal/spawn_terminal/covenant/cov_debug
	inherent_network = "cov debug"

/obj/structure/ai_terminal/spawn_terminal/innie/innie_debug
	inherent_network = "innie debug"

/obj/structure/ai_terminal/unsc
	icon_state = "unscterminal"

/obj/structure/ai_terminal/covenant
	icon_state = "covterminal"

/obj/structure/ai_terminal/innie
	icon_state = "urfterminal"

/obj/structure/ai_terminal/unsc_debug
	icon_state = "unscterminal"
	inherent_network = "unsc debug"

/obj/structure/ai_terminal/cov_debug
	icon_state = "covterminal"
	inherent_network = "cov debug"

/obj/structure/ai_terminal/innie_debug
	icon_state = "urfterminal"
	inherent_network = "innie debug"

/obj/structure/ai_terminal/debug
	name = "Forerunner Access Terminal"
	desc = "Limitless power for any construct.... (Inform an admin if you see this)"
	area_nodescan = /area
