/obj/machinery/computer/fusion_fuel_control
	name = "fuel injection control computer"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel"

	var/id_tag
	var/scan_range = 25

/obj/machinery/computer/fusion_fuel_control/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/computer/fusion_fuel_control/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/computer/fusion_fuel_control/interact(var/mob/user)

	if(stat & (BROKEN|NOPOWER))
		user.unset_machine()
		user << browse(null, "window=fuel_control")
		return

	if (!istype(user, /mob/living/silicon) && get_dist(src, user) > 1)
		user.unset_machine()
		user << browse(null, "window=fuel_control")
		return

	if(!id_tag)
		to_chat(user, "<span class='warning'>This console has not been assigned an ident tag. Please contact your system administrator or conduct a manual update with a standard multitool.</span>")
		return

	var/dat = "<B>Reactor Core Fuel Control #[id_tag]</B><BR>"
	dat += {"
		<hr>
		<table border=1 width='100%'>
		<tr>
		<td><b>Contains</b></td>
		<td><b>Assembly</b></td>
		<td><b>Remaining</b></td>
		</tr>"}

	for(var/obj/machinery/fusion_fuel_injector/I in fuel_injectors)
		if(!id_tag || !I.id_tag || I.id_tag != id_tag || get_dist(src, I) > scan_range)
			continue

		dat += "<tr>"

		if(I.stat & (BROKEN|NOPOWER))
			dat += "<td><span class='danger'>ERROR</span></td>"
			dat += "<td><span class='danger'>ERROR</span></td>"
			dat += "<td><span class='danger'>ERROR</span></td>"
		else
			dat += "<td>[I.cur_assembly ? I.cur_assembly.fuel_type : "NONE"]</td>"
			if(I.cur_assembly)
				dat += "<td><a href='?src=\ref[src];toggle_injecting=\ref[I]'>\[[I.injecting ? "Halt injecting" : "Begin injecting"]\]</a></td>"
			else
				dat += "<td>None</td>"
			if(I.cur_assembly)
				dat += "<td>[I.cur_assembly.percent_depleted * 100]%</td>"
			else
				dat += "<td>NA</td>"

		dat += "</tr>"

	dat += {"</table><hr>
		<A href='?src=\ref[src];refresh=1'>Refresh</A>
		<A href='?src=\ref[src];close=1'>Close</A><BR>"}

	var/datum/browser/popup = new(user, "fuel_control", "Fusion Fuel Control Console", 800, 400, src)
	popup.set_content(dat)
	popup.open()
	user.set_machine(src)

/obj/machinery/computer/fusion_fuel_control/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["toggle_injecting"])
		var/obj/machinery/fusion_fuel_injector/I = locate(href_list["toggle_injecting"])
		if(I.id_tag != id_tag || get_dist(src, I) > scan_range)
			return

		if(istype(I))
			if(I.injecting)
				I.StopInjecting()
			else
				I.BeginInjecting()

	if( href_list["close"] )
		usr << browse(null, "window=fuel_control")
		usr.unset_machine()

	updateDialog()


/obj/machinery/computer/fusion_fuel_control/attackby(var/obj/item/W, var/mob/user)
	if(isMultitool(W))
		var/new_ident = input("Enter a new ident tag.", "Fuel Control", id_tag) as null|text
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
		return
	return ..()
