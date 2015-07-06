/obj/machinery/beehive
	name = "beehive"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beehive"
	density = 1
	anchored = 1

	var/closed = 0
	var/bee_count = 0 // Percentage
	var/smoked = 0
	var/honeycombs = 0
	var/frames = 0
	var/maxFrames = 5

/obj/machinery/beehive/update_icon()
	overlays.Cut()
	icon_state = "beehive"
	if(honeycombs >= 1)
		overlays += "filled[round(honeycombs)]"
	if(frames)
		overlays += "empty[frames]"

/obj/machinery/beehive/examine(var/mob/user)
	..()
	if(!closed)
		user << "The lid is open."

/obj/machinery/beehive/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/crowbar))
		closed = !closed
		user.visible_message("<span class='notice'>[user] [closed ? "closes" : "opens"] \the [src].</span>", "<span class='notice'>You [closed ? "close" : "open"] \the [src]")
		return
	else if(istype(I, /obj/item/weapon/wrench))
		anchored = !anchored
		user.visible_message("<span class='notice'>[user] [anchored ? "wrenches" : "unwrenches"] \the [src].</span>", "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src]")
		return
	else if(istype(I, /obj/item/bee_smoker))
		if(closed)
			user << "<span class='notice'>You need to open \the [src] with a crowbar before smoking the bees.</span>"
			return
		user.visible_message("<span class='notice'>[user] smokes the bees in \the [src].</span>", "<span class='notice'>You smoke the bees in \the [src].</span>")
		smoked = 30
		return
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
		update_icon()
		user.drop_from_inventory(I)
		qdel(I)
		return
	else if(istype(I, /obj/item/bee_pack))
		if(bee_count)
			user << "<span class='notice'>\The [src] already has bees inside.</span>"
			return
		if(closed)
			user << "<span class='notice'>You need to open \the [src] with a crowbar before putting the bees inside.</span>"
			return
		user.visible_message("<span class='notice'>[user] puts \the [I] into \the [src].</span>", "<span class='notice'>You put \the [I] into \the [src].</span>")
		bee_count = 20
		user.drop_from_inventory(I)
		qdel(I)
		return
	else if(istype(I, /obj/item/device/analyzer/plant_analyzer))
		user << "<span class='notice'>[src] scan result...</span>"
		user << "Beehive is [bee_count ? "[bee_count]% full" : "empty"]."
		user << "There are [frames ? frames : "no"] frames installed."
		return 1

/obj/machinery/beehive/attack_hand(var/mob/user)
	if(!closed)
		if(honeycombs < 1)
			user << "<span class='notice'>There are no filled honeycombs.</span>"
			return
		if(!smoked && bee_count)
			user << "<span class='notice'>The bees won't let you take the honeycombs out like this, smoke them first.</span>"
			return
		user.visible_message("<span class='notice'>[user] starts taking the honeycombs out of \the [src].", "<span class='notice'>You start taking the honeycombs out of \the [src]...")
		while(honeycombs >= 1 && do_after(user, 30))
			new /obj/item/honey_frame/filled(loc)
			--honeycombs
			--frames
			update_icon()
		if(honeycombs < 1)
			user << "<span class='notice'>You take all filled honeycombs out.</span>"
		return

/obj/machinery/beehive/process()
	if(closed && !smoked && bee_count)
		pollinate_flowers()
		update_icon()
	smoked = max(0, smoked - 1)
	if(!smoked && bee_count)
		bee_count = min(bee_count + 1, 100)

/obj/machinery/beehive/proc/pollinate_flowers()
	var/coef = bee_count / 100
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(7, src))
		if(H.seed && !H.dead)
			H.health += 0.05 * coef
			honeycombs = min(honeycombs + 0.01 * coef, frames)

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
		icon_state = "centrifuge_moving"
		qdel(H)
		spawn(50)
			new /obj/item/honey_frame(loc)
			new /obj/item/stack/wax(loc)
			honey += processing
			processing = 0
			icon_state = "centrifuge"
	else if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(!honey)
			user << "<span class='notice'>There is no honey in \the [src].</span>"
			return
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
	user.visible_message("<span class='notice'>[user] constructs a beehive.</span>", "<span class='notice'>You construct a beehive.</span>")
	new /obj/machinery/beehive(get_turf(user))
	user.drop_from_inventory(src)
	qdel(src)

/obj/item/stack/wax
	name = "wax"
	desc = "Soft substance produced by bees. Used to make candles."
	icon_state = "sheet-metal"

/obj/item/stack/wax/New()
	..()
	recipes = wax_recipes

var/global/list/datum/stack_recipe/wax_recipes = list( \
	new/datum/stack_recipe("candle", /obj/item/weapon/flame/candle) \
)

/obj/item/bee_pack
	name = "bee pack"
	desc = "Contains a queen bee and some worker bees. Everything you'll need to start a hive!"
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"
