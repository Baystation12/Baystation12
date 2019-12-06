/datum/phenomena/herald
	name = "Bestow Heraldry"
	desc = "Turn one of your followers into a herald of your coming."
	cost = 100
	cooldown = 60 SECONDS
	flags = PHENOMENA_FOLLOWER
	expected_type = /mob/living/carbon/human
	var/static/list/possible_forms = list(
									"Champion" = list("description" = "A protector of the faith. Fully protected by knightly armor, a Champion can shoot fire from their hands.",
													"armor" = /obj/item/clothing/suit/armor/sunsuit,
													"helm" = /obj/item/clothing/head/helmet/sunhelm,
													"extension" = /datum/extension/deity_be_near/champion,
													"spells" = list(/spell/hand/duration/sunwrath)
													),
									"Oracle" = list("description" = "A preacher of the faith, the Oracle gives off heavenly light that they can use to heal followers and stun enemies.",
												"armor" = /obj/item/clothing/suit/armor/sunrobe,
												"extension" = /datum/extension/deity_be_near/oracle,
												"spells" = list(/spell/targeted/glimpse_of_eternity)
												),
									"Traitor" = list("description" = "Believers that reject the sun god's blessings, instead reveling in the shadows. Can turn invisible when its dark, and can move unprotected in space.",
												"armor" = /obj/item/clothing/suit/space/shadowsuit,
												"helm" = /obj/item/clothing/head/helmet/space/shadowhood,
												"extension" = /datum/extension/deity_be_near/traitor,
												"spells" = list(/spell/veil_of_shadows)
												)
									)

/datum/phenomena/herald/can_activate(var/a)
	if(!..())
		return FALSE
	return valid_for_herald(a)

/datum/phenomena/herald/proc/valid_for_herald(var/a)
	var/mob/living/carbon/human/H = a
	if(!istype(H))
		return FALSE
	var/obj/item/I = H.get_equipped_item(slot_wear_suit)
	if(I)
		var/datum/extension/deity_be_near/dbn = get_extension(I, /datum/extension/deity_be_near)
		if(dbn)
			return FALSE
	return TRUE

/datum/phenomena/herald/proc/equip_slot(var/mob/living/L, var/slot_id, var/new_item)
	var/equipped = L.get_inventory_slot(slot_id)
	if(equipped)
		L.unEquip(equipped, get_turf(L))
	L.equip_to_slot_if_possible(new_item, slot_id)

/datum/phenomena/herald/Topic(var/href, var/list/href_list)
	if(..())
		return 1
	if(usr != linked)
		return 1

	if(href_list["herald"])
		var/list/form = possible_forms[href_list["herald"]]
		var/mob/living/L = locate(href_list["target"])
		var/turf/T = get_turf(L)
		if(!L || !valid_for_herald(L) || !form)
			return 1
		var/type = form["armor"]
		var/obj/item/I = new type(T)
		var/datum/extension/deity_be_near/extension = set_extension(I, form["extension"], linked)
		L.equip_to_slot_or_store_or_drop(I, slot_wear_suit)
		if(form["helm"])
			var/h_type = form["helm"]
			var/obj/item/helm = new h_type(T)
			L.equip_to_slot_or_store_or_drop(helm, slot_head)
			extension.expected_helmet = helm.type //We only do by type because A. its easier to manage and B the chances of it being non-unique in a normal game is very small
		if(form["weapon"])
			var/w_type = form["weapon"]
			L.equip_to_slot_or_store_or_drop(new w_type(T), slot_r_hand)
		if(form["spells"])
			for(var/s in form["spells"])
				var/spell/S = new s
				S.set_connected_god(linked)
				L.add_spell(S)
		to_chat(L, "<span class='notice'>You have been chosen by your master to lead your fellow followers into the next age of rebirth.<br>You have been granted powerful armor and a powerful spell. Don't lose them, as they are your key to your divinity and leadership.<br>You also have particular sway over your deity's structures.</span>")
		to_chat(linked, "<span class='notice'>\The [L] is now your herald!</span>")
		linked.remove_phenomena(name)
		show_browser(linked, null, "window=herald")

/datum/phenomena/herald/activate(var/mob/living/carbon/human/H)
	var/list/html = list()
	html += "<center><h2>Heralds</h2></center>"
	html += "<br><i>Pick the type of herald you want.</i></br>"
	html += "<table><tr><td><b>Name</b></td><td><b>Description</b></td></tr>"
	for(var/type in possible_forms)
		var/list/form = possible_forms[type]
		html += "<tr><td><a href='?src=\ref[src];herald=[type];target=\ref[H]'>[type]</a></td><td>[form["description"]]</td></tr>"
	html += "</table>"
	show_browser(linked, jointext(html,null), "window=herald")

/datum/phenomena/create_gateway
	name = "Create Gateway"
	desc = "Creates a gateway from this world to the next. Gateways syphon absurd amounts of power but can be sacrificed to summon powerful minions."
	cost = 200
	flags = PHENOMENA_NEAR_STRUCTURE
	expected_type = /atom

/datum/phenomena/create_gateway/can_activate(var/atom/a)
	if(!..())
		return 0
	if(istype(a, /obj/structure/deity/gateway))
		var/obj/structure/deity/gateway/G = a
		if(G.linked_god == linked)
			return 1
	var/turf/T = get_turf(a)
	if(!T || T.density)
		return 0
	for(var/i in T)
		var/atom/at = i
		if(at.density)
			return 0
	return 1

/datum/phenomena/create_gateway/activate(var/atom/a)
	..()
	if(istype(a, /obj/structure/deity/gateway))
		qdel(a)
	else
		new /obj/structure/deity/gateway(get_turf(a), linked)

/datum/phenomena/flickering_whisper
	name = "Flickering Whisper"
	desc = "Whisper to a non-believer, allowing you to intrude on their thoughts and see what they see."
	flags = PHENOMENA_NONFOLLOWER
	expected_type = /mob/living

/datum/phenomena/flickering_whisper/activate(var/mob/living/L)
	var/atom/whisper_from
	for(var/obj/structure/deity/radiant_statue/rs in view(3, L))
		whisper_from = rs
		break
	var/message = sanitize(input(linked, "What is your message?", null) as null|text)
	if(!linked || !message || QDELETED(src))
		return
	to_chat(L, "<span class='cult'>[whisper_from ? "The [whisper_from] speaks to you" : "You hear a whisper say"] \"[message]\"</span>")
	linked.eyeobj.visualnet.add_source(L)
	GLOB.destroyed_event.register(L, src, .proc/deactivate_look)
	addtimer(CALLBACK(src, .proc/deactivate_look, L), 30 SECONDS)

/datum/phenomena/flickering_whisper/proc/deactivate_look(var/mob/viewer)
	if(!linked.is_follower(viewer)) //Don't remove if they are follower
		linked.eyeobj.visualnet.remove_source(viewer)
	GLOB.destroyed_event.unregister(viewer, src)

/datum/phenomena/burning_glare
	name = "Burning Glare"
	desc = "Burn a victim. If they are burnt enough, you'll set them ablaze."
	cost = 100
	flags = PHENOMENA_NONFOLLOWER|PHENOMENA_NEAR_STRUCTURE
	cooldown = 30 SECONDS
	expected_type = /mob/living

/datum/phenomena/burning_glare/activate(var/mob/living/L)
	..()
	to_chat(L, "<span class='danger'>You feel yourself burn!</span>")
	L.adjustFireLoss(10)
	if(L.getFireLoss() > 60)
		L.fire_stacks += 50
		L.IgniteMob()

/datum/phenomena/divine_right
	name = "Divine Right"
	desc = "Trigger your rebirth into the body of someone wearing a herald's uniform. This takes time, requires 3 open gateways, and if the body is destroyed during the ritual... so are you. But once complete, you become an unstoppable demigod of unnatural power."
	cost = 300
	cooldown = 180 SECONDS
	flags = PHENOMENA_FOLLOWER|PHENOMENA_NEAR_STRUCTURE
	expected_type = /mob/living

/datum/phenomena/divine_right/can_activate(var/mob/living/L)
	if(!..())
		return FALSE
	var/active_gateways = 0
	for(var/obj/structure/deity/gateway/G in linked.structures)
		active_gateways += 1

	if(active_gateways < 3)
		to_chat(linked, "<span class='warning'>You do not have enough gateways activated.</span>")
		return FALSE

	var/obj/O = L.get_equipped_item(slot_wear_suit)
	if(O && has_extension(O, /datum/extension/deity_be_near))
		var/datum/extension/deity_be_near/dbn = get_extension(O, /datum/extension/deity_be_near)
		if(dbn.wearing_full())
			return TRUE
		to_chat(linked, "<span class='warning'>\The [L] is not wearing a herald's uniform.</span>")
	return FALSE

/datum/phenomena/divine_right/activate(var/mob/living/L)
	..()
	to_chat(L, "<span class='cult'>Your soul is ripped from your body as your master prepares to possess it.</span>")
	to_chat(linked, "<span class='cult'>You prepare the body for possession. Keep it safe. If it is totally destroyed, you will die.</span>")
	L.ghostize()
	L.Weaken(1)
	new /obj/aura/starborn(L)
	L.status_flags |= GODMODE
	GLOB.destroyed_event.register(L,src,.proc/fail_ritual)
	addtimer(CALLBACK(src, .proc/succeed_ritual, L), 600 SECONDS) //6 minutes
	for(var/mob/living/player in GLOB.player_list)
		sound_to(player, 'sound/effects/cascade.ogg')
		if(player.mind && istype(player.mind.assigned_job, /datum/job/chaplain))
			to_chat(player, "<span class='cult'>Something bad is coming.... you know you don't have much time. Find and destroy the vessel, before its too late.</span>")
		else if(player != linked && !linked.is_follower(player, silent = 1))
			to_chat(player, "<span class='warning'>The world swims around you for just a moment... something is wrong. Very wrong.</span>")
		else
			to_chat(player, "<span class='notice'>Your Master is being reborn into the body of \the [L]. Protect it at all costs.</span>")

/datum/phenomena/divine_right/proc/fail_ritual(var/mob/living/L)
	qdel(linked)

/datum/phenomena/divine_right/proc/succeed_ritual(var/mob/living/L)
	to_chat(linked, "<span class='cult'>You have been reborn! Your power is limited here, focused on your body, but in return you are both eternal and physical.</span>")
	for(var/mob/living/player in GLOB.player_list)
		sound_to(player, 'sound/effects/cascade.ogg')
		to_chat(player, "<span class='cult'>\The [linked] has been born into flesh. Kneel to its authority or else.</span>")
	linked.mind.transfer_to(L)
	L.SetName("[linked] Incarnate")
	L.real_name = "[linked] Incarnate"

/datum/phenomena/movable_object/wisp
	name = "Wisp"
	desc = "Creates or moves a small ball of light for your followers to use."
	cost = 30
	object_type = /obj/item/device/flashlight/slime

/datum/phenomena/movable_object/wisp/add_object()
	..()
	object_to_move.SetName("wisp")