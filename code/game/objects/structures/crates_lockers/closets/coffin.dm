/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon = 'icons/obj/closets/coffin.dmi'
	setup = 0
	closet_appearance = null

	var/screwed_shut = 0
	var/screwdriver_time_needed = 75

obj/structure/closet/coffin/can_open()
	. =  ..()
	if(screwed_shut)
		return 0

obj/structure/closet/coffin/attackby(obj/item/W as obj, mob/user as mob)
	if(!src.opened && isScrewdriver(W))
		to_chat(user, "<span class='notice'>You begin screwing [src]'s lid [screwed_shut ? "open" : "shut"].</span>")
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		if(do_after(user, screwdriver_time_needed, src))
			screwed_shut = !screwed_shut
			to_chat(user, "<span class='notice'>You [screwed_shut ? "screw down" : "unscrew"] [src]'s lid.</span>")
	else
		..()

/obj/structure/closet/coffin/req_breakout()
	. = ..()
	if(screwed_shut)
		return 1
	

obj/structure/closet/coffin/break_open()
	screwed_shut = 0
	..()
	
/obj/structure/closet/coffin/wooden
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon = 'icons/obj/closets/coffin_wood.dmi'
	setup = 0
	closet_appearance = null
