/obj/machinery/psi_meter
	name = "psi-meter"
	desc = "A bulky psi-meter for conducting assays of psi-operants."
	icon = 'icons/obj/machines/psimeter.dmi'
	icon_state = "meter_on"
	use_power = POWER_USE_ACTIVE
	anchored = TRUE
	density = TRUE
	opacity = FALSE

	var/list/last_assay
	var/mob/living/last_assayed

/obj/machinery/psi_meter/on_update_icon()
	if(use_power && !(stat & (NOPOWER|BROKEN)))
		icon_state = "meter_on"
	else
		icon_state = "meter_off"

/obj/machinery/psi_meter/interface_interact(var/mob/user)
	interact(user)
	return TRUE

/obj/machinery/psi_meter/interact(var/mob/user)

	if(!use_power) return

	var/list/dat = list()
	if(LAZYLEN(last_assay))
		dat = last_assay
	else
		dat += "<h2>TELESTO Mark I Psi-Meter</h2><hr><table border = 1 width = 100%><tr><td colspan = 2><b>Candidates</b></td></tr>"
		var/found
		for(var/mob/living/H in range(1, src))
			found = TRUE
			dat += "<tr><td>[H.name]</td><td><a href='?src=\ref[src];assay=\ref[H]'>Conduct Assay</a>"
		if(!found)
			dat += "<tr><td colspan = 2>No candidates found.</td></tr>"
		dat += "<table>"

	var/datum/browser/popup = new(user, "psi_assay_\ref[src]", "Psi-Assay")
	popup.set_content(jointext(dat,null))
	popup.open()

/obj/machinery/psi_meter/Topic(href, href_list)
	. = ..()
	if(!.)

		if(!issilicon(usr) && !Adjacent(usr))
			return FALSE

		var/refresh
		if(href_list["print"])
			if(last_assay)
				var/obj/item/paper/P = new(loc)
				P.name = "paper - Psi-Assay ([last_assayed.name])"
				P.info = jointext(last_assay - last_assay[last_assay.len],null) // Last line is 'print | clear' link line.
				return TRUE

		if(href_list["clear"])
			last_assay = null
			refresh = TRUE
		else if(href_list["assay"])
			last_assayed = locate(href_list["assay"])
			if(istype(last_assayed))
				last_assayed.show_psi_assay(usr, src)
				refresh = TRUE

		if(refresh)
			interact(usr)
			return TRUE
