/obj/item/clothing/accessory/necklace/collar
	name = "silver tag collar"
	desc = "A collar for your little pets... or the big ones."
	icon = 'packs/infinity/icons/obj/clothing/obj_accessories.dmi'
	icon_state = "collar_bksilv"

	accessory_icons = list(
		slot_w_uniform_str = 'packs/infinity/icons/mob/onmob/onmob_accessories.dmi',
		slot_wear_suit_str = 'packs/infinity/icons/mob/onmob/onmob_accessories.dmi'
	)
	item_icons = list(
		slot_wear_mask_str = 'packs/infinity/icons/mob/onmob/onmob_accessories.dmi'
	)

	var/renameable = FALSE

/obj/item/clothing/accessory/necklace/collar/gold
	name = "golden tag collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_bkgold"
	renameable = TRUE

/obj/item/clothing/accessory/necklace/collar/bell
	name = "bell collar"
	desc = "A collar with a tiny bell hanging from it, purrfect furr kitties."
	icon_state = "collar_bkbell"
	renameable = TRUE

/obj/item/clothing/accessory/necklace/collar/spike
	name = "spiked collar"
	desc = "A collar with spikes that look as sharp as your teeth."
	icon_state = "collar_bkspike"
	renameable = TRUE

/obj/item/clothing/accessory/necklace/collar/pink
	name = "pink collar"
	desc = "This collar will make your pets look FA-BU-LOUS."
	icon_state = "collar_pisilv"
	renameable = TRUE

/obj/item/clothing/accessory/necklace/collar/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if(renameable && tool.sharp)
		var/inscription = sanitize(input("Enter an inscription to engrave.", "Inscription") as null|text)

		if(!user.stat && !user.incapacitated() && user.Adjacent(src) && user.use_sanity_check(src, tool))
			if(!inscription)
				return TRUE
			USE_FEEDBACK_FAILURE("You carve \"[inscription]\" into \the [src].")
			name = initial(name) + " ([inscription])"
			desc = initial(desc) + " The tag says \"[inscription]\"."
			return TRUE
	return ..()

/obj/item/clothing/accessory/necklace/collar/holo
	name = "holo-collar"
	desc = "An expensive holo-collar for the modern day pet."
	icon_state = "collar_bkholo"

/obj/item/clothing/accessory/necklace/collar/holo/attack_self(mob/user as mob)
	to_chat(user, SPAN_NOTICE("[name]'s interface is projected onto your hand."))

	var/str = copytext(reject_bad_text(input(user,"Tag text?","Set tag","")),1,MAX_NAME_LEN)

	if(!str || !length(str))
		to_chat(user, SPAN_NOTICE("[name]'s tag set to be blank."))
		name = initial(name)
		desc = initial(desc)
	else
		to_chat(user, SPAN_NOTICE("You set the [name]'s tag to '[str]'."))
		name = initial(name) + " ([str])"
		desc = initial(desc) + " The tag says \"[str]\"."

/obj/item/clothing/accessory/necklace/collar/shock
	name = "shock collar"
	desc = "A collar used to ease hungry predators."
	icon_state = "collar_bkshk0"
	item_state = "collar_bkshk"
	var/on = FALSE // 0 for off, 1 for on, starts off to encourage people to set non-default frequencies and codes.
	var/frequency = 1449
	var/code = 2
	var/datum/radio_frequency/radio_connection

/obj/item/clothing/accessory/necklace/collar/shock/New()
	..()
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT) // Makes it so you don't need to change the frequency off of default for it to work.

/obj/item/clothing/accessory/necklace/collar/shock/Destroy() //Clean up your toys when you're done.
	radio_controller.remove_object(src, frequency)
	radio_connection = null //Don't delete this, this is a shared object.
	return ..()

/obj/item/clothing/accessory/necklace/collar/shock/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/clothing/accessory/necklace/collar/shock/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if(((istype(usr, /mob/living/carbon/human) && ((!( SSticker ) || (SSticker && SSticker.mode != "monkey")) && LAZYACCESS(usr.contents, src))) || (LAZYACCESS(usr.contents, master) || (in_range(src, usr) && istype(loc, /turf)))))
		usr.set_machine(src)
		if(href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			set_frequency(new_frequency)
		else
			if(href_list["code"])
				code += text2num(href_list["code"])
				code = round(code)
				code = min(100, code)
				code = max(1, code)
			else
				if(href_list["power"])
					on = !( on )
					icon_state = "collar_bkshk[on]" // And apparently this works, too?!
		if(!( master ))
			if(istype(loc, /mob))
				attack_self(loc)
			else
				for(var/mob/M in viewers(1, src))
					if(M.client)
						attack_self(M)
		else
			if(istype(master.loc, /mob))
				attack_self(master.loc)
			else
				for(var/mob/M in viewers(1, master))
					if(M.client)
						attack_self(M)
	else
		close_browser(usr, "window=radio")
		return
	return

/obj/item/clothing/accessory/necklace/collar/shock/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption != code)
		return

	if(on)
		var/mob/M = null
		if(ismob(loc))
			M = loc
		if(ismob(loc.loc))
			M = loc.loc // This is about as terse as I can make my solution to the whole 'collar won't work when attached as accessory' thing.
		to_chat(M, SPAN_DANGER("You feel a sharp shock!"))
		var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
		s.set_up(3, 1, M)
		s.start()
		M.Weaken(5)
	return

/obj/item/clothing/accessory/necklace/collar/shock/attack_self(mob/user as mob, flag1)
	if(!istype(user, /mob/living/carbon/human))
		return
	user.set_machine(src)
	var/dat = {"<TT>
			<A href='?src=\ref[src];power=1'>Turn [on ? "Off" : "On"]</A><BR>
			<B>Frequency/Code</B> for collar:<BR>
			Frequency:
			<A href='byond://?src=\ref[src];freq=-10'>-</A>
			<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(frequency)]
			<A href='byond://?src=\ref[src];freq=2'>+</A>
			<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

			Code:
			<A href='byond://?src=\ref[src];code=-5'>-</A>
			<A href='byond://?src=\ref[src];code=-1'>-</A> [code]
			<A href='byond://?src=\ref[src];code=1'>+</A>
			<A href='byond://?src=\ref[src];code=5'>+</A><BR>
			</TT>"}
	show_browser(user, dat, "window=radio")
	onclose(user, "radio")
	return
