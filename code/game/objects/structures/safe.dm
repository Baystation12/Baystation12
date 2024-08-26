/*
CONTAINS:
SAFES
FLOOR SAFES
*/

//SAFES
/obj/structure/safe
	name = "safe"
	desc = "A huge chunk of metal with a dial embedded in it. Fine print on the dial reads \"Scarborough Arms - 2 tumbler safe, guaranteed thermite resistant, explosion resistant, and assistant resistant.\"."
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "safe"
	anchored = TRUE
	density = TRUE
	var/open = 0		//is the safe open?
	var/tumbler_1_pos	//the tumbler position- from 0 to 72
	var/tumbler_1_open	//the tumbler position to open at- 0 to 72
	var/tumbler_2_pos
	var/tumbler_2_open
	var/dial = 0		//where is the dial pointing?
	var/space = 0		//the combined w_class of everything in the safe
	var/maxspace = 24	//the maximum combined w_class of stuff in the safe

/obj/structure/safe/Initialize()
	for(var/obj/item/I in loc)
		if(space >= maxspace)
			return
		if(I.w_class + space <= maxspace) //todo replace with internal storage or something
			space += I.w_class
			I.forceMove(src)
	. = ..()
	tumbler_1_pos = rand(0, 72)
	tumbler_1_open = rand(0, 72)

	tumbler_2_pos = rand(0, 72)
	tumbler_2_open = rand(0, 72)

/obj/structure/safe/proc/check_unlocked(mob/user as mob, canhear)
	if(user && canhear)
		if(tumbler_1_pos == tumbler_1_open)
			to_chat(user, SPAN_NOTICE("You hear a [pick("tonk", "krunk", "plunk")] from [src]."))
		if(tumbler_2_pos == tumbler_2_open)
			to_chat(user, SPAN_NOTICE("You hear a [pick("tink", "krink", "plink")] from [src]."))
	if(tumbler_1_pos == tumbler_1_open && tumbler_2_pos == tumbler_2_open)
		if(user) visible_message("<b>[pick("Spring", "Sprang", "Sproing", "Clunk", "Krunk")]!</b>")
		return 1
	return 0


/obj/structure/safe/proc/decrement(num)
	num -= 1
	if(num < 0)
		num = 71
	return num


/obj/structure/safe/proc/increment(num)
	num += 1
	if(num > 71)
		num = 0
	return num


/obj/structure/safe/on_update_icon()
	if(open)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)


/obj/structure/safe/attack_hand(mob/user as mob)
	user.set_machine(src)
	var/dat = "<center>"
	dat += "<a href='?src=\ref[src];open=1'>[open ? "Close" : "Open"] [src]</a> | <a href='?src=\ref[src];decrement=1'>-</a> [dial * 5] <a href='?src=\ref[src];increment=1'>+</a>"
	if(open)
		dat += "<table>"
		for(var/i = length(contents), i>=1, i--)
			var/obj/item/P = contents[i]
			dat += "<tr><td><a href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
		dat += "</table></center>"
	show_browser(user, "<html><head><meta charset='utf-8'><meta charset='utf-8'><title>[name]</title></head><body>[dat]</body></html>", "window=safe;size=350x300")


/obj/structure/safe/Topic(href, href_list)
	if(!ishuman(usr))	return
	var/mob/living/carbon/human/user = usr

	var/canhear = 0
	if (user.IsHolding(/obj/item/clothing/accessory/stethoscope))
		canhear = 1

	if(href_list["open"])
		if(check_unlocked())
			to_chat(user, SPAN_NOTICE("You [open ? "close" : "open"] [src]."))
			open = !open
			update_icon()
			updateUsrDialog()
			return
		else
			to_chat(user, SPAN_NOTICE("You can't [open ? "close" : "open"] [src], the lock is engaged!"))
			return

	if(href_list["decrement"])
		dial = decrement(dial)
		if(dial == tumbler_1_pos + 1 || dial == tumbler_1_pos - 71)
			tumbler_1_pos = decrement(tumbler_1_pos)
			if(canhear)
				to_chat(user, SPAN_NOTICE("You hear a [pick("clack", "scrape", "clank")] from [src]."))
			if(tumbler_1_pos == tumbler_2_pos + 37 || tumbler_1_pos == tumbler_2_pos - 35)
				tumbler_2_pos = decrement(tumbler_2_pos)
				if(canhear)
					to_chat(user, SPAN_NOTICE("You hear a [pick("click", "chink", "clink")] from [src]."))
			check_unlocked(user, canhear)
		updateUsrDialog()
		return

	if(href_list["increment"])
		dial = increment(dial)
		if(dial == tumbler_1_pos - 1 || dial == tumbler_1_pos + 71)
			tumbler_1_pos = increment(tumbler_1_pos)
			if(canhear)
				to_chat(user, SPAN_NOTICE("You hear a [pick("clack", "scrape", "clank")] from [src]."))
			if(tumbler_1_pos == tumbler_2_pos - 37 || tumbler_1_pos == tumbler_2_pos + 35)
				tumbler_2_pos = increment(tumbler_2_pos)
				if(canhear)
					to_chat(user, SPAN_NOTICE("You hear a [pick("click", "chink", "clink")] from [src]."))
			check_unlocked(user, canhear)
		updateUsrDialog()
		return

	if(href_list["retrieve"])
		show_browser(user, "", "window=safe") // Close the menu

		var/obj/item/P = locate(href_list["retrieve"]) in src
		if(open)
			if(P && in_range(src, user))
				user.put_in_hands(P)
				updateUsrDialog()


/obj/structure/safe/use_tool(obj/item/tool, mob/user, list/click_params)
	// If open - Insert item
	if (open)
		if (tool.w_class + space >= maxspace)
			USE_FEEDBACK_FAILURE("\The [src] doesn't have enough space for \the [tool].")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		space += tool.w_class
		updateUsrDialog()
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] in \the [src]."),
			SPAN_NOTICE("You put \the [tool] in \the [src]."),
			range = 2
		)
		return TRUE

	// Stethoscope - Cracking tip
	if (istype(tool, /obj/item/clothing/accessory/stethoscope))
		to_chat(user, SPAN_INFO("Hold \the [tool] in one of your hands while you manipulate the dial to help with cracking the code."))
		return TRUE

	return ..()


/obj/structure/safe/ex_act(severity)
	return

//FLOOR SAFES
/obj/structure/safe/floor
	name = "floor safe"
	icon_state = "floorsafe"
	density = FALSE
	level = ATOM_LEVEL_UNDER_TILE
	layer = BELOW_OBJ_LAYER

/obj/structure/safe/floor/Initialize()
	. = ..()
	var/turf/T = loc
	if(istype(T) && !T.is_plating())
		hide(1)
	update_icon()

/obj/structure/safe/floor/hide(intact)
	set_invisibility(intact ? INVISIBILITY_ABSTRACT : 0)

/obj/structure/safe/floor/hides_under_flooring()
	return 1
