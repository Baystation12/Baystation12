/obj/machinery/paperwork_dispenser
	name = "paperwork dispenser"
	desc = "Prints out standard forms for various departments."
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	use_power = 1
	idle_power_usage = 0
	var/paper_amount = 30
	var/max_paper = 30
	var/ui_title = "PaperWork 1600"
	var/list/dispensable_paper = list("Test", "Test2", "Test3")

/obj/machinery/paperwork_dispenser/New()
	..()
	dispensable_paper = sortList(dispensable_paper)

/obj/machinery/paperwork_dispenser/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return

/obj/machinery/paperwork_dispenser/blob_act()
	if (prob(50))
		del(src)

/obj/machinery/paperwork_dispenser/meteorhit()
	del(src)
	return

/obj/machinery/paperwork_dispenser/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 1)
	if(stat & (BROKEN|NOPOWER)) return
	if(user.stat || user.restrained()) return

	// this is the data which will be sent to the ui
	var/data[0]
	data["paper_amount"] = paper_amount
	data["max_paper"] = max_paper

	var papers[0]
	for (var/p in dispensable_paper)
		var/obj/item/weapon/paper/form/temp = dispensable_paper[p]
		if(temp)
			papers.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("dispense" = temp.id) ))) // list in a list because Byond merges the first list...
	data["papers"] = papers

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "paperwork_dispenser.tmpl", ui_title, 390, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/paperwork_dispenser/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	if(href_list["paper_amount"])
		paper_amount = round(text2num(href_list["paper_amount"]), 1) // round to nearest 5
		if (paper_amount < 0) // Since the user can actually type the commands himself, some sanity checking
			paper_amount = 0
		if (paper_amount > max_paper)
			paper_amount = 30

	add_fingerprint(usr)
	return 1 // update UIs attached to this object

/obj/machinery/paperwork_dispenser/attackby(var/obj/item/weapon/reagent_containers/B as obj, var/mob/user as mob)
	if(isrobot(user))
		return
	if(istype(B, /obj/item/weapon/paper))
		user.drop_item()
		paper_amount += 1
		B.loc = src
		user << "You put [B] into the machine."
		nanomanager.update_uis(src) // update all UIs attached to src
		return
	else
		user << "<span class='notice'>This machine only accepts paper</span>"

/obj/machinery/paperwork_dispenser/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/paperwork_dispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	ui_interact(user)
