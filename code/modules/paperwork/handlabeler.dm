/obj/item/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	item_flags = ITEM_FLAG_TRY_ATTACK
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.
	matter = list(MATERIAL_PLASTIC = 100)

/obj/item/hand_labeler/get_mechanics_info()
	. = ..()
	. += {"
		<p>The hand labeler can be used to attach labels to objects. To do this, first set a label by using the labeler in your hand and typing in the text to use. Then click on any object.</p>
		<p>You can turn the labeler back off by using it in hand again.</p>
		<p>If the labeler is turned on, this will bypass all other interactions - This means you can use the labeler on bags without also storing it, and other such interactions.</p>
	"}

/obj/item/hand_labeler/attack(atom/target, mob/living/user, target_zone, animate)
	if (!mode)
		return FALSE
	if (!labels_left)
		to_chat(user, SPAN_WARNING("\The [src] has no labels left."))
		return TRUE
	if (!label || !length(label))
		to_chat(user, SPAN_WARNING("\The [src] does not have label text set."))
		return TRUE
	if(has_extension(target, /datum/extension/labels))
		var/datum/extension/labels/L = get_extension(target, /datum/extension/labels)
		if(!L.CanAttachLabel(user, label))
			return TRUE
	target.attach_label(user, src, label)
	return TRUE


/**
 * Handles attaching a labeller label to the atom.
 *
 * **Parameters**:
 * - `user` - The mob attaching the label.
 * - `labeler` - The labeler being used to attach the label.
 * - `label_text` (string) - The text to be added as a label.
 */
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
	if (!mode)
		var/str = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_LNAME_LEN)
		if (!str || !length(str))
			to_chat(user, SPAN_WARNING("Invalid text."))
			return
		label = str
		mode = TRUE
		update_icon()
		to_chat(user, SPAN_NOTICE("You turn \the [src] on and set it's text to '[label]'."))
	else
		label = null
		mode = FALSE
		update_icon()
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))


/obj/item/hand_labeler/on_update_icon()
	icon_state = "labeler[mode]"
