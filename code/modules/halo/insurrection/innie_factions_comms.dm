GLOBAL_LIST_EMPTY(innie_comms_computers)

/obj/machinery/computer/innie_comms
	icon_keyboard = "syndie_key"
	icon_screen = "tcboss"
	var/broadcast_quest_status = 0
	var/list/active_quests = list()

/obj/machinery/computer/innie_comms/New()
	. = ..()
	GLOB.innie_comms_computers.Add(src)

/obj/machinery/computer/innie_comms/proc/new_quest(var/datum/npc_quest/Q)
	active_quests.Add(Q)

/obj/machinery/computer/innie_comms/proc/quest_finished(var/datum/npc_quest/Q)
	active_quests.Remove(Q)

/obj/machinery/computer/innie_comms/attack_hand(var/mob/living/user)
	if(user && istype(user))// && can_use(user))
		add_fingerprint(user)
		user.set_machine(src)
		ui_interact(user)

/obj/machinery/computer/innie_comms/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/data[0]
	data["name"] = "test"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "autosurgeon.tmpl", "Communications Console", 400, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

//total map size is 248x248