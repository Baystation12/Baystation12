var/global/list/wishlist

/datum/event/distress
	var/call_type = null
	var/postStartTicks 	= 0 //running timer

/datum/event/distress/setup()
	var/maxTicks = 300*severity //5 minutes for mundane, 15 minutes for major
	endWhen = maxTicks

datum/event/distress/announce()
	command_announcement.Announce("Distress call received. Message is being rerouted to command channel. Please check communications program for full message.", "[station_name()] Communications Array")


var/global/sent_goods = null
var/global/distress_in_progress = 0

/datum/event/distress/start()
	distress_in_progress = 1
	call_type= pick(
				"engineering",
				//"medical",
				//"engineering",
				//"security"
				)

	switch(call_type)
		if("engineering")
			wishlist = generate_wishlist("cargo") //generates the list of stuff needed to suceed
			var/message = generate_message()

			global_announcer.autosay(message, "Distress call", "Command") // sends a shorter version of the message to the command channel, so they know roughly whats up

			post_comm_message("Distress call", "[message] <br><br> We require the following materials: [jointext(global.wishlist, ", ")]") // sends the detailed version to the comm console
		if("medical")
		if("engineering")
		else
			return

/datum/event/distress/tick()
	postStartTicks++
	if(postStartTicks == endWhen/2) //send an update of progress after half the time passed
		command_announcement.Announce("Distress call update received. Please check communications program.", "[station_name()] Communications Array")
		post_comm_message("Distress call - update", "The situation is getting serious. We have no chance without additional supplies. We urgently need: [jointext(wishlist, ", ")]")

	if(!wishlist.len) //end the event if the wishlist was fulfilled
		postStartTicks = endWhen
		command_announcement.Announce("Distress call update received. Please check communications program.", "[station_name()] Communications Array")
		post_comm_message("Distress call - update", "The situation is now under control. We wish express our deepest gratitude to you and the crew of your fine vessel and wish you the best of luck on your journey.")

/datum/event/distress/end()
	var/global/wishlist = null