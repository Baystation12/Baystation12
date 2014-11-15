/*
 * Paper
 * also scraps of paper
 */

/obj/machinery/photocopier
	name = "photocopier"
	desc = "stub"

/obj/machinery/faxmachine
	name = "faxmachine"
	desc = "stub"
	var/department

/obj/machinery/photocopier/faxmachine
	desc = "stub"
	var/department

	proc/recievefax(var/P)

/obj/item/device/toner
	name = "toner"
	desc = "stub"

/obj/item/weapon/paperwork/paper
	name = "paper"
	gender = PLURAL
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	throwforce = 0
	w_class = 1.0
	throw_range = 1
	throw_speed = 1
	layer = 4
	pressure_resistance = 1
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD
	attack_verb = list("bapped")

	var/list/text_content = list()
	var/tmp/cached_content //caches the content that is displayed when the paper is viewed
	var/tmp/cached_content_edit //caches the content that is displayed the paper is being edited

	var/info	//backwards compatibility
	var/list/stamped = list()
	var/stamps = "stub"
	var/ico[0]      //Icons and
	var/offset_x[0] //offsets stored for later
	var/offset_y[0] //usage by the photocopier

	carbon
		desc = "stub"
		var/iscopy
		var/copied

/obj/item/weapon/paperwork/paper/New()
	if (info)
		text_content = list(info)

/obj/item/weapon/paperwork/paper/attackby(obj/item/weapon/P as obj, mob/user as mob)
	..()
	if(istype(P, /obj/item/weapon/paperwork))
		create_bundle(P, user)
		return

	if(istype(P, /obj/item/weapon/pen) || istype(P, /obj/item/toy/crayon))
		show_content(user, editing=1)
		return

/obj/item/weapon/paperwork/paper/render_content(mob/user=null, var/editing=0)
	//TODO#paperwork Stamps
	if (isnull(cached_content) || (editing && isnull(cached_content_edit)))
		regenerate_cached_content()

	if(user && !can_read(user))
		return stars(cached_content)

	if (editing)
		return cached_content_edit
	return cached_content

/obj/item/weapon/paperwork/paper/show_content(var/mob/user)
	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[render_content(user)]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")

/obj/item/weapon/paperwork/paper/proc/set_content(var/new_text)
	text_content = list(new_text)
	regenerate_cached_content()

/obj/item/weapon/paperwork/paper/proc/clear_content()
	text_content = list()
	cached_content = ""

/obj/item/weapon/paperwork/paper/proc/regenerate_cached_content()
	cached_content = list2text(text_content)

	cached_content_edit = ""
	for (var/i = 1, i <= text_content.len, i++)
		cached_content_edit += "[text_content[i]]<font face=\"[DEFAULT_FONT]\"><A href='?src=\ref[src];write_content=[i]'>write</A></font>"
	cached_content_edit += "<font face=\"[DEFAULT_FONT]\"><A href='?src=\ref[src];write_content=end'>write</A></font>"

/obj/item/weapon/paperwork/paper/Topic(href, href_list)
	..()
	if (href_list["write_content"])

		if(!usr || (usr.stat || usr.restrained()) || !can_read(usr))
			return

		// if paper is not in usr, then it must be near them, or in a clipboard or folder, which must be in or near usr
		if(src.loc != usr && !src.Adjacent(usr) && !((istype(src.loc, /obj/item/weapon/clipboard) || istype(src.loc, /obj/item/weapon/folder)) && (src.loc.loc == usr || src.loc.Adjacent(usr)) ) )
			return

		//get the new content
		var/obj/item/I = usr.get_active_hand()
		var/new_content = paperwork_input(usr, I)
		if (!new_content)
			return

		//insert it
		if (href_list["write_content"] == "end")
			text_content += new_content
		else
			text_content.Insert(text2num(href_list["write_content"]), new_content)

		regenerate_cached_content()


