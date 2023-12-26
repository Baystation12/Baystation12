/* Library Machines
 *
 * Contains:
 *		Library Scanner
 *		Book Binder
 */

/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "scanner"
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	anchored = TRUE
	density = TRUE
	var/obj/item/book/cache		// Last scanned book

/obj/machinery/libraryscanner/use_tool(obj/item/O, mob/living/user, list/click_params)
	if(istype(O, /obj/item/book))
		user.unEquip(O, src)
		return TRUE

	return ..()

/obj/machinery/libraryscanner/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/libraryscanner/interact(mob/user)
	usr.set_machine(src)
	var/dat = "<HEAD><TITLE>Scanner Control Interface</TITLE></HEAD><BODY>\n" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	if(cache)
		dat += "[SPAN_COLOR("#005500", "Data stored in memory.")]<BR>"
	else
		dat += "No data stored in memory.<BR>"
	dat += "<A href='?src=\ref[src];scan=1'>\[Scan\]</A>"
	if(cache)
		dat += "       <A href='?src=\ref[src];clear=1'>\[Clear Memory\]</A><BR><BR><A href='?src=\ref[src];eject=1'>\[Remove Book\]</A>"
	else
		dat += "<BR>"
	show_browser(user, dat, "window=scanner")
	onclose(user, "scanner")

/obj/machinery/libraryscanner/Topic(href, href_list)
	if(..())
		close_browser(usr, "window=scanner")
		onclose(usr, "scanner")
		return

	if(href_list["scan"])
		for(var/obj/item/book/B in contents)
			cache = B
			break
	if(href_list["clear"])
		cache = null
	if(href_list["eject"])
		for(var/obj/item/book/B in contents)
			B.dropInto(loc)
	src.add_fingerprint(usr)
	src.updateUsrDialog()

/*
 * Book binder
 */
/obj/machinery/bookbinder
	name = "Book Binder"
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	anchored = TRUE
	density = TRUE
	var/binding

/obj/machinery/bookbinder/use_tool(obj/item/O, mob/living/user, list/click_params)
	if(istype(O, /obj/item/paper))
		if(!user.unEquip(O, src))
			return TRUE
		if (binding)
			to_chat(user, SPAN_WARNING("\The [src] is currently busy printing a book."))
			return TRUE

		user.visible_message(
			SPAN_NOTICE("\The [user] loads some paper into \the [src]."),
			SPAN_NOTICE("You load some paper into \the [src].")
		)
		visible_message(SPAN_NOTICE("\The [src] begins to hum as it warms up its printing drums."))
		binding = TRUE
		sleep(rand(200,400))
		visible_message(SPAN_NOTICE("\The [src] whirs as it prints and binds a new book."))
		binding = FALSE
		var/obj/item/book/b = new(loc)
		b.dat = O:info
		b.SetName("Print Job #" + "[rand(100, 999)]")
		b.icon_state = "book[rand(1,7)]"
		qdel(O)
		return TRUE

	return ..()
