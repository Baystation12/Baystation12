/datum/build_mode/turret
	name = "Turret Editor"
	icon_state = "buildmode15"
	var/list/settings = list()
	var/help_text = {"\
	***** Build Mode: Turret ******
	Left Click             - Spawn a turret or update an existing turret.
	Right Click            - Delete a turret
	Right Click build icon - Configure turret settings.
	************************************\
	"}

/datum/build_mode/turret/New(host)
	. = ..()
	settings["health"] = 100
	settings["repair"] = 0
	settings["weapon"] = /obj/item/gun/energy/gun
	settings["check_weapons"] = 0
	settings["check_access"] = 0
	settings["check_synth"] = 0
	settings["lethal"] = 0
	settings["access_list"] = list()

/datum/build_mode/turret/Help()
	to_chat(user, SPAN_NOTICE(help_text))

/datum/build_mode/turret/Configurate()
	ui_interact(user)

/datum/build_mode/turret/ui_interact(mob/user, ui_key = "turret_editor", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	. = ..()

	var/data[0]
	data["health"] = settings["health"]
	data["repair"] = settings["repair"]
	data["weapon"] = settings["weapon"]
	data["check_weapons"] = settings["check_weapons"]
	data["check_access"] = settings["check_access"]
	data["check_synth"] = settings["check_synth"]
	data["lethal"] = settings["lethal"]
	data["access_list"] = settings["access_list"]

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_editor.tmpl", src.name, 425, 600, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/build_mode/turret/CanUseTopic(mob/user)
	if (!isadmin(user))
		return STATUS_CLOSE
	return ..()

/datum/build_mode/turret/Topic(user, href_list)
	if (href_list["health"])
		var/health = input("Set Starting Health", "Set Starting Health") as null | num

		if (health)
			settings["health"] = health

		. = TOPIC_HANDLED

	if (href_list["repair"])
		var/repair = alert("Should the turret repair itself over time?", "Auto Repair", "Yes", "No") == "Yes"

		if (repair)
			settings["repair"] = TRUE

		. = TOPIC_HANDLED

	if (href_list["weapon"])
		var/weapon = input("What weapon should the turret use?", "Weapon type") as anything in subtypesof(/obj/item/gun/energy) | null

		if (weapon)
			settings["weapon"] = weapon

		. = TOPIC_HANDLED

	if (href_list["check_weapons"])
		var/check_weapons = alert("Shoot at people with weapons out?", "Shoot Baddies", "Yes", "No") == "Yes"

		settings["check_weapons"] = check_weapons

		. = TOPIC_HANDLED

	if (href_list["check_access"])
		var/check_access = alert("Shoot at those without access? ", "Shoot No Access", "Yes", "No") == "Yes"

		settings["check_access"] = check_access

		. = TOPIC_HANDLED

	if (href_list["check_synth"])
		var/check_synth = alert("Shoot at only non-synths?", "Shoot Organics", "Yes", "No") == "Yes"

		settings["check_synth"] = check_synth

		. = TOPIC_HANDLED

	if (href_list["lethal"])
		var/lethal = alert("Lethal or stun?", "Lethality", "Lethal", "Stun") == "Lethal"

		settings["lethal"] = lethal

		. = TOPIC_HANDLED

	if (href_list["add_access"])
		var/access_list = input("Add Access type", "Access List") as anything in get_all_access_datums()|null

		if (!access_list)
			return

		settings["access_list"] += list(access_list)

		. = TOPIC_HANDLED

	if (href_list["remove_access"])
		var/access_list = input("Remove Access type", "Access List") as anything in settings["access_list"]|null

		if (!access_list)
			return

		settings["access_list"] -= access_list

		. = TOPIC_HANDLED

/datum/build_mode/turret/OnClick(atom/object, list/pa)
	if (pa["right"])
		if (istype(object, /obj/machinery/porta_turret))
			qdel(object)

	if (pa["left"])
		if (!object)
			return


		var/turf/T = get_turf(object)

		if (!T)
			return

		var/obj/machinery/porta_turret/P
		if (istype(object, /obj/machinery/porta_turret))
			P = object
			to_chat(usr, SPAN_NOTICE("Updated turret settings."))
		else
			P = new /obj/machinery/porta_turret(T)

		P.health = settings["health"]
		P.maxhealth = settings["health"]
		P.auto_repair = settings["repair"]
		P.installation = settings["weapon"]
		P.check_weapons = settings["check_weapons"]
		P.check_access = settings["check_access"]
		P.check_synth = settings["check_synth"]

		var/access_types = list()
		for (var/datum/access/A in settings["access_list"])
			access_types += A.id

		P.req_access = access_types
		P.setup()
