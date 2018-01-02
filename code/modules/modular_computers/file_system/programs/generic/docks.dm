/datum/computer_file/program/docking
	filename = "docking"
	filedesc = "Docking Control"
	required_access = access_heads
	nanomodule_path = /datum/nano_module/docking
	program_icon_state = "supply"
	program_menu_icon = "triangle-2-e-w"
	extended_desc = "A management tool that lets you se the status of the docking ports."
	size = 10
	available_on_ntnet = 1
	requires_ntnet = 1

/datum/nano_module/docking
	name = "Docking Control program"
	var/list/docking_controllers = list() //list of tags

/datum/computer_file/program/docking/run_program()
	. = ..()
	if(NM)
		var/datum/nano_module/docking/NMD = NM
		NMD.refresh_docks()

/datum/nano_module/docking/proc/refresh_docks()
	var/atom/movable/AM = nano_host()
	if(!istype(AM))
		return
	docking_controllers.Cut()
	var/list/zlevels = GetConnectedZlevels(AM.z)
	for(var/obj/machinery/embedded_controller/radio/airlock/docking_port/D in SSmachines.machinery)
		if(D.z in zlevels)
			var/shuttleside = 0
			for(var/sname in shuttle_controller.shuttles) //do not touch shuttle-side ones
				var/datum/shuttle/autodock/S = shuttle_controller.shuttles[sname]
				if(istype(S) && S.shuttle_docking_controller)
					if(S.shuttle_docking_controller.id_tag == D.docking_program.id_tag)
						shuttleside = 1
						break
			if(shuttleside)
				continue
			docking_controllers += D.docking_program.id_tag

/datum/nano_module/docking/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/list/docks = list()
	for(var/docktag in docking_controllers)
		var/datum/computer/file/embedded_program/docking/P = locate(docktag)
		if(P)
			var/docking_attempt = P.tag_target && !P.dock_state
			docks.Add(list(list(
				"tag"=P.id_tag, 
				"location" = P.get_name(), 
				"status" = capitalize(P.get_docking_status()), 
				"docking_attempt" = docking_attempt, 
				"codes" = P.docking_codes ? P.docking_codes : "Unset"
				)))
	data["docks"] = docks
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "docking.tmpl", name, 1050, 800, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/docking/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["edit_code"])
		var/datum/computer/file/embedded_program/docking/P = locate(href_list["edit_code"])
		if(P)
			var/newcode = input("Input new docking codes", "Docking codes", P.docking_codes) as text|null
			if (newcode)
				P.docking_codes = uppertext(newcode)
		return 1
	if(href_list["dock"])
		var/datum/computer/file/embedded_program/docking/P = locate(href_list["dock"])
		if(P)
			P.receive_user_command("dock")
		return 1