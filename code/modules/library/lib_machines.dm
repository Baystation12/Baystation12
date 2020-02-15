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
	anchored = 1
	density = 1
	var/obj/item/weapon/book/cache		// Last scanned book

/obj/machinery/libraryscanner/attackby(var/obj/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/book))
		if(!user.unEquip(O, src))
			return

/obj/machinery/libraryscanner/interface_interact(var/mob/user)
	interact(user)
	return TRUE

/obj/machinery/libraryscanner/interact(var/mob/user)
	usr.set_machine(src)
	var/dat = "<HEAD><TITLE>Scanner Control Interface</TITLE></HEAD><BODY>\n" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	if(cache)
		dat += "<FONT color=#005500>Data stored in memory.</FONT><BR>"
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
		for(var/obj/item/weapon/book/B in contents)
			cache = B
			break
	if(href_list["clear"])
		cache = null
	if(href_list["eject"])
		for(var/obj/item/weapon/book/B in contents)
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
	anchored = 1
	density = 1

/obj/machinery/bookbinder/attackby(var/obj/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/paper))
		if(!user.unEquip(O, src))
			return
		user.visible_message("[user] loads some paper into [src].", "You load some paper into [src].")
		src.visible_message("[src] begins to hum as it warms up its printing drums.")
		sleep(rand(200,400))
		src.visible_message("[src] whirs as it prints and binds a new book.")
		var/obj/item/weapon/book/b = new(src.loc)
		b.dat = O:info
		b.SetName("Print Job #" + "[rand(100, 999)]")
		b.icon_state = "book[rand(1,7)]"
		qdel(O)
	else
		..()
