/obj/structure/vending_refill
	name = "vendor restock"
	desc = "A large sealed container containing items sold from a vending machine."
	icon = 'icons/obj/closets/bases/large_crate.dmi'
	icon_state = "base"
	color = COLOR_BEASTY_BROWN
	w_class = ITEM_SIZE_HUGE

	var/expected_type
	var/list/product_records


/obj/structure/vending_refill/Destroy()
	QDEL_NULL_LIST(product_records)
	return ..()


/obj/structure/vending_refill/get_lore_info()
	return "Vendor restock containers are notoriously difficult to open, representing the pinnacle of humanity's antitheft technologies."


/obj/structure/vending_refill/get_mechanics_info()
	return "Drag to a vendor to restock. Generally can not be opened."


/obj/structure/vending_refill/MouseDrop(obj/machinery/vending/vendor)
	if (!CanMouseDrop(vendor, usr))
		return
	if (!istype(vendor))
		return ..()
	var/target_type = vendor.base_type || vendor.type
	if (!ispath(expected_type, target_type))
		return ..()
	for (var/datum/stored_items/refill_product in product_records)
		for (var/datum/stored_items/vendor_product in vendor.product_records)
			if (vendor_product.merge(refill_product))
				break
		if (!QDELETED(refill_product))
			refill_product.migrate(vendor)
			vendor.product_records += refill_product
	product_records = null
	SSnano.update_uis(vendor)
	qdel(src)
