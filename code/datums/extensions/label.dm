/datum/extension/labels
	base_type = /datum/extension/labels
	expected_type = /atom
	var/atom/atom_holder
	var/list/labels


/datum/extension/labels/Destroy()
	atom_holder = null
	return ..()


/datum/extension/labels/New()
	..()
	atom_holder = holder


/datum/extension/labels/proc/AddLabel(label, mob/user)
	if (!CanAddLabel(label, user))
		return
	if (!length(labels))
		atom_holder.verbs += /atom/proc/RemoveLabel
	LAZYADD(labels, label)
	if (user)
		user.visible_message(
			SPAN_ITALIC("\The [user] attaches a label to \a [atom_holder]."),
			SPAN_ITALIC("You label \the [atom_holder] with \"[label]\".")
		)
	var/old_name = atom_holder.name
	atom_holder.name = "[atom_holder.name] ([label])"
	GLOB.name_set_event.raise_event(src, old_name, atom_holder.name)


/datum/extension/labels/proc/RemoveLabel(label, mob/user)
	if (!(label in labels))
		return
	LAZYREMOVE(labels, label)
	if (!length(labels))
		atom_holder.verbs -= /atom/proc/RemoveLabel
	var/full_label = " ([label])"
	var/index = findtextEx_char(atom_holder.name, full_label)
	if (!index)
		return
	if (user)
		user.visible_message(
			SPAN_ITALIC("\The [user] removes a label from \a [atom_holder]."),
			SPAN_ITALIC("You remove the \"[label]\" label from \the [atom_holder].")
		)
	var/old_name = atom_holder.name
	atom_holder.name = replacetext_char(atom_holder.name, full_label, "", index, index + length_char(full_label))
	GLOB.name_set_event.raise_event(src, old_name, atom_holder.name)


/datum/extension/labels/proc/AppendLabelsToName(name)
	if (!length(labels))
		return name
	return "[name] ([jointext(labels, ") (")])"


/datum/extension/labels/proc/CanAddLabel(label, mob/user)
	var/label_length = length_char(label)
	if (!label_length)
		return FALSE
	var/free_length = 64
	for (var/entry in labels)
		free_length -= length_char(entry) + 3
	if (free_length < label_length + 3)
		if (user)
			to_chat(user, SPAN_WARNING("That won't fit. There is space for [max(free_length - 3, 0)] more letters."))
		return FALSE
	return TRUE


/proc/get_attached_labels(atom/source)
	RETURN_TYPE(/list)
	if (has_extension(source, /datum/extension/labels))
		var/datum/extension/labels/labels = get_extension(source, /datum/extension/labels)
		if (length(labels.labels))
			return labels.labels.Copy()
		return list()


/**
 * Removes a labeller label from the atom.
 *
 * **Parameters**:
 * - `label` - The label to remove.
 */
/atom/proc/RemoveLabel(label in get_attached_labels(src))
	set name = "Remove Label"
	set desc = "Used to remove labels"
	set category = "Object"
	set src in view(1)
	if (CanPhysicallyInteract(usr))
		if (has_extension(src, /datum/extension/labels))
			var/datum/extension/labels/labels = get_extension(src, /datum/extension/labels)
			labels.RemoveLabel(label, usr)


/// Convenience shortcut for user labelling attempts. Overrides provide behavior.
/atom/proc/AddLabel(label, mob/user)
	if (user)
		to_chat(user, SPAN_NOTICE("The label refuses to stick to \the [src]."))


/obj/AddLabel(label, mob/user)
	if (!simulated)
		return
	var/datum/extension/labels/labels = get_or_create_extension(src, /datum/extension/labels)
	labels.AddLabel(label, user)


/obj/machinery/portable_atmospherics/hydroponics/soil/AddLabel(label, mob/user)
	if (user)
		to_chat(user, SPAN_WARNING("The label refuses to stick to \the [src]."))
