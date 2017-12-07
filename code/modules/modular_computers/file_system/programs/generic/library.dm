/*
In reply to this set of comments on lib_machines.dm:
// TODO: Make this an actual /obj/machinery/computer that can be crafted from circuit boards and such
// It is August 22nd, 2012... This TODO has already been here for months.. I wonder how long it'll last before someone does something about it.

The answer was five and a half years -ZeroBits
*/

/datum/computer_file/program/library
	filename = "library"
	filedesc = "Library"
	extended_desc = "This program can be used to view e-books from an external archive."
	program_icon_state = "word"
	program_menu_icon = "note"
	size = 6
	requires_ntnet = 1
	available_on_ntnet = 1

	nanomodule_path = /datum/nano_module/library

/datum/nano_module/library
	name = "Library"
	var/error_message = ""
	var/current_book
	var/obj/machinery/libraryscanner/scanner
	var/sort_by = "id"

/datum/nano_module/library/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	if(error_message)
		data["error"] = error_message
	else if(current_book)
		data["current_book"] = current_book
	else
		var/list/all_entries[0]
		establish_old_db_connection()
		if(!dbcon_old.IsConnected())
			error_message = "Unable to contact External Archive. Please contact your system administrator for assistance."
		else
			var/DBQuery/query = dbcon_old.NewQuery("SELECT id, author, title, category FROM library ORDER BY "+sanitizeSQL(sort_by))
			query.Execute()

			while(query.NextRow())
				all_entries.Add(list(list(
				"id" = query.item[1],
				"author" = query.item[2],
				"title" = query.item[3],
				"category" = query.item[4]
			)))
		data["book_list"] = all_entries
		data["scanner"] = istype(scanner)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "library.tmpl", "Library Program", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/library/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["viewbook"])
		view_book(href_list["viewbook"])
		return 1
	if(href_list["viewid"])
		view_book(sanitizeSQL(input("Enter USBN:") as num|null))
		return 1
	if(href_list["closebook"])
		current_book = null
		return 1
	if(href_list["connectscanner"])
		if(!nano_host())
			return 1
		for(var/d in GLOB.cardinal)
			var/obj/machinery/libraryscanner/scn = locate(/obj/machinery/libraryscanner, get_step(nano_host(), d))
			if(scn && scn.anchored)
				scanner = scn
				return 1
	if(href_list["uploadbook"])
		if(!scanner || !scanner.anchored)
			scanner = null
			error_message = "Hardware Error: No scanner detected. Unable to access cache."
			return 1
		if(!scanner.cache)
			error_message = "Interface Error: Scanner cache does not contain any data. Please scan a book."
			return 1

		var/obj/item/weapon/book/B = scanner.cache

		if(B.unique)
			error_message = "Interface Error: Cached book is copy-protected."
			return 1

		B.name = input(usr, "Enter Book Title", "Title", B.name) as text|null
		B.author = input(usr, "Enter Author Name", "Author", B.author) as text|null

		if(!B.author)
			B.author = "Anonymous"
		else if(lowertext(B.author) == "edgar allen poe" || lowertext(B.author) == "edgar allan poe")
			error_message = "User Error: Upload something original."
			return 1

		if(!B.title)
			B.title = "Untitled"

		var/choice = input(usr, "Upload [B.name] by [B.author] to the External Archive?") in list("Yes", "No")
		if(choice == "Yes")
			establish_old_db_connection()
			if(!dbcon_old.IsConnected())
				error_message = "Network Error: Connection to the Archive has been severed."
				return 1

			var/upload_category = input(usr, "Upload to which category?") in list("Fiction", "Non-Fiction", "Reference", "Religion")

			var/sqltitle = sanitizeSQL(B.name)
			var/sqlauthor = sanitizeSQL(B.author)
			var/sqlcontent = sanitizeSQL(B.dat)
			var/sqlcategory = sanitizeSQL(upload_category)
			var/DBQuery/query = dbcon_old.NewQuery("INSERT INTO library (author, title, content, category) VALUES ('[sqlauthor]', '[sqltitle]', '[sqlcontent]', '[sqlcategory]')")
			if(!query.Execute())
				to_chat(usr, query.ErrorMsg())
				error_message = "Network Error: Unable to upload to the Archive. Contact your system Administrator for assistance."
				return 1
			else
				log_and_message_admins("has uploaded the book titled [B.name], [length(B.dat)] signs")
				log_game("[usr.name]/[usr.key] has uploaded the book titled [B.name], [length(B.dat)] signs")
				alert("Upload Complete.")
			return 1

		return 0

	if(href_list["printbook"])
		if(!current_book)
			error_message = "Software Error: Unable to print; book not found."
			return 1

		//PRINT TO BINDER
		if(!nano_host())
			return 1
		for(var/d in GLOB.cardinal)
			var/obj/machinery/bookbinder/bndr = locate(/obj/machinery/bookbinder, get_step(nano_host(), d))
			if(bndr && bndr.anchored)
				var/obj/item/weapon/book/B = new(bndr.loc)
				B.name = current_book["title"]
				B.title = current_book["title"]
				B.author = current_book["author"]
				B.dat = current_book["content"]
				B.icon_state = "book[rand(1,7)]"
				B.desc = current_book["author"]+", "+current_book["title"]+", "+"USBN "+current_book["id"]
				bndr.visible_message("\The [bndr] whirs as it prints and binds a new book.")
				return 1

		//Regular printing
		print_text("<i>Author: [current_book["author"]]<br>USBN: [current_book["id"]]</i><br><h3>[current_book["title"]]</h3><br>[current_book["content"]]", usr)
		return 1
	if(href_list["sortby"])
		sort_by = href_list["sortby"]
		return 1
	if(href_list["reseterror"])
		if(error_message)
			current_book = null
			scanner = null
			sort_by = "id"
			error_message = ""
		return 1

/datum/nano_module/library/proc/view_book(var/id)
	if(current_book || !id)
		return 0

	var/sqlid = sanitizeSQL(id)
	establish_old_db_connection()
	if(!dbcon_old.IsConnected())
		error_message = "Network Error: Connection to the Archive has been severed."
		return 1

	var/DBQuery/query = dbcon_old.NewQuery("SELECT * FROM library WHERE id=[sqlid]")
	query.Execute()

	while(query.NextRow())
		current_book = list(
			"id" = query.item[1],
			"author" = query.item[2],
			"title" = query.item[3],
			"content" = query.item[4]
			)
		break
	return 1