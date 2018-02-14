// Library admin panel. Because let's be honest, you didn't actually use sentry.
var/list/library_panels = list()

/datum/admins/proc/library_admin()
	set category = "Admin"
	set name = "Library Panel"
	set desc = "Allows you to view and administrate the library"

	// Archive categories
	var/list/archive_library = list("Fiction", "Non-Fiction", "Reference", "Religion")
	var/list/archive_emag = list("Adult", "Classified")
	var/list/archive_news = list("News")

	// Gave mods access because if we let enough staff have access to it, maybe one of them willl actually use it :^)
	if(!check_rights(R_MOD|R_ADMIN|R_DEBUG|R_SERVER))
		to_chat(usr, "You are not allowed to use this command")
		return

	// If we don't already have a ui, then create one
	var/datum/library_admin/lib_ui
	lib_ui = library_panels[usr]

	if (!lib_ui)
		lib_ui = new /datum/library_admin
		library_panels[usr] = lib_ui

	// Archive selection
	var/input_result = input(usr, "Select Archive to Display") in list("Library", "Traitor", "News", "Cancel")
	if(input_result == "Cancel")
		return
	else if(input_result == "Library")
		lib_ui.categories = archive_library
	else if(input_result == "Traitor")
		lib_ui.categories = archive_emag
	else if(input_result == "News")
		lib_ui.categories = archive_news
	else
		return // return to keep it from going forward

	lib_ui.current_book = null
	lib_ui.current_edit = null
	lib_ui.sort_by = "id"
	lib_ui.desc_sort = 1

	lib_ui.refresh_popup(usr)

/datum/library_admin
	var/list/current_book
	var/current_edit
	var/sort_by = "id"
	var/desc_sort = 1
	var/list/categories = list()

/datum/library_admin/proc/refresh_popup(var/mob/usr)
	var/dat = ""
	var/list/book_list = list()

	if(current_edit) // Editor
		dat += {"\
		<h2>EDITING</h2>
		<div class=\"item\">
		<div class=\"itemLabel\">Commands:</div>
		<div class=\"itemContent\">
		<a href='?src=\ref[src];close_book=1;'>Cancel</a>
		<a href='?src=\ref[src];edit_current=1;'>Edit</a>
		<a href='?src=\ref[src];submit_book=1;'>Submit</a>
		</div>
		</div>
		<div style=\"box-sizing: border-box; background-color: #ECF0F1; padding: 12px;\">
		[current_edit]
		</div>"}

	else if(current_book) // Just reading
		dat += {"\
		<h2>"}+current_book["title"]+{"</h2>
		<div class=\"item\">
		<div class=\"itemLabel\">Author:</div>
		<div class=\"itemContent\">"}+current_book["author"]+{"</div>
		<div class=\"itemLabel\">Uploader:</div>
		<div class=\"itemContent\">"}+current_book["uploader"]+{"</div>
		<div class=\"itemLabel\">USBN:</div>
		<div class=\"itemContent\">"}+current_book["id"]+{"</div>
		<div class=\"itemLabel\">Commands:</div>
		<div class=\"itemContent\">
		<a href='?src=\ref[src];close_book=1;'>Close</a>
		<a href='?src=\ref[src];edit_book=1;'>Edit</a>
		<a href='?src=\ref[src];delete_book=\ref"}+current_book["id"]+{";'>Delete</a>"}

		if(!current_book["approved"])
			dat += "<a href='?src=\ref[src];approve_book=\ref"+current_book["id"]+";'>Approve</a>"
		else
			dat += "Approved"

		dat += {"\
		</div>
		</div>
		<div style=\"box-sizing: border-box; background-color: #ECF0F1; padding: 12px;\">"}+current_book["content"]+{"</div>"}
	else
		////////// DATABASE & SQL STUFF //////////
		// You can browse my library anytime babe~
		establish_old_db_connection()
		if(!dbcon_old.IsConnected())
			to_chat(usr, "ERROR: Could not connect to the library database")
		return

		// Clear our book list and set our screen
		book_list = list()

		// Start constructing the DB Query
		var/query_sql = "SELECT id, author, title, category, uploader, approved FROM library WHERE "

		// Limit to the listed categories
		for(var/cat=1,cat<categories.len,cat++)
			query_sql += "category=[categories[cat]] OR "
			query_sql += "category=[categories[categories.len]]"

		// Order by however we're ordering it
		query_sql += " ORDER BY "
		query_sql += sort_by
		if(desc_sort)
			query_sql += " DESC"

		// Execute query
		var/DBQuery/query = dbcon_old.NewQuery(query_sql)
		query.Execute()

		while(query.NextRow())
			book_list.Add(list(list(
			"id" = query.item[1],
			"author" = query.item[2],
			"title" = query.item[3],
			"category" = query.item[4],
			"uploader" = query.item[5],
			"approved" = query.item[6]
			)))

		////////// LIBRARY LIST UI //////////
		dat += {"\
		<h2>Library</h2>
		<div class=\"item\">
		<div class=\"itemLabel\">
		Commands:
		</div>
		<div class=\"itemContent\">
		<a href='?src=\ref[src];create_book=1;'>Create Book</a>
		</div>
		</div>
		<div class=\"item\">
		<div class=\"itemLabel\">
		Sort by:
		</div>
		<div class=\"itemContent\">
		<a href='?src=\ref[src];sort_by='title';'>Title</a>
		<a href='?src=\ref[src];sort_by='author';'>Author</a>
		<a href='?src=\ref[src];sort_by='uploader';'>Uploader</a>
		<a href='?src=\ref[src];sort_by='category';'>Category</a>
		<a href='?src=\ref[src];sort_by='id';'>USBN</a>
		<a href='?src=\ref[src];sort_by='approved';'>Approved</a>
		</div>
		</div>
		<table style=\"width:100%\">
		<tr><th style=\"width:10%\">Cmd<th style=\"width:30%\">Title<th style=\"width:15%\">Author<th style=\"width:15%\">Uploader<th style=\"width:15%\">Category<th style=\"width:10%\">USBN<th style=\"width:5%\">Approved"}

		for(var/value in book_list)
			dat += {"\
			<tr><td><a href='?src=\ref[src];view_book=\ref"}+value["id"]+{";'>Open</a>
			<td>"}+value["title"]+{"
			<td>"}+value["author"]+{"
			<td>"}+value["uploader"]+{"
			<td>"}+value["category"]+{"
			<td>"}+value["id"]+{"
			<td>"}+value["approved"]+{"
			</div>"}

		dat += "</table>"

	var/datum/browser/popup = new(usr, "library_panel", "Library Panel", 700, 800, src)
	popup.set_content(dat)
	popup.open()

/datum/library_admin/Topic(href, href_list)
	. = ..()
	if(!.)
		//// ARCHIVE SCREEN ////
		if(href_list["view_book"]) // View Book
			// Don't do this database dance if we're already viewing a book
			if(current_book)
				to_chat(usr, "ERROR: Yo dawg, I heard you liked books, but you can't view a book while you're viewing a book")
			return

			// Sanitize our book ID
			var/sqlid = sanitizeSQL(href_list["view_book"])

			// Connect to the database
			establish_old_db_connection()
			if(!dbcon_old.IsConnected())
				to_chat(usr, "ERROR: Could not connect to the library database.")
				return

			// Get our query up and e x e c u t e
			var/DBQuery/query = dbcon_old.NewQuery("SELECT id, author, title, content, uploader, approved FROM library WHERE id=[sqlid]")
			query.Execute()

			while(query.NextRow())
				current_book = list(
				"id" = query.item[1],
				"author" = query.item[2],
				"title" = query.item[3],
				"content" = query.item[4],
				"uploader" = query.item[5],
				"approved" = query.item[6]
				)
				break
			. = TOPIC_REFRESH

		if(href_list["sort_by"]) // Sort the display list yo
			// If you click the sort option you're already on, switch descending/ascending
			if(sort_by == sanitizeSQL(href_list["sort_by"]))
				desc_sort = !desc_sort
			else
				sort_by = sanitizeSQL(href_list["sort_by"])
				desc_sort = 0
			. = TOPIC_REFRESH

		//// BOOK SCREEN ////
		if(href_list["close_book"]) // Just close the book yo
			current_book = null
			current_edit = null
			. = TOPIC_REFRESH

		if(href_list["delete_book"]) // DELETE A book forever
			// Sanitize our book ID
			var/sqlid = sanitizeSQL(href_list["delete_book"])

			// Try to establish a connection to the database
			establish_old_db_connection()
			if(!dbcon_old.IsConnected())
				to_chat(usr, "ERROR: Could not connect to the library database.")
				return

			// Deliberately made DELETE the second choice, so it wouldn't be auto-picked by enter-press
			if(input(usr, "DELETE USBN-[sqlid] FOREVER?") in list("Cancel", "DELETE") != "DELETE")
				return

			// delet this
			var/DBQuery/query = dbcon_old.NewQuery("DELETE FROM library WHERE id=[sqlid]")
			query.Execute()

			// Tell the server/admins
			log_and_message_staff("has deleted book id=[sqlid]")
			log_game("[usr.name]/[usr.key] has deleted book id=[sqlid]")

			// Since we likely deleted the book we're currently viewing
			current_book = null
			current_edit = null
			. = TOPIC_REFRESH

		if(href_list["approve_book"]) // Approve a book
			// Sanitize our book ID
			var/sqlid = sanitizeSQL(href_list["approve_book"])

			// Try to establish a connection to the database
			establish_old_db_connection()
			if(!dbcon_old.IsConnected())
				to_chat(usr, "ERROR: Could not connect to the library database.")
				return

			// Ask if they want to approve it
			if(input(usr, "Approve USBN-[sqlid]?") in list("Approve", "Cancel") != "Approve")
				return

			// Approve
			var/DBQuery/query = dbcon_old.NewQuery("UPDATE library SET approved=1 WHERE id=[sqlid]")
			query.Execute()

			// Tell the server/admins
			log_and_message_staff("has approved book id=[sqlid]")
			log_game("[usr.name]/[usr.key] has approved book id=[sqlid]")

			// We probably approved the book we're currently looking at
			current_book = null
			current_edit = null
			. = TOPIC_REFRESH

		//// EDITOR SCREEN ////
		if(href_list["edit_book"]) // Edit a book we're viewing
			if(current_edit)
				to_chat(usr, "ERROR: You're already editing a book.")
				return

			current_edit = current_book["content"]
			. = TOPIC_REFRESH

		if(href_list["create_book"]) // Create a new book to edit
			if(current_book || current_edit)
				to_chat(usr, "ERROR: You're already editing or viewing a book.")
				return

			// It needs to be set to something. Why not our current fonts?
			current_edit = {"<font face=\"[PAPER_DEFAULT_FONT]\">DEFAULT FONT</font>
			<font face=\"[PAPER_CRAYON_FONT]\">CRAYON FONT</font>
			<font face=\"[PAPER_SIGN_FONT]\">SIGNATURE FONT</font>"}

			. = TOPIC_REFRESH

		if(href_list["edit_current"]) // Edit our current edit thing
			if(!current_edit)
				to_chat(usr, "ERROR: You're not editing a book.")
				return

			// Cheating? Maybe.
			current_edit = input(usr, "HTML content", "Write", current_edit) as message

			. = TOPIC_REFRESH

		if(href_list["submit_book"]) // Submit to the library
			if(!current_edit)
				to_chat(usr, "ERROR: You're not editing a book.")
				return

			if(!current_book) // Are we creating a new book?
				// Get our sanitized vars
				var/newbook_name = sanitizeSQL(input(usr, "Enter Book Title", "Title", "Untitled") as text|null)
				var/newbook_author = sanitizeSQL(input(usr, "Enter Author Name", "Author", "Anonymous") as text|null)
				var/newbook_category = sanitizeSQL(input(usr, "Choose Category") in categories)
				var/newbook_content = sanitizeSQL(current_edit)
				var/newbook_uploader = sanitizeSQL(usr.key)

				// Make sure we're submitting
				if(input(usr, "Submit [newbook_name] by [newbook_author] to the Library?") in list("Submit", "Cancel") != "Submit")
					return

				// Establish a database connection
				establish_old_db_connection()
				if(!dbcon_old.IsConnected())
					to_chat(usr, "ERROR: Could not connect to the library database.")
					return

				// Submit the book; books uploaded via the admin panel are auto-approved
				var/DBQuery/query = dbcon_old.NewQuery("INSERT INTO library (author, title, content, category, uploader, approved) VALUES ('[newbook_author]', '[newbook_name]', '[newbook_content]', '[newbook_category]', '[newbook_uploader]', 1)")
				if(!query.Execute())
					to_chat(usr, query.ErrorMsg())
					to_chat(usr, "ERROR: Could not upload to the library database.")
					return
				else
					log_and_message_staff("has uploaded the book titled [newbook_name], [length(newbook_content)] signs")
					log_game("[usr.name]/[usr.key] has uploaded the book titled [newbook_name], [length(newbook_content)] signs")
					alert("Upload Complete.")

			else // Nope, we're just editing one
				var/edit_content = sanitizeSQL(current_edit)
				var/sqlid = sanitizeSQL(current_book["id"])

				if(input(usr, "Submit your edit of "+current_book["title"]+" (USBN-[sqlid])?") in list("Submit", "Cancel") != "Submit")
					return

				// Establish a database connection
				establish_old_db_connection()
				if(!dbcon_old.IsConnected())
					to_chat(usr, "ERROR: Could not connect to the library database.")
					return

				// Submit the book; books uploaded via the admin panel are auto-approved
				var/DBQuery/query = dbcon_old.NewQuery("UPDATE library SET content=[edit_content] WHERE id=[sqlid]")
				if(!query.Execute())
					to_chat(usr, query.ErrorMsg())
					to_chat(usr, "ERROR: Could not upload to the library database.")
					return
				else
					log_and_message_staff("has edited the book titled "+current_book["title"])
					log_game("[usr.name]/[usr.key] has edited the book titled "+current_book["title"])
					alert("Edit Complete.")

			current_edit = null
			current_book = null
			. = TOPIC_REFRESH

