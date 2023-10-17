/obj/item/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	matter = list(MATERIAL_PLASTIC = 100)

	/// If set, the label text this will apply.
	var/label

/obj/item/hand_labeler/get_mechanics_info()
	. = ..()
	. += {"
		<p>The hand labeler can be used to attach labels to objects. To do this, first set a label by using the labeler in your hand and typing in the text to use. Then click on any object.</p>
		<p>You can turn the labeler back off by using it in hand again.</p>
		<p>If the labeler is turned on, this will bypass all other interactions - This means you can use the labeler on bags without also storing it, and other such interactions.</p>
	"}


/obj/item/hand_labeler/on_update_icon()
	icon_state = "labeler[!isnull(label)]"


/obj/item/hand_labeler/use_before(atom/target, mob/living/user)
	. = FALSE
	if (label)
		target.AddLabel(label, user)
		return TRUE


/obj/item/hand_labeler/attack_self(mob/living/user)
	if (label)
		to_chat(user, SPAN_ITALIC("You turn off \the [src]."))
		label = null
		update_icon()
	else
		var/response = input(user, "Label Text:") as null | text
		if (!response)
			return
		response = sanitizeSafe(response, MAX_LNAME_LEN)
		if (!length(response))
			to_chat(user, SPAN_WARNING("Invalid Label."))
			return
		label = response
		to_chat(user, SPAN_ITALIC("You turn \the [src] on and set its text to \"[label]\"."))
		update_icon()
