/obj/machinery/computer/fusion_core_control
	name = "\improper R-UST Mk. 8 core control"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "core_control"
	light_color = COLOR_ORANGE

	var/id_tag
	var/scan_range = 25
	var/list/connected_devices = list()
	var/obj/machinery/power/fusion_core/cur_viewed_device

/obj/machinery/computer/fusion_core_control/attackby(var/obj/item/thing, var/mob/user)
	if(ismultitool(thing))
		var/new_ident = input("Enter a new ident tag.", "Core Control", id_tag) as null|text
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
			cur_viewed_device = null
		return
	else
		return ..()

/obj/machinery/computer/fusion_core_control/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/computer/fusion_core_control/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/computer/fusion_core_control/interact(mob/user)

	if(!cur_viewed_device || !check_core_status(cur_viewed_device))
		cur_viewed_device = null

	if(!id_tag)
		to_chat(user, "<span class='warning'>This console has not been assigned an ident tag. Please contact your system administrator or conduct a manual update with a standard multitool.</span>")
		return

	if(cur_viewed_device && (cur_viewed_device.id_tag != id_tag || get_dist(src, cur_viewed_device) > scan_range))
		cur_viewed_device = null

	var/dat = "<B>Core Control #[id_tag]</B><BR>"

	if(cur_viewed_device)
		dat += {"
			<a href='?src=\ref[src];goto_scanlist=1'>Back to overview</a><hr>
			Device ident '[cur_viewed_device.id_tag]' <span style='color: [cur_viewed_device.owned_field ? "green" : "red"]'>[cur_viewed_device.owned_field ? "active" : "inactive"].</span><br>
			<b>Power status:</b> [cur_viewed_device.avail()]/[cur_viewed_device.active_power_usage] W<br>
			<hr>
			<a href='?src=\ref[src];toggle_active=1'>Bring field [cur_viewed_device.owned_field ? "offline" : "online"].</a><br>
			<hr>
			<b>Field power density (W.m<sup>-3</sup>):</b><br>
			<a href='?src=\ref[src];str=-1000'>----</a>
			<a href='?src=\ref[src];str=-100'>--- </a>
			<a href='?src=\ref[src];str=-10'>--  </a>
			<a href='?src=\ref[src];str=-1'>-   </a>
			<a href='?src=\ref[src];str=0'>[cur_viewed_device.field_strength]</a>
			<a href='?src=\ref[src];str=1'>+   </a>
			<a href='?src=\ref[src];str=10'>++  </a>
			<a href='?src=\ref[src];str=100'>+++ </a>
			<a href='?src=\ref[src];str=1000'>++++</a><hr>
		"}

		if(cur_viewed_device.owned_field)
			dat += {"
				<b>Approximate field diameter (m):</b> [cur_viewed_device.owned_field.size]<br>
				<b>Field instability:</b> [cur_viewed_device.owned_field.percent_unstable * 100]%<br>
				<b>Plasma temperature:</b> [cur_viewed_device.owned_field.plasma_temperature + 295]K<hr>
				<b>Fuel:</b><br>
				<table><tr><th><b>Name</b></th><th><b>Amount</b></th></tr>
			"}
			for(var/reagent in cur_viewed_device.owned_field.dormant_reactant_quantities)
				dat += "<tr><td>[reagent]</td><td>[cur_viewed_device.owned_field.dormant_reactant_quantities[reagent]]</td></tr>"
			dat += "</table><hr>"

	else

		connected_devices.Cut()
		for(var/obj/machinery/power/fusion_core/C in fusion_cores)
			if(C.id_tag == id_tag && get_dist(src, C) <= scan_range)
				connected_devices += C
		for(var/obj/machinery/power/fusion_core/C in gyrotrons)
			if(C.id_tag == id_tag && get_dist(src, C) <= scan_range)
				connected_devices += C

		if(connected_devices.len)
			dat += {"
				<b>Connected EM field generators:</b><hr>
				<table>
					<tr>
						<th><b>Device tag</b></th>
						<th><b>Status</b></th>
						<th><b>Controls</b></th>
					</tr>
			"}

			for(var/obj/machinery/power/fusion_core/C in connected_devices)
				var/status
				var/can_access = 1
				if(!check_core_status(C))
					status = "<span style='color: red'>Unresponsive</span>"
					can_access = 0
				else if(C.avail() < C.active_power_usage)
					status = "<span style='color: orange'>Underpowered</span>"
				else
					status = "<span style='color: green'>Good</span>"

				dat += {"
					<tr>
						<td>[C.id_tag]</td>
						<td>[status]</td>
				"}

				if(!can_access)
					dat += {"
						<td><span style='color: red'>ERROR</span></td>
					"}
				else
					dat += {"
						<td><a href=?src=\ref[src];access_device=[connected_devices.Find(C)]'>ACCESS</a></td>
					"}
				dat += {"
					</tr>
				"}

		else
			dat += "<span style='color: red'>No electromagnetic field generators connected.</span>"

	var/datum/browser/popup = new(user, "fusion_control", name, 500, 400, src)
	popup.set_content(dat)
	popup.open()
	user.set_machine(src)

/obj/machinery/computer/fusion_core_control/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["access_device"])
		var/idx = Clamp(text2num(href_list["toggle_active"]), 1, connected_devices.len)
		cur_viewed_device = connected_devices[idx]
		updateUsrDialog()
		return 1

	//All HREFs from this point on require a device anyways.
	if(!cur_viewed_device || !check_core_status(cur_viewed_device) || cur_viewed_device.id_tag != id_tag || get_dist(src, cur_viewed_device) > scan_range)
		return

	if(href_list["goto_scanlist"])
		cur_viewed_device = null
		updateUsrDialog()
		return 1

	if(href_list["toggle_active"])
		if(!cur_viewed_device.Startup()) //Startup() whilst the device is active will return null.
			cur_viewed_device.Shutdown()
		updateUsrDialog()
		return 1

	if(href_list["str"])
		var/val = text2num(href_list["str"])
		if(!val) //Value is 0, which is manual entering.
			cur_viewed_device.set_strength(input("Enter the new field power density (W.m^-3)", "Fusion Control", cur_viewed_device.field_strength) as num)
		else
			cur_viewed_device.set_strength(cur_viewed_device.field_strength + val)
		updateUsrDialog()
		return 1

//Returns 1 if the machine can be interacted with via this console.
/obj/machinery/computer/fusion_core_control/proc/check_core_status(var/obj/machinery/power/fusion_core/C)
	if(isnull(C))
		return
	if(C.stat & BROKEN)
		return
	if(C.idle_power_usage > C.avail())
		return
	. = 1
