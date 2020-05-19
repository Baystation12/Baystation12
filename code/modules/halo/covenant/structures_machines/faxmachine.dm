
/obj/machinery/photocopier/faxmachine/covenant
	name = "Superluminal Communications Array"
	icon = 'code/modules/halo/covenant/structures_machines/consoles.dmi'
	network_name = "Covenant supraluminal communications network"
	icon_state = "covie_console"
	department = "Covenant"
	available_departments  = list("Covenant")
	admin_departments = list(\
		"Ministry of Tranquility (General)",\
		"Ministry of Resolution (War Matters)",\
		"Ministry of Fervent Intercession (Internal Affairs)")
	req_one_access = list(access_covenant)
