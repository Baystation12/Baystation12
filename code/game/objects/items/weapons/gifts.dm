/obj/item/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/parcels.dmi'
	icon_state = "gift1"
	item_state = "gift1"
	randpixel = 10

/obj/item/a_gift/New()
	..()
	if(w_class > 0 && w_class < ITEM_SIZE_HUGE)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"
	return

/obj/item/a_gift/ex_act()
	qdel(src)
	return

/obj/item/a_gift/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/storage/wallet,
		/obj/item/storage/photo_album,
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/backpack/holding,
		/obj/item/storage/belt/champion,
		/obj/item/pickaxe/hand/silver,
		/obj/item/pen/invisible,
		/obj/item/lipstick/random,
		/obj/item/grenade/smokebomb,
		/obj/item/carvable/corncob,
		/obj/item/contraband/poster,
		/obj/item/book/manual/barman_recipes,
		/obj/item/book/manual/chef_recipes,
		/obj/item/bikehorn,
		/obj/item/beach_ball,
		/obj/item/beach_ball/holoball,
		/obj/item/toy/water_balloon,
		/obj/item/toy/blink,
		/obj/item/toy/crossbow,
		/obj/item/gun/projectile/revolving/capgun,
		/obj/item/toy/katana,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/prize/powerloader,
		/obj/item/toy/prize/seraph,
		/obj/item/toy/spinningtoy,
		/obj/item/toy/sword,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris,
		/obj/item/device/paicard,
		/obj/item/device/synthesized_instrument/violin,
		/obj/item/storage/belt/utility/full,
		/obj/item/clothing/accessory/horrible,
		/obj/item/storage/box/large/foam_gun,
		/obj/item/storage/box/large/foam_gun/burst,
		/obj/item/storage/box/large/foam_gun/revolver)

	if(!ispath(gift_type,/obj/item))	return

	var/obj/item/I = new gift_type(M)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)
