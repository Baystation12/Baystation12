/obj/item/weapon/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	icon = 'icons/obj/wallet.dmi'
	icon_state = "wallet-white"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL //Don't worry, see can_hold[]
	max_storage_space = 8
	can_hold = list(
		/obj/item/weapon/spacecash,
		/obj/item/weapon/card,
		/obj/item/clothing/mask/smokable,
		/obj/item/weapon/lipstick,
		/obj/item/weapon/haircomb,
		/obj/item/weapon/mirror,
		/obj/item/clothing/accessory/locket,
		/obj/item/clothing/head/hairflower,
		/obj/item/device/flashlight/pen,
		/obj/item/device/flashlight/slime,
		/obj/item/seeds,
		/obj/item/weapon/coin,
		/obj/item/weapon/dice,
		/obj/item/weapon/disk,
		/obj/item/weapon/implant,
		/obj/item/weapon/implanter,
		/obj/item/weapon/flame,
		/obj/item/weapon/paper,
		/obj/item/weapon/paper_bundle,
		/obj/item/weapon/pen,
		/obj/item/weapon/photo,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/glass/beaker/vial,
		/obj/item/device/radio/headset,
		/obj/item/device/paicard,
		/obj/item/weapon/stamp)
	slot_flags = SLOT_ID

	var/obj/item/weapon/card/id/front_id = null

/obj/item/weapon/storage/wallet/leather
	color = COLOR_SEDONA

/obj/item/weapon/storage/wallet/Destroy()
	if(front_id)
		front_id.dropInto(loc)
		front_id = null
	. = ..()

/obj/item/weapon/storage/wallet/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			name = initial(name)
			update_icon()

/obj/item/weapon/storage/wallet/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/weapon/card/id))
			front_id = W
			name = "[name] ([front_id])"
			update_icon()

/obj/item/weapon/storage/wallet/update_icon()
	overlays.Cut()
	if(front_id)
		var/tiny_state = "id-generic"
		if("id-"+front_id.icon_state in icon_states(icon))
			tiny_state = "id-"+front_id.icon_state
		var/image/tiny_image = new/image(icon, icon_state = tiny_state)
		tiny_image.appearance_flags = RESET_COLOR
		overlays += tiny_image

/obj/item/weapon/storage/wallet/GetIdCard()
	return front_id

/obj/item/weapon/storage/wallet/GetAccess()
	var/obj/item/I = GetIdCard()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/weapon/storage/wallet/random/New()
	..()
	var/item1_type = pick( /obj/item/weapon/spacecash/bundle/c10,/obj/item/weapon/spacecash/bundle/c100,/obj/item/weapon/spacecash/bundle/c1000,/obj/item/weapon/spacecash/bundle/c20,/obj/item/weapon/spacecash/bundle/c200,/obj/item/weapon/spacecash/bundle/c50, /obj/item/weapon/spacecash/bundle/c500)
	var/item2_type
	if(prob(50))
		item2_type = pick( /obj/item/weapon/spacecash/bundle/c10,/obj/item/weapon/spacecash/bundle/c100,/obj/item/weapon/spacecash/bundle/c1000,/obj/item/weapon/spacecash/bundle/c20,/obj/item/weapon/spacecash/bundle/c200,/obj/item/weapon/spacecash/bundle/c50, /obj/item/weapon/spacecash/bundle/c500)
	var/item3_type = pick( /obj/item/weapon/coin/silver, /obj/item/weapon/coin/silver, /obj/item/weapon/coin/gold, /obj/item/weapon/coin/iron, /obj/item/weapon/coin/iron, /obj/item/weapon/coin/iron )

	spawn(2)
		if(item1_type)
			new item1_type(src)
		if(item2_type)
			new item2_type(src)
		if(item3_type)
			new item3_type(src)
	update_icon()

/obj/item/weapon/storage/wallet/poly
	name = "polychromic wallet"
	desc = "You can recolor it! Fancy! The future is NOW!"

/obj/item/weapon/storage/wallet/poly/New()
	..()
	color = get_random_colour()
	update_icon()

/obj/item/weapon/storage/wallet/poly/verb/change_color()
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

/obj/item/weapon/storage/wallet/poly/emp_act()
	icon_state = "wallet-emp"
	update_icon()

	spawn(200)
		if(src)
			icon_state = initial(icon_state)
			update_icon()
