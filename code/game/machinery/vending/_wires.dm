/datum/wires/vending
	holder_type = /obj/machinery/vending
	wire_count = 4

	// Vending machine wire field indices.
	var/const/WIRE_THROW_PRODUCTS = FLAG(0)
	var/const/WIRE_SHOW_CONTRABAND = FLAG(1)
	var/const/WIRE_SHOCK_USERS = FLAG(2)
	var/const/WIRE_SCAN_ID = FLAG(3)

	descriptions = list(
		new /datum/wire_description (WIRE_THROW_PRODUCTS, "This wire leads to the item dispensor force controls."),
		new /datum/wire_description (WIRE_SHOW_CONTRABAND, "This wire appears connected to a reserve inventory compartment."),
		new /datum/wire_description (WIRE_SHOCK_USERS, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description (WIRE_SCAN_ID, "This wire is connected to the ID scanning panel.", SKILL_EXPERIENCED)
	)


/datum/wires/vending/GetInteractWindow(mob/user)
	var/obj/machinery/vending/vendor = holder
	. += ..()
	. += "<BR>The orange light is [vendor.seconds_electrified ? "off" : "on"].<BR>"
	. += "The red light is [vendor.shoot_inventory ? "blinking" : "off"].<BR>"
	. += "The green light is [(vendor.IsShowingContraband()) ? "on" : "off"].<BR>"
	. += "The [vendor.scan_id ? "purple" : "yellow"] light is on.<BR>"


/datum/wires/vending/CanUse(mob/living/user)
	var/obj/machinery/vending/vendor = holder
	if (!istype(user, /mob/living/silicon))
		if (vendor.seconds_electrified)
			if (vendor.shock(user, 100))
				return FALSE
	if (vendor.panel_open)
		return TRUE
	return FALSE


/datum/wires/vending/UpdatePulsed(index)
	var/obj/machinery/vending/vendor = holder
	switch (index)
		if (WIRE_THROW_PRODUCTS)
			if (IsIndexCut(WIRE_THROW_PRODUCTS))
				vendor.shoot_inventory = TRUE
			else
				vendor.shoot_inventory = !vendor.shoot_inventory
		if (WIRE_SHOW_CONTRABAND)
			if (IsIndexCut(WIRE_SHOW_CONTRABAND))
				vendor.UpdateShowContraband(TRUE)
			else
				vendor.UpdateShowContraband()
		if (WIRE_SHOCK_USERS)
			if (IsIndexCut(WIRE_SHOCK_USERS))
				vendor.seconds_electrified = -1
			else
				vendor.seconds_electrified = 30
		if (WIRE_SCAN_ID)
			if (IsIndexCut(WIRE_SCAN_ID))
				vendor.scan_id = !initial(vendor.scan_id)
			else
				vendor.scan_id = !vendor.scan_id


/datum/wires/vending/UpdateCut(index, mended)
	var/obj/machinery/vending/vendor = holder
	switch (index)
		if (WIRE_THROW_PRODUCTS)
			vendor.shoot_inventory = !mended
		if (WIRE_SHOW_CONTRABAND)
			vendor.UpdateShowContraband(!mended)
		if (WIRE_SHOCK_USERS)
			vendor.seconds_electrified = mended ? 0 : -1
		if (WIRE_SCAN_ID)
			vendor.scan_id = initial(vendor.scan_id)
			if (!mended)
				vendor.scan_id = !vendor.scan_id


/// Returns truthy when the throw products wire is cut.
/datum/wires/vending/proc/GetThrowProducts()
	return HAS_FLAGS(wires_status, WIRE_THROW_PRODUCTS)


/// Update the throw products wire index, flipping if null.
/datum/wires/vending/proc/UpdateThrowProducts(cut_wire)
	UpdateWire(WIRE_THROW_PRODUCTS, cut_wire)


/// Returns truthy when the show contraband wire is cut.
/datum/wires/vending/proc/GetShowContraband()
	return HAS_FLAGS(wires_status, WIRE_SHOW_CONTRABAND)


/// Update the show contraband wire index, flipping if null.
/datum/wires/vending/proc/UpdateShowContraband(cut_wire)
	UpdateWire(WIRE_SHOW_CONTRABAND, cut_wire)


/// Returns truthy when the shock users wire is cut.
/datum/wires/vending/proc/GetShockUsers()
	return HAS_FLAGS(wires_status, WIRE_SHOCK_USERS)


/// Update the shock users wire index, flipping if null.
/datum/wires/vending/proc/UpdateShockUsers(cut_wire)
	UpdateWire(WIRE_SHOCK_USERS, cut_wire)


/// Returns truthy when the scan ID wire is cut.
/datum/wires/vending/proc/GetScanIdCut()
	return HAS_FLAGS(wires_status, WIRE_SCAN_ID)


/// Update the scan id wire index, flipping if null.
/datum/wires/vending/proc/UpdateScanId(cut_wire)
	UpdateWire(WIRE_SCAN_ID, cut_wire)
