// chip sprites from this PR: https://github.com/new-frontiers-14/frontier-station-14/pull/4445

/obj/item/stack/pokerchip
	singular_name = "Poker chip"
	plural_name = "Poker chips"
	icon = 'icons/obj/pokerchips.dmi'
	icon_state = "pokerchip"
	base_state = "pokerchip"
	plural_icon_state = "pokerchip_stack"
	max_icon_state = "pokerchip_stack"
	amount = 20
	max_amount = 100
	w_class = ITEM_SIZE_TINY
	var/value = 1

/obj/item/stack/pokerchip/five
	singular_name = "5-credit Poker Chip"
	plural_name = "5-credit Poker Chips"
	base_state = "pokerchip_5"
	plural_icon_state = "pokerchip_5_stack"
	value = 5

/obj/item/stack/pokerchip/ten
	singular_name = "10-credit Poker Chip"
	plural_name = "10-credit Poker Chips"
	base_state = "pokerchip_10"
	plural_icon_state = "pokerchip_10_stack"
	value = 10

/obj/item/stack/pokerchip/twentyfive
	singular_name = "25-credit Poker Chip"
	plural_name = "25-credit Poker Chips"
	base_state = "pokerchip_25"
	plural_icon_state = "pokerchip_25_stack"
	value = 25

/obj/item/stack/pokerchip/fifty
	singular_name = "50-credit Poker Chip"
	plural_name = "50-credit Poker Chips"
	base_state = "pokerchip_50"
	plural_icon_state = "pokerchip_50_stack"
	value = 50

/obj/item/stack/pokerchip/hundred
	singular_name = "100-credit Poker Chip"
	plural_name = "100-credit Poker Chips"
	base_state = "pokerchip_100"
	plural_icon_state = "pokerchip_100_stack"
	value = 100

/obj/item/stack/pokerchip/twofifty
	singular_name = "250-credit Poker Chip"
	plural_name = "250-credit Poker Chips"
	base_state = "pokerchip_250"
	plural_icon_state = "pokerchip_250_stack"
	value = 250

/obj/item/stack/pokerchip/fivehundred
	singular_name = "500-credit Poker Chip"
	plural_name = "500-credit Poker Chips"
	base_state = "pokerchip_500"
	plural_icon_state = "pokerchip_500_stack"
	value = 500

/obj/item/stack/pokerchip/thousand
	singular_name = "1000-credit Poker Chip"
	plural_name = "1000-credit Poker Chips"
	base_state = "pokerchip_1000"
	plural_icon_state = "pokerchip_1000_stack"
	value = 1000

/obj/item/stack/pokerchip/proc/update()
	SetName(get_stack_name())
	if(amount>1 && value > 1)
		SetName("[name] [plural_name]")
		desc = "A stack of poker chips. These are worth [value] credits each."
		gender = PLURAL
		icon_state = plural_icon_state
	else if(amount>1)
		SetName("[name] [plural_name]")
		desc = "A stack of poker chips. These are worth one credit each."
		icon_state = plural_icon_state
		gender = PLURAL
	else if(value > 1)
		SetName("[name] [plural_name]")
		desc = "A poker chip. This are worth [value] credits each."
		gender = NEUTER
		icon_state = base_state
	else
		SetName("[name] [singular_name]")
		desc = "A poker chip. This one is worth one credit."
		gender = NEUTER
		icon_state = base_state

/obj/item/stack/pokerchip/use(used)
	. = ..()
	update()
	return

/obj/item/stack/pokerchip/Initialize()
	. = ..()
	update()

/obj/item/stack/proc/add_to_stacks(mob/user, check_hands)
	update()