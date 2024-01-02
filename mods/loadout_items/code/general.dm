// Big Gigachad Towels
/obj/item/rolled_towel
	name = "rolled big towel"
	desc = "A collapsed big towel - looks like you can't use it as a normal one... Try it on a beach."
	icon = 'packs/infinity/icons/obj/items.dmi'
	icon_state = "rolled_towel"
	w_class = 2

	force = 0.3 // Big soft towel is more harmless
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	// SIERRA TODO: port to Bay12 drop sounds
	// drop_sound = 'sound/items/drop/cloth.ogg'
	// pickup_sound = 'sound/items/pickup/cloth.ogg'

	var/beach_towel = /obj/structure/towel

/obj/item/rolled_towel/attack_self(mob/living/user as mob)
	var/obj/item/rolled_towel/R = new beach_towel(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/towel
	name = "big towel"
	icon = 'mods/loadout_items/icons/towels.dmi'
	icon_state = "beach_towel"
	anchored = FALSE
	var/rolled_towel = /obj/item/rolled_towel

/obj/structure/towel/attack_hand(mob/living/user as mob)
	..()
	if(!ishuman(user))
		return 0
	visible_message("<span class='notice'>[usr] rolled up [src].</span>")
	var/obj/item/rolled_towel/B = new rolled_towel(get_turf(src))
	usr.put_in_hands(B)
	qdel(src)

/obj/item/rolled_towel/black
	name = "black rolled towel"
	icon_state = "black_rolled_towel"
	beach_towel = /obj/structure/towel/black

/obj/structure/towel/black
	name = "black big towel"
	icon_state = "black_beach_towel"
	rolled_towel = /obj/item/rolled_towel/black

/obj/item/rolled_towel/blue_stripped
	name = "blue rolled towel"
	icon_state = "bluestripp_towel"
	beach_towel = /obj/structure/towel/blue_stripped

/obj/structure/towel/blue_stripped
	name = "blue big towel"
	icon_state = "bluestripp_beach"
	rolled_towel = /obj/item/rolled_towel/blue_stripped

/obj/item/rolled_towel/red_stripped
	name = "red rolled towel"
	icon_state = "redstripp_towel"
	beach_towel = /obj/structure/towel/red_stripped

/obj/structure/towel/red_stripped
	name = "red big towel"
	icon_state = "redstripp_beach"
	rolled_towel = /obj/item/rolled_towel/red_stripped

/obj/item/rolled_towel/green_stripped
	name = "green rolled towel"
	icon_state = "greenstripp_towel"
	beach_towel = /obj/structure/towel/green_stripped

/obj/structure/towel/green_stripped
	name = "green big towel"
	icon_state = "greenstripp_beach"
	rolled_towel = /obj/item/rolled_towel/green_stripped

/obj/item/rolled_towel/yellow_stripped
	name = "yellow rolled towel"
	icon_state = "yellowstripp_towel"
	beach_towel = /obj/structure/towel/yellow_stripped

/obj/structure/towel/yellow_stripped
	name = "green big towel"
	icon_state = "yellowstripp_beach"
	rolled_towel = /obj/item/rolled_towel/yellow_stripped

/obj/item/rolled_towel/pink_stripped
	name = "pink rolled towel"
	icon_state = "pinkstripp_towel"
	beach_towel = /obj/structure/towel/pink_stripped

/obj/structure/towel/pink_stripped
	name = "green big towel"
	icon_state = "pinkstripp_beach"
	rolled_towel = /obj/item/rolled_towel/pink_stripped

/obj/item/rolled_towel/ilove
	name = "*i <3 you* rolled towel"
	icon_state = "rolled_towel"
	beach_towel = /obj/structure/towel/ilove

/obj/structure/towel/ilove
	name = "*i <3 you* big towel"
	icon_state = "ilove_beach"
	rolled_towel = /obj/item/rolled_towel/ilove

/obj/item/rolled_towel/fitness
	name = "rolled fitness mat"
	desc = "A fitness mat - place it in a gym for better training.."
	icon_state = "rolled_gym_beach"
	beach_towel = /obj/structure/towel/fitness

/obj/structure/towel/fitness
	name = "fitness mat"
	icon_state = "gym_beach"
	rolled_towel = /obj/item/rolled_towel/fitness

/obj/structure/towel/holo
	name = "big holographic towel"
	icon = 'mods/loadout_items/icons/towels.dmi'
	icon_state = "beach_towel"
	anchored = TRUE
	rolled_towel = null

/obj/structure/towel/holo/attack_hand(mob/living/user as mob)
	return

/obj/structure/towel/holo/ilove
	name = "*i <3 you* big towel"
	icon_state = "ilove_beach"

/obj/structure/towel/holo/blue_stripped
	name = "blue big towel"
	icon_state = "bluestripp_beach"

// Cards

/obj/item/deck/compact
	name = "compact deck of cards"
	desc = "A deck of playing cards. Looks like this one hasn't numbers from two to five, and jokers."
	icon_state = "deck"

/obj/item/deck/compact/New()
	..()

	var/datum/playingcard/P
	for(var/suit in list("spades", "clubs", "diamonds", "hearts"))

		var/colour
		if(suit == "spades" || suit == "clubs")
			colour = "black_"
		else
			colour = "red_"

		for(var/number in list("ace", "six", "seven", "eight", "nine", "ten"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]num"
			P.back_icon = "card_back"
			cards += P

		for(var/number in list("jack", "queen", "king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]col"
			P.back_icon = "card_back"
			cards += P

// Zippo

/obj/item/flame/lighter/zippo/fancy
	name = "engraved zippo"
	icon = 'mods/loadout_items/icons/lighters.dmi'
	icon_state = "engraved"

/obj/item/flame/lighter/zippo/fancy/gold
	name = "golden zippo"
	icon_state = "gold"

/obj/item/flame/lighter/zippo/fancy/station
	name = "13'th zippo "
	icon_state = "13"

/obj/item/flame/lighter/zippo/fancy/black
	name = "cross zippo"
	icon_state = "black"

/obj/item/flame/lighter/zippo/fancy/blue
	name = "blue zippo"
	icon_state = "bluezippo"

/obj/item/flame/lighter/zippo/fancy/red
	name = "red-white zippo"
	icon_state = "redzippo"

/obj/item/flame/lighter/zippo/fancy/butterfly
	name = "butterfly zippo"
	icon_state = "butterzippo"

/obj/item/flame/lighter/zippo/fancy/fancy
	name = "flower zippo"
	icon_state = "fancyzippo"

/obj/item/flame/lighter/zippo/fancy/on_update_icon()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)

	if(lit)
		icon_state = "[bis.base_icon_state]_on"
		item_state = "[bis.base_icon_state]_on"
	else
		icon_state = "[bis.base_icon_state]"
		item_state = "[bis.base_icon_state]"

// Wheelchair

/obj/item/wheelchair_kit
	name = "compressed wheelchair kit"
	desc = "Collapsed parts, prepared to immediately spring into the shape of a wheelchair."
	icon = 'packs/infinity/icons/obj/items.dmi'
	icon_state = "wheelchair-item"
	item_state = "rbed"
	w_class = ITEM_SIZE_LARGE

/obj/item/wheelchair_kit/attack_self(mob/user)
	visible_message("<b>[user]</b> starts lay out \the [src.name].")
	if(do_after(user, 4 SECONDS, src))
		var/obj/structure/bed/chair/wheelchair/W = new /obj/structure/bed/chair/wheelchair(get_turf(user))
		visible_message(SPAN_NOTICE("<b>[user]</b> lay out \the [W.name]."))
		W.add_fingerprint(user)
		qdel(src)
