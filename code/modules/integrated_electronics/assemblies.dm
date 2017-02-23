/obj/item/device/electronic_assembly
	name = "electronic assembly"
	desc = "It's a case, for building electronics with."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_small"
	var/max_components = 10
	var/max_complexity = 40
	var/opened = 0
	var/obj/item/electronic_assembly_shell/applied_shell

/obj/item/device/electronic_assembly/medium
	name = "electronic mechanism"
	desc = "It's a medium sized case, for building electronics with."
	icon_state = "setup_medium"
	w_class = ITEM_SIZE_NORMAL
	max_components = 20
	max_complexity = 80

/obj/item/device/electronic_assembly/large
	name = "electronic machine"
	desc = "A large case, for building electronics with."
	icon_state = "setup_large"
	w_class = ITEM_SIZE_LARGE
	max_components = 30
	max_complexity = 120

/obj/item/device/electronic_assembly/drone
	name = "electronic drone"
	desc = "A little drone fit to be controlled via electronics."
	icon_state = "setup_drone"
	w_class = ITEM_SIZE_NORMAL
	max_components = 25
	max_complexity = 100

/obj/item/device/electronic_assembly/Destroy()
	qdel(applied_shell)
	applied_shell = null
	. = ..()

/obj/item/device/electronic_assembly/GetAccess()
	. = list()
	for(var/obj/item/integrated_circuit/part in contents)
		. |= part.GetAccess()

/obj/item/device/electronic_assembly/GetIdCard()
	. = list()
	for(var/obj/item/integrated_circuit/part in contents)
		var/id_card = part.GetIdCard()
		if(id_card)
			return id_card

/obj/item/device/electronic_assembly/verb/rotate()
	set category = "Object"
	set name = "Rotate Assembly"
	set src in view(1)

	if(usr.incapacitated())
		return
	set_dir(turn(dir, -90))
	to_chat(usr, "\The src is now facing [dir2text(dir)].")
/obj/item/device/electronic_assembly/proc/get_part_complexity()
	. = 0
	for(var/obj/item/integrated_circuit/part in contents)
		. += part.complexity

/obj/item/device/electronic_assembly/proc/get_part_size()
	. = 0
	for(var/obj/item/integrated_circuit/part in contents)
		. += part.size

/obj/item/device/electronic_assembly/proc/open_interact(mob/user)
	if(!CanInteract(user, physical_state))
		return

	var/total_part_size = get_part_size()
	var/total_complexity = get_part_complexity()
	var/HTML = list()

	HTML += "<html><head><title>[src.name]</title></head><body>"
	HTML += "<br><a href='?src=\ref[src]';refresh=1>\[Refresh\]</a>  |  "
	HTML += "<a href='?src=\ref[src];rename=1'>\[Rename\]</a><br>"
	HTML += "[total_part_size]/[max_components] ([round((total_part_size / max_components) * 100, 0.1)]%) space taken up in the assembly.<br>"
	HTML += "[total_complexity]/[max_complexity] ([round((total_complexity / max_complexity) * 100, 0.1)]%) maximum complexity."
	HTML += "<br><br>"
	HTML += "Components;<br>"

	HTML += "<table>"
	for(var/obj/item/integrated_circuit/circuit in contents)
		HTML += "<tr>"
		HTML += "<td><a href=?src=\ref[circuit];examine=1>[circuit.name]</a></td>"
		HTML += "<td><a href=?src=\ref[circuit];rename=1>\[Rename\]</a></td>"
		HTML += "<td><a href=?src=\ref[src];bottom=\ref[circuit]>\[To Bottom\]</a></td>"
		HTML += "<td><a href=?src=\ref[circuit];remove=1>\[Remove\]</a></td>"
		HTML += "</tr>"
	HTML += "</table>"

	HTML += "</body></html>"
	user << browse(jointext(HTML,null), "window=open-assembly-\ref[src];size=600x350;border=1;can_resize=1;can_close=1;can_minimize=1")

/obj/item/device/electronic_assembly/proc/closed_interact(mob/user)
	if(!CanInteract(user, physical_state))
		return

	var/HTML = list()
	HTML += "<html><head><title>[src.name]</title></head><body>"
	HTML += "<br><a href='?src=\ref[src];refresh=1'>\[Refresh\]</a>"
	HTML += "<br><br>"

	var/listed_components = FALSE
	for(var/obj/item/integrated_circuit/circuit in contents)
		var/list/topic_data = circuit.get_topic_data(user)
		if(topic_data.len)
			listed_components = TRUE
			HTML += "<b>[circuit.name]: </b>"
			if(topic_data.len != 1)
				HTML += "<br>"
			for(var/entry in topic_data)
				var/href = topic_data[entry]
				if(href)
					HTML += "<a href=?src=\ref[circuit];[href]>[entry]</a>"
				else
					HTML += entry
				HTML += "<br>"
			HTML += "<br>"
	HTML += "</body></html>"

	if(listed_components)
		user << browse(jointext(HTML,null), "window=closed-assembly-\ref[src];size=600x350;border=1;can_resize=1;can_close=1;can_minimize=1")

/obj/item/device/electronic_assembly/Topic(href, href_list[])
	if(..())
		return 1

	if(href_list["refresh"])
		interact(usr)
		return 1

	if(!opened)
		return 0

	else if(href_list["rename"])
		rename(usr)
		. = 1

	else if(href_list["bottom"])
		var/obj/circuit = locate(href_list["bottom"]) in contents
		if(!circuit)
			return
		circuit.loc = null
		circuit.loc = src
		. = 1

	if(.)
		interact(usr) // To refresh the UI.

/obj/item/device/electronic_assembly/verb/rename()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	if(!CanInteract(M, physical_state))
		return

	var/input = sanitizeSafe(input("What do you want to name this?", "Rename", src.name) as null|text, MAX_NAME_LEN)
	if(src && input && input != name && CanInteract(M, physical_state))
		to_chat(M, "<span class='notice'>The machine now has a label reading '[input]'.</span>")
		name = input

/obj/item/device/electronic_assembly/update_icon()
	if(applied_shell)
		desc = applied_shell.applied_description
		icon = applied_shell.icon
		icon_state = applied_shell.icon_state
	else
		desc = initial(desc)
		icon = initial(icon)
		if(opened)
			icon_state = initial(icon_state) + "-open"
		else
			icon_state = initial(icon_state)

/obj/item/device/electronic_assembly/examine(mob/user)
	. = ..(user, 2 * w_class) // Larger assemblies are easier to see from a distance
	to_chat(user, "\The [src] is currently facing [dir2text(dir)].")
	if(.)
		for(var/obj/item/integrated_circuit/IO in contents)
			IO.external_examine(user, opened)

/obj/item/device/electronic_assembly/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/integrated_circuit))
		if(!user.unEquip(I))
			return 0
		if(add_circuit(I, user))
			to_chat(user, "<span class='notice'>You slide \the [I] inside \the [src].</span>")
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			interact(user)
		else
			user.put_in_any_hand_if_possible(I)
	else if(istype(I, /obj/item/weapon/crowbar))
		if(applied_shell)
			to_chat(user, "<span class='warning'>You cannot open the assembly while it has a shell attached.</span>")
			return 0
		playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
		opened = !opened
		to_chat(user, "<span class='notice'>You [opened ? "opened" : "closed"] \the [src].</span>")
		update_icon()
	else if(istype(I, /obj/item/electronic_assembly_shell))
		if(opened)
			to_chat(user, "<span class='warning'>You cannot attach a shell while the assembly is open.</span>")
			return 0
		if(!user.unEquip(I))
			return 0
		var/obj/item/electronic_assembly_shell/S = I
		if(apply_shell(S, user))
			playsound(src, 'sound/weapons/flipblade.ogg', 50, 0, -2)
	else if(istype(I, /obj/item/weapon/screwdriver)	&& applied_shell)
		applied_shell.dropInto(loc)
		user.put_in_any_hand_if_possible(applied_shell)
		applied_shell = null
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 0, -2)
		update_icon()
	else if(istype(I, /obj/item/device/integrated_electronics/wirer) || istype(I, /obj/item/device/integrated_electronics/debugger) || istype(I, /obj/item/weapon/screwdriver))
		if(opened)
			interact(user)
		else
			to_chat(user, "<span class='warning'>\The [src] isn't opened, so you can't fiddle with the internal components.  \
			Try using a crowbar.</span>")
	else
		return ..()

/obj/item/device/electronic_assembly/attack_self(mob/user)
	interact(user)

/obj/item/device/electronic_assembly/interact(mob/user)
	if(!CanInteract(user, physical_state))
		return
	if(opened)
		open_interact(user)
	closed_interact(user)

/obj/item/device/electronic_assembly/emp_act(severity)
	..()
	for(var/atom/movable/AM in contents)
		AM.emp_act(severity)

/obj/item/device/electronic_assembly/ex_act(severity)
	for(var/obj/thing in src)
		thing.ex_act(severity)
	..()

/obj/item/device/electronic_assembly/proc/add_circuit(var/obj/item/integrated_circuit/IC, var/mob/user)
	if(!opened)
		to_chat(user, "<span class='warning'>\The [src] isn't opened, so you can't put anything inside.  Try using a crowbar.</span>")
		return FALSE

	var/total_part_size = get_part_size()
	var/total_complexity = get_part_complexity()

	if((total_part_size + IC.size) > max_components)
		to_chat(user, "<span class='warning'>You can't seem to add the '[IC.name]', as there's insufficient space.</span>")
		return FALSE
	if((total_complexity + IC.complexity) > max_complexity)
		to_chat(user, "<span class='warning'>You can't seem to add the '[IC.name]', since this setup's too complicated for the case.</span>")
		return FALSE

	return IC.forceMove(src)

/obj/item/device/electronic_assembly/proc/apply_shell(var/obj/item/electronic_assembly_shell/a_shell, var/user)
	if(applied_shell)
		to_chat(user, "<span class='warning'>There is already a shell attached.</span>")
		return 0
	if(!a_shell.can_apply_shell(src, user))
		return FALSE
	a_shell.forceMove(src)
	applied_shell = a_shell
	update_icon()
	return TRUE
