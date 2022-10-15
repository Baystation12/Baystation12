/obj/item/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.
	matter = list(MATERIAL_PLASTIC = 100)

/obj/item/hand_labeler/attack()
	return

/obj/item/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!mode)	//if it's off, give up.
		return
	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(!labels_left)
		to_chat(user, SPAN_NOTICE("No labels left."))
		return
	if(!label || !length(label))
		to_chat(user, SPAN_NOTICE("No label text set."))
		return
	if(has_extension(A, /datum/extension/labels))
		var/datum/extension/labels/L = get_extension(A, /datum/extension/labels)
		if(!L.CanAttachLabel(user, label))
			return
	A.attach_label(user, src, label)

/atom/proc/attach_label(user, atom/labeler, label_text)
	to_chat(user, SPAN_NOTICE("The label refuses to stick to [name]."))

/mob/observer/attach_label(user, atom/labeler, label_text)
	to_chat(user, SPAN_NOTICE("\The [labeler] passes through \the [src]."))

/obj/machinery/portable_atmospherics/hydroponics/attach_label(user)
	if(!mechanical)
		to_chat(user, SPAN_NOTICE("How are you going to label that?"))
		return
	..()
	update_icon()

/obj/attach_label(user, atom/labeler, label_text)
	if(!simulated)
		return
	var/datum/extension/labels/L = get_or_create_extension(src, /datum/extension/labels)
	L.AttachLabel(user, label_text)

/obj/item/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
		//Now let them chose the text.
		var/str = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_LNAME_LEN)
		if(!str || !length(str))
			to_chat(user, SPAN_NOTICE("Invalid text."))
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '[str]'."))
	else
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))
