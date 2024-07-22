/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	icon = 'icons/obj/wallet.dmi'
	icon_state = "wallet-white"
	color = COLOR_BROWN_ORANGE
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = ITEM_SIZE_SMALL * 3
	slot_flags = SLOT_ID
	contents_allowed = list(
		/obj/item/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/smokable,
		/obj/item/lipstick,
		/obj/item/haircomb,
		/obj/item/mirror,
		/obj/item/clothing/accessory/locket,
		/obj/item/clothing/head/hairflower,
		/obj/item/device/flashlight/pen,
		/obj/item/seeds,
		/obj/item/material/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implant,
		/obj/item/flame,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/phototrinket,
		/obj/item/reagent_containers/pill,
		/obj/item/device/encryptionkey,
		/obj/item/key,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/accessory/medal,
		/obj/item/clothing/accessory/armor_tag,
		/obj/item/clothing/ring,
		/obj/item/passport,
		/obj/item/clothing/accessory/pride_pin,
		/obj/item/clothing/accessory/pronouns,
		/obj/item/storage/chewables/rollable,
		/obj/item/storage/fancy/matches/matchbook
	)

	/// If this wallet contains ID cards, the one that is displayed through its window.
	var/obj/item/card/id/front_id


/obj/item/storage/wallet/Destroy()
	front_id = null
	return ..()


/obj/item/storage/wallet/remove_from_storage(obj/item/item, atom/into)
	. = ..(item, into)
	if (!. || item != front_id)
		return
	front_id = null
	SetName(initial(name))
	update_icon()


/obj/item/storage/wallet/handle_item_insertion(obj/item/item, silent)
	. = ..(item, silent)
	if (!. || !istype(item, /obj/item/card/id))
		return
	front_id = item
	update_icon()


/obj/item/storage/wallet/on_update_icon()
	ClearOverlays()
	if (front_id)
		var/tiny_state = "id-generic"
		var/check_state = "id-[front_id.icon_state]"
		if (check_state in icon_states(icon))
			tiny_state = check_state
		var/image/tiny_image = new/image(icon, icon_state = tiny_state)
		tiny_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
		AddOverlays(tiny_image)


/obj/item/storage/wallet/GetIdCard()
	return front_id


/obj/item/storage/wallet/GetAccess()
	var/obj/item/card/id/id = GetIdCard()
	if (id)
		id.GetAccess()
	return ..()


/obj/item/storage/wallet/AltClick(mob/living/user)
	if (user != loc || user.incapacitated() || !ishuman(user))
		return ..()
	var/obj/item/card/id/id = GetIdCard()
	if (istype(id))
		remove_from_storage(id, get_turf(user))
		user.put_in_hands(id)
		return TRUE
	return ..()


/obj/item/storage/wallet/random
	/// Loose cash types permitted for spawning in random wallets.
	var/static/list/cash_types = subtypesof(/obj/item/spacecash/bundle)


/obj/item/storage/wallet/random/Initialize()
	. = ..()
	if (prob(65))
		var/obj/item/spacecash/ewallet/stick = new (src)
		stick.worth = floor(grand() * 1200)
	else
		for (var/i = 1 to rand(1, 2))
			var/type = pick(cash_types)
			new type (src)
	if (prob(33))
		new_simple_coin(src)
	update_icon()


/obj/item/storage/wallet/poly
	name = "polychromic wallet"
	desc = "You can recolor it! Fancy! The future is NOW!"


/obj/item/storage/wallet/poly/Initialize()
	color = get_random_colour()
	return ..()


/obj/item/storage/wallet/poly/verb/change_color()
	set name = "Change Wallet Color"
	set category = "Object"
	set desc = "Change the color of the wallet."
	set src in usr
	if (usr.incapacitated())
		return
	var/new_color = input(usr, "Pick a new color", "Wallet Color", color) as null | color
	if (!new_color || new_color == color || usr.incapacitated())
		return
	color = new_color


/obj/item/storage/wallet/poly/emp_act(severity)
	icon_state = "wallet-emp"
	update_icon()
	addtimer(new Callback(src, .proc/resolve_emp_timer), 5 SECONDS)
	..()


/obj/item/storage/wallet/poly/proc/resolve_emp_timer()
	icon_state = initial(icon_state)
	update_icon()
