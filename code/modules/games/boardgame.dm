/obj/item/board
	name = "board"
	desc = "A standard 16\" checkerboard. Well used." //Goddamn imperial system.
	icon = 'icons/obj/pieces.dmi'
	icon_state = "board"

	var/num = 0
	var/board_icons = list()
	var/board = list()
	var/selected = -1

/obj/item/board/ShiftClick(mob/user)
	if(CanPhysicallyInteract(user))
		user.set_machine(src)
		interact(user)
	else
		..()

/obj/item/board/attack_hand(mob/living/carbon/human/M as mob)
	if(M.machine == src)
		return ..()
	else
		M.examinate(src)

/obj/item/board/attackby(obj/item/I as obj, mob/user as mob)
	if(!addPiece(I,user))
		..()

/obj/item/board/proc/addPiece(obj/item/I as obj, mob/user as mob, var/tile = 0)
	if(I.w_class != ITEM_SIZE_TINY) //only small stuff
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
	if(!user.unEquip(I, src))
		return 0
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


/obj/item/board/interact(mob/user as mob)
	if(user.is_physically_disabled() || (!isAI(user) && !user.Adjacent(src))) //can't see if you arent conscious. If you are not an AI you can't see it unless you are next to it, either.
		close_browser(user, "window=boardgame")
		user.unset_machine()
		return

	var/list/dat = list({"
	<html><head><style type='text/css'>
	td,td a{height:50px;width:50px}table{border-spacing:0;border:none;border-collapse:collapse}td{text-align:center;padding:0;background-repeat:no-repeat;background-position:center center}td.light{background-color:#6cf}td.dark{background-color:#544b50}td.selected{background-color:#c8dbc3}td a{display:table-cell;text-decoration:none;position:relative;line-height:50px;height:50px;width:50 px;vertical-align:middle}
	</style></head><body><table>
	"})
	var i, stagger
	stagger = 0 //so we can have the checkerboard effect
	for(i=0, i<64, i++)
		if(i%8 == 0)
			dat += "<tr>"
			stagger = !stagger
		if(selected == i)
			dat += "<td class='selected'"
		else if((i + stagger)%2 == 0)
			dat += "<td class='dark'"
		else
			dat += "<td class='light'"

		if(board["[i]"])
			var/obj/item/I = board["[i]"]
			send_rsc(user, board_icons["[I.icon] [I.icon_state]"],"[I.icon_state].png")
			dat += " style='background-image:url([I.icon_state].png)'>"
		else
			dat+= ">"
		if(!isobserver(user))
			dat += "<a href='?src=\ref[src];select=[i];person=\ref[user]'></a>"
		dat += "</td>"

	dat += "</table>"

	if(selected >= 0 && !isobserver(user))
		dat += "<br><A href='?src=\ref[src];remove=0'>Remove Selected Piece</A>"
	show_browser(user, jointext(dat, null),"window=boardgame;size=430x500") // 50px * 8 squares + 30 margin
	onclose(usr, "boardgame")

/obj/item/board/Topic(href, href_list)
	if(!usr.Adjacent(src))
		usr.unset_machine()
		close_browser(usr, "window=boardgame")
		return

	if(!usr.incapacitated()) //you can't move pieces if you can't move
		if(href_list["select"])
			var/s = href_list["select"]
			var/obj/item/I = board["[s]"]
			if(selected >= 0)
				//check to see if clicked on tile is currently selected one
				if(text2num(s) == selected)
					selected = -1 //deselect it
				else

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
			if(!I)
				return
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

//Checkers

/obj/item/reagent_containers/food/snacks/checker
	name = "checker"
	desc = "It is plastic and shiny."
	icon = 'icons/obj/pieces.dmi'
	icon_state = "checker_black"
	w_class = ITEM_SIZE_TINY
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("a choking hazard" = 4)
	nutriment_amt = 1
	var/piece_color ="black"

/obj/item/reagent_containers/food/snacks/checker/New()
	..()
	icon_state = "[name]_[piece_color]"
	name = "[piece_color] [name]"

/obj/item/reagent_containers/food/snacks/checker/red
	piece_color ="red"

//Chess

/obj/item/reagent_containers/food/snacks/checker/pawn
	name = "pawn"
	desc = "How many pawns will die in your war?"

/obj/item/reagent_containers/food/snacks/checker/pawn/red
	piece_color ="red"

/obj/item/reagent_containers/food/snacks/checker/knight
	name = "knight"
	desc = "The piece chess deserves, and needs to actually play."

/obj/item/reagent_containers/food/snacks/checker/knight/red
	piece_color ="red"

/obj/item/reagent_containers/food/snacks/checker/bishop
	name = "bishop"
	desc = "What corruption occured, urging holy men to fight?"

/obj/item/reagent_containers/food/snacks/checker/bishop/red
	piece_color ="red"

/obj/item/reagent_containers/food/snacks/checker/rook
	name = "rook"
	desc = "Representing ancient moving towers. So powerful and fast they were banned from wars, forever."

/obj/item/reagent_containers/food/snacks/checker/rook/red
	piece_color ="red"

/obj/item/reagent_containers/food/snacks/checker/queen
	name = "queen"
	desc = "A queen of battle and pain. She dances across the battlefield."

/obj/item/reagent_containers/food/snacks/checker/queen/red
	piece_color ="red"

/obj/item/reagent_containers/food/snacks/checker/king
	name = "king"
	desc = "Why does a chess game end when the king dies?"

/obj/item/reagent_containers/food/snacks/checker/king/red
	piece_color ="red"