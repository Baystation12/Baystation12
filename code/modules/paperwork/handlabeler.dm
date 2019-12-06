/obj/item/weapon/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.
	matter = list(MATERIAL_PLASTIC = 100)

/obj/item/weapon/hand_labeler/attack()
	return

/obj/item/weapon/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!mode)	//if it's off, give up.
		return
	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(!labels_left)
		to_chat(user, "<span class='notice'>No labels left.</span>")
		return
	if(!label || !length(label))
		to_chat(user, "<span class='notice'>No label text set.</span>")
		return
	if(has_extension(A, /datum/extension/labels))
		var/datum/extension/labels/L = get_extension(A, /datum/extension/labels)
		if(!L.CanAttachLabel(user, label))
			return
	A.attach_label(user, src, label)

/atom/proc/attach_label(var/user, var/atom/labeler, var/label_text)
	to_chat(user, "<span class='notice'>The label refuses to stick to [name].</span>")

/mob/observer/attach_label(var/user, var/atom/labeler, var/label_text)
	to_chat(user, "<span class='notice'>\The [labeler] passes through \the [src].</span>")

/obj/machinery/portable_atmospherics/hydroponics/attach_label(var/user)
	if(!mechanical)
		to_chat(user, "<span class='notice'>How are you going to label that?</span>")
		return
	..()
	update_icon()

/obj/attach_label(var/user, var/atom/labeler, var/label_text)
	if(!simulated)
		return
	var/datum/extension/labels/L = get_or_create_extension(src, /datum/extension/labels)
	L.AttachLabel(user, label_text)

/obj/item/weapon/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, "<span class='notice'>You turn on \the [src].</span>")
		//Now let them chose the text.
		var/str = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_LNAME_LEN)
		if(!str || !length(str))
			to_chat(user, "<span class='notice'>Invalid text.</span>")
			return
		label = str
		to_chat(user, "<span class='notice'>You set the text to '[str]'.</span>")
	else
		to_chat(user, "<span class='notice'>You turn off \the [src].</span>")
