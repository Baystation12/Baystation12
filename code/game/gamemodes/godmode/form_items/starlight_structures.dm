/obj/structure/deity/altar/starlight
	icon_state = "altarcandle"

/obj/structure/deity/pylon/starlight
	name = "sun pylon"
	desc = "A minature sun, floating ontop of a small pillar."
	icon_state = "star_pylon"

/obj/structure/deity/gateway
	name = "gateway"
	desc = "A gateway into the unknown."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"
	power_adjustment = 1
	density = 0
	var/weakref/target_ref
	var/start_time = 0
	var/power_drain = 7
	var/looking_for
	var/static/list/possible_forms = list(
								"Starborn" = list(
												"description" = "A species of hardy fire-wreathed soldiers.",
												"message" = "As a Starborn, you are immune to laser-fire you are a hardy soldier, able to take on the greatest of foes.",
												"species" = "Starborn"
											),
								"Blueforged" = list(
												"description" = "Trans-dimensional beings with a multitude of miraculous abilities.",
												"message" = "As a Blueforged, you are immune to all physical damage... except for heat. Not even your god can protect you.",
												"species" = "Blueforged",
												"spells" = list(
													/spell/targeted/ethereal_jaunt,
													/spell/targeted/shatter,
													/spell/hand/burning_grip,
													/spell/aoe_turf/disable_tech,
													/spell/targeted/projectile/magic_missile,
													/spell/open_gateway
												)
											),
								"Shadowling" = list(
												"description" = "Beings that come from a place of no light. They sneak from place to place, disabling everyone they touch..",
												"message" = "As a Shadow you take damage from the light itself but have the ability to vanish from sight itself.",
												"species" = "Shadow",
												"spells" = list(
															/spell/veil_of_shadows,
															/spell/targeted/subjugation,
															/spell/targeted/projectile/magic_missile
														)
											)
										)

/obj/structure/deity/gateway/New()
	..()
	if(linked_god)
		linked_god.power_per_regen -= power_drain
	START_PROCESSING(SSobj, src)

/obj/structure/deity/gateway/Process()
	if(!linked_god)
		return
	if(linked_god.power <= 0)
		to_chat(linked_god,"<span class='warning'>\The [src] disappears from your lack of power!</span>")
		qdel(src)
		return
	var/mob/living/carbon/human/target
	if(target_ref)
		target = target_ref.resolve()
	if(target)
		if(get_turf(target) != get_turf(src))
			target = null
			target_ref = null
			start_time = 0
			return
		else if(prob(5))
			to_chat(target,"<span class='danger'>\The [src] sucks at your lifeforce!</span>")
		if(start_time && world.time > start_time + 300)
			start_time = 0
			to_chat(target,"<span class='danger'>You have been sucked into \the [src], your soul used to fuel \the [linked_god]'s minions.</span>")
			var/mob/living/starlight_soul/ss = new(get_turf(linked_god),target)
			if(target.mind)
				target.mind.transfer_to(ss)
			else
				ss.ckey = target.ckey
			ss.set_deity(linked_god)
			target.dust()
			if(power_drain >= 3)
				linked_god.power_per_regen += 3
				power_drain -= 3
	else
		//Get new target
		var/mob/living/carbon/human/T = locate() in get_turf(src)
		if(T)
			target_ref = weakref(T)
			start_time = world.time
			to_chat(T, "<span class='danger'>You feel your lifeforce begin to drain into \the [src]!</span>")

/obj/structure/deity/gateway/Destroy()
	linked_god.power_per_regen += power_drain
	. = ..()

/obj/structure/deity/gateway/attack_deity(var/mob/living/deity/deity)
	var/list/html = list()
	html += "<h3>Servant List</h3>"
	html += "<br><i>Select a minion type to summon</i></br>"
	html += "<table><tr><td>Name</td><td>Description</td></tr>"
	for(var/a in possible_forms)
		var/list/form = possible_forms[a]
		html += "<tr><td><a href='?src=\ref[src];spawn_type=[a]'>[a]</a></td><td>[form["description"]]</td></tr>"
	html += "</table>"
	show_browser(linked_god, jointext(html, null), "window=gateway")

/obj/structure/deity/gateway/CanUseTopic(var/mob/user)
	if(linked_god && (user == linked_god || user.loc == linked_god.loc))
		return STATUS_INTERACTIVE
	return STATUS_CLOSE

/obj/structure/deity/gateway/proc/stop_looking_for(var/successful)
	if(looking_for)
		if(!successful)
			to_chat(linked_god, "<span class='warning'>\The [src] did not find any [looking_for]. You may try again if you wish.</span>")
		looking_for = null

/obj/structure/deity/gateway/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["accept"] && istype(user,/mob/living/starlight_soul))
		if(href_list["accept"] != looking_for)
			return TOPIC_HANDLED
		var/mob/living/carbon/human/H = new(get_turf(src))
		user.mind.transfer_to(H)
		H.set_species(possible_forms[looking_for]["species"])
		for(var/s in possible_forms[looking_for]["spells"])
			var/spell/S = new s
			H.add_spell(S)
		GLOB.godcult.add_antagonist_mind(H.mind, 1, "[looking_for] of [linked_god]", "You are a powerful entity in the service to \the [linked_god]. [possible_forms[looking_for]["species"]]", specific_god = linked_god)
		stop_looking_for(TRUE)

		return TOPIC_HANDLED
	if(href_list["spawn_type"] && user == linked_god)
		if(looking_for)
			to_chat(usr, "<span class='warning'>\The [src] is already looking for a [looking_for].</span>")
		else
			looking_for = href_list["spawn_type"]
			to_chat(usr, "<span class='notice'>\The [src] is now looking for a [looking_for].</span>")
			for(var/l in get_turf(linked_god))
				if(istype(l, /mob/living/starlight_soul))
					to_chat(l, "<span class='notice'>\The [src] is looking for a soul to become a [looking_for]. Accept?</span> (<a href='?\ref[src];accept=[looking_for]'>Yes</a>)")
			addtimer(CALLBACK(src, .proc/stop_looking_for, FALSE), 30 SECONDS)
		show_browser(linked_god, null, "window=gateway")
		return TOPIC_HANDLED

/obj/structure/deity/radiant_statue
	name = "radiant statue"
	icon_state = "statue"
	build_cost = 750
	power_adjustment = 1
	deity_flags = DEITY_STRUCTURE_NEAR_IMPORTANT|DEITY_STRUCTURE_ALONE
	var/charge = 0
	var/charging = 0 //Charging, dispersing, etc.

/obj/structure/deity/radiant_statue/on_update_icon()
	if(charging)
		icon_state = "statue_charging"
	else if(charge)
		icon_state = "statue_active"
	else
		icon_state = "statue"

/obj/structure/deity/radiant_statue/Destroy()
	if(charging)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/deity/radiant_statue/proc/get_followers_nearby()
	. = list()
	if(linked_god)
		for(var/m in linked_god.minions)
			var/datum/mind/M = m
			if(get_dist(M.current, src) <= 3)
				. += M.current

/obj/structure/deity/radiant_statue/attack_hand(var/mob/living/L)
	if(!istype(L))
		return
	var/obj/O = L.get_equipped_item(slot_wear_suit)
	if(O && has_extension(O,/datum/extension/deity_be_near))
		if(activate_charging())
			to_chat(L, "<span class='notice'>You place your hands on \the [src], feeling your master's power course through you.</span>")
		else
			to_chat(L, "<span class='warning'>\The [src] is already activated</span>")
	else
		to_chat(L, "<span class='warning'>\The [src] does not recognize you as a herald of \the [linked_god]. You must wear a full set of herald's armor.</span>")

/obj/structure/deity/radiant_statue/attack_deity(var/mob/living/deity/deity)
	if(activate_charging())
		to_chat(deity,"<span class='notice'>You activate \the [src], and it begins to charge as long as at least one of your followers is nearby.</span>")
	else
		to_chat(deity,"<span class='warning'>\The [src] is either already activated, or there are no followers nearby to charge it.</span>")

/obj/structure/deity/radiant_statue/proc/activate_charging()
	var/list/followers = get_followers_nearby()
	if(is_processing || !followers.len)
		return 0
	charging = 1
	START_PROCESSING(SSobj, src)
	src.visible_message("<span class='notice'><b>\The [src]</b> hums, activating.</span>")
	update_icon()
	return 1

/obj/structure/deity/radiant_statue/attackby(var/obj/item/I, var/mob/user)
	if(charging && (istype(I, /obj/item/weapon/material/knife/ritual/shadow) || istype(I, /obj/item/weapon/gun/energy/staff/beacon)) && charge_item(I, user))
		return
	..()

/obj/structure/deity/radiant_statue/proc/charge_item(var/obj/item/I, var/mob/user)
	. = 0
	if(istype(I, /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/energy = I
		if(energy.power_supply)
			energy.power_supply.give(energy.charge_cost * energy.max_shots)
			. = 1
	else if(istype(I ,/obj/item/weapon/material/knife/ritual/shadow))
		var/obj/item/weapon/material/knife/ritual/shadow/shad = I
		shad.charge = initial(shad.charge)
		. = 1
	if(.)
		to_chat(user, "<span class='notice'>\The [src]'s glow envelops \the [I], restoring it to proper use.</span>")
		charge -= 1

/obj/structure/deity/radiant_statue/Process()
	if(charging)
		charge++
		var/list/followers = get_followers_nearby()
		if(followers.len == 0)
			stop_charging()
			return

		if(charge == 40)
			src.visible_message("<span class='notice'><b>\The [src]</b> lights up, pulsing with energy.</span>")
			charging = 0
			update_icon()
	else
		charge -= 0.5
		var/list/followers = get_followers_nearby()
		if(followers.len)
			for(var/m in followers)
				var/mob/living/L = m
				L.adjustFireLoss(-5)
				if(prob(5))
					to_chat(L, "<span class='notice'>You feel a pleasant warmth spread throughout your body...</span>")
				for(var/s in L.mind.learned_spells)
					var/spell/spell = s
					spell.charge_counter = spell.charge_max
		if(charge == 0)
			stop_charging()

/obj/structure/deity/radiant_statue/proc/stop_charging()
	STOP_PROCESSING(SSobj, src)
	src.visible_message("<span class='notice'><b>\The [src]</b> powers down, returning to it's dormant form.</span>")
	charging = 0
	update_icon()

/obj/structure/deity/blood_forge/starlight
	name = "radiant forge"
	desc = "a swath of heat and fire permeats from this forge."
	recipe_feat_list = "Fire Crafting"
	text_modifications = list("Cost" = "Burn",
								"Dip" = "fire. Pain envelopes you as dark burns mar your hands and you begin to shape it into something more useful",
								"Shape" = "You shape the fire, ignoring the painful burns it gives you in the process.",
								"Out" = "flames")
