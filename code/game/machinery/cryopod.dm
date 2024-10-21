/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 */


//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/machines/medical/cryopod.dmi'
	icon_state = "cellconsole"
	density = FALSE
	interact_offline = 1
	stat_immune = MACHINE_STAT_NOSCREEN | MACHINE_STAT_NOINPUT | MACHINE_STAT_NOPOWER
	var/mode = null

	//Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	var/list/frozen_items = list()
	var/list/_admin_logs = list() // _ so it shows first in VV

	var/storage_type = "crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = 1

/obj/machinery/computer/cryopod/robot
	name = "robotic storage console"
	desc = "An interface between crew and the robotic storage systems."
	icon = 'icons/obj/machines/robot_storage.dmi'
	icon_state = "console"

	storage_type = "cyborgs"
	storage_name = "Robotic Storage Control"
	allow_items = 0

/obj/machinery/computer/cryopod/on_update_icon()
	return

/obj/machinery/computer/cryopod/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/cryopod/interact(mob/user)
	user.set_machine(src)

	var/dat

	dat += "<hr/><br/><b>[storage_name]</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View storage log</a>.<br>"
	if(allow_items)
		dat += "<a href='?src=\ref[src];view=1'>View objects</a>.<br>"
		dat += "<a href='?src=\ref[src];item=1'>Recover object</a>.<br>"
		dat += "<a href='?src=\ref[src];allitems=1'>Recover all objects</a>.<br>"

	show_browser(user, dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/OnTopic(user, href_list, state)
	if(href_list["log"])
		var/dat = "<b>Recently stored [storage_type]</b><br/><hr/><br/>"
		for(var/person in frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"
		show_browser(user, dat, "window=cryolog")
		. = TOPIC_REFRESH

	else if(href_list["view"])
		if(!allow_items) return

		var/dat = "<b>Recently stored objects</b><br/><hr/><br/>"
		for(var/obj/item/I in frozen_items)
			dat += "[I.name]<br/>"
		dat += "<hr/>"

		show_browser(user, dat, "window=cryoitems")
		. = TOPIC_HANDLED

	else if(href_list["item"])
		if(!allow_items) return

		if(length(frozen_items) == 0)
			to_chat(user, SPAN_NOTICE("There is nothing to recover from storage."))
			return TOPIC_HANDLED

		var/obj/item/I = input(user, "Please choose which object to retrieve.","Object recovery",null) as null|anything in frozen_items
		if(!I || !CanUseTopic(user, state))
			return TOPIC_HANDLED

		if(!(I in frozen_items))
			to_chat(user, SPAN_NOTICE("\The [I] is no longer in storage."))
			return TOPIC_HANDLED

		visible_message(SPAN_NOTICE("The console beeps happily as it disgorges \the [I]."), range = 3)

		I.dropInto(loc)
		frozen_items -= I
		. = TOPIC_REFRESH

	else if(href_list["allitems"])
		if(!allow_items) return TOPIC_HANDLED

		if(length(frozen_items) == 0)
			to_chat(user, SPAN_NOTICE("There is nothing to recover from storage."))
			return TOPIC_HANDLED

		visible_message(SPAN_NOTICE("The console beeps happily as it disgorges the desired objects."), range = 3)

		for(var/obj/item/I in frozen_items)
			I.dropInto(loc)
			frozen_items -= I
		. = TOPIC_REFRESH

/obj/item/stock_parts/circuitboard/cryopodcontrol
	name = "circuit board (cryogenic oversight console)"
	build_path = /obj/machinery/computer/cryopod
	origin_tech = list(TECH_DATA = 3)

/obj/item/stock_parts/circuitboard/robotstoragecontrol
	name = "circuit board (robotic storage console)"
	build_path = /obj/machinery/computer/cryopod/robot
	origin_tech = list(TECH_DATA = 3)

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/machines/medical/cryogenic_legacy.dmi'
	icon_state = "cryo_rear"
	anchored = TRUE
	dir = WEST

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/machines/medical/cryopod.dmi'
	icon_state = "cryopod"
	density = TRUE
	anchored = TRUE
	dir = WEST

	var/base_icon_state = "cryopod"
	var/occupied_icon_state = "cryopod_closed"
	var/on_store_message = "has entered long-term storage."
	var/on_store_visible_message = "hums and hisses as it moves $occupant$ into storage." // $occupant$ is automatically converted to the occupant's name
	var/on_store_name = "Cryogenic Oversight"
	var/on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/occupant = null       // Person waiting to be despawned.
	var/time_till_despawn = 9000  // Down to 15 minutes //30 minutes-ish is too long
	var/time_entered = 0          // Used to keep track of the safe period.
	var/obj/item/device/radio/intercom/announce //
	var/announce_despawn = TRUE

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_message = 0
	var/applies_stasis = 1

	// These items are preserved when the process() despawn proc occurs.
	var/list/preserve_items = list(
		/obj/item/integrated_circuit/manipulation/bluespace_rift,
		/obj/item/integrated_circuit/input/teleporter_locator,
		/obj/item/card/id/captains_spare,
		/obj/item/aicard,
		/obj/item/device/mmi,
		/obj/item/device/paicard,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/suit,
		/obj/item/clothing/shoes/magboots,
		/obj/item/blueprints,
		/obj/item/clothing/head/helmet/space,
		/obj/item/storage/internal
	)

/obj/machinery/cryopod/robot
	name = "robotic storage unit"
	desc = "A storage unit for robots."
	icon = 'icons/obj/machines/robot_storage.dmi'
	icon_state = "pod_0"
	base_icon_state = "pod_0"
	occupied_icon_state = "pod_1"
	on_store_message = "has entered robotic storage."
	on_store_name = "Robotic Storage Oversight"
	on_enter_occupant_message = "The storage unit broadcasts a sleep signal to you. Your systems start to shut down, and you enter low-power mode."
	allow_occupant_types = list(/mob/living/silicon/robot)
	disallow_occupant_types = list(/mob/living/silicon/robot/drone)
	applies_stasis = 0

/obj/machinery/cryopod/New()
	announce = new /obj/item/device/radio/intercom(src)
	..()

/obj/machinery/cryopod/Destroy()
	if(occupant)
		occupant.forceMove(loc)
	. = ..()

/obj/machinery/cryopod/Initialize()
	. = ..()
	find_control_computer()

/obj/machinery/cryopod/proc/find_control_computer(urgent=0)
	// Workaround for http://www.byond.com/forum/?post=2007448
	for(var/obj/machinery/computer/cryopod/C in src.loc.loc)
		control_computer = C
		break
	// control_computer = locate(/obj/machinery/computer/cryopod) in src.loc.loc

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer && urgent && last_no_computer_message + 5*60*10 < world.time)
		log_and_message_admins("Cryopod in [src.loc.loc] could not find control computer!", null, src)
		last_no_computer_message = world.time

	return control_computer != null

/obj/machinery/cryopod/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1

/obj/machinery/cryopod/examine(mob/user, distance, is_adjacent)
	. = ..()
	if (occupant && is_adjacent)
		occupant.examine(arglist(args))

//Lifted from Unity stasis.dm and refactored.
/obj/machinery/cryopod/Process()
	if(occupant)
		if(applies_stasis && iscarbon(occupant) && (world.time > time_entered + 20 SECONDS))
			var/mob/living/carbon/C = occupant
			C.SetStasis(2)

		//Allow a ten minute gap between entering the pod and actually despawning.
		// Only provide the gap if the occupant hasn't ghosted
		if ((world.time - time_entered < time_till_despawn) && (occupant.ckey))
			return

		if(!occupant.client && occupant.stat<2) //Occupant is living and has no client.
			if(!control_computer)
				if(!find_control_computer(urgent=1))
					return

			despawn_occupant()

// This function can not be undone; do not call this unless you are sure
// Also make sure there is a valid control computer
/obj/machinery/cryopod/proc/despawn_occupant()
	SHOULD_NOT_SLEEP(TRUE) // Sleeping causes the double-despawn bug

	if (QDELETED(occupant))
		log_and_message_admins("A mob was deleted while in a cryopod, or the cryopod double-processed. This may cause errors!", null)
		return

	if (istype(occupant, /mob/living/carbon/human))
		var/mob/living/carbon/human/human = occupant
		var/record_name = human.get_id_name("")
		if (record_name)
			var/datum/computer_file/report/crew_record/record = get_crewmember_record(record_name)
			if (record)
				record.set_status("Stored")

	//Drop all items into the pod.
	for(var/obj/item/W in occupant)
		occupant.drop_from_inventory(W)
		W.forceMove(src)

		if(length(W.contents)) //Make sure we catch anything not handled by qdel() on the items.
			for(var/obj/item/O in W.contents)
				if(istype(O,/obj/item/storage/internal)) //Stop eating pockets, you fuck!
					continue
				O.forceMove(src)

	//Delete all items not on the preservation list.
	var/list/items = src.contents.Copy()
	items -= occupant // Don't delete the occupant
	items -= announce // or the autosay radio.
	items -= component_parts

	for(var/obj/item/W in items)

		var/preserve = null
		// Snowflaaaake.
		if(istype(W, /obj/item/device/mmi))
			var/obj/item/device/mmi/brain = W
			if(brain.brainmob && brain.brainmob.client && brain.brainmob.key)
				preserve = 1
			else
				continue
		else
			for(var/T in preserve_items)
				if(istype(W,T))
					preserve = 1
					break

		if(!preserve)
			qdel(W)
		else
			if(control_computer && control_computer.allow_items)
				control_computer.frozen_items += W
				W.forceMove(null)
			else
				W.forceMove(src.loc)

	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in all_objectives)
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(O.target == occupant.mind)
			if(O.owner && O.owner.current)
				to_chat(O.owner.current, SPAN_WARNING("You get the feeling your target is no longer within your reach..."))
			qdel(O)

	//Handle job slot/tater cleanup.
	if(occupant.mind)
		if(occupant.mind.assigned_job)
			occupant.mind.assigned_job.clear_slot()

		if(LAZYLEN(occupant.mind.objectives))
			occupant.mind.objectives = null
			occupant.mind.special_role = null

	icon_state = base_icon_state

	//TODO: Check objectives/mode, update new targets if this mob is the target, spawn new antags?


	//Make an announcement and log the person entering storage.

	// Titles should really be fetched from data records
	//  and records should not be fetched by name as there is no guarantee names are unique
	var/role_alt_title = occupant.mind ? occupant.mind.role_alt_title : "Unknown"

	if(control_computer)
		control_computer.frozen_crew += "[occupant.real_name], [role_alt_title] - [stationtime2text()]"
		control_computer._admin_logs += "[key_name(occupant)] ([role_alt_title]) at [stationtime2text()]"
	log_and_message_admins("([role_alt_title]) entered cryostorage.", occupant)

	if(announce_despawn)
		invoke_async(announce, /obj/item/device/radio/proc/autosay, "[occupant.real_name], [role_alt_title], [on_store_message]", "[on_store_name]")

	var/despawnmessage = replacetext(on_store_visible_message, "$occupant$", occupant.real_name)
	visible_message(SPAN_NOTICE("\The [initial(name)] " + despawnmessage), range = 3)

	//This should guarantee that ghosts don't spawn.
	occupant.ckey = null

	// Delete the mob.
	qdel(occupant)
	set_occupant(null)

/obj/machinery/cryopod/proc/attempt_enter(mob/target, mob/user)
	if (!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("You're too simple to understand how to do that."))
		return
	if (user.incapacitated() || !user.Adjacent(src))
		to_chat(user, SPAN_WARNING("You're in no position to do that."))
		return
	if (!user.Adjacent(target))
		to_chat(user, SPAN_WARNING("\The [target] isn't close enough."))
		return
	if (user != target  && target.client)
		var/response = alert(target, "Enter the [src]?", null, "Yes", "No")
		if (response != "Yes")
			to_chat(user, SPAN_WARNING("\The [target] refuses."))
			return
	if (user.incapacitated() || !user.Adjacent(src))
		to_chat(user, SPAN_WARNING("You're in no position to do that."))
		return
	if (!user.Adjacent(target))
		to_chat(user, SPAN_WARNING("\The [target] isn't close enough."))
		return
	add_fingerprint(user) //Add fingerprints for trying to go in.
	if (!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
		return
	if (!user_can_move_target_inside(target, user))
		return
	if (!user.Adjacent(target))
		to_chat(user, SPAN_WARNING("\The [target] isn't close enough."))
		return
	set_occupant(target)
	if (user != target)
		add_fingerprint(target) //Add fingerprints of the person stuffed in.
	log_and_message_admins("placed [target == user ? "themself" : key_name_admin(target)] into \a [src]", user)
	target.remove_grabs_and_pulls()

/obj/machinery/cryopod/user_can_move_target_inside(mob/target, mob/user)
	if (occupant)
		to_chat(user, SPAN_WARNING("\The [src] is already occupied!"))
		return FALSE
	if (!check_occupant_allowed(target))
		return FALSE
	return ..()

/obj/machinery/cryopod/MouseDrop_T(mob/target, mob/user)
	if (!CanMouseDrop(target, user) || !ismob(target))
		return
	if (!user_can_move_target_inside(target, user))
		return

	user.visible_message(SPAN_NOTICE("\The [user] begins placing \the [target] into \the [src]."), SPAN_NOTICE("You start placing \the [target] into \the [src]."))
	attempt_enter(target, user)

/obj/machinery/cryopod/use_grab(obj/item/grab/grab, list/click_params) //Grab is deleted at the level of attempt_enter if all checks are passed.
	MouseDrop_T(grab.affecting, grab.assailant)
	return TRUE

/obj/machinery/cryopod/verb/eject()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return

	icon_state = base_icon_state

	//Eject any items that aren't meant to be in the pod.
	var/list/items = contents - component_parts
	if(occupant) items -= occupant
	if(announce) items -= announce

	for(var/obj/item/W in items)
		W.dropInto(loc)

	src.go_out()
	add_fingerprint(usr)

	SetName(initial(name))
	return

/obj/machinery/cryopod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0 || !check_occupant_allowed(usr))
		return

	if(src.occupant)
		to_chat(usr, SPAN_NOTICE("<B>\The [src] is in use.</B>"))
		return

	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.Victim == usr)
			to_chat(usr, "You're too busy getting your life sucked out of you.")
			return

	visible_message("\The [usr] starts climbing into \the [src].", range = 3)

	if(do_after(usr, 2 SECONDS, src, DO_PUBLIC_UNIQUE))

		if(!usr || !usr.client)
			return

		if(src.occupant)
			to_chat(usr, SPAN_NOTICE("<B>\The [src] is in use.</B>"))
			return

		set_occupant(usr)

		src.add_fingerprint(usr)

	return

/obj/machinery/cryopod/proc/go_out()

	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.dropInto(loc)
	set_occupant(null)

	icon_state = base_icon_state

	return

/obj/machinery/cryopod/proc/set_occupant(mob/living/carbon/occupant, silent)
	src.occupant = occupant
	if(!occupant)
		SetName(initial(name))
		return

	occupant.stop_pulling()
	if(occupant.client)
		if(!silent)
			to_chat(occupant, SPAN_NOTICE("[on_enter_occupant_message]"))
			to_chat(occupant, SPAN_NOTICE("<b>If you ghost, log out or close your client now, your character will shortly be permanently removed from the round.</b>"))
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
	occupant.forceMove(src)
	time_entered = world.time

	SetName("[name] ([occupant])")
	icon_state = occupied_icon_state

/obj/machinery/cryopod/relaymove(mob/user)
	go_out()

//A prop version for away missions and such

/obj/structure/broken_cryo
	name = "broken cryo sleeper"
	desc = "Whoever was inside isn't going to wake up now. It looks like you could pry it open with a crowbar."
	icon = 'icons/obj/machines/medical/cryopod.dmi'
	icon_state = "broken_cryo"
	anchored = TRUE
	density = TRUE
	var/closed = 1
	var/busy = 0
	var/remains_type = /obj/item/remains/human

/obj/structure/broken_cryo/attack_hand(mob/user)
	..()
	if (closed)
		to_chat(user, SPAN_NOTICE("You tug at the glass but can't open it with your hands alone."))
	else
		to_chat(user, SPAN_NOTICE("The glass is already open."))


/obj/structure/broken_cryo/use_tool(obj/item/tool, mob/user, list/click_params)
	// Crowbar - Open cryopod
	if (isCrowbar(tool))
		if (!closed)
			USE_FEEDBACK_FAILURE("\The [src] is already open.")
			return TRUE
		busy = TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts prying \the [src]'s cover off with \a [tool]."),
			SPAN_NOTICE("You start prying \the [src]'s cover off with \the [tool].")
		)
		if (!do_after(user, 5 SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool))
			return TRUE
		closed = FALSE
		update_icon()
		var/obj/dead = new remains_type(loc)
		dead.dir = dir
		user.visible_message(
			SPAN_NOTICE("\The [user] opens \the [src]'s cover with \a [tool], exposing \a [dead]."),
			SPAN_NOTICE("You open \the [src]'s cover with \the [tool], exposing \a [dead].")
		)
		return TRUE

	return ..()


/obj/structure/broken_cryo/on_update_icon()
	icon_state = initial(icon_state)
	if (!closed)
		icon_state += "_open"
