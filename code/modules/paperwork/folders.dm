/obj/item/folder
	name = "folder"
	desc = "A folder."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = ITEM_SIZE_SMALL

/obj/item/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/folder/white
	desc = "A white folder."
	icon_state = "folder_white"

/obj/item/folder/nt
	desc = "A corporate folder."
	icon_state = "folder_nt"

/obj/item/folder/on_update_icon()
	overlays.Cut()
	if(contents.len)
		overlays += "folder_paper"
	return

/obj/item/folder/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/paper_bundle))
		if(!user.unEquip(W, src))
			return
		to_chat(user, "<span class='notice'>You put the [W] into \the [src].</span>")
		update_icon()
	else if(istype(W, /obj/item/pen))
		var/n_name = sanitizeSafe(input(usr, "What would you like to label the folder?", "Folder Labelling", null)  as text, MAX_NAME_LEN)
		if((loc == usr && usr.stat == 0))
			SetName("folder[(n_name ? text("- '[n_name]'") : null)]")
	return

/obj/item/folder/attack_self(mob/user as mob)
	var/dat = "<title>[name]</title>"
	for(var/obj/item/paper/P in src)
		dat += "<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Ph]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Ph]'>Rename</A> - <A href='?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"
	for(var/obj/item/paper_bundle/Pb in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Pb]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Pb]'>Rename</A> - <A href='?src=\ref[src];browse=\ref[Pb]'>[Pb.name]</A><BR>"
	show_browser(user, dat, "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

/obj/item/folder/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(src.loc == usr)

		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if(P && (P.loc == src) && istype(P))
				usr.put_in_hands(P)

		else if(href_list["read"])
			var/obj/item/paper/P = locate(href_list["read"])
			if(P && (P.loc == src) && istype(P))
				if(!(istype(usr, /mob/living/carbon/human) || isghost(usr) || istype(usr, /mob/living/silicon)))
					show_browser(usr, "<HTML><meta charset=\"UTF-8\"><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.show_info(usr))][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")
				else
					show_browser(usr, "<HTML><meta charset=\"UTF-8\"><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.show_info(usr)][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")
		else if(href_list["look"])
			var/obj/item/photo/P = locate(href_list["look"])
			if(P && (P.loc == src) && istype(P))
				P.show(usr)
		else if(href_list["browse"])
			var/obj/item/paper_bundle/P = locate(href_list["browse"])
			if(P && (P.loc == src) && istype(P))
				P.attack_self(usr)
				onclose(usr, "[P.name]")
		else if(href_list["rename"])
			var/obj/item/O = locate(href_list["rename"])

			if(O && (O.loc == src))
				if(istype(O, /obj/item/paper))
					var/obj/item/paper/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/photo))
					var/obj/item/photo/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/paper_bundle))
					var/obj/item/paper_bundle/to_rename = O
					to_rename.rename()

		//Update everything
		attack_self(usr)
		update_icon()
	return

/obj/item/folder/envelope
	name = "envelope"
	desc = "A thick envelope. You can't see what's inside."
	icon_state = "envelope_sealed"
	var/sealed = 1

/obj/item/folder/envelope/on_update_icon()
	if(sealed)
		icon_state = "envelope_sealed"
	else
		icon_state = "envelope[contents.len > 0]"

/obj/item/folder/envelope/examine(mob/user)
	. = ..()
	to_chat(user, "The seal is [sealed ? "intact" : "broken"].")

/obj/item/folder/envelope/proc/sealcheck(user)
	var/ripperoni = alert("Are you sure you want to break the seal on \the [src]?", "Confirmation","Yes", "No")
	if(ripperoni == "Yes")
		visible_message("[user] breaks the seal on \the [src], and opens it.")
		sealed = 0
		update_icon()
		return 1

/obj/item/folder/envelope/attack_self(mob/user as mob)
	if(sealed)
		sealcheck(user)
		return
	else
		..()

/obj/item/folder/envelope/attackby(obj/item/W as obj, mob/user as mob)
	if(sealed)
		sealcheck(user)
		return
	else
		..()
