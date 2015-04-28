/obj/machinery/beehive
	name = "beehive"
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"
	density = 1
	anchored = 1

	var/closed = 0
	var/bee_count = 0 // A real hive has 20k - 80k bees... we tone it down
	var/smoked = 0
	var/honeycombs = 0
	var/frames = 0
	var/maxFrames = 5

/obj/machinery/beehive/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/crowbar))
		closed = !closed
		user.visible_message("<span class='notice'>[user] [closed ? "closes" : "opens"] \the [src].</span>", "<span class='notice'>You [closed ? "close" : "open"] \the [src]")
	else if(istype(I, /obj/item/weapon/wrench))
		anchored = !anchored
		user.visible_message("<span class='notice'>[user] [closed ? "wrenches" : "unwrenches"] \the [src].</span>", "<span class='notice'>You [closed ? "wrench" : "unwrench"] \the [src]")
	else if(istype(I, /obj/item/bee_smoker))
		if(!closed)
			user << "<span class='notice'>You need to open \the [src] with a crowbar before smoking the bees.</span>"
			return
		user.visible_message("<span class='notice'>[user] smokes the bees in \the [src].</span>", "<span class='notice'>You smoke the bees in \the [src].</span>")
		smoked = 30
	else if(istype(I, /obj/item/honey_frame))
		if(closed)
			user << "<span class='notice'>You need to open \the [src] with a crowbar before inserting \the [I].</span>"
			return
		if(frames >= maxFrames)
			user << "<span class='notice'>There is no place for an another frame.</span>"
			return
		var/obj/item/honey_frame/H = I
		if(H.honey)
			user << "<span class='notice'>\The [I] is full with beeswax and honey, empty it in the extractor first.</span>"
			return
		++frames
		user.visible_message("<span class='notice'>[user] loads \the [I] into \the [src].</span>", "<span class='notice'>You load \the [I] into \the [src].</span>")
		qdel(I)

/obj/machinery/beehive/attack_hand(var/mob/user)
	if(!closed)
		if(honeycombs < 1)
			user << "<span class='notice'>There are no filled honeycombs.</span>"
			return
		user.visible_message("<span class='notice'>[user] starts taking the honeycombs out of \the [src].", "<span class='notice'>You start taking the honeycombs out of \the [src]...")
		while(honeycombs > 1 && do_after(user, 30))
			new /obj/item/honey_frame/filled(loc)
			--honeycombs
			--frames
		user << "<span class='notice'>You take all filled honeycombs out.</span>"

/obj/machinery/beehive/process()
	if(closed && !smoked)
		pollinate_flowers()
	smoked = max(0, smoked - 1)

/obj/machinery/beehive/proc/pollinate_flowers()
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(7, src))
		if(H.seed && !H.dead)
			H.health += 0.05
			honeycombs = max(honeycombs + 0.01, frames) // 100/tray amount ticks per frame, each 20 units of honey

/obj/machinery/honey_extractor
	name = "honey extractor"
	desc = "A machine used to turn honeycombs on the frame into honey and wax."
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"

	var/processing = 0
	var/honey = 0

/obj/machinery/honey_extractor/attackby(var/obj/item/I, var/mob/user)
	if(processing)
		user << "<span class='notice'>\The [src] is currently spinning, wait until it's finished.</span>"
		return
	else if(istype(I, /obj/item/honey_frame))
		var/obj/item/honey_frame/H = I
		if(!H.honey)
			user << "<span class='notice'>\The [H] is empty, put it into a beehive.</span>"
			return
		user.visible_message("<span class='notice'>[user] loads \the [H] into \the [src] and turns it on.</span>", "<span class='notice'>You load \the [H] into \the [src] and turn it on.</span>")
		processing = H.honey
		qdel(H)
		spawn(50)
			new /obj/item/honey_frame(loc)
			//new /obj/item/stack/wax(loc)
			honey += processing
			processing = 0
	else if(istype(I, /obj/item/weapon/reagent_containers/glass))
		var/obj/item/weapon/reagent_containers/glass/G = I
		var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, honey)
		G.reagents.add_reagent("honey", transferred)
		honey -= transferred
		user.visible_message("<span class='notice'>[user] collects honey from \the [src] into \the [G].</span>", "<span class='notice'>You collect [transferred] units of honey from \the [src] into the [G].</span>")
		return 1

/obj/item/bee_smoker
	name = "bee smoker"
	desc = "A device used to calm down bees before harvesting honey."
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"
	w_class = 2

/obj/item/honey_frame
	name = "beehive frame"
	desc = "A frame for the beehive that the bees will fill with honeycombs."
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"
	w_class = 2

	var/honey = 0

/obj/item/honey_frame/filled
	name = "filled beehive frame"
	desc = "A frame for the beehive that the bees have filled with honeycombs."
	honey = 20

/obj/item/beehive_assembly
	name = "beehive assembly"
	desc = "Contains everything you need to build a beehive. Cannot be disassembled once deployed."
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"

/obj/item/beehive_assembly/attack_self(var/mob/user)
	new /obj/machinery/beehive(get_turf(user))
	qdel(src)

/obj/item/bee_pack
	name = "bee pack"
	desc = "A stasis-pack that contains a queen bee and some workers. Put it into the beehive to wake them up."	