/* Library Items
 *
 * Contains:
 *		Bookcase
 *		Book
 */


/*
 * Bookcase
 */

/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/obj/library.dmi'
	icon_state = "book-0"
	anchored = TRUE
	density = TRUE
	opacity = 1
	obj_flags = OBJ_FLAG_ANCHORABLE


/obj/structure/bookcase/Initialize()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/book))
			I.forceMove(src)
	update_icon()
	. = ..()


/obj/structure/bookcase/use_tool(obj/item/tool, mob/user, list/click_params)
	// Book - Add book to shelf
	if (istype(tool, /obj/item/book))
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(tool, src)
			return TRUE
		update_icon()
		return TRUE

	// Pen - Title bookshelf
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "What would you like to title this bookshelf?", "Bookshelf Title") as null|text
		input = sanitizeSafe(input, MAX_NAME_LEN)
		if (!input || !user.use_sanity_check(src, tool))
			return TRUE
		SetName("[initial(name)] ([input])")
		user.visible_message(
			SPAN_NOTICE("\The [user] re-labels \the [src] with \a [tool]."),
			SPAN_NOTICE("You re-label \the [src] with \the [tool].")
		)
		return TRUE

	// Screwdriver - Dismantle bookshelf
	if (isScrewdriver(tool))
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] begins dismantling \the [src] with \a [tool]."),
			SPAN_NOTICE("You begin dismantling \the [src] with \a [tool].")
		)
		if (!user.do_skilled(2.5 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		var/obj/item/stack/material/wood/wood = new (loc, 5)
		transfer_fingerprints_to(wood)
		for (var/obj/item/book/book in contents)
			book.dropInto(loc)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \a [tool].")
		)
		qdel_self()
		return TRUE

	return ..()


/obj/structure/bookcase/attack_hand(mob/user as mob)
	if(length(contents))
		var/obj/item/book/choice = input("Which book would you like to remove from the shelf?") as null|obj in contents
		if(choice)
			if(!CanPhysicallyInteract(user))
				return
			if(ishuman(user))
				if(!user.get_active_hand())
					user.put_in_hands(choice)
			else
				choice.dropInto(loc)
			update_icon()


/obj/structure/bookcase/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			for(var/obj/item/book/b in contents)
				qdel(b)
			qdel(src)
			return
		if(EX_ACT_HEAVY)
			for(var/obj/item/book/b in contents)
				if (prob(50)) b.dropInto(loc)
				else qdel(b)
			qdel(src)
			return
		if(EX_ACT_LIGHT)
			if (prob(50))
				for(var/obj/item/book/b in contents)
					b.dropInto(loc)
				qdel(src)
			return
		else
	return


/obj/structure/bookcase/on_update_icon()
	if(length(contents) < 5)
		icon_state = "book-[length(contents)]"
	else
		icon_state = "book-5"


/obj/structure/bookcase/manuals/medical
	name = "Medical Manuals bookcase"

/obj/structure/bookcase/manuals/medical/New()
	..()
	new /obj/item/book/manual/medical_cloning(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/chemistry_recipes(src)
	update_icon()


/obj/structure/bookcase/manuals/engineering
	name = "Engineering Manuals bookcase"


/obj/structure/bookcase/manuals/engineering/New()
	..()
	new /obj/item/book/manual/engineering_construction(src)
	new /obj/item/book/manual/engineering_particle_accelerator(src)
	new /obj/item/book/manual/engineering_hacking(src)
	new /obj/item/book/manual/engineering_guide(src)
	new /obj/item/book/manual/atmospipes(src)
	new /obj/item/book/manual/engineering_singularity_safety(src)
	new /obj/item/book/manual/evaguide(src)
	new /obj/item/book/manual/rust_engine(src)
	update_icon()


/obj/structure/bookcase/manuals/research_and_development
	name = "R&D Manuals bookcase"


/obj/structure/bookcase/manuals/research_and_development/New()
	..()
	new /obj/item/book/manual/research_and_development(src)
	update_icon()


/*
 * Book
 */

/obj/item/book
	name = "book"
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL	//upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	/// Actual page content
	var/dat
	/// Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/author
	/// 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/unique = FALSE
	/// The real name of the book.
	var/title
	/// Has the book been hollowed out for use as a secret storage item?
	var/carved = 0
	/// What's in the book?
	var/obj/item/store


/obj/item/book/examine(mob/user, distance, is_adjacent)
	. = ..()

	if (title)
		to_chat(user, "It's titled, \"[title]\".<br/>")
	if (author)
		to_chat(user, "Written by, [author].<br/>")


/obj/item/book/attack_self(mob/user as mob)
	if(carved)
		if(!store)
			to_chat(user, SPAN_NOTICE("\The [src]'s pages are carved out.."))
			return
		to_chat(user, SPAN_NOTICE("[store] falls out of [title]!"))
		store.dropInto(loc)
		store = null
		return

	playsound(loc, "pageturn", 50, 1)

	if (istype(src, /obj/item/book/trinket))
		return

	if (!dat)
		to_chat(user, "This book is completely blank!")
		return

	show_browser(user, dat, "window=book;size=1000x550")
	playsound(loc, "pageturn", 50, 1)
	user.visible_message("[user] opens \a [src] titled \"[title]\" and begins reading intently.")
	onclose(user, "book")


/obj/item/book/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(carved)
		if(store)
			to_chat(user, SPAN_WARNING("There's already something in \the [src]!"))
			return TRUE
		if(W.w_class > ITEM_SIZE_SMALL)
			to_chat(user, SPAN_WARNING("\The [W] won't fit in \the [src]."))
			return TRUE
		if(!user.unEquip(W, src))
			FEEDBACK_UNEQUIP_FAILURE(user, W)
			return TRUE
		store = W
		to_chat(user, SPAN_NOTICE("You put \the [W] in \the [src]."))
		return TRUE

	else if(istype(W, /obj/item/pen))
		if(unique)
			FEEDBACK_FAILURE(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
			return TRUE
		var/choice = input("What would you like to change?") in list("Title", "Contents", "Author", "Cancel")
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(sanitizeSafe(input("Write a new title:")))
				if(!newtitle)
					FEEDBACK_FAILURE(user, "The title is invalid.")
					return TRUE
				else
					SetName(newtitle)
					title = newtitle
					return TRUE
			if("Contents")
				var/content = sanitize(input("Write your book's contents (HTML NOT allowed):") as message|null, MAX_BOOK_MESSAGE_LEN)
				if(!content)
					FEEDBACK_FAILURE(user, "The content is invalid.")
					return TRUE
				else
					dat += content
					return TRUE
			if("Author")
				var/newauthor = sanitize(input(usr, "Write the author's name:"))
				if(!newauthor)
					FEEDBACK_FAILURE(user, "The name is invalid.")
					return TRUE
				else
					author = newauthor
					return TRUE
			else
				return TRUE

	else if(istype(W, /obj/item/material/knife) || isWirecutter(W))
		if(carved)
			FEEDBACK_FAILURE(user, "\The [src] already has something carved in it.")
			return TRUE
		to_chat(user, SPAN_NOTICE("You begin to carve out \the [src]."))
		if(!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			return TRUE
		to_chat(user, SPAN_NOTICE("You carve out the pages from \the [src]! You didn't want to read it anyway."))
		carved = TRUE
		return TRUE

	return ..()


/obj/item/book/use_before(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	. = FALSE
	if (istype(M) && user.a_intent == I_HELP && user.zone_sel.selecting == BP_EYES)
		user.visible_message(SPAN_NOTICE("You open up the book and show it to [M]. "), \
			SPAN_NOTICE(" [user] opens up a book and shows it to [M]. "))
		show_browser(M, "<i>Author: [author].</i><br><br>" + "[dat]", "window=book;size=1000x550")
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam
		return TRUE


/*
 * Manual Base Object
 */

/obj/item/book/manual
	icon = 'icons/obj/library.dmi'
	unique = TRUE
	/// Using full url or just title, example - Standard_Operating_Procedure (https://wiki.baystation12.net/index.php?title=Standard_Operating_Procedure)
	var/url


/obj/item/book/manual/New()
	..()
	if(url)
		// If we haven't wikiurl or it included in url - just use url
		if(config.wiki_url && !findtextEx(url, config.wiki_url, 1, length(config.wiki_url)+1))
			// If we have wikiurl, but it hasn't "index.php" then add it and making full link in url
			if(config.wiki_url && !findtextEx(config.wiki_url, "/index.php", -10))
				if(findtextEx(config.wiki_url, "/", -1))
					url = config.wiki_url + "index.php?title=" + url
				else
					url = config.wiki_url + "/index.php?title=" + url
			else	//Or just making full link in url
				url = config.wiki_url + "?title=" + url
		dat = {"
			<html>
				<head>
				</head>
				<body>
					<iframe width='100%' height='100%' src="[url]&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>
			"}


/*
 * Loadout Trinket Object
 */

/obj/item/book/trinket
	name = "abstract book"

	abstract_type = /obj/item/book/trinket
	unique = TRUE

	/// Iterator for cover.
	var/i = 1
	var/bsprites
	var/base_sprite


/obj/item/book/trinket/verb/cover_change()
	set name = "Change Cover"
	set category = "Object"
	set src in usr

	if (usr.incapacitated())
		FEEDBACK_FAILURE(usr, "You can't do that.")
		return

	var/obj/item/book/trinket/book = usr.get_active_hand()
	if (!istype(book))
		book = usr.get_inactive_hand()
		if (!istype(book))
			FEEDBACK_FAILURE(usr, "You need to hold the [src] in your hands to do that.")
			return

	if (i == bsprites)
		icon_state = initial(icon_state)
		i = initial(i)
		update_icon()
		return

	icon_state = "[base_sprite][i++]"
	update_icon()


/obj/item/book/trinket/bound
	name = "custom book"
	desc = "A hard-bound book. The sky's your limit. Swap covers in-game. Custon name becomes the title in-game.."

	icon_state = "book1"
	base_sprite = "book"
	bsprites = 7


/obj/item/book/trinket/magazine
	name = "custom magazine"
	desc = "A magazine book. The sky's your limit. Swap covers in-game. Custon name becomes the title in-game.."

	icon_state = "magazine1"
	base_sprite = "magazine"
	bsprites = 1
