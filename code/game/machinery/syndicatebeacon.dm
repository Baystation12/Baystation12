//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//  Beacon randomly spawns in space
//	When a non-traitor (no special role in /mind) uses it, he is given the choice to become a traitor
//	If he accepts there is a random chance he will be accepted, rejected, or rejected and killed
//	Bringing certain items can help improve the chance to become a traitor


/obj/machinery/syndicate_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/structures/syndicate_beacon.dmi'
	icon_state = "syndbeacon"

	anchored = TRUE
	density = TRUE

	var/temptext = ""
	var/selfdestructing = 0
	var/charges = 1

/obj/machinery/syndicate_beacon/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/syndicate_beacon/interact(mob/user)
	user.set_machine(src)
	var/dat = SPAN_COLOR("#005500", "<i>Scanning [pick("retina pattern", "voice print", "fingerprints", "dna sequence")]...<br>Identity confirmed,<br></i>")
	if(istype(user, /mob/living/carbon/human) || istype(user, /mob/living/silicon/ai))
		if(is_special_character(user))
			dat += "[SPAN_COLOR("#007700", "<i>Operative record found. Greetings, Agent [user.name].</i>")]<br>"
		else if(charges < 1)
			dat += "<TT>Connection severed.</TT><BR>"
		else
			var/honorific = "Mr."
			if(user.gender == FEMALE)
				honorific = "Ms."
			dat += "[SPAN_COLOR("red", "<i>Identity not found in operative database. What can the Syndicate do for you today, [honorific] [user.name]?</i>")]<br>"
			if(!selfdestructing)
				dat += "<br><br><A href='?src=\ref[src];betraitor=1;traitormob=\ref[user]'>\"[pick("I want to switch teams.", "I want to work for you.", "Let me join you.", "I can be of use to you.", "You want me working for you, and here's why...", "Give me an objective.", "How's the 401k over at the Syndicate?")]\"</A><BR>"
	dat += temptext
	show_browser(user, dat, "window=syndbeacon")
	onclose(user, "syndbeacon")

/obj/machinery/syndicate_beacon/Topic(href, href_list)
	if(..())
		return
	if(href_list["betraitor"])
		if(charges < 1)
			src.updateUsrDialog()
			return
		var/mob/M = locate(href_list["traitormob"])
		if(M.mind.special_role || jobban_isbanned(M, MODE_TRAITOR))
			temptext = "<i>We have no need for you at this time. Have a pleasant day.</i><br>"
			src.updateUsrDialog()
			return
		charges -= 1
		if (rand(0, 1))
			temptext = "[SPAN_COLOR("red", "<i><b>Double-crosser. You planned to betray us from the start. Allow us to repay the favor in kind.</b></i>")]"
			src.updateUsrDialog()
			spawn(rand(50,200)) selfdestruct()
			return
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/N = M
			to_chat(M, "<B>You have joined the ranks of the Syndicate and become a traitor to the station!</B>")
			GLOB.traitors.add_antagonist(N.mind)
			GLOB.traitors.equip(N)
			log_and_message_admins("has accepted a traitor objective from a syndicate beacon.", M)


	src.updateUsrDialog()
	return


/obj/machinery/syndicate_beacon/proc/selfdestruct()
	selfdestructing = 1
	var/range = rand(5, 12)
	spawn() explosion(src.loc, range)

////////////////////////////////////////
//Singularity beacon
////////////////////////////////////////
/obj/machinery/power/singularity_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/machines/power/singularity.dmi'
	icon_state = "beacon"

	anchored = FALSE
	density = TRUE
	layer = BASE_ABOVE_OBJ_LAYER //so people can't hide it and it's REALLY OBVIOUS

	var/active = 0
	var/icontype = "beacon"

/obj/machinery/power/singularity_beacon/proc/Activate(mob/user = null)
	if(surplus() < 1500)
		if(user) to_chat(user, SPAN_NOTICE("The connected wire doesn't have enough current."))
		return
	for(var/obj/singularity/singulo in world)
		if(singulo.z == z)
			singulo.target = src
	icon_state = "[icontype]1"
	active = 1

	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	if(user)
		to_chat(user, SPAN_NOTICE("You activate the beacon."))


/obj/machinery/power/singularity_beacon/proc/Deactivate(mob/user = null)
	for(var/obj/singularity/singulo in world)
		if(singulo.target == src)
			singulo.target = null
	icon_state = "[icontype]0"
	active = 0
	if(user)
		to_chat(user, SPAN_NOTICE("You deactivate the beacon."))


/obj/machinery/power/singularity_beacon/physical_attack_hand(mob/user)
	. = TRUE
	if(anchored)
		if(active)
			Deactivate(user)
		else
			Activate(user)
	else
		to_chat(user, SPAN_DANGER("You need to screw the beacon to the floor first!"))

/obj/machinery/power/singularity_beacon/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isScrewdriver(W))
		if(active)
			to_chat(user, SPAN_DANGER("You need to deactivate the beacon first!"))
			return TRUE

		if(anchored)
			anchored = FALSE
			to_chat(user, SPAN_NOTICE("You unscrew the beacon from the floor."))
			disconnect_from_network()
			return TRUE
		else
			if(!connect_to_network())
				to_chat(user, "This device must be placed over an exposed cable.")
				return TRUE
			anchored = TRUE
			to_chat(user, SPAN_NOTICE("You screw the beacon to the floor and attach the cable."))
			return TRUE

	return ..()


/obj/machinery/power/singularity_beacon/Destroy()
	if(active)
		Deactivate()
	..()

//stealth direct power usage
/obj/machinery/power/singularity_beacon/Process()
	if(!active)
		return PROCESS_KILL
	if(draw_power(1500) < 1500)
		Deactivate()

/obj/machinery/power/singularity_beacon/syndicate
	icontype = "beaconsynd"
	icon_state = "beaconsynd0"
