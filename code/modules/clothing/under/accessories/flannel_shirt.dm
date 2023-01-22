/obj/item/clothing/accessory/flannel
	name = "flannel shirt"
	desc = "A comfy, plaid flannel shirt."
	icon_state = "flannel"
	var/rolled
	var/tucked
	var/buttoned


/obj/item/clothing/accessory/flannel/on_update_icon()
	icon_state = initial(icon_state)
	if (rolled)
		icon_state += "r"
	if (tucked)
		icon_state += "t"
	if (buttoned)
		icon_state += "b"
	update_clothing_icon()


/obj/item/clothing/accessory/flannel/on_attached(obj/item/clothing/C, mob/user)
	..()
	parent.verbs += /obj/item/clothing/accessory/flannel/verb/toggle_tucking
	parent.verbs += /obj/item/clothing/accessory/flannel/verb/toggle_sleeves
	parent.verbs += /obj/item/clothing/accessory/flannel/verb/toggle_flannel


/obj/item/clothing/accessory/flannel/on_removed(mob/user)
	if (parent)
		parent.verbs -= /obj/item/clothing/accessory/flannel/verb/toggle_tucking
		parent.verbs -= /obj/item/clothing/accessory/flannel/verb/toggle_sleeves
		parent.verbs -= /obj/item/clothing/accessory/flannel/verb/toggle_flannel
	..()


/obj/item/clothing/accessory/flannel/verb/toggle_flannel()
	set name = "Toggle Flannel Buttons"
	set category = "Object"
	set src in usr
	if (!ishuman(usr) || usr.stat)
		return
	var/obj/item/clothing/accessory/flannel/F = src
	if (!istype(F))
		F = locate() in src
		if (!F)
			return
	F.buttoned = !F.buttoned
	to_chat(usr, "You [F.buttoned ? "button up" : "unbutton"] your [F.name].")
	F.queue_icon_update()


/obj/item/clothing/accessory/flannel/verb/toggle_sleeves()
	set name = "Toggle Flannel Sleeves"
	set category = "Object"
	set src in usr
	if (!ishuman(usr) || usr.stat)
		return
	var/obj/item/clothing/accessory/flannel/F = src
	if (!istype(F))
		F = locate() in src
		if (!F)
			return
	F.rolled = !F.rolled
	to_chat(usr, "You roll [F.rolled ? "up" : "down"] the sleeves of your [F.name].")
	F.queue_icon_update()


/obj/item/clothing/accessory/flannel/verb/toggle_tucking()
	set name = "Toggle Flannel Tucking"
	set category = "Object"
	set src in usr
	if (!ishuman(usr) || usr.stat)
		return
	var/obj/item/clothing/accessory/flannel/F = src
	if (!istype(F))
		F = locate() in src
		if (!F)
			return
	F.tucked = !F.tucked
	to_chat(usr, "You [F.tucked ? "tuck in" : "untuck"] your [F.name].")
	F.queue_icon_update()
