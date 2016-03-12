/obj/item/weapon/board
	name = "board"
	desc = "A standard 12' checkerboard. Well used."
	icon = 'icons/obj/pieces.dmi'
	icon_state = "board"

	var/num = 0
	var/board_icons = list()
	var/board = list()
	var/selected = -1

/obj/item/weapon/board/New()
	..()
	var i
	for(i = 0; i < 12; i++)
		new /obj/item/weapon/checker(src.loc)
		new /obj/item/weapon/checker/red(src.loc)

/obj/item/weapon/board/examine(mob/user, var/distance = -1)
	if(in_range(user,src))
		user.set_machine(src)
		interact(user)
		return
	..()

/obj/item/weapon/board/attack_hand(mob/living/carbon/human/M as mob)
	if(M.machine == src)
		..()
	else
		src.examine(M)

obj/item/weapon/board/attackby(obj/item/I as obj, mob/user as mob)
	if(!addPiece(I,user))
		..()

/obj/item/weapon/board/proc/addPiece(obj/item/I as obj, mob/user as mob, var/tile = 0)
	if(I.w_class != 1) //only small stuff
		user.show_message("<span class='warning'>\The [I] is too big to be used as a board piece.</span>")
		return 0
	if(num == 64)
		user.show_message("<span class='warning'>\The [src] is already full!</span>")
		return 0
	if(tile > 0 && board["[tile]"])
		user.show_message("<span class='warning'>That space is already filled!</span>")
		return 0
	if(!user.Adjacent(src))
		return 0

	user.drop_from_inventory(I)
	I.forceMove(src)
	num++


	if(!board_icons["[I.icon] [I.icon_state]"])
		board_icons["[I.icon] [I.icon_state]"] = new /icon(I.icon,I.icon_state)

	if(tile == 0)
		var i;
		for(i=0;i<64;i++)
			if(!board["[i]"])
				board["[i]"] = I
				break
	else
		board["[tile]"] = I

	src.updateDialog()

	return 1


/obj/item/weapon/board/interact(mob/user as mob)
	if(user.is_physically_disabled() || (!isAI(user) && !user.Adjacent(src))) //can't see if you arent conscious. If you are not an AI you can't see it unless you are next to it, either.
		user << browse(null, "window=boardgame")
		user.unset_machine()
		return

	var/dat = "<HTML>"
	dat += "<table border='0'>"
	var i, stagger
	stagger = 0 //so we can have the checkerboard effect
	for(i=0, i<64, i++)
		if(i%8 == 0)
			dat += "<tr>"
			stagger = !stagger
		dat += "<td align='center' height='50' width='50' bgcolor="
		if(selected == i)
			dat += "'#FF8566'>"
		else if((i + stagger)%2 == 0)
			dat += "'#66CCFF'>"
		else
			dat += "'#252536'>"
		if(!isobserver(user))
			dat += "<A href='?src=\ref[src];select=[i];person=\ref[user]' style='display:block;text-decoration:none;'>"
		if(board["[i]"])
			var/obj/item/I = board["[i]"]
			user << browse_rsc(board_icons["[I.icon] [I.icon_state]"],"[I.icon_state].png")
			dat += "<image src='[I.icon_state].png' style='border-style: none'>"
		else
			dat += "&nbsp;"

		if(!isobserver(user))
			dat += "</A>"
		dat += "</td>"

	dat += "</table><br>"

	if(selected >= 0 && !isobserver(user))
		dat += "<br><A href='?src=\ref[src];remove=0'>Remove Selected Piece</A>"
	user << browse(dat,"window=boardgame;size=500x500")
	onclose(usr, "boardgame")

/obj/item/weapon/board/Topic(href, href_list)
	if(!usr.Adjacent(src))
		usr.unset_machine()
		usr << browse(null, "window=boardgame")
		return

	if(!usr.incapacitated()) //you can't move pieces if you can't move
		if(href_list["select"])
			var/s = href_list["select"]
			var/obj/item/I = board["[s]"]
			if(selected >= 0)
				//check to see if clicked on tile is currently selected one
				if(text2num(s) == selected)
					selected = 0 //deselect it
					return

				if(I) //cant put items on other items.
					return

			//put item in new spot.
				I = board["[selected]"]
				board["[selected]"] = null
				board -= "[selected]"
				board -= null
				board["[s]"] = I
				selected = -1
			else
				if(I)
					selected = text2num(s)
				else
					var/mob/living/carbon/human/H = locate(href_list["person"])
					if(!istype(H))
						return
					var/obj/item/O = H.get_active_hand()
					if(!O)
						return
					addPiece(O,H,text2num(s))
		if(href_list["remove"])
			var/obj/item/I = board["[selected]"]
			board["[selected]"] = null
			board -= "[selected]"
			board -= null
			I.forceMove(src.loc)
			num--
			selected = -1
			var j
			for(j=0;j<64;j++)
				if(board["[j]"])
					var/obj/item/K = board["[j]"]
					if(K.icon == I.icon && cmptext(K.icon_state,I.icon_state))
						src.updateDialog()
						return
			//Didn't find it in use, remove it and allow GC to delete it.
			board_icons["[I.icon] [I.icon_state]"] = null
			board_icons -= "[I.icon] [I.icon_state]"
			board_icons -= null
	src.updateDialog()

/obj/item/weapon/checker/
	name = "black checker"
	desc = "It is plastic and shiny."
	icon = 'icons/obj/pieces.dmi'
	icon_state = "checker_black"
	w_class = 1

/obj/item/weapon/checker/red
	name = "red checker"
	icon_state = "checker_red"
