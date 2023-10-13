/mob/living/bot/remotebot
	name = "Remote-Bot"
	desc = "A remote controlled robot used by lazy people to switch channels and get pizza."
	icon = 'icons/mob/bot/fetchbot.dmi'
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
	. = ..()
	if(holding)
		to_chat(user, SPAN_NOTICE("It is holding \the [icon2html(holding, user)] [holding]."))

/mob/living/bot/remotebot/explode()
	on = 0
	new /obj/decal/cleanable/blood/oil(get_turf(src.loc))
	visible_message(SPAN_DANGER("[src] blows apart!"))
	if(controller)
		controller.bot = null
		controller = null
	for(var/i in 1 to rand(3,5))
		var/obj/item/stack/material/cardboard/C = new(src.loc)
		if(prob(50))
			C.forceMove(get_step(src, pick(GLOB.alldirs)))

	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)


/mob/living/bot/remotebot/get_interactions_info()
	. = ..()
	.["Remote Control"] = "<p>Syncs the remote control to the bot, allowing it to be controlled. Only one remote control can be synced to a given bot.</p>"


/mob/living/bot/remotebot/use_tool(obj/item/tool, mob/user, list/click_params)
	// Remove Control - Link controller to bot
	if (istype(tool, /obj/item/device/bot_controller))
		if (controller)
			USE_FEEDBACK_FAILURE("\The [src] is already connected to a remote control.")
			return TRUE
		var/obj/item/device/bot_controller/bot_controller = tool
		bot_controller.bot = src
		controller = bot_controller
		GLOB.destroyed_event.register(bot_controller, src, .proc/controller_deleted)
		user.visible_message(
			SPAN_NOTICE("\The [user] syncs \a [tool] to \the [src]."),
			SPAN_NOTICE("You sync \the [tool] to \the [src].")
		)
		return TRUE

	return ..()


/mob/living/bot/remotebot/proc/controller_deleted(obj/item/device/bot_controller/bot_controller)
	if (controller == bot_controller)
		controller = null
	GLOB.destroyed_event.unregister(bot_controller, src, .proc/controller_deleted)


/mob/living/bot/remotebot/update_icons()
	icon_state = "fetchbot[on]"

/mob/living/bot/remotebot/Destroy()
	if(holding)
		holding.forceMove(loc)
		holding = null
	return ..()

/mob/living/bot/remotebot/proc/pickup(obj/item/I)
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

/mob/living/bot/remotebot/proc/hit(atom/movable/a)
	src.visible_message("<b>\The [src]</b> taps \the [a] with its claw.")
	flick("fetchbot-c", src)
	working = 1
	sleep(10)
	working = 0

/mob/living/bot/remotebot/proc/command(atom/a)
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
	icon = 'icons/obj/surgery_tools.dmi'
	icon_state = "autopsy_scanner"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	item_state = "electronic"
	var/mob/living/bot/remotebot/bot

/obj/item/device/bot_controller/attack_self(mob/user)
	src.interact(user)

/obj/item/device/bot_controller/interact(mob/user)
	user.set_machine(src)
	if(!(src in user) || !bot)
		close_browser(user, "window=bot_controller")
		return
	var/dat = "<center><TT><b>Remote Control: [bot.name]</b></TT><br>"
	dat += "Currently Holding: [bot.holding ? bot.holding.name : "Nothing"]<br><br>"
	var/is_looking = (user.client.eye == bot)
	dat += "<a href='byond://?src=\ref[src];look=[is_looking];'>[is_looking ? "Stop" : "Start"] Looking</a><br>"
	dat += "<a href='byond://?src=\ref[src];drop=1;'>Drop Item</a><br></center>"

	show_browser(user, dat, "window=bot_controller")
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


/obj/item/device/bot_controller/dropped(mob/living/user)
	if(user.client.eye == bot)
		user.client.eye = user
	return ..()


/obj/item/device/bot_controller/afterattack(atom/A, mob/living/user)
	if(bot)
		bot.command(A)

/obj/item/device/bot_controller/Destroy()
	if(bot)
		bot.controller_deleted(src)
		bot = null
	return ..()

/obj/item/device/bot_kit
	name = "Remote-Bot Kit"
	desc = "The cover says 'control your own cardboard nuclear powered robot. Comes with real plutonium!"
	icon = 'icons/obj/boxes.dmi'
	icon_state = "remotebot"

/obj/item/device/bot_kit/attack_self(mob/living/user)
	to_chat(user, "You quickly dismantle the box and retrieve the controller and the remote bot itself.")
	var/turf/T = get_turf(src.loc)
	new /mob/living/bot/remotebot(T)
	new /obj/item/device/bot_controller(T)
	qdel(src)
