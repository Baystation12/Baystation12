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
	anchored = 1
	density = 1
	opacity = 1
	obj_flags = OBJ_FLAG_ANCHORABLE

/obj/structure/bookcase/Initialize()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/weapon/book))
			I.forceMove(src)
	update_icon()
	. = ..()

/obj/structure/bookcase/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/book))
		if(!user.unEquip(O, src))
			return
		update_icon()
	else if(istype(O, /obj/item/weapon/pen))
		var/newname = sanitizeSafe(input("What would you like to title this bookshelf?"), MAX_NAME_LEN)
		if(!newname)
			return
		else
			SetName("bookcase ([newname])")
	else if(isScrewdriver(O))
		playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
		to_chat(user, "<span class='notice'>You begin dismantling \the [src].</span>")
		if(do_after(user,25,src))
			to_chat(user, "<span class='notice'>You dismantle \the [src].</span>")
			new/obj/item/stack/material/wood(get_turf(src), 5)
			for(var/obj/item/weapon/book/b in contents)
				b.dropInto(loc)
			qdel(src)

	else
		..()
	return

/obj/structure/bookcase/attack_hand(var/mob/user as mob)
	if(contents.len)
		var/obj/item/weapon/book/choice = input("Which book would you like to remove from the shelf?") as null|obj in contents
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
		if(1.0)
			for(var/obj/item/weapon/book/b in contents)
				qdel(b)
			qdel(src)
			return
		if(2.0)
			for(var/obj/item/weapon/book/b in contents)
				if (prob(50)) b.dropInto(loc)
				else qdel(b)
			qdel(src)
			return
		if(3.0)
			if (prob(50))
				for(var/obj/item/weapon/book/b in contents)
					b.dropInto(loc)
				qdel(src)
			return
		else
	return

/obj/structure/bookcase/on_update_icon()
	if(contents.len < 5)
		icon_state = "book-[contents.len]"
	else
		icon_state = "book-5"



/obj/structure/bookcase/manuals/medical
	name = "Medical Manuals bookcase"

	New()
		..()
		new /obj/item/weapon/book/manual/medical_cloning(src)
		new /obj/item/weapon/book/manual/medical_diagnostics_manual(src)
		new /obj/item/weapon/book/manual/medical_diagnostics_manual(src)
		new /obj/item/weapon/book/manual/medical_diagnostics_manual(src)
		new /obj/item/weapon/book/manual/chemistry_recipes(src)
		update_icon()


/obj/structure/bookcase/manuals/engineering
	name = "Engineering Manuals bookcase"

	New()
		..()
		new /obj/item/weapon/book/manual/engineering_construction(src)
		new /obj/item/weapon/book/manual/engineering_particle_accelerator(src)
		new /obj/item/weapon/book/manual/engineering_hacking(src)
		new /obj/item/weapon/book/manual/engineering_guide(src)
		new /obj/item/weapon/book/manual/atmospipes(src)
		new /obj/item/weapon/book/manual/engineering_singularity_safety(src)
		new /obj/item/weapon/book/manual/evaguide(src)
		new /obj/item/weapon/book/manual/rust_engine(src)
		update_icon()

/obj/structure/bookcase/manuals/research_and_development
	name = "R&D Manuals bookcase"

	New()
		..()
		new /obj/item/weapon/book/manual/research_and_development(src)
		update_icon()


/*
 * Book
 */
/obj/item/weapon/book
	name = "book"
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	var/dat			 // Actual page content
	var/author		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/unique = 0   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title		 // The real name of the book.
	var/carved = 0	 // Has the book been hollowed out for use as a secret storage item?
	var/obj/item/store	//What's in the book?

/obj/item/weapon/book/attack_self(var/mob/user as mob)
	if(carved)
		if(store)
			to_chat(user, "<span class='notice'>[store] falls out of [title]!</span>")
			store.dropInto(loc)
			store = null
			return
		else
			to_chat(user, "<span class='notice'>The pages of [title] have been cut out!</span>")
			return
	if(src.dat)
		user << browse(dat, "window=book;size=1000x550")
		user.visible_message("[user] opens a book titled \"[src.title]\" and begins reading intently.")
		onclose(user, "book")
	else
		to_chat(user, "This book is completely blank!")

/obj/item/weapon/book/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(carved == 1)
		if(!store)
			if(W.w_class < ITEM_SIZE_NORMAL)
				if(!user.unEquip(W, src))
					return
				store = W
				to_chat(user, "<span class='notice'>You put [W] in [title].</span>")
				return
			else
				to_chat(user, "<span class='notice'>[W] won't fit in [title].</span>")
				return
		else
			to_chat(user, "<span class='notice'>There's already something in [title]!</span>")
			return
	if(istype(W, /obj/item/weapon/pen))
		if(unique)
			to_chat(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
			return
		var/choice = input("What would you like to change?") in list("Title", "Contents", "Author", "Cancel")
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(sanitizeSafe(input("Write a new title:")))
				if(!newtitle)
					to_chat(usr, "The title is invalid.")
					return
				else
					src.SetName(newtitle)
					src.title = newtitle
			if("Contents")
				var/content = sanitize(input("Write your book's contents (HTML NOT allowed):") as message|null, MAX_BOOK_MESSAGE_LEN)
				if(!content)
					to_chat(usr, "The content is invalid.")
					return
				else
					src.dat += content
			if("Author")
				var/newauthor = sanitize(input(usr, "Write the author's name:"))
				if(!newauthor)
					to_chat(usr, "The name is invalid.")
					return
				else
					src.author = newauthor
			else
				return
	else if(istype(W, /obj/item/weapon/material/knife) || isWirecutter(W))
		if(carved)	return
		to_chat(user, "<span class='notice'>You begin to carve out [title].</span>")
		if(do_after(user, 30, src))
			to_chat(user, "<span class='notice'>You carve out the pages from [title]! You didn't want to read it anyway.</span>")
			carved = 1
			return
	else
		..()

/obj/item/weapon/book/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_sel.selecting == BP_EYES)
		user.visible_message("<span class='notice'>You open up the book and show it to [M]. </span>", \
			"<span class='notice'> [user] opens up a book and shows it to [M]. </span>")
		M << browse("<i>Author: [author].</i><br><br>" + "[dat]", "window=book;size=1000x550")
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

/*
 * Manual Base Object
 */
/obj/item/weapon/book/manual
	icon = 'icons/obj/library.dmi'
	unique = 1   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/url // Using full url or just tittle, example - Standard_Operating_Procedure (https://wiki.baystation12.net/index.php?title=Standard_Operating_Procedure)

/obj/item/weapon/book/manual/New()
	..()
	if(url)		// URL provided for this manual
		// If we haven't wikiurl or it included in url - just use url
		if(config.wikiurl && !findtextEx(url, config.wikiurl, 1, length(config.wikiurl)+1))
			// If we have wikiurl, but it hasn't "index.php" then add it and making full link in url
			if(config.wikiurl && !findtextEx(config.wikiurl, "/index.php", -10))
				if(findtextEx(config.wikiurl, "/", -1))
					url = config.wikiurl + "index.php?title=" + url
				else
					url = config.wikiurl + "/index.php?title=" + url
			else	//Or just making full link in url
				url = config.wikiurl + "?title=" + url
		dat = {"
			<html>
				<head>
				</head>
				<body>
					<iframe width='100%' height='100%' src="[url]&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>
			"}
