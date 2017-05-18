/mob/living/deity
	name = "shapeless creature"
	desc = "A shape of otherworldly matter, not yet ready to be unleashed into this world."
	icon = 'icons/mob/deity_big.dmi'
	icon_state = "egg"
	var/power_min = 10 //Below this amount you regenerate uplink TCs
	var/power_tick = 10
	pixel_x = -128
	pixel_y = -128
	health = 100
	maxHealth = 100 //I dunno what to do with health at this point.
	var/eye_type = /mob/observer/eye/cult
	var/list/minions = list() //Minds of those who follow him
	var/list/structures = list() //The objs that this dude controls.
	var/list/feats = list() //These are the deities 'skills' that they unlocked. Which can unlock abilities, new categories, etc. What this list actually IS is the names of the feats and whatever data they need,
	var/obj/item/device/uplink/mob_uplink
	var/datum/god_form/form
	var/datum/current_boon

/mob/living/deity/New()
	..()
	if(eye_type)
		eyeobj = new eye_type(src)
		eyeobj.possess(src)
		eyeobj.visualnet.add_source(src)
	var/obj/item/uplink_holder = new(src) //because uplink devices need to be inside an item to work.
	mob_uplink = new(uplink_holder, telecrystals = 0)

/mob/living/deity/Life()
	. = ..()
	if(. && mob_uplink.uses < power_min && --power_tick == 0)
		mob_uplink.uses += 1
		nanomanager.update_uis(mob_uplink)
		power_tick = initial(power_tick)

/mob/living/deity/death()
	. = ..()
	if(.)
		for(var/m in minions)
			var/datum/mind/M = m
			if(M.learned_spells)
				for(var/s in M.learned_spells)
					var/spell/S = s
					if(S.connected_god == src)
						M.current.remove_spell(S)
						qdel(S)
			to_chat(M, "<font size='3'><span class='danger'>Your connection has been severed! \The [src] is no more!</span></font>")
			sound_to(M, 'sound/hallucinations/far_noise.ogg')
			M.current.Weaken(10)
		for(var/s in structures)
			var/obj/structure/deity/S = s
			S.linked_god = null

/mob/living/deity/Destroy()
	death(0)
	minions.Cut()
	structures.Cut()
	qdel(eyeobj.visualnet)
	qdel(eyeobj)
	qdel(form)
	return ..()

/mob/living/deity/verb/open_menu()
	set name = "Open Menu"
	set category = "Godhood"

	if(!form)
		to_chat(src, "<span class='warning'>Choose a form first!</span>")
		return
	if(!src.mob_uplink.uplink_owner)
		src.mob_uplink.uplink_owner = src.mind
	mob_uplink.update_nano_data()
	src.mob_uplink.trigger(src)

/mob/living/deity/verb/choose_form()
	set name = "Choose Form"
	set category = "Godhood"

	var/dat = {"<h3><center><b>Choose a Form</b></h3>
	<i>This choice is permanent. Choose carefully, but quickly.</i></center>
	<table border="1" style="width:100%;border-collapse:collapse;">
	<tr>
		<th>Name</th>
		<th>Look</th>
		<th>Description</th>
	</tr>"}
	var/list/forms = subtypesof(/datum/god_form)

	for(var/form in forms)
		var/datum/god_form/G = form
		var/god_name = initial(G.name)
		var/icon/god_icon = icon(icon, initial(G.god_icon_state))
		send_rsc(src,god_icon, "[god_name].png")
		dat += {"<tr>
					<td><a href="?src=\ref[src];form=[G]">[god_name]</a></td>
					<td><img src="[god_name].png"></td>
					<td>[initial(G.info)]</td>
				</tr>"}
	dat += "</table>"
	show_browser(src, dat, "window=godform;can_close=0")

/mob/living/deity/proc/set_form(var/type)
	form = new type(src)
	to_chat(src, "<span class='notice'>You undergo a transformation into your new form!</span>")
	spawn(1)
		name = form.name
		var/newname = sanitize(input(src, "Choose a name for your new form.", "Name change", form.name) as text, MAX_NAME_LEN)
		if(newname)
			fully_replace_character_name(newname)
	src.verbs -= /mob/living/deity/verb/choose_form
	show_browser(src, null, "window=godform")
	for(var/m in minions)
		var/datum/mind/mind = m
		var/mob/living/L = mind.current
		L.faction = form.faction

//Gets the name based on form, or if there is no form name, type.
/mob/living/deity/proc/get_type_name(var/type)
	if(form && form.buildables[type])
		var/list/vars = form.buildables[type]
		if(vars["name"])
			return vars["name"]
	var/atom/movable/M = type
	return initial(M.name)