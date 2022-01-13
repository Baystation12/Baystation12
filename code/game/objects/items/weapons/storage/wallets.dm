/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	icon = 'icons/obj/wallet.dmi'
	icon_state = "wallet-white"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL //Don't worry, see can_hold[]
	max_storage_space = 8
	can_hold = list(
		/obj/item/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/smokable,
		/obj/item/lipstick,
		/obj/item/haircomb,
		/obj/item/mirror,
		/obj/item/clothing/accessory/locket,
		/obj/item/clothing/head/hairflower,
		/obj/item/device/flashlight/pen,
		/obj/item/device/flashlight/slime,
		/obj/item/seeds,
		/obj/item/material/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/reagent_containers/glass/beaker/vial,
		/obj/item/flame,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/pill,
		/obj/item/device/radio/headset,
		/obj/item/device/encryptionkey,
		/obj/item/key,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/accessory/medal,
		/obj/item/clothing/accessory/armor_tag,
		/obj/item/clothing/ring,
		/obj/item/passport,
		/obj/item/clothing/accessory/pride_pin,
		/obj/item/clothing/accessory/pronouns
	)

	slot_flags = SLOT_ID

	var/obj/item/card/id/front_id = null

/obj/item/storage/wallet/leather
	color = COLOR_SEDONA

/obj/item/storage/wallet/Destroy()
	if(front_id)
		front_id.dropInto(loc)
		front_id = null
	. = ..()

/obj/item/storage/wallet/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			SetName(initial(name))
			update_icon()

/obj/item/storage/wallet/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/card/id))
			front_id = W
			update_icon()

/obj/item/storage/wallet/on_update_icon()
	overlays.Cut()
	if(front_id)
		var/tiny_state = "id-generic"
		if(("id-"+front_id.icon_state) in icon_states(icon))
			tiny_state = "id-"+front_id.icon_state
		var/image/tiny_image = new/image(icon, icon_state = tiny_state)
		tiny_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
		overlays += tiny_image

/obj/item/storage/wallet/GetIdCard()
	return front_id

/obj/item/storage/wallet/GetAccess()
	var/obj/item/I = GetIdCard()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet/random/New()
	..()
	var/item1_type = pick( /obj/item/spacecash/bundle/c10,/obj/item/spacecash/bundle/c100,/obj/item/spacecash/bundle/c1000,/obj/item/spacecash/bundle/c20,/obj/item/spacecash/bundle/c200,/obj/item/spacecash/bundle/c50, /obj/item/spacecash/bundle/c500)
	var/item2_type
	if(prob(50))
		item2_type = pick( /obj/item/spacecash/bundle/c10,/obj/item/spacecash/bundle/c100,/obj/item/spacecash/bundle/c1000,/obj/item/spacecash/bundle/c20,/obj/item/spacecash/bundle/c200,/obj/item/spacecash/bundle/c50, /obj/item/spacecash/bundle/c500)
	var/item3_type = pick( /obj/item/material/coin/silver, /obj/item/material/coin/silver, /obj/item/material/coin/gold, /obj/item/material/coin/iron, /obj/item/material/coin/iron, /obj/item/material/coin/iron )

	spawn(2)
		if(item1_type)
			new item1_type(src)
		if(item2_type)
			new item2_type(src)
		if(item3_type)
			new item3_type(src)
	update_icon()

/obj/item/storage/wallet/poly
	name = "polychromic wallet"
	desc = "You can recolor it! Fancy! The future is NOW!"

/obj/item/storage/wallet/poly/New()
	..()
	color = get_random_colour()
	update_icon()

/obj/item/storage/wallet/poly/verb/change_color()
	set name = "Change Wallet Color"
	set category = "Object"
	set desc = "Change the color of the wallet."
	set src in usr

	if(usr.incapacitated())
		return

	var/new_color = input(usr, "Pick a new color", "Wallet Color", color) as color|null
	if(!new_color || new_color == color || usr.incapacitated())
		return
	color = new_color

/obj/item/storage/wallet/poly/emp_act()
	icon_state = "wallet-emp"
	update_icon()

	spawn(200)
		if(src)
			icon_state = initial(icon_state)
			update_icon()
