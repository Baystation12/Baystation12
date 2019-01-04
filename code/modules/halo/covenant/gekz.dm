
/obj/item/weapon/spacecash/bundle/gekz1
	name = "1 gekz"
	desc = "It's worth 1 gekz."
	worth = 1
	currency = "gekz"
	icon_state = "gekz1"
	icon_state_base = "gekz"

/obj/item/weapon/spacecash/bundle/gekz10
	name = "10 gekz"
	desc = "It's worth 10 gekz."
	worth = 10
	currency = "gekz"
	icon_state = "gekz10"
	icon_state_base = "gekz"

/obj/item/weapon/spacecash/bundle/gekz20
	name = "20 gekz"
	desc = "It's worth 20 gekz."
	worth = 20
	currency = "gekz"
	icon_state = "gekz20"
	icon_state_base = "gekz"

/obj/item/weapon/spacecash/bundle/gekz50
	name = "100 gekz"
	desc = "It's worth 100 gekz."
	worth = 100
	currency = "gekz"
	icon_state = "gekz100"
	icon_state_base = "gekz"

/obj/item/weapon/spacecash/bundle/gekz100
	name = "100 gekz"
	desc = "It's worth 100 gekz."
	worth = 100
	currency = "gekz"
	icon_state = "gekz100"
	icon_state_base = "gekz"

/obj/item/weapon/spacecash/bundle/gekz200
	name = "200 gekz"
	desc = "It's worth 200 gekz."
	worth = 200
	currency = "gekz"
	icon_state = "gekz200"
	icon_state_base = "gekz"

/obj/item/weapon/spacecash/bundle/gekz500
	name = "500 gekz"
	desc = "It's worth 500 gekz."
	worth = 500
	currency = "gekz"
	icon_state = "gekz500"
	icon_state_base = "gekz"

/obj/item/weapon/spacecash/bundle/gekz1000
	name = "1000 gekz"
	desc = "It's worth 1000 gekz."
	worth = 1000
	currency = "gekz"
	icon_state = "gekz1000"
	icon_state_base = "gekz"

/obj/item/weapon/spacecash/bundle/random
	name = "a random bundle of cash"
	icon_state = "cash100"
	var/amount_lower = 5
	var/amount_upper = 95

/obj/item/weapon/spacecash/bundle/random/New()
	. = ..()
	worth = rand(amount_lower, amount_upper)
	update_icon()

/obj/item/weapon/spacecash/bundle/random/gekz
	name = "a random bundle of gekz"
	currency = "gekz"
	icon_state = "gekz100"
	icon_state_base = "gekz"
