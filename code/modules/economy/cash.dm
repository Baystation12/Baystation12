/obj/item/weapon/spacecash
	name = "0 credits"
	desc = "It's worth 0 credits."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "credits1"
	var/icon_state_base = "credits"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_TINY
	var/access = list()
	access = access_crate_cash
	var/worth = 0
	var/global/denominations = list(1000,500,200,100,50,20,10,1)
	var/currency = "credits"

/obj/item/weapon/spacecash/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/spacecash))
		if(istype(W, /obj/item/weapon/spacecash/ewallet)) return 0

		var/obj/item/weapon/spacecash/bundle/bundle = W
		if(bundle.currency != src.currency)
			to_chat(user, "\icon[src] <span class='warning'>[src] is a different kind of currency.</span>")
			return

		if(!istype(W, /obj/item/weapon/spacecash/bundle))
			var/obj/item/weapon/spacecash/cash = W
			user.drop_from_inventory(cash)
			bundle = new type(src.loc)
			bundle.worth += cash.worth
			qdel(cash)
		else //is bundle
			bundle = W
		bundle.worth += src.worth
		bundle.update_icon()
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user
			h_user.drop_from_inventory(src)
			h_user.drop_from_inventory(bundle)
			h_user.put_in_hands(bundle)
		to_chat(user, "<span class='notice'>You add [src.worth] worth of [currency] to the bundles.<br>It holds [bundle.worth] [currency] now.</span>")
		qdel(src)

/obj/item/weapon/spacecash/proc/getMoneyImages()
	if(icon_state)
		return list(icon_state)

/obj/item/weapon/spacecash/bundle
	name = "pile of credits"
	icon_state = ""
	desc = "They are worth 0 credits."
	worth = 0

/obj/item/weapon/spacecash/bundle/getMoneyImages()
	. = list()
	var/sum = src.worth
	var/num = 0
	for(var/i in denominations)
		while(sum >= i && num < 50)
			sum -= i
			num++
			. += "[icon_state_base][i]"
	if(num == 0) // Less than one credit, let's just make it look like 1 for ease
		. += "[icon_state_base]1"

/obj/item/weapon/spacecash/bundle/update_icon()
	overlays.Cut()
	var/list/images = src.getMoneyImages()

	for(var/A in images)
		var/image/banknote = image('icons/obj/items.dmi', A)
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		src.overlays += banknote

	src.desc = "They are worth [worth] [currency]."
	if(worth in denominations)
		src.name = "[worth] [currency]"
	else
		src.name = "pile of [worth] [currency]"

	if(overlays.len <= 2)
		w_class = ITEM_SIZE_TINY
	else
		w_class = ITEM_SIZE_SMALL

/obj/item/weapon/spacecash/bundle/attack_self()
	var/amount = input(usr, "How many [currency] do you want to take out? (0 to [src.worth])", "Take Money", 20) as num
	var/result = split_off(amount, usr)
	if(result)
		usr.put_in_hands(result)
	else
		return 0

/obj/item/weapon/spacecash/bundle/proc/split_off(var/amount, var/mob/user)
	amount = round(Clamp(amount, 0, src.worth))
	if(amount==0) return 0

	src.worth -= amount
	src.update_icon()
	if(!worth)
		user.drop_from_inventory(src)
	if(amount in list(1000,500,200,100,50,20,1))
		var/cashtype = text2path("/obj/item/weapon/spacecash/bundle/[currency][amount]")
		var/obj/cash = new cashtype (user.loc, currency)
		. = cash
	else
		var/obj/item/weapon/spacecash/bundle/bundle = new (user.loc, currency, amount)
		bundle.worth = amount
		bundle.update_icon()
		. = bundle
	if(!worth)
		qdel(src)

/obj/item/weapon/spacecash/bundle/credits1
	name = "1 credit"
	icon_state = "credits1"
	desc = "It's worth 1 credit."
	worth = 1

/obj/item/weapon/spacecash/bundle/credits10
	name = "10 credits"
	icon_state = "credits10"
	desc = "It's worth 10 credits."
	worth = 10

/obj/item/weapon/spacecash/bundle/credits20
	name = "20 credits"
	icon_state = "credits20"
	desc = "It's worth 20 credits."
	worth = 20

/obj/item/weapon/spacecash/bundle/credits50
	name = "50 credits"
	icon_state = "credits50"
	desc = "It's worth 50 credits."
	worth = 50

/obj/item/weapon/spacecash/bundle/credits100
	name = "100 credits"
	icon_state = "credits100"
	desc = "It's worth 100 credits."
	worth = 100

/obj/item/weapon/spacecash/bundle/credits200
	name = "200 credits"
	icon_state = "credits200"
	desc = "It's worth 200 credits."
	worth = 200

/obj/item/weapon/spacecash/bundle/credits500
	name = "500 credits"
	icon_state = "credits500"
	desc = "It's worth 500 credits."
	worth = 500

/obj/item/weapon/spacecash/bundle/credits1000
	name = "1000 credits"
	icon_state = "credits1000"
	desc = "It's worth 1000 credits."
	worth = 1000

proc/spawn_money(var/sum, spawnloc, mob/living/carbon/human/human_user as mob, var/currency_name = "credits")
	if(sum in list(1000,500,200,100,50,20,10,1))
		var/cash_type = text2path("/obj/item/weapon/spacecash/bundle/[currency_name][sum]")
		var/obj/cash = new cash_type (usr.loc)
		if(ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(cash)
	else
		var/obj/item/weapon/spacecash/bundle/bundle = new (spawnloc)
		bundle.currency = currency_name
		bundle.icon_state_base = currency_name
		bundle.worth = sum
		bundle.update_icon()
		if (ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(bundle)
	return

/obj/item/weapon/spacecash/ewallet
	name = "Charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/weapon/spacecash/ewallet/examine(mob/user)
	. = ..(user)
	if (!(user in view(2)) && user!=src.loc) return
	to_chat(user, "<span class='notice'>Charge card's owner: [src.owner_name]. Credits remaining: [src.worth].</span>")
