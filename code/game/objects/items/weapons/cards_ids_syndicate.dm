var/global/list/syndicate_ids = list()

/obj/item/weapon/card/id/syndicate
	name = "agent card"
	assignment = "Agent"
	var/list/initial_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)
	origin_tech = list(TECH_ILLEGAL = 3)
	var/registered_user = null

/obj/item/weapon/card/id/syndicate/New(mob/user as mob)
	syndicate_ids += src
	..()
	access = initial_access.Copy()

/obj/item/weapon/card/id/syndicate/Destroy()
	syndicate_ids -= src
	registered_user = null
	return ..()

/mob/Destroy()
	// On mob destruction, ensure any references are cleared
	for(var/obj/item/weapon/card/id/syndicate/SID in syndicate_ids)
		if(SID.registered_user = user)
			registered_user = null
	return ..()

/obj/item/weapon/card/id/syndicate/afterattack(var/obj/item/weapon/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = O
		src.access |= I.access
		if(player_is_antag(user))
			user << "<span class='notice'>\The [src]'s microscanners activate as you pass it over the ID, copying its access.</span>"

/obj/item/weapon/card/id/syndicate/attack_self(mob/user as mob)
	if(!registered_user)
		registered_user = user
	if(registered_user == user)
		switch(alert("Would you like edit the ID, or show it?","Edit","Show"))
			if("Edit")
				ui_interact(user)
			if("Show")
				..()
	else
		..()

/obj/item/weapon/card/id/syndicate/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["hide_breakers"] = hide_breakers

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "agent_id_card.tmpl", "Agent id", 600, 400)
		ui.set_initial_data(data)
		ui.open()

/obj/item/weapon/card/id/syndicate/CanUseTopic(mob/user)
	if(user != registered_user)
		return STATUS_CLOSE
	return ..()

/obj/item/weapon/card/id/syndicate/Topic(href, href_list, var/nowindow = 0, var/datum/topic_state/state)
	if(..())
		return 1

	update_uis(src)
	return 1
