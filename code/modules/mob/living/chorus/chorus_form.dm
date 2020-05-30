/mob/living/chorus
	var/datum/chorus_form/form

/mob/living/chorus/proc/set_form(var/datum/chorus_form/new_form)
	if(form)
		return FALSE
	form = new_form
	form.setup_form(src)
	show_browser(src, null, "window=godform")
	set_default_nano_data()
	for(var/r in resources)
		update_resource(r)
	upgrade_to_egg(get_turf(src))
	var/datum/hud/chorus/H = src.hud_used
	var/delete_choose = H.choose
	H.adding -= delete_choose
	H.choose = null
	src.client.screen -= delete_choose
	qdel(delete_choose)
	return TRUE

/mob/living/chorus/Destroy()
	if(form)
		qdel(form)
		form = null
	. = ..()

/mob/living/chorus/Login()
	. = ..()
	if(form)
		form.send_rscs(src)

/mob/living/chorus/self_click()
	. = ..()
	if(. && form)
		form.self_click(src)

/mob/living/chorus/proc/shape_implant(var/obj/item/weapon/implant/chorus_loyalty/cl)
	if(form)
		form.shape_implant(cl)

/mob/living/chorus/proc/choose_form()
	var/dat = list()
	dat += {"<h3><center><b>Choose a Form</b></h3>
	<i>This choice is permanent. Choose carefully, but quickly.<br>
	<u>You will spawn at the location of the choose form button<br>
	So choose your form at the correct position</u></i></center>
	<table border="1" style="width:100%;border-collapse:collapse;">
	<tr>
		<th>Name</th>
		<th>Theme</th>
		<th>Description</th>
	</tr>"}
	var/list/forms = subtypesof(/datum/chorus_form)

	for(var/form in forms)
		var/datum/chorus_form/G = form
		var/god_name = initial(G.name)
		var/icon/god_icon = icon('icons/obj/cult_tall.dmi', initial(G.form_state))
		send_rsc(src,god_icon, "[god_name].png")
		dat += {"<tr>
					<td><a href="?src=\ref[src];form=\ref[G]">[god_name]</a></td>
					<td><img src="[god_name].png"></td>
					<td>[initial(G.desc)]</td>
				</tr>"}
	dat += "</table>"
	show_browser(src, JOINTEXT(dat), "window=godform;can_close=0")