#define MANUFACTURER_NANOTRASEN "NT"
#define MANUFACTURER_HEPHAESTUS "HEP"
#define MANUFACTURER_LAWSON_ARMS "LA"
#define MANUFACTURER_WARD_TAKAHASHI "WT"
#define MANUFACTURER_NOVAYA_ZEMLYA "NZ"
#define MANUFACTURER_HELTEK "HT"
#define MANUFACTURER_LUMOCO "LUM"
#define MANUFACTURER_AL_MALIKI_MOSLEY "AM"
#define MANUFACTURER_ZVEZMEKH "ZM"
#define MANUFACTURER_MARS_MILITARY "MI"
#define MANUFACTURER_AMARANTH_ARMORERS "AA"
#define MANUFACTURER_FALLBACK "FX"

#define FILED_SERIAL_NUMBER ""

GLOBAL_LIST_EMPTY(used_gun_serial_numbers)

/obj/item/gun
	/// The serial of the gun. If null, the gun doesn't have one.
	/// If empty string (FILED_SERIAL_NUMBER), it was filed off.
	var/serial_number = null
	/// The manufacturer of the gun. If null, no serial number will be generated.
	var/manufacturer = null

/obj/item/gun/Initialize()
	. = ..()
	if (isnull(serial_number) && !isnull(manufacturer))
		serial_number = generate_serial_number()

/obj/item/gun/PostFabrication()
	. = ..()
	serial_number = generate_fabricator_serial_number()

/obj/item/gun/examine(mob/user, distance, is_adjacent)
	. = ..()
	if (distance > 1)
		return
	if (serial_number && serial_number != FILED_SERIAL_NUMBER)
		to_chat(user, "The serial number is [serial_number].")
	else if (serial_number == FILED_SERIAL_NUMBER)
		to_chat(user, "The serial number was filed off!")

/obj/item/gun/use_tool(obj/item/tool, mob/user, list/click_params)
	// Screwdriver - File off serial number
	if (!isScrewdriver(tool) || serial_number == FILED_SERIAL_NUMBER)
		return ..()
	playsound(src, 'sound/effects/metal_file.ogg', 50, TRUE)
	add_fingerprint(user)
	user.visible_message(
		SPAN_WARNING("\The [user] begins to vigurously scrape the \the [src] with \the [tool]!"),
		SPAN_WARNING("You begin to file the serial number off \the [src]."),
		SPAN_WARNING("You hear the horrible sound of scraping metal.")
	)
	if (do_after(user, 6 SECONDS, src, DO_PUBLIC_UNIQUE | DO_BAR_OVER_USER))
		serial_number = FILED_SERIAL_NUMBER
		user.visible_message(
			SPAN_WARNING("\The [user] finshing scraping something off \the [src] with \the [tool]!"),
			SPAN_WARNING("You finish filing the serial number off \the [src].")
		)
	return ..()

/obj/item/gun/proc/generate_fabricator_serial_number()
	var/gen = "FAB" + num2text(rand(1, 9999), 9)
	if (GLOB.used_gun_serial_numbers[gen])
		return generate_fabricator_serial_number()
	GLOB.used_gun_serial_numbers[gen] = TRUE
	return gen

/obj/item/gun/proc/generate_serial_number()
	var/gen = manufacturer + roll_serial_digits()
	if (GLOB.used_gun_serial_numbers[gen])
		return generate_serial_number()
	GLOB.used_gun_serial_numbers[gen] = TRUE
	return gen

/obj/item/gun/proc/roll_serial_digits(padding = "0")
	var/static/list/maximums = list(9999, 99999, 999999)
	return pad_left(num2text(rand(1, maximums[rand(1, 3)]), 9), 7, padding)

#undef FILED_SERIAL_NUMBER
