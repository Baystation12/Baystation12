/datum/extension/labels
	base_type = /datum/extension/labels
	expected_type = /atom
	var/atom/atom_holder
	var/list/labels

/datum/extension/labels/New()
	..()
	atom_holder = holder

/datum/extension/labels/Destroy()
	atom_holder = null
	return ..()

/datum/extension/labels/proc/AttachLabel(var/mob/user, var/label)
	if(!CanAttachLabel(user, label))
		return

	if(!LAZYLEN(labels))
		atom_holder.verbs += /atom/proc/RemoveLabel
	LAZYADD(labels, label)

	user.visible_message("<span class='notice'>\The [user] attaches a label to \the [atom_holder].</span>", \
						 "<span class='notice'>You attach a label, '[label]', to \the [atom_holder].</span>")

	var/old_name = atom_holder.name
	atom_holder.name = "[atom_holder.name] ([label])"
	GLOB.name_set_event.raise_event(src, old_name, atom_holder.name)

/datum/extension/labels/proc/RemoveLabel(var/mob/user, var/label)
	if(!(label in labels))
		return

	LAZYREMOVE(labels, label)
	if(!LAZYLEN(labels))
		atom_holder.verbs -= /atom/proc/RemoveLabel

	var/full_label = " ([label])"
	var/index = findtextEx(atom_holder.name, full_label)
	if(!index) // Playing it safe, something might not have set the name properly
		return

	user.visible_message("<span class='notice'>\The [user] removes a label from \the [atom_holder].</span>", \
						 "<span class='notice'>You remove a label, '[label]', from \the [atom_holder].</span>")

	var/old_name = atom_holder.name
	// We find and replace the first instance, since that's the one we removed from the list
	atom_holder.name = replacetext(atom_holder.name, full_label, "", index, index + length(full_label))
	GLOB.name_set_event.raise_event(src, old_name, atom_holder.name)

// We may have to do something more complex here
// in case something appends strings to something that's labelled rather than replace the name outright
// Non-printable characters should be of help if this comes up
/datum/extension/labels/proc/AppendLabelsToName(var/name)
	if(!LAZYLEN(labels))
		return name
	. = list(name)
	for(var/entry in labels)
		. += " ([entry])"
	. = jointext(., null)

/datum/extension/labels/proc/CanAttachLabel(var/user, var/label)
	if(!length(label))
		return FALSE
	if(ExcessLabelLength(label, user))
		return FALSE
	return TRUE

/datum/extension/labels/proc/ExcessLabelLength(var/label, var/user)
	. = length(label) + 3 // Each label also adds a space and two brackets when applied to a name
	if(LAZYLEN(labels))
		for(var/entry in labels)
			. += length(entry) + 3
	. = . > 64 ? TRUE : FALSE
	if(. && user)
		to_chat(user, "<span class='warning'>The label won't fit.</span>")

/proc/get_attached_labels(var/atom/source)
	if(has_extension(source, /datum/extension/labels))
		var/datum/extension/labels/L = get_extension(source, /datum/extension/labels)
		if(LAZYLEN(L.labels))
			return L.labels.Copy()
		return list()

/atom/proc/RemoveLabel(var/label in get_attached_labels(src))
	set name = "Remove Label"
	set desc = "Used to remove labels"
	set category = "Object"
	set src in view(1)

	if(CanPhysicallyInteract(usr))
		if(has_extension(src, /datum/extension/labels))
			var/datum/extension/labels/L = get_extension(src, /datum/extension/labels)
			L.RemoveLabel(usr, label)