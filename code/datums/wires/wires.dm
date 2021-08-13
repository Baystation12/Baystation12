// Wire datums. Created by Giacomand.
// Was created to replace a horrible case of copy and pasted code with no care for maintability.
// Goodbye Door wires, Cyborg wires, Vending Machine wires, Autolathe wires
// Protolathe wires, APC wires and Camera wires!

#define MAX_FLAG 65535

var/list/same_wires = list()
// 14 colours, if you're adding more than 14 wires then add more colours here
var/list/wireColours = list("red", "blue", "green", "darkred", "orange", "brown", "gold", "gray", "cyan", "navy", "purple", "pink", "black", "yellow")

/datum/wires

	var/random = 0 // Will the wires be different for every single instance.
	var/atom/holder = null // The holder
	var/holder_type = null // The holder type; used to make sure that the holder is the correct type.
	var/wire_count = 0 // Max is 16
	var/wires_status = 0 // BITFLAG OF WIRES

	var/list/wires = list()
	var/list/signallers = list()

	var/table_options = " align='center'"
	var/row_options1 = " width='80px'"
	var/row_options2 = " width='320px'"
	var/window_x = 450
	var/window_y = 470

	var/list/descriptions // Descriptions of wires (datum/wire_description) for use with examining.

/datum/wires/New(var/atom/holder)
	..()
	src.holder = holder
	if(!istype(holder, holder_type))
		CRASH("Our holder is null/the wrong type!")

	// Generate new wires
	if(random)
		GenerateWires()
		for(var/datum/wire_description/desc in descriptions)
			if(prob(50))
				desc.skill_level++
	// Get the same wires
	else
		// We don't have any wires to copy yet, generate some and then copy it.
		if(!same_wires[holder_type])
			GenerateWires()
			same_wires[holder_type] = src.wires.Copy()
		else
			var/list/wires = same_wires[holder_type]
			src.wires = wires // Reference the wires list.

/datum/wires/Destroy()
	holder = null
	return ..()

/datum/wires/proc/get_mechanics_info()
	return

/datum/wires/proc/GenerateWires()
	var/list/colours_to_pick = wireColours.Copy() // Get a copy, not a reference.
	var/list/indexes_to_pick = list()
	//Generate our indexes
	for(var/i = 1; i < MAX_FLAG && i < (1 << wire_count); i += i)
		indexes_to_pick += i
	colours_to_pick.len = wire_count // Downsize it to our specifications.

	while(colours_to_pick.len && indexes_to_pick.len)
		// Pick and remove a colour
		var/colour = pick_n_take(colours_to_pick)

		// Pick and remove an index
		var/index = pick_n_take(indexes_to_pick)

		src.wires[colour] = index
		//wires = shuffle(wires)

/datum/wires/proc/Interact(var/mob/living/user)

	if (!user)
		return

	var/html = null
	if(holder && CanUse(user))
		html = GetInteractWindow(user)
	if(html)
		user.set_machine(holder)
	else
		user.unset_machine()
		// No content means no window.
		close_browser(user, "window=wires")
		return

	var/datum/browser/popup = new(user, "wires", holder.name, window_x, window_y)
	popup.set_content(html)
	popup.set_title_image(user.browse_rsc_icon(holder.icon, holder.icon_state))
	popup.open()
	return TRUE

/datum/wires/proc/GetInteractWindow(mob/user)
	var/html = list()
	html += "<div class='block'>"
	html += "<h3>Exposed Wires</h3>"
	html += "<table[table_options]>"

	var/list/wires_used = list()
	for(var/colour in wires)
		wires_used += prob(user.skill_fail_chance(SKILL_ELECTRICAL, 20, SKILL_ADEPT)) ? pick(wires) : colour
	if(!user.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
		wires_used = shuffle(wires_used)

	for(var/colour in wires_used)
		html += "<tr>"
		html += "<td[row_options1]><font color='[colour]'>&#9724;</font>[capitalize(colour)]</td>"
		html += "<td[row_options2]>"
		html += "<A href='?src=\ref[src];action=1;cut=[colour]'>[IsColourCut(colour) ? "Mend" :  "Cut"]</A>"
		html += " <A href='?src=\ref[src];action=1;pulse=[colour]'>Pulse</A>"
		html += " <A href='?src=\ref[src];action=1;attach=[colour]'>[IsAttached(colour) ? "Detach" : "Attach"] Signaller</A>"
		html += " <A href='?src=\ref[src];action=1;examine=[colour]'>Examine</A></td></tr>"
	html += "</table>"
	html += "</div>"

	if (random)
		html += "<i>\The [holder] appears to have tamper-resistant electronics installed.</i><br><br>" //maybe this could be more generic?

	return JOINTEXT(html)

/datum/wires/Topic(href, href_list)
	..()
	if(in_range(holder, usr) && isliving(usr))

		var/mob/living/L = usr
		if(CanUse(L) && href_list["action"])

			var/obj/item/I = L.get_active_hand()

			var/obj/item/offhand_item
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				offhand_item = H.wearing_rig && H.wearing_rig.selected_module

			holder.add_hiddenprint(L)
			if(href_list["cut"]) // Toggles the cut/mend status
				if(isWirecutter(I) || isWirecutter(offhand_item))
					var/colour = href_list["cut"]
					var/message = ""
					if (CutWireColour(colour))
						message = SPAN_NOTICE("You mend the [colour] wire.")
					else
						message = SPAN_NOTICE("You cut the [colour] wire.")

					if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 20, SKILL_ADEPT)))
						RandomCut()
						message = SPAN_DANGER("You accidentally nick another wire in addition to the [colour] wire!")
					else if(!L.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
						RandomCutAll(10)
						message = SPAN_DANGER("You think you might have nicked some of the other wires in addition to the [colour] wire!")
					to_chat(usr, message)
					playsound(usr.loc, "sound/items/Wirecutter.ogg", 20)
				else
					to_chat(L, "<span class='error'>You need wirecutters!</span>")
			else if(href_list["pulse"])
				if(isMultitool(I) || isMultitool(offhand_item))
					var/colour = href_list["pulse"]
					if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 30, SKILL_ADEPT)))
						RandomPulse()
						to_chat(L, "<span class='danger'>You accidentally pulse another wire instead of the [colour] wire!</span>")
						if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 60, SKILL_BASIC)))
							RandomPulse() //or two
					else
						PulseColour(colour)
						to_chat(usr, SPAN_NOTICE("You pulse the [colour] wire."))
					playsound(usr.loc, "sound/effects/pop.ogg", 20)
					if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 50, SKILL_BASIC)))
						wires = shuffle(wires) //Leaves them in a different order for anyone else.
						to_chat(L, "<span class='danger'>You get the wires all tangled up!</span>")
				else
					to_chat(L, "<span class='error'>You need a multitool!</span>")
			else if(href_list["attach"])
				var/colour = href_list["attach"]
				var/failed = 0
				if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 80, SKILL_EXPERT)))
					colour = pick(wires)
					to_chat(L, "<span class='danger'>Are you sure you got the right wire?</span>")
					failed = 1
				// Detach
				if(IsAttached(colour))
					var/obj/item/O = Detach(colour)
					if(O)
						L.put_in_hands(O)
						to_chat(usr, SPAN_NOTICE("You detach the signaller from the [colour] wire."))

				// Attach
				else
					if(istype(I, /obj/item/device/assembly/signaler))
						if(L.unEquip(I))
							Attach(colour, I)
							if(!failed)
								to_chat(usr, SPAN_NOTICE("You attach the signaller to the [colour] wire."))
					else
						to_chat(L, "<span class='error'>You need a remote signaller!</span>")
			else if(href_list["examine"])
				var/colour = href_list["examine"]
				to_chat(usr, examine(GetIndex(colour), usr))

		// Update Window
			Interact(usr)

	if(href_list["close"])
		close_browser(usr, "window=wires")
		usr.unset_machine(holder)

//
// Overridable Procs
//

/// Called when wires cut/mended.
/datum/wires/proc/UpdateCut(index, mended)
	return

/// Called when wire pulsed. Add code here.
/datum/wires/proc/UpdatePulsed(index)
	return

/// Intended to be called when a pulsed wire 'resets'. You'll have to call this yourself in an `addtimer()` call in `UpdatePulsed()`.
/datum/wires/proc/ResetPulsed(index)
	return

/datum/wires/proc/examine(index, mob/user)
	. = "You aren't sure what this wire does."

	var/datum/wire_description/wd = get_description(index)
	if(!wd)
		return
	if(wd.skill_level && !user.skill_check(SKILL_ELECTRICAL, wd.skill_level))
		return
	return wd.description

/datum/wires/proc/CanUse(var/mob/living/L)
	return 1

// Example of use:
/*

var/const/BOLTED= 1
var/const/SHOCKED = 2
var/const/SAFETY = 4
var/const/POWER = 8

/datum/wires/door/UpdateCut(var/index, var/mended)
	var/obj/machinery/door/airlock/A = holder
	switch(index)
		if(BOLTED)
		if(!mended)
			A.bolt()
	if(SHOCKED)
		A.shock()
	if(SAFETY )
		A.safety()

*/


//
// Helper Procs
//

/datum/wires/proc/get_description(index)
	for(var/datum/wire_description/desc in descriptions)
		if(desc.index == index)
			return desc

/datum/wires/proc/PulseColour(var/colour)
	PulseIndex(GetIndex(colour))

/datum/wires/proc/PulseIndex(var/index)
	if(IsIndexCut(index))
		return
	UpdatePulsed(index)

/datum/wires/proc/GetIndex(var/colour)
	if(wires[colour])
		var/index = wires[colour]
		return index
	else
		CRASH("[colour] is not a key in wires.")


/datum/wires/proc/RandomPulse()
	var/index = rand(1, wires.len)
	PulseColour(wires[index])

//
// Is Index/Colour Cut procs
//

/datum/wires/proc/IsColourCut(var/colour)
	var/index = GetIndex(colour)
	return IsIndexCut(index)

/datum/wires/proc/IsIndexCut(var/index)
	return (index & wires_status)

//
// Signaller Procs
//

/datum/wires/proc/IsAttached(var/colour)
	if(signallers[colour])
		return 1
	return 0

/datum/wires/proc/GetAttached(var/colour)
	if(signallers[colour])
		return signallers[colour]
	return null

/datum/wires/proc/Attach(var/colour, var/obj/item/device/assembly/signaler/S)
	if(colour && S)
		if(!IsAttached(colour))
			signallers[colour] = S
			S.forceMove(holder)
			S.connected = src
			return S

/datum/wires/proc/Detach(var/colour)
	if(colour)
		var/obj/item/device/assembly/signaler/S = GetAttached(colour)
		if(S)
			signallers -= colour
			S.connected = null
			S.dropInto(holder.loc)
			return S


/datum/wires/proc/Pulse(var/obj/item/device/assembly/signaler/S)

	for(var/colour in signallers)
		if(S == signallers[colour])
			PulseColour(colour)
			break

//
// Cut Wire Colour/Index procs
//

/datum/wires/proc/CutWireColour(var/colour)
	var/index = GetIndex(colour)
	return CutWireIndex(index)

/datum/wires/proc/CutWireIndex(var/index)
	if(IsIndexCut(index))
		wires_status &= ~index
		UpdateCut(index, 1)
		return 1
	else
		wires_status |= index
		UpdateCut(index, 0)
		return 0

/datum/wires/proc/RandomCut()
	var/r = rand(1, wires.len)
	CutWireColour(wires[r])

/datum/wires/proc/RandomCutAll(var/probability = 10)
	for(var/i = 1; i < MAX_FLAG && i < (1 << wire_count); i += i)
		if(prob(probability))
			CutWireIndex(i)

/datum/wires/proc/CutAll()
	for(var/i = 1; i < MAX_FLAG && i < (1 << wire_count); i += i)
		CutWireIndex(i)

/datum/wires/proc/IsAllCut()
	if(wires_status == (1 << wire_count) - 1)
		return 1
	return 0

/datum/wires/proc/MendAll()
	for(var/i = 1; i < MAX_FLAG && i < (1 << wire_count); i += i)
		if(IsIndexCut(i))
			CutWireIndex(i)

//
//Shuffle and Mend
//

/datum/wires/proc/Shuffle()
	wires_status = 0
	GenerateWires()
