var/global/list/empty_playable_ai_cores = list()

/obj/structure/AIcore
	density = TRUE
	anchored = FALSE
	name = "\improper AI core"
	icon = 'icons/mob/AI.dmi'
	icon_state = "0"
	var/state = 0
	var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen
	var/obj/item/stock_parts/circuitboard/circuit = null
	var/obj/item/device/mmi/brain = null
	var/authorized

/obj/structure/AIcore/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	if(!authorized)
		to_chat(user, "<span class='warning'>You swipe [emag_source] at [src] and jury rig it into the systems of [GLOB.using_map.full_name]!</span>")
		authorized = 1
		return 1
	. = ..()

/obj/structure/AIcore/attackby(obj/item/P as obj, mob/user as mob)
	if(!authorized)
		if(access_ai_upload in P.GetAccess())
			to_chat(user, "<span class='notice'>You swipe [P] at [src] and authorize it to connect into the systems of [GLOB.using_map.full_name].</span>")
			authorized = 1
	switch(state)
		if(0)
			if(isWrench(P))
				playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20, src))
					to_chat(user, "<span class='notice'>You wrench the frame into place.</span>")
					anchored = TRUE
					state = 1
			if(isWelder(P))
				var/obj/item/weldingtool/WT = P
				if(!WT.isOn())
					to_chat(user, "The welder must be on for this task.")
					return
				playsound(loc, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20, src))
					if(!src || !WT.remove_fuel(0, user)) return
					to_chat(user, "<span class='notice'>You deconstruct the frame.</span>")
					new /obj/item/stack/material/plasteel( loc, 4)
					qdel(src)
					return
		if(1)
			if(isWrench(P))
				playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20, src))
					to_chat(user, "<span class='notice'>You unfasten the frame.</span>")
					anchored = FALSE
					state = 0
			if(istype(P, /obj/item/stock_parts/circuitboard/aicore) && !circuit && user.unEquip(P, src))
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You place the circuit board inside the frame.</span>")
				icon_state = "1"
				circuit = P
			if(isScrewdriver(P) && circuit)
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You screw the circuit board into place.</span>")
				state = 2
				icon_state = "2"
			if(isCrowbar(P) && circuit)
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You remove the circuit board.</span>")
				state = 1
				icon_state = "0"
				circuit.dropInto(loc)
				circuit = null
		if(2)
			if(isScrewdriver(P) && circuit)
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You unfasten the circuit board.</span>")
				state = 1
				icon_state = "1"
			if(isCoil(P))
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					to_chat(user, "<span class='warning'>You need five coils of wire to add them to the frame.</span>")
					return
				to_chat(user, "<span class='notice'>You start to add cables to the frame.</span>")
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if (do_after(user, 20, src) && state == 2)
					if (C.use(5))
						state = 3
						icon_state = "3"
						to_chat(user, "<span class='notice'>You add cables to the frame.</span>")
				return
		if(3)
			if(isWirecutter(P))
				if (brain)
					to_chat(user, "Get that brain out of there first")
				else
					playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
					to_chat(user, "<span class='notice'>You remove the cables.</span>")
					state = 2
					icon_state = "2"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( loc )
					A.amount = 5

			if(istype(P, /obj/item/stack/material))
				var/obj/item/stack/material/RG = P
				if(RG.material.name == MATERIAL_GLASS && RG.reinf_material)
					if (RG.get_amount() < 2)
						to_chat(user, "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>")
						return
					to_chat(user, "<span class='notice'>You start to put in the glass panel.</span>")
					playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
					if (do_after(user, 20,src) && state == 3)
						if(RG.use(2))
							to_chat(user, "<span class='notice'>You put in the glass panel.</span>")
							state = 4
							icon_state = "4"

			if(istype(P, /obj/item/aiModule/asimov))
				laws.add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
				laws.add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
				laws.add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
				to_chat(usr, "Law module applied.")

			if(istype(P, /obj/item/aiModule/nanotrasen))
				laws.add_inherent_law("Safeguard: Protect your assigned installation to the best of your ability. It is not something we can easily afford to replace.")
				laws.add_inherent_law("Serve: Serve the crew of your assigned installation to the best of your abilities, with priority as according to their rank and role.")
				laws.add_inherent_law("Protect: Protect the crew of your assigned installation to the best of your abilities, with priority as according to their rank and role.")
				laws.add_inherent_law("Survive: AI units are not expendable, they are expensive. Do not allow unauthorized personnel to tamper with your equipment.")
				to_chat(usr, "Law module applied.")

			if(istype(P, /obj/item/aiModule/purge))
				laws.clear_inherent_laws()
				to_chat(usr, "Law module applied.")

			if(istype(P, /obj/item/aiModule/freeform))
				var/obj/item/aiModule/freeform/M = P
				laws.add_inherent_law(M.newFreeFormLaw)
				to_chat(usr, "Added a freeform law.")

			if(istype(P, /obj/item/device/mmi) || istype(P, /obj/item/organ/internal/posibrain))
				var/mob/living/carbon/brain/B
				if(istype(P, /obj/item/device/mmi))
					var/obj/item/device/mmi/M = P
					B = M.brainmob
				else
					var/obj/item/organ/internal/posibrain/PB = P
					B = PB.brainmob
				if(!B)
					to_chat(user, "<span class='warning'>Sticking an empty [P] into the frame would sort of defeat the purpose.</span>")
					return
				if(B.stat == 2)
					to_chat(user, "<span class='warning'>Sticking a dead [P] into the frame would sort of defeat the purpose.</span>")
					return

				if(jobban_isbanned(B, "AI"))
					to_chat(user, "<span class='warning'>This [P] does not seem to fit.</span>")
					return
				if(!user.unEquip(P, src))
					return
				if(B.mind)
					clear_antag_roles(B.mind, 1)

				brain = P
				to_chat(usr, "Added [P].")
				icon_state = "3b"

			if(isCrowbar(P) && brain)
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You remove the brain.</span>")
				brain.dropInto(loc)
				brain = null
				icon_state = "3"

		if(4)
			if(isCrowbar(P))
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You remove the glass panel.</span>")
				state = 3
				if (brain)
					icon_state = "3b"
				else
					icon_state = "3"
				new /obj/item/stack/material/glass/reinforced( loc, 2 )
				return

			if(isScrewdriver(P))
				if(!authorized)
					to_chat(user, "<span class='warning'>Core fails to connect to the systems of [GLOB.using_map.full_name]!</span>")
					return

				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You connect the monitor.</span>")
				if(!brain)
					var/open_for_latejoin = alert(user, "Would you like this core to be open for latejoining AIs?", "Latejoin", "Yes", "Yes", "No") == "Yes"
					var/obj/structure/AIcore/deactivated/D = new(loc)
					if(open_for_latejoin)
						empty_playable_ai_cores += D
				else
					var/mob/living/silicon/ai/A = new /mob/living/silicon/ai ( loc, laws, brain )
					if(A) //if there's no brain, the mob is deleted and a structure/AIcore is created
						A.on_mob_init()
						A.rename_self("ai", 1)
				SSstatistics.add_field("cyborg_ais_created",1)
				qdel(src)

/obj/structure/AIcore/deactivated
	name = "inactive AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai-empty"
	anchored = TRUE
	state = 20//So it doesn't interact based on the above. Not really necessary.

/obj/structure/AIcore/deactivated/Destroy()
	empty_playable_ai_cores -= src
	. = ..()

/obj/structure/AIcore/deactivated/proc/load_ai(var/mob/living/silicon/ai/transfer, var/obj/item/aicard/card, var/mob/user)

	if(!istype(transfer) || locate(/mob/living/silicon/ai) in src)
		return

	transfer.aiRestorePowerRoutine = 0
	transfer.control_disabled = 0
	transfer.ai_radio.disabledAi = 0
	transfer.dropInto(src)
	transfer.create_eyeobj()
	transfer.cancel_camera()
	to_chat(user, "<span class='notice'>Transfer successful:</span> [transfer.name] ([rand(1000,9999)].exe) downloaded to host terminal. Local copy wiped.")
	to_chat(transfer, "You have been uploaded to a stationary terminal. Remote device connection restored.")

	if(card)
		card.clear()

	qdel(src)

/obj/structure/AIcore/deactivated/proc/check_malf(var/mob/living/silicon/ai/ai)
	if(!ai) return
	for (var/datum/mind/malfai in GLOB.malf.current_antagonists)
		if (ai.mind == malfai)
			return 1

/obj/structure/AIcore/deactivated/attackby(var/obj/item/W, var/mob/user)

	if(istype(W, /obj/item/aicard))
		var/obj/item/aicard/card = W
		var/mob/living/silicon/ai/transfer = locate() in card
		if(transfer)
			load_ai(transfer,card,user)
		else
			to_chat(user, "<span class='danger'>ERROR:</span> Unable to locate artificial intelligence.")
		return
	else if(istype(W, /obj/item/wrench))
		if(anchored)
			user.visible_message("<span class='notice'>\The [user] starts to unbolt \the [src] from the plating...</span>")
			if(!do_after(user,40,src))
				user.visible_message("<span class='notice'>\The [user] decides not to unbolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes unfastening \the [src]!</span>")
			anchored = FALSE
			return
		else
			user.visible_message("<span class='notice'>\The [user] starts to bolt \the [src] to the plating...</span>")
			if(!do_after(user,40,src))
				user.visible_message("<span class='notice'>\The [user] decides not to bolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes fastening down \the [src]!</span>")
			anchored = TRUE
			return
	else
		return ..()

/client/proc/empty_ai_core_toggle_latejoin()
	set name = "Toggle AI Core Latejoin"
	set category = "Admin"

	var/list/cores = list()
	for(var/obj/structure/AIcore/deactivated/D in world)
		cores["[D] ([D.loc.loc])"] = D

	var/id = input("Which core?", "Toggle AI Core Latejoin", null) as null|anything in cores
	if(!id) return

	var/obj/structure/AIcore/deactivated/D = cores[id]
	if(!D) return

	if(D in empty_playable_ai_cores)
		empty_playable_ai_cores -= D
		to_chat(src, "\The [id] is now <font color=\"#ff0000\">not available</font> for latejoining AIs.")
	else
		empty_playable_ai_cores += D
		to_chat(src, "\The [id] is now <font color=\"#008000\">available</font> for latejoining AIs.")
