// Library computer program
/datum/computer_file/program/library
	filename = "library"
	filedesc = "Library"
	extended_desc = "This program can be used to view e-books from an external archive."
	program_icon_state = "word"
	program_key_state = "atmos_key"
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
	var/desc_sort = 1
	var/list/categories = list("Fiction", "Non-Fiction", "Reference", "Religion")
	var/list/emag_categories = list("Adult", "Classified") // Only staff can upload to these categories, and only emagged consoles display them

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
			// Start constructing the DB Query
			var/query_sql = "SELECT id, author, title, category FROM library"

			// Limit to the listed categories (for e-mag categories, and future separated archives)
			var/add_sql = " WHERE approved=1 AND "
			for(var/cat=1,cat<categories.len,cat++)
				add_sql += "category=[categories[cat]] OR "
			add_sql += "category=[categories[categories.len]]"

			// If we're e-magged, then give us access to the hot stuff
			var/obj/item/modular_computer/PC = nano_host()
			if(istype(PC) && PC.computer_emagged)
				add_sql += " OR "
				for(var/cat=1,cat<emag_categories.len,cat++)
					add_sql += "category=[emag_categories[cat]] OR "
				add_sql += "category=[emag_categories[categories.len]]"

			add_sql += " ORDER BY "
			add_sql += sort_by
			if(desc_sort)
				add_sql += " DESC"

			query_sql += add_sql

			var/DBQuery/query = dbcon_old.NewQuery(query_sql)
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
		view_book(input("Enter USBN:") as num)
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

		B.SetName(input(usr, "Enter Book Title", "Title", B.name) as text|null)
		B.author = input(usr, "Enter Author Name", "Author", B.author) as text|null

		if(!B.author)
			B.author = "Anonymous"
		else if(lowertext(B.author) == "edgar allen poe" || lowertext(B.author) == "edgar allan poe")
			error_message = "User Error: Upload something original."
			return 1

		if(!B.title)
			B.title = "Untitled"

		var/upload_category = input(usr, "Upload to which category?") in categories

		var/choice = input(usr, "Submit [B.name] by [B.author] to the Library?") in list("Submit", "Cancel")
		if(choice == "Submit")
			establish_old_db_connection()
			if(!dbcon_old.IsConnected())
				error_message = "Network Error: Connection to the Archive has been severed."
				return 1

			var/sqltitle = sanitizeSQL(B.name)
			var/sqlauthor = sanitizeSQL(B.author)

			var/copied = html_decode(B.dat)
			copied = replacetext(copied, "<font face=\"[PAPER_DEFAULT_FONT]\" color=", "<font face=\"[PAPER_DEFAULT_FONT]\" nocolor=")
			copied = replacetext(copied, "<font face=\"[PAPER_CRAYON_FONT]\" color=", "<font face=\"[PAPER_CRAYON_FONT]\" nocolor=")
			copied = replacetext(copied, "<font face=\"[PAPER_SIGN_FONT]\" color=", "<font face=\"[PAPER_SIGN_FONT]\" nocolor=")

			var/sqlcontent = sanitizeSQL(copied)

			var/sqlcategory = sanitizeSQL(upload_category)
			var/sqluploader = sanitizeSQL(usr.key)

			var/DBQuery/query = dbcon_old.NewQuery("INSERT INTO library (author, title, content, category, uploader, approved) VALUES ('[sqlauthor]', '[sqltitle]', '[sqlcontent]', '[sqlcategory]', '[sqluploader]', 0)")
			if(!query.Execute())
				to_chat(usr, query.ErrorMsg())
				error_message = "Network Error: Unable to upload to the Archive. Contact your system Administrator for assistance."
				return 1
			else
				log_and_message_staff("has uploaded the book titled [B.name], [length(B.dat)] signs")
				log_game("[usr.name]/[usr.key] has uploaded the book titled [B.name], [length(B.dat)] signs")
				alert("Upload Complete. The staff team may now review your book to make sure it meets our quality standards before approval.")
			return 1

		return 0

	if(href_list["printbook"])
		if(!current_book)
			error_message = "Software Error: Unable to print; book not found."
			return 1

		//Print to binder
		if(!nano_host())
			return 1
		for(var/d in GLOB.cardinal)
			var/obj/machinery/bookbinder/bndr = locate(/obj/machinery/bookbinder, get_step(nano_host(), d))
			if(bndr && bndr.anchored)
				var/obj/item/weapon/book/B = new(bndr.loc)
				B.SetName(current_book["title"])
				B.title = current_book["title"]
				B.author = current_book["author"]
				B.dat = current_book["content"]
				B.icon_state = "book[rand(1,7)]"
				B.desc = current_book["author"]+", "+current_book["title"]+", "+"USBN "+current_book["id"]
				bndr.visible_message("\The [bndr] whirs as it prints and binds a new book.")
				return 1

		//Regular printing
		print_text("<i>Author: [current_book["author"]]<br>USBN: [current_book["id"]]</i><br><h2>[current_book["title"]]</h2><br>[current_book["content"]]", usr)
		return 1
	if(href_list["sortby"])
		if(sort_by == href_list["sortby"])
			desc_sort = !desc_sort
		else
			sort_by = sanitizeSQL(href_list["sortby"])
			desc_sort = 0
		return 1
	if(href_list["reseterror"])
		if(error_message)
			current_book = null
			scanner = null
			sort_by = "id"
			desc_sort = 1
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

	var/DBQuery/query = dbcon_old.NewQuery("SELECT * FROM library WHERE id=[sqlid] AND approved=1")
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