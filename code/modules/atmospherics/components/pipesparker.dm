/obj/machinery/atmospherics/pipe/cap/sparker
	name = "pipe sparker"
	desc = "A pipe sparker. Useful for starting pipe fires."
	level = 2
	icon = 'icons/atmos/pipe-sparker.dmi'
	icon_state = "pipe-sparker"
	volume = ATMOS_DEFAULT_VOLUME_PIPE / 2
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon = 'icons/atmos/pipe-sparker.dmi'
	build_icon_state = "pipe-igniter"
	idle_power_usage = 20

	maximum_pressure = 420*ONE_ATMOSPHERE
	fatigue_pressure = 350*ONE_ATMOSPHERE
	alert_pressure = 350*ONE_ATMOSPHERE

	var/last_spark = 0
	var/disabled = FALSE
	var/obj/item/device/assembly/signaler/signaler = null

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	public_methods = list(
		/decl/public_access/public_method/pipe_sparker_spark
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/sparker/pipe = 1)

/decl/public_access/public_method/pipe_sparker_spark
	name = "pipespark"
	desc = "Ignites gas in a pipeline."
	call_proc = /obj/machinery/atmospherics/pipe/cap/sparker/proc/ignite

/decl/stock_part_preset/radio/receiver/sparker/pipe
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/pipe_sparker_spark)

/obj/machinery/atmospherics/pipe/cap/sparker/visible
	level = 2
	icon_state = "pipe-sparker"

/obj/machinery/atmospherics/pipe/cap/sparker/hidden
	level = 1
	icon_state = "pipe-sparker"
	alpha = 128

/obj/machinery/atmospherics/pipe/cap/sparker/proc/cant_ignite()
	if ((world.time < last_spark + 50) || !powered() || disabled)
		return TRUE
	return FALSE

/obj/machinery/atmospherics/pipe/cap/sparker/proc/ignite()
	playsound(loc, 'sound/machines/click.ogg', 10, 1)
	if (cant_ignite())
		return

	playsound(loc, "sparks", 100, 1)
	use_power_oneoff(2000)
	flick("pipe-sparker-spark", src)
	parent.air.react(null, TRUE, TRUE)//full bypass
	last_spark = world.time

/obj/machinery/atmospherics/pipe/cap/sparker/physical_attack_hand(mob/user)
	playsound(loc, "button", 30, 1)
	if (cant_ignite())
		user.visible_message(
			SPAN_NOTICE("\The [user] tries to activate \the [src], but nothing happens."),
			SPAN_NOTICE("You try to activate \the [src], but nothing happens.")
		)
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] activates \the [src]."),
		SPAN_NOTICE("You activate \the [src].")
	)
	ignite()

/obj/machinery/atmospherics/pipe/cap/sparker/attackby(obj/item/W as obj, mob/user as mob)
	if (isScrewdriver(W) && !signaler)
		add_fingerprint(user)
		disabled = !disabled
		if (disabled)
			user.visible_message(
				SPAN_WARNING("\The [user] has disabled \the [src]!"),
				SPAN_WARNING("You disable the connection to \the [src].")
			)
		else if (!disabled)
			user.visible_message(
				SPAN_NOTICE("\The [user] has reconnected wiring on \the [src]!"),
				SPAN_NOTICE("You fix the wire connection on \the [src].")
			)
		update_icon()
		return

	if (istype(W, /obj/item/device/assembly/signaler) && signaler == null)
		if (disabled)
			to_chat(user, SPAN_WARNING("\The [src] is disabled!"))
			return
		signaler = W
		if (signaler.secured)
			to_chat(user, SPAN_WARNING("\The [signaler] is secured!"))
			signaler = null
			return
		signaler.mholder = src
		user.unEquip(signaler)
		signaler.forceMove(src)
		user.visible_message(
			SPAN_NOTICE("\The [user] connects \the [signaler] to \the [src]."),
			SPAN_NOTICE("You connect \the [signaler] to \the [src].")
		)
		update_icon()
		return

	if (isScrewdriver(W) && signaler)
		signaler.mholder = null
		signaler.dropInto(loc)
		user.visible_message(
			SPAN_WARNING("\The [user] disconnects \the [signaler] from \the [src]."),
			SPAN_WARNING("You disconnect \the [signaler] from \the [src].")
		)
		signaler = null
		update_icon()
		return

	if (isWrench(W) && (signaler || disabled))
		to_chat(user, SPAN_NOTICE("Remove signalers and check the wiring before unwrenching \the [src]."))
		return
	..()

/obj/machinery/atmospherics/pipe/cap/sparker/proc/process_activation()//the signaler calls this
	ignite()

/obj/machinery/atmospherics/pipe/cap/sparker/on_update_icon()
	..()
	if (signaler)
		overlays += image('icons/atmos/pipe-sparker.dmi', "pipe-sparker-s")
	if (disabled)
		overlays += image('icons/atmos/pipe-sparker.dmi', "pipe-sparker-d")
	update_underlays()

/obj/machinery/atmospherics/pipe/cap/sparker/update_underlays()
	if (..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if (!istype(T))
			return
		add_underlay(T, node, dir)

/obj/machinery/atmospherics/pipe/cap/sparker/set_color(new_color)
	return

/obj/machinery/atmospherics/pipe/cap/sparker/color_cache_name(obj/machinery/atmospherics/node)//returns to the original
	if (!istype(node))
		return null

	return node.pipe_color
