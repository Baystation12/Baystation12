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

/obj/item/weapon/paperwork/paper/carbon
	desc = "stub"
	var/iscopy
	var/copied

/datum/stamp
	var/stamp_name = "rubber stamp"
	var/stamp_type
	var/image/overlay
	var/overlay_state
	var/offset_x
	var/offset_y

/datum/stamp/New(var/obj/item/weapon/stamp/S)
	if (S)
		stamp_name = S.name
		stamp_type = S.type
		overlay_state = "paper_[S.icon_state]"
		if(istype(S, /obj/item/weapon/stamp/captain) || istype(S, /obj/item/weapon/stamp/centcomm))
			offset_x = rand(-2, 0)
			offset_y = rand(-1, 2)
		else
			offset_x = rand(-2, 2)
			offset_y = rand(-3, 2)
		update_overlay()

/datum/stamp/proc/update_overlay()
	if (isnull(overlay))
		overlay = image('icons/obj/bureaucracy.dmi')
	overlay.pixel_x = offset_x
	overlay.pixel_y = offset_y
	overlay.icon_state = overlay_state

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

	var/info = null	//backwards compatibility
	
	//TODO#paperwork
	var/list/stamped = list()
	var/stamps = "stub"
	var/ico[0]      //Icons and
	var/offset_x[0] //offsets stored for later
	var/offset_y[0] //usage by the photocopier

/obj/item/weapon/paperwork/paper/New()
	..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	update_icon()

/obj/item/weapon/paperwork/paper/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if((CLUMSY in usr.mutations) && prob(50))
		usr << "<span class='warning'>You cut yourself on the paper.</span>"
		if (ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.drip(1)
		return
	
	..()
	
	if(istype(P, /obj/item/weapon/paperwork))
		create_bundle(P, user)

	else if(istype(P, /obj/item/weapon/pen) || istype(P, /obj/item/toy/crayon))
		show_content(user, editing=1)
	
	else if(istype(P, /obj/item/weapon/stamp))
		var/datum/stamp/S = new (P)
		stamped += S
		visible_message("<span class='notice'>[user] stamps the paper with \his rubber stamp.</span>", \
						"<span class='notice'>You stamp the paper with your rubber stamp.</span>", \
						"<span class='notice'>You hear the sound of rubber hitting paper.</span>")
		

/obj/item/weapon/paperwork/paper/attack_self(mob/user as mob)
	if((CLUMSY in usr.mutations) && prob(50))
		usr << "<span class='warning'>You cut yourself on the paper.</span>"
		if (ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.drip(1)
		return
	
	..()

//TODO#paperwork Stamps
/obj/item/weapon/paperwork/paper/render_content(mob/user=null, var/editing=0)
	//backwards compatibility with code that sets info
	if (!isnull(info))
		text_content = list(info)
		info = null
		regenerate_cached_content()

	if (isnull(cached_content) || (editing && isnull(cached_content_edit)))
		regenerate_cached_content()

	if(user && !can_read(user))
		return stars(cached_content)

	if (editing)
		return cached_content_edit
	return cached_content

/obj/item/weapon/paperwork/paper/show_content(var/mob/user, var/editing=0)
	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[render_content(user, editing)]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")

/obj/item/weapon/paperwork/paper/proc/set_content(var/new_text)
	text_content = list(new_text)
	regenerate_cached_content()
	update_icon()

/obj/item/weapon/paperwork/paper/proc/clear_content()
	text_content = list()
	cached_content = ""
	info = null
	update_icon()




/obj/item/weapon/paperwork/paper/proc/regenerate_cached_content()
	cached_content = list2text(text_content)

	cached_content_edit = ""
	for (var/i = 1, i <= text_content.len, i++)
		cached_content_edit += "[text_content[i]][(i < text_content.len)? "<font face=\"[DEFAULT_FONT]\"><A href='?src=\ref[src];write_content=[i]'>write</A></font>" : ""]"
	cached_content_edit += "<font face=\"[DEFAULT_FONT]\"><A href='?src=\ref[src];write_content=end'>write</A></font>"

/obj/item/weapon/paperwork/paper/update_icon()
	if(icon_state == "paper_talisman")
		return
	if(text_content || info)
		icon_state = "paper_words"
		return
	icon_state = "paper"

/obj/item/weapon/paperwork/paper/Topic(href, href_list)
	world << "write_content: [href_list["write_content"]]"
	world << "usr: [usr]"
	world << "usr.get_active_hand(): [usr.get_active_hand()]"

	if (href_list["write_content"])
		if(!usr || usr.stat || usr.restrained() || !can_read(usr))
			return

		// if paper is not in usr, then it must be near them, or in a clipboard or folder, which must be in or near usr
		if(src.loc != usr && !src.Adjacent(usr) && !((istype(src.loc, /obj/item/weapon/clipboard) || istype(src.loc, /obj/item/weapon/folder)) && (src.loc.loc == usr || src.loc.Adjacent(usr)) ) )
			return

		//get the new content
		var/obj/item/I = usr.get_active_hand()
		var/list/new_content = paperwork_input(usr, I)
		if (!new_content)
			return

		//insert the new content. The first and last elements of the new content gets merged with neighboring elements in text_content
		if (href_list["write_content"] == "end")
			join_lists(text_content, new_content)
		else
			//easiest way to do this is to split text_content
			var/i = text2num(href_list["write_content"])
			var/list/tail = text_content.Copy(i+1)
			text_content.Cut(i+1)
			
			join_lists(text_content, new_content)
			join_lists(text_content, tail)
		
		update_icon()
		regenerate_cached_content()
		show_content(usr, editing=1)
		return
	
	..()

//Helper proc to join two lists of strings, merging the first element of tail with the last element of head
/obj/item/weapon/paperwork/paper/proc/join_lists(var/list/head, var/list/tail)
	if (!tail)
		return
	
	if (head.len)
		head[head.len] = "[head[head.len]][tail[1]]"
		tail.Cut(1,2)
	head += tail
