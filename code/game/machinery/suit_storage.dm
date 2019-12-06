// Only sane way to do this is with marcos.
#define TRY_INSERT_SUIT_PIECE(slot, path)\
	if(istype(I, /obj/item/##path)){\
		if(!isopen) return;\
		if(##slot){\
			to_chat(user, SPAN_NOTICE("The unit already contains \a [slot]."));\
			return\
		};\
		if(!user.unEquip(I, src)) return;\
		to_chat(user, SPAN_NOTICE("You load the [I.name] into the storage compartment."));\
		##slot = I;\
		update_icon();\
		SSnano.update_uis(src);\
		return\
	}

#define dispense_clothing(item) if(!isopen){return}if(item){item.dropInto(loc); item = null}

/obj/machinery/suit_storage_unit
	name = "Suit Storage Unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "close"
	anchored = 1
	density = 1
	idle_power_usage = 50
	active_power_usage = 200
	interact_offline = 1
	req_access = list()

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null
	var/obj/item/clothing/shoes/magboots/boots = null
	var/obj/item/weapon/tank/tank = null
	var/obj/item/clothing/mask/mask = null

	var/isopen = FALSE
	var/islocked = FALSE
	var/isUV = FALSE
	var/issuperUV = FALSE
	var/panelopen = FALSE
	var/safetieson = TRUE

/obj/machinery/suit_storage_unit/Initialize()
	. = ..()
	if(suit)
		suit = new suit(src)
	if(helmet)
		helmet = new helmet(src)
	if(boots)
		boots = new boots(src)
	if(tank)
		tank = new tank(src)
	if(mask)
		mask = new mask(src)
	update_icon()

/obj/machinery/suit_storage_unit/Destroy()
	dump_everything()
	. = ..()

/obj/machinery/suit_storage_unit/on_update_icon()
	overlays.Cut()
	if(panelopen)
		overlays += ("panel")
	if(isUV)
		if(issuperUV)
			overlays += ("super")
		else if(occupant)
			overlays += ("uvhuman")
		else
			overlays += ("uv")
	else if(isopen)
		if(is_broken())
			overlays += ("broken")
		else
			overlays += ("open")
			if(suit)
				overlays += ("suit")
			if(helmet)
				overlays += ("helm")
			if(boots || tank || mask)
				overlays += ("storage")
	else if(occupant)
		overlays += ("human")

/obj/machinery/suit_storage_unit/get_req_access()
	if(!islocked)
		return list()
	return ..()

/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1)
			if(prob(50))
				dump_everything()
			qdel(src)
		if(2)
			if(prob(35))
				dump_everything()
				qdel(src)

/obj/machinery/suit_storage_unit/attackby(var/obj/item/I, var/mob/user)
	if(isScrewdriver(I))
		if(do_after(user, 50, src))
			panelopen = !panelopen
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("You [panelopen ? "open" : "close"] the unit's maintenance panel."))
			SSnano.update_uis(src)
			update_icon()
		 return
	if(isCrowbar(I))
		if(inoperable() && !islocked && !isopen)
			to_chat(user, SPAN_NOTICE("You begin prying the unit open."))
			if(do_after(user, 50, src))
				isopen = TRUE
				to_chat(user, SPAN_NOTICE("You pry the unit open."))
				SSnano.update_uis(src)
				update_icon()
		else if(islocked)
			to_chat(user, SPAN_WARNING("You can't pry the unit open, it's locked!"))
		return
	if(istype(I, /obj/item/grab) )
		var/obj/item/grab/G = I
		if(!(ismob(G.affecting)) )
			return
		if(!isopen)
			to_chat(user, SPAN_NOTICE("The unit's doors are shut."))
			return
		if(inoperable())
			to_chat(user, SPAN_NOTICE("The unit is not operational."))
			return
		if(occupant || helmet || suit || boots || tank || mask)
			to_chat(user, SPAN_NOTICE("The unit's storage area is too cluttered."))
			return
		visible_message(SPAN_WARNING("[user] starts putting [G.affecting.name] into the Suit Storage Unit."))
		if(do_after(user, 20, src) && G && G.affecting)
			var/mob/M = G.affecting
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.forceMove(src)
			occupant = M
			isopen = FALSE
			add_fingerprint(user)
			qdel(G)
			SSnano.update_uis(src)
			update_icon()
		return

	TRY_INSERT_SUIT_PIECE(suit, clothing/suit/space)
	TRY_INSERT_SUIT_PIECE(helmet, clothing/head/helmet/space)
	TRY_INSERT_SUIT_PIECE(boots, clothing/shoes/magboots)
	TRY_INSERT_SUIT_PIECE(tank, weapon/tank)
	TRY_INSERT_SUIT_PIECE(mask, clothing/mask)
	update_icon()
	SSnano.update_uis(src)

/obj/machinery/suit_storage_unit/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/suit_storage_unit/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()

	data["panelopen"] = panelopen
	data["open"] = isopen
	data["locked"] = islocked
	data["uv"] = isUV
	data["superuv"] = issuperUV
	data["safeties"] = safetieson
	data["helmet"] = helmet
	data["suit"] = suit 
	data["boots"] = boots
	data["tank"] = tank
	data["mask"] = mask

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "suit_storage_unit.tmpl", "Suit Storage Unit", 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/suit_storage_unit/CanUseTopic(var/mob/user)
	if(!user.IsAdvancedToolUser())
		return STATUS_CLOSE
	return ..()

/obj/machinery/suit_storage_unit/OnTopic(var/user, var/list/href_list, var/datum/topic_state/state)
	if(href_list["toggleUV"])
		toggleUV(user)
		return TOPIC_REFRESH
	if(href_list["togglesafeties"])
		togglesafeties(user)
		return TOPIC_REFRESH
	if(href_list["dispense_helmet"])
		dispense_helmet()
		update_icon()
		return TOPIC_REFRESH
	if(href_list["dispense_suit"])
		dispense_suit()
		update_icon()
		return TOPIC_REFRESH
	if(href_list["dispense_boots"])
		dispense_boots()
		update_icon()
		return TOPIC_REFRESH
	if(href_list["dispense_tank"])
		dispense_tank()
		update_icon()
		return TOPIC_REFRESH
	if(href_list["dispense_mask"])
		dispense_mask()
		update_icon()
		return TOPIC_REFRESH
	if(href_list["toggle_open"])
		toggle_open(user)
		update_icon()
		return TOPIC_REFRESH
	if(href_list["toggle_lock"])
		toggle_lock(user)
		return TOPIC_REFRESH
	if(href_list["start_UV"])
		start_UV(user)
		update_icon()
		return TOPIC_REFRESH
	if(href_list["eject_guy"])
		eject_occupant(user)
		update_icon()
		return TOPIC_REFRESH

/obj/machinery/suit_storage_unit/proc/dispense_helmet()
	dispense_clothing(helmet)

/obj/machinery/suit_storage_unit/proc/dispense_suit()
	dispense_clothing(suit)

/obj/machinery/suit_storage_unit/proc/dispense_boots()
	dispense_clothing(boots)

/obj/machinery/suit_storage_unit/proc/dispense_tank()
	dispense_clothing(tank)

/obj/machinery/suit_storage_unit/proc/dispense_mask()
	dispense_clothing(mask)

/obj/machinery/suit_storage_unit/proc/dump_everything()
	if(islocked)
		islocked = FALSE
	if(!isopen)
		isopen = TRUE
	dispense_clothing(helmet)
	dispense_clothing(suit)
	dispense_clothing(boots)
	dispense_clothing(tank)
	dispense_clothing(mask)
	if(occupant)
		eject_occupant(occupant)

/obj/machinery/suit_storage_unit/proc/toggleUV(var/mob/user)
	if(!panelopen)
		return
	else
		issuperUV = !issuperUV
		to_chat(user, issuperUV ? SPAN_WARNING("You crank the dial all the way up to \"15nm\".") : SPAN_NOTICE("You slide the dial back towards \"185nm\"."))

/obj/machinery/suit_storage_unit/proc/togglesafeties(var/mob/user)
	if(!panelopen)
		return
	else
		safetieson = !safetieson
		to_chat(user, SPAN_NOTICE("You push the button. The coloured LED next to it [safetieson ? "turns green" : "turns red"]."))

/obj/machinery/suit_storage_unit/proc/toggle_open(var/mob/user)
	if(is_unpowered())
		to_chat(user, SPAN_NOTICE("The unit is offline."))
		return
	if(islocked || isUV)
		to_chat(user, SPAN_NOTICE("Unable to open unit."))
		return
	if(occupant)
		eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	isopen = !isopen
	playsound(src, 'sound/machines/suitstorage_cycledoor.ogg', 50, 0)

/obj/machinery/suit_storage_unit/proc/toggle_lock(var/mob/user)
	if(is_unpowered())
		to_chat(user, SPAN_NOTICE("The unit is offline."))
		return
	if(!allowed(user))
		to_chat(user, FEEDBACK_ACCESS_DENIED)
		return
	if(occupant && safetieson)
		to_chat(user, SPAN_WARNING("The Unit's safety protocols disallow locking when a biological form is detected inside its compartments."))
		return
	if(isopen)
		return
	islocked = !islocked
	playsound(src, 'sound/machines/suitstorage_lockdoor.ogg', 50, 0)

/obj/machinery/suit_storage_unit/proc/start_UV(var/mob/user)
	if(isUV || isopen)
		return
	if(is_unpowered())
		to_chat(user, SPAN_NOTICE("The unit is offline."))
		return
	if(occupant && safetieson)
		to_chat(user, SPAN_WARNING("Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle."))
		return
	if(!helmet  && !mask && !suit && !boots && !tank && !occupant )
		to_chat(user, SPAN_NOTICE("Unit storage bays empty. Nothing to disinfect -- Aborting."))
		return
	if(occupant && !islocked)
		islocked = TRUE
	to_chat(user, SPAN_NOTICE("You start the Unit's cauterisation cycle."))
	isUV = TRUE
	update_use_power(POWER_USE_ACTIVE)
	update_icon()
	SSnano.update_uis(src)

	var/datum/callback/uvburn = CALLBACK(src, .proc/uv_burn)
	addtimer(uvburn, 5 SECONDS)
	addtimer(uvburn, 10 SECONDS)
	addtimer(uvburn, 15 SECONDS)
	addtimer(CALLBACK(src, .proc/uv_finish), 20 SECONDS)

/obj/machinery/suit_storage_unit/proc/uv_burn()
	if(occupant)
		occupant.apply_damage(50, IRRADIATE, damage_flags = DAM_DISPERSED)
		var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in occupant.internal_organs
		if(!rad_organ)
			if(occupant.can_feel_pain())
				occupant.emote("scream")
			if(issuperUV)
				var/burndamage = rand(40,60)
				occupant.take_organ_damage(0,burndamage)
			else
				var/burndamage = rand(10,15)
				occupant.take_organ_damage(0,burndamage)

/obj/machinery/suit_storage_unit/proc/uv_finish()
	isUV = FALSE
	if(issuperUV)
		if(helmet )
			helmet  = null
		if(suit)
			suit = null
		if(boots)
			boots = null
		if(tank)
			tank = null
		if(mask)
			mask = null
		visible_message(SPAN_WARNING("With a loud whining noise, the Suit Storage Unit's door grinds open. Puffs of ashen smoke come out of its chamber."))
		set_broken(TRUE)
		isopen = TRUE
		islocked = FALSE         //
		eject_occupant(occupant) // Mixing up these two lines causes bug. DO NOT DO IT.
	else
		if(helmet )
			helmet.clean_blood()
		if(suit)
			suit.clean_blood()
		if(boots)
			boots.clean_blood()
		if(tank)
			tank.clean_blood()
		if(mask)
			mask.clean_blood()
	update_use_power(POWER_USE_IDLE)
	update_icon()
	SSnano.update_uis(src)

/obj/machinery/suit_storage_unit/proc/eject_occupant(var/mob/user)
	if(islocked)
		return
	if(!occupant)
		return
	if(!isopen)
		isopen = TRUE
	visible_message(SPAN_NOTICE("The suit storage unit spits out [occupant]."))
	occupant.reset_view()
	occupant.dropInto(loc)
	occupant = null
	update_icon()

/obj/machinery/suit_storage_unit/verb/get_out()
	set name = "Eject Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.incapacitated())
		return
	eject_occupant(usr)
	add_fingerprint(usr)
	SSnano.update_uis(src)
	update_icon()

/obj/machinery/suit_storage_unit/verb/move_inside()
	set name = "Hide in Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.incapacitated())
		return
	if (!isopen)
		to_chat(usr, SPAN_NOTICE("The unit's doors are shut."))
		return
	if (inoperable())
		to_chat(usr, SPAN_NOTICE("The unit is not operational."))
		return
	if ( (occupant) || (helmet ) || (suit) )
		to_chat(usr, SPAN_WARNING("It's too cluttered inside for you to fit in!"))
		return
	visible_message(SPAN_NOTICE("\The [usr] starts squeezing into the suit storage unit!"))
	if(do_after(usr, 10, src))
		usr.reset_view(src)
		usr.stop_pulling()
		usr.forceMove(src)
		occupant = usr
		isopen = FALSE
		update_icon()
		add_fingerprint(usr)
		SSnano.update_uis(src)

#undef TRY_INSERT_SUIT_PIECE
#undef dispense_clothing