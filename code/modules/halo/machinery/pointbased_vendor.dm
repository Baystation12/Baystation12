#define REQPOINT_MAX 4

GLOBAL_LIST_INIT(mobs_to_reqdatum,list())

/datum/vendor_req
	var/mob/mob_ref
	var/list/reqd_items = list() //Format: item = purchased-for price
	var/point_max
	var/point_current

/datum/vendor_req/New(var/mobref,var/reqmax)
	mob_ref = mobref
	point_max = reqmax
	point_current = point_max

//In this vendor, items are not limited on an overall basis. Instead, they operate on an overall point limit.
/obj/machinery/pointbased_vending
	name = "Point-based vendor"
	desc = "A vendor that somehow tracks your amount of requisition points, like magic."
	icon = 'code/modules/halo/icons/machinery/gunvend.dmi'
	icon_state ="ironhammer"
	layer = BELOW_OBJ_LAYER
	density = 1
	anchored = 1
	ai_access_level = 3
	idle_power_usage = 150
	clicksound = "button"
	clickvol = 40
	var/icon_deny = "ironhammer-deny"
	var/icon_vend = "ironhammer"
	var/vend_ready = 1
	var/vend_delay = 10

	var/list/product_records = list()

	var/list/products = list() //This vendor holds unlimited amounts. Format: typepath = pointprice
	var/list/amounts = list() //Format: Typepath = amount. Only put amounts here if you want to limit them.

/obj/machinery/pointbased_vending/proc/init_mob_reqdatum(var/mob/m)
	GLOB.mobs_to_reqdatum[m] = new /datum/vendor_req (m,REQPOINT_MAX)

/obj/machinery/pointbased_vending/New()
	src.build_inventory()
	power_change()

/obj/machinery/pointbased_vending/proc/get_user_profile(var/mob/user)
	var/mobdatum = GLOB.mobs_to_reqdatum[user]
	if(!mobdatum)
		init_mob_reqdatum(user)
		mobdatum = GLOB.mobs_to_reqdatum[user]
	return mobdatum

/obj/machinery/pointbased_vending/proc/build_inventory()

	for(var/entry in products)
		if(!ispath(entry))
			src.product_records.Add(entry)
			continue
		var/datum/stored_items/vending_products/product = new/datum/stored_items/vending_products(src, entry)

		product.price = src.products[entry]
		var/custom_prod_amt = amounts[entry]
		if(custom_prod_amt)
			product.amount = custom_prod_amt
		else
			product.amount = 100

		src.product_records.Add(product)

/obj/machinery/pointbased_vending/attack_hand(var/mob/living/m)
	if(istype(m))
		ui_interact(m)

/obj/machinery/pointbased_vending/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	var/list/listed_products = list()
	var/datum/vendor_req/user_req = get_user_profile(user)
	if(!user_req)
		to_chat(user,"<span class = 'notice'>[src] beeps a warning as if fails to detect your identity.</span>")
		return

	for(var/key = 1 to src.product_records.len)
		var/datum/stored_items/vending_products/I = src.product_records[key]
		if(istype(I))
			listed_products.Add(list(list(
				"key" = key,
				"name" = I.item_name,
				"price" = I.price,
				"color" = I.display_color,
				"amount" = I.get_amount())))
		else
			listed_products.Add(list(list(
				"key" = key,
				"name" = I,
				"price" = -1,
				"color" = null,
				"amount" = -1)))

	data["products"] = listed_products
	data["pointsleft"] = user_req.point_current
	data["pointsmax"] = user_req.point_max

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "vending_machine_pointbased.tmpl", src.name, 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/pointbased_vending/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(..())
		return

	if ((usr.contents.Find(src) || ((in_range(src, usr) || istype(usr,/mob/living/silicon/ai)) && istype(src.loc, /turf))))
		if ((href_list["vend"]) && vend_ready)
			var/datum/vendor_req/user_req = get_user_profile(usr)
			if(!user_req)
				return
			if((!allowed(usr)))
				to_chat(usr, "<span class='warning'>Access denied.</span>")
				flick(icon_deny,src)
				return
			var/key = text2num(href_list["vend"])
			var/datum/stored_items/vending_products/R = product_records[key]
			if(user_req.point_current >= R.price)
				user_req.point_current -= R.price
			else
				to_chat(usr,"<span class = 'warning'>Insufficient requisition points for purchase.</span>")
				return

			vend_ready = 0
			flick(icon_vend,src)
			spawn(vend_delay)
				var/prod = R.get_product(get_turf(src))
				user_req.reqd_items[prod] = R.price
				vend_ready = 1

		src.add_fingerprint(usr)
		GLOB.nanomanager.update_uis(src)

/obj/machinery/pointbased_vending/proc/do_refund_checks(var/obj/item/weapon/gun/projectile/p,var/user)
	if(istype(p))
		if(p.load_method == 4 && !p.ammo_magazine)
			to_chat(user,"<span class = 'notice'>[p] needs a magazine loaded before it can be refunded.</span>")
			return 0
	return 1

/obj/machinery/pointbased_vending/attackby(obj/item/weapon/W, mob/living/user)
	if(!istype(user))
		return
	var/datum/vendor_req/user_req = get_user_profile(user)
	if(W in user_req.reqd_items)
		if(!do_refund_checks(W,user))
			return
		to_chat(user,"<span class = 'notice'>You insert [W] into [src], refunding your requisition points.</span>")
		user.drop_from_inventory(W)
		W.loc = null
		user_req.point_current += user_req.reqd_items[W]
		user_req.reqd_items -= W
		GLOB.nanomanager.update_uis(src)
	else
		to_chat(user,"<span class = 'notice'>[src] rejects [W]</span>")

/obj/machinery/pointbased_vending/Destroy()
	for(var/datum/stored_items/vending_products/R in product_records)
		qdel(R)
	product_records = null
	return ..()

/obj/machinery/pointbased_vending/ex_act(severity)
	return