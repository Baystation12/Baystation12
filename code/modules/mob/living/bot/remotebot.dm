/mob/living/bot/remotebot
	name = "Remote-Bot"
	desc = "A remote controlled robot used by lazy people to switch channels and get pizza."
	icon_state = "fetchbot1"
	health = 15
	maxHealth = 15

	var/working = 0
	var/next_movement_time = 0
	var/speed = 10 //lower = better
	var/obj/item/holding = null
	var/obj/item/device/bot_controller/controller = null

/mob/living/bot/remotebot/movement_delay()
	var/tally = ..()
	tally += speed
	if(holding)
		tally += (2 * holding.w_class)
	return tally

/mob/living/bot/remotebot/examine(mob/user)
	..(user)
	if(holding)
		to_chat(user, "<span class='notice'>It is holding \the \icon[holding] [holding].</span>")

/mob/living/bot/remotebot/explode()
	on = 0
	new /obj/effect/decal/cleanable/blood/oil(get_turf(src.loc))
	visible_message("<span class='danger'>[src] blows apart!</span>")
	if(controller)
		controller.bot = null
		controller = null
	for(var/i in 1 to rand(3,5))
		var/obj/item/stack/material/cardboard/C = new(src.loc)
		if(prob(50))
			C.loc = get_step(src, pick(alldirs))

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/mob/living/bot/remotebot/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/device/bot_controller) && !controller)
		user.visible_message("\The [user] waves \the [I] over \the [src].")
		to_chat(user, "<span class='notice'>You link \the [src] to \the [I].</span>")
		var/obj/item/device/bot_controller/B = I
		B.bot = src
		controller = B
	return ..()

/mob/living/bot/remotebot/update_icons()
	icon_state = "fetchbot[on]"

/mob/living/bot/remotebot/Destroy()
	if(holding)
		holding.forceMove(loc)
		holding = null
	return ..()

/mob/living/bot/remotebot/proc/pickup(var/obj/item/I)
	if(holding || get_dist(src,I) > 1)
		return
	src.visible_message("<b>\The [src]</b> picks up \the [I].")
	flick("fetchbot-c", src)
	working = 1
	sleep(10)
	working = 0
	I.forceMove(src)
	holding = I

/mob/living/bot/remotebot/proc/drop()
	if(working || !holding)
		return
	holding.forceMove(loc)
	holding = null

/mob/living/bot/remotebot/proc/hit(var/atom/movable/a)
	src.visible_message("<b>\The [src]</b> taps \the [a] with its claw.")
	flick("fetchbot-c", src)
	working = 1
	sleep(10)
	working = 0

/mob/living/bot/remotebot/proc/command(var/atom/a)
	if(working || stat || !on || a == src) //can't touch itself
		return
	if(isturf(a) || get_dist(src,a) > 1)
		walk_to(src,a,0,movement_delay())
	else if(istype(a, /obj/item))
		pickup(a)
	else
		hit(a)

/obj/item/device/bot_controller
	name = "remote control"
	desc = "Used to control something remotely. Even has a tiny screen!"
	icon_state = "forensic1"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	item_state = "electronic"
	var/mob/living/bot/remotebot/bot

/obj/item/device/bot_controller/attack_self(var/mob/user)
	src.interact(user)

/obj/item/device/bot_controller/interact(var/mob/user)
	user.set_machine(src)
	if(!(src in user) || !bot)
		user << browse(null, "window=bot_controller")
		return
	var/dat = "<center><TT><b>Remote Control: [bot.name]</b></TT><br>"
	dat += "Currently Holding: [bot.holding ? bot.holding.name : "Nothing"]<br><br>"
	var/is_looking = (user.client.eye == bot)
	dat += "<a href='byond://?src=\ref[src];look=[is_looking];'>[is_looking ? "Stop" : "Start"] Looking</a><br>"
	dat += "<a href='byond://?src=\ref[src];drop=1;'>Drop Item</a><br></center>"

	user << browse(dat, "window=bot_controller")
	onclose(user, "botcontroller")

/obj/item/device/bot_controller/check_eye()
	return 0

/obj/item/device/bot_controller/Topic(href, href_list)
	..()
	if(!bot)
		return

	if(href_list["drop"])
		bot.drop()
	if(href_list["look"])
		if(href_list["look"] == "1")
			usr.reset_view(usr)
			usr.visible_message("\The [usr] looks up from \the [src]'s screen.")
		else
			usr.reset_view(bot)
			usr.visible_message("\The [usr] looks intently on \the [src]'s screen.")

	src.interact(usr)


/obj/item/device/bot_controller/dropped(var/mob/living/user)
	if(user.client.eye == bot)
		user.client.eye = user
	return ..()


/obj/item/device/bot_controller/afterattack(atom/A, mob/living/user)
	if(bot)
		bot.command(A)

/obj/item/device/bot_controller/Destroy()
	if(bot)
		bot.controller = null
		bot = null
	return ..()

/obj/item/device/bot_kit
	name = "Remote-Bot Kit"
	desc = "The cover says 'control your own cardboard nuclear powered robot. Comes with real plutonium!"
	icon = 'icons/obj/storage.dmi'
	icon_state = "remotebot"

/obj/item/device/bot_kit/attack_self(var/mob/living/user)
	to_chat(user, "You quickly dismantle the box and retrieve the controller and the remote bot itself.")
	var/turf/T = get_turf(src.loc)
	new /mob/living/bot/remotebot(T)
	new /obj/item/device/bot_controller(T)
	user.drop_from_inventory(src)
	qdel(src)