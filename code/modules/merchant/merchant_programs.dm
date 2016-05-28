/datum/computer_file/program/merchant
	filename = "mlist"
	filedesc = "Merchant's List"
	extended_desc = "Allows communication and trade between passing vessels, even while jumping."
	program_icon_state = "comm"
	nanomodule_path = /datum/nano_module/program/merchant
	requires_ntnet = 0
	size = 12
	usage_flags = PROGRAM_CONSOLE


/datum/nano_module/program/merchant
	name = "Merchant's List"
	available_to_ai = 1
	var/current_merchant = 0
	var/obj/machinery/merchant_pad/pad = null
	var/temp = null

/datum/nano_module/program/merchant/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	data["mode"] = !!current_merchant
	if(current_merchant)
		if(current_merchant > traders.len)
			current_merchant = traders.len
		var/datum/trader/T = traders[current_merchant]
		data["traderName"] = T.name
		data["origin"]     = T.origin

/datum/nano_module/program/merchant/proc/connect_pad()
	if(program)
		pad = locate(/obj/machinery/artifact_scanpad) in orange(1, program.computer)
