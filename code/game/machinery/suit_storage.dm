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
	name = "suit storage unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/machines/suitstorage.dmi'
	icon_state = "close"
	anchored = TRUE
	density = TRUE
	idle_power_usage = 50
	active_power_usage = 200
	interact_offline = 1
	req_access = list()

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null
	var/obj/item/clothing/shoes/magboots/boots = null
	var/obj/item/tank/tank = null
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
	ClearOverlays()
	if(panelopen)
		AddOverlays(("panel"))
	if(isUV)
		if(issuperUV)
			AddOverlays(("super"))
		else if(occupant)
			AddOverlays(("uvhuman"))
		else
			AddOverlays(("uv"))
	else if(isopen)
		if(MACHINE_IS_BROKEN(src))
			AddOverlays(("broken"))
		else
			AddOverlays(("open"))
			if(suit)
				AddOverlays(("suit"))
			if(helmet)
				AddOverlays(("helm"))
			if(boots || tank || mask)
				AddOverlays(("storage"))
	else if(occupant)
		AddOverlays(("human"))

/obj/machinery/suit_storage_unit/get_req_access()
	if(!islocked)
		return list()
	return ..()

/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			if(prob(50))
				dump_everything()
			qdel(src)
		if(EX_ACT_HEAVY)
			if(prob(35))
				dump_everything()
				qdel(src)

/obj/machinery/suit_storage_unit/use_tool(obj/item/I, mob/living/user, list/click_params)
	if ((. = ..()))
		return

	if(isScrewdriver(I))
		if(do_after(user, (I.toolspeed * 5) SECONDS, src, DO_REPAIR_CONSTRUCT))
			panelopen = !panelopen
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			to_chat(user, SPAN_NOTICE("You [panelopen ? "open" : "close"] the unit's maintenance panel."))
			SSnano.update_uis(src)
			update_icon()
		 return TRUE

	if(isCrowbar(I))
		if(inoperable() && !islocked && !isopen)
			to_chat(user, SPAN_NOTICE("You begin prying the unit open."))
			if(do_after(user, (I.toolspeed * 5) SECONDS, src, DO_REPAIR_CONSTRUCT))
				isopen = TRUE
				to_chat(user, SPAN_NOTICE("You pry the unit open."))
				SSnano.update_uis(src)
				update_icon()
		else if(islocked)
			to_chat(user, SPAN_WARNING("You can't pry the unit open, it's locked!"))
		return TRUE

	TRY_INSERT_SUIT_PIECE(suit, clothing/suit/space)
	TRY_INSERT_SUIT_PIECE(helmet, clothing/head/helmet/space)
	TRY_INSERT_SUIT_PIECE(boots, clothing/shoes/magboots)
	TRY_INSERT_SUIT_PIECE(tank, tank)
	TRY_INSERT_SUIT_PIECE(mask, clothing/mask)
	update_icon()
	SSnano.update_uis(src)
	return TRUE

/obj/machinery/suit_storage_unit/proc/move_target_inside(mob/target, mob/user)
	visible_message(SPAN_WARNING("\The [user] starts putting \the [target] into \the [src]."))
	add_fingerprint(user)
	if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
		if(!user_can_move_target_inside(target, user))
			return
		if (target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = src
		target.forceMove(src)
		occupant = target
		if (user != target)
			add_fingerprint (target)
		isopen = FALSE
		target.remove_grabs_and_pulls()
		SSnano.update_uis(src)
		update_icon()

/obj/machinery/suit_storage_unit/user_can_move_target_inside(mob/target, mob/user)
	if (!isopen)
		to_chat(user, SPAN_NOTICE("The unit's doors are shut."))
		return FALSE
	if (occupant || suit || tank || (helmet && boots && mask))
		to_chat(user, SPAN_NOTICE("The unit's storage area is too cluttered."))
		return FALSE
	return ..()

/obj/machinery/suit_storage_unit/use_grab(obj/item/grab/grab, list/click_params)
	if (!user_can_move_target_inside(grab.affecting, grab.assailant))
		return TRUE
	move_target_inside(grab.affecting, grab.assailant)
	return TRUE

/obj/machinery/suit_storage_unit/MouseDrop_T(mob/target, mob/user)
	if (!ismob(target) || !CanMouseDrop(target, user))
		return
	if (user != target)
		to_chat(user, SPAN_WARNING("You need to grab \the [target] to be able to do that!"))
		return
	else if (user_can_move_target_inside(target, user))
		move_target_inside(target, user)
		return

/obj/machinery/suit_storage_unit/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/suit_storage_unit/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
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

/obj/machinery/suit_storage_unit/CanUseTopic(mob/user)
	if(!user.IsAdvancedToolUser())
		return STATUS_CLOSE
	return ..()

/obj/machinery/suit_storage_unit/OnTopic(user, list/href_list, datum/topic_state/state)
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

/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user)
	if(!panelopen)
		return
	else
		issuperUV = !issuperUV
		to_chat(user, issuperUV ? SPAN_WARNING("You crank the dial all the way up to \"15nm\".") : SPAN_NOTICE("You slide the dial back towards \"185nm\"."))

/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user)
	if(!panelopen)
		return
	else
		safetieson = !safetieson
		to_chat(user, SPAN_NOTICE("You push the button. The coloured LED next to it [safetieson ? "turns green" : "turns red"]."))

/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user)
	if(!is_powered())
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

/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user)
	if(!is_powered())
		to_chat(user, SPAN_NOTICE("The unit is offline."))
		return
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user, src)
		return
	if(occupant && safetieson)
		to_chat(user, SPAN_WARNING("The Unit's safety protocols disallow locking when a biological form is detected inside its compartments."))
		return
	if(isopen)
		return
	islocked = !islocked
	playsound(src, 'sound/machines/suitstorage_lockdoor.ogg', 50, 0)

/obj/machinery/suit_storage_unit/proc/start_UV(mob/user)
	if(isUV || isopen)
		return
	if(!is_powered())
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

	var/datum/callback/uvburn = new Callback(src, PROC_REF(uv_burn))
	addtimer(uvburn, 5 SECONDS)
	addtimer(uvburn, 10 SECONDS)
	addtimer(uvburn, 15 SECONDS)
	addtimer(new Callback(src, PROC_REF(uv_finish)), 20 SECONDS)

/obj/machinery/suit_storage_unit/proc/uv_burn()
	if(occupant)
		occupant.apply_damage(50, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
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

/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user)
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
	if(do_after(usr, 1 SECOND, src, DO_PUBLIC_UNIQUE))
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
