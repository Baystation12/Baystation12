#define SHOW_LINK_PREV	1
#define SHOW_LINK_NEXT	2

#undefine

/obj/item/weapon/paperwork/bundle
	name = "paper bundle"
	gender = PLURAL
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	throwforce = 0
	w_class = 1
	throw_range = 2
	throw_speed = 1
	layer = 4
	pressure_resistance = 1
	attack_verb = list("bapped")
	var/page = 1
	var/screen = SHOW_LINK_NEXT

//Attaches a paperwork item to the end of the bundle
/obj/item/weapon/paperwork/bundle/proc/attach_item(obj/item/weapon/paperwork/P, mob/user)
	if (istype(P, /obj/item/weapon/paperwork/paper/carbon))
		var/obj/item/weapon/paperwork/paper/carbon/C = P
		if (!C.iscopy && !C.copied)
			user << "<span class='notice'>Take off the carbon copy first.</span>"
			add_fingerprint(user)
			return 0

	user.drop_from_inventory(P)
	if (!istype(P, /obj/item/weapon/paperwork/bundle))
		P.loc = src
	else
		for(var/obj/O in P)
			O.loc = src
			O.add_fingerprint(user)
		del(P)
	
	update_bundle(1)
	update_icon()
	return 1

//paperwork/create_bundle() won't work when src is a bundle (src gets deleted) so override it.
//I don't think create_bundle is ever called on a paper bundle but it's better to be safe.
/obj/item/weapon/paperwork/bundle/create_bundle(obj/item/weapon/paperwork/other, mob/user)
	attach_item(other, user)

/obj/item/weapon/paperwork/bundle/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W, /obj/item/weapon/paperwork))
		if (attach_item(W, user))
			user << "<span class='notice'>You add \the [W] to \the [src].</span>"

	else if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/toy/crayon))
		usr << browse(null, "window=[name]") //Closes the dialog
		var/obj/item/weapon/paperwork/P = src[page]
		P.attackby(W, user)
	
	//Stamp the first page, since that's the only one for which stamps are visible
	else if(istype(W, /obj/item/weapon/stamp))
		var/obj/item/weapon/paperwork/P = src[1]
		P.attackby(W, user)
		update_icon()
	
	else
		//update_icon()
		//attack_self(usr) //Update the browsed page.
		//add_fingerprint(usr)
		..()

//Render the page's content
/obj/item/weapon/paperwork/bundle/render_content(mob/user=null, var/show_page=null)
	if (isnull(show_page))
		show_page = page
	
	//generate page contents
	if (istype(src[show_page], /obj/item/weapon/paperwork))
		var/obj/item/weapon/paperwork/P = src[show_page]
		return P.render_content(user)
	return ""

/obj/item/weapon/paperwork/bundle/show_content(mob/user)
	//generate header
	var/dat = ""

	dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'>[(screen & SHOW_LINK_PREV)? "<A href='?src=\ref[src];prev_page=1'>Previous Page</A>" : ""]</DIV>"
	dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove Page</A></DIV>"
	dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'>[(screen & SHOW_LINK_NEXT)? "<A href='?src=\ref[src];next_page=1'>Next Page</A>" : ""]</DIV>"

	dat += "<BR><HR>[render_content(user, page)]"

	user << browse(dat, "window=[name]")
	onclose(user, "[name]")

//sets the current page
/obj/item/weapon/paperwork/bundle/proc/set_page(var/newpage)
	if (newpage != page)
		page = newpage
		playsound(src.loc, "pageturn", 50, 1)
		update_bundle()

/obj/item/weapon/paperwork/bundle/Topic(href, href_list)
	..()
	if((src in usr.contents) || (istype(src.loc, /obj/item/weapon/folder) && (src.loc in usr.contents)))
		usr.set_machine(src)
		if(href_list["next_page"])
			set_page(page+1)
			add_fingerprint(usr)

		if(href_list["prev_page"])
			set_page(page-1)
			add_fingerprint(usr)

		if(href_list["remove"])
			var/obj/item/weapon/W = src[page]
			usr.put_in_hands(W)
			usr << "<span class='notice'>You remove the [W.name] from the bundle.</span>"
			add_fingerprint(usr)

			update_bundle()
			update_icon()
	else
		usr << "<span class='notice'>You need to hold \the [src] in your hands!</span>"

	//refresh the browser window
	if (istype(usr, /mob))
		src.attack_self(usr)
		updateUsrDialog()

/obj/item/weapon/paperwork/bundle/verb/remove_all()
	set name = "Loosen Bundle"
	set category = "Object"
	set src in usr

	usr << "<span class='notice'>You take apart the bundle.</span>"
	for(var/obj/O in src)
		O.loc = usr.loc
		O.layer = initial(O.layer)
		O.add_fingerprint(usr)
	usr.drop_from_inventory(src)
	usr << browse(null, "window=[name]") //close the browser window
	del(src)
	return

//Should be called when the bundle is modified
//added var overrides the contents.len check so that bundles are not immediately destroyed when adding the very first item.
/obj/item/weapon/paperwork/bundle/proc/update_bundle(var/added=0)
	//can't have a bundle of 1
	if(!added && contents.len == 1)
		var/obj/item/weapon/paperwork/paper/P = src[1]
		usr.drop_from_inventory(src)
		usr.put_in_hands(P)
		usr << browse(null, "window=[name]") //close the browser window
		del(src)
	
	//ensure page is within bounds
	page = between(1, page, contents.len)
	
	screen = 0
	if (page > 1)
		screen |= SHOW_LINK_PREV
	if (page < contents.len)
		screen |= SHOW_LINK_NEXT
	
	switch (contents.len)
		if (1 to 2)
			throwforce = 0
			w_class = 1
			throw_range = 1
			throw_speed = 1
		if (3 to 4)
			throwforce = 0
			w_class = 1
			throw_range = 2
			throw_speed = 1
		if (5 to 8)
			throwforce = 0
			w_class = 2
			throw_range = 3
			throw_speed = 1
		if (9 to 16)
			desc = "A huge stack of papers."
			throwforce = 3
			w_class = 3
			throw_range = 5
			throw_speed = 2
		if (17 to INFINITY)
			desc = "An enormous stack of papers!"
			throwforce = 5
			w_class = 4
			throw_range = 7
			throw_speed = 3

/obj/item/weapon/paperwork/bundle/update_icon()
	var/obj/item/weapon/paperwork/paper/P = src[1]
	icon_state = P.icon_state
	overlays = P.overlays
	underlays = 0
	var/i = 0
	var/photo
	for(var/obj/O in src)
		var/image/img = image('icons/obj/bureaucracy.dmi')
		if(istype(O, /obj/item/weapon/paperwork/paper))
			img.icon_state = O.icon_state
			img.pixel_x -= min(1*i, 2)
			img.pixel_y -= min(1*i, 2)
			pixel_x = min(0.5*i, 1)
			pixel_y = min(  1*i, 2)
			underlays += img
			i++
		else if(istype(O, /obj/item/weapon/photo))
			var/obj/item/weapon/photo/Ph = O
			img = Ph.tiny
			photo = 1
			overlays += img
	if(i>1)
		desc =  "[i] papers clipped to each other."
	else
		desc = "A single sheet of paper."
	if(photo)
		desc += "\nThere is a photo attached to it."
	overlays += image('icons/obj/bureaucracy.dmi', "clip")
	return
