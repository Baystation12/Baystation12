// Too complex, so different file for it
// Blackout tool, used to trigger massive electricity outttage on ship or station, including connected levels.
// It may have additional shots to use, but currently balanced to one shot.

/datum/uplink_item/item/tools/blackout
	name = "High Pulse Electricity Outage Tool"
	item_cost = 36
	path = /obj/item/device/blackout
	desc = "A device which can create power surge in terminal, spread it in power network and temporally creating blackout."

/obj/item/device/blackout
	name = "Energy network scanner"
	desc = "A device with several metal antennas. It looks like a scanner or multimeter, but this one is completely black."
	icon = 'mods/antagonists/icons/obj/blackout.dmi'
	icon_state = "device_blackout-off"

	var/severity = 2
	var/shots = 1
	var/lastUse = 0
	var/cooldown = (20 MINUTES)

/obj/item/device/blackout/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(!istype(target))
		return

	target.add_fingerprint(user)

	if(istype(target, /obj/machinery/power/terminal))
		var/obj/machinery/power/terminal/terminal = target

		if(!terminal.powernet)
			to_chat(user, SPAN_WARNING("This power station isn't connected to power net."))
			return

		if(check_to_use())
			to_chat(user, SPAN_WARNING("Device does not respond. Perhaps you need to try later."))
			return

		if(!shots)
			to_chat(user, SPAN_WARNING("Device does not respond."))
			return

		hacktheenergy(terminal, user)

/obj/item/device/blackout/proc/hacktheenergy(obj/machinery/power/terminal/terminal_in, mob/user)
	if(!istype(terminal_in) || !user) return // security

	src.audible_message("<font color=Maroon><b>Synthesized recording</b></font> states, \"-- Вас приветствует Ассистент КиДжи. Начало. Производится подключение к терминалу. --\"")
	if(!do_after(user, 60, terminal_in)) return

	src.audible_message("<font color=Maroon><b>Synthesized recording</b></font> states, \"-- Подключение к терминалу успешно. Начато получение информации о конфигурации электросети... --\"")
	if(!do_after(user, 160, terminal_in)) return

	src.audible_message("<font color=Maroon><b>Synthesized recording</b></font> states, \"-- Сканирование корабельной электросети успешно. Начинается процедура перегрузки корабельной электросети. Не прерывайте работу терминала. --\"")
	icon_state = "device_blackout-on"
	playsound(src, 'sound/items/goggles_charge.ogg', 50, 1)

	if(do_after(user, 80, terminal_in))
		src.audible_message("<font color=Maroon><b>Synthesized recording</b></font> states, \"-- Перегрузка завершена. Можете отсоединять терминал. \
			Утилизируйте устройство после использования. --\"")

		shots--
		cooldown = world.time

		power_failure()

		log_and_message_admins("[key_name(usr)] used \the [src.name] on \the [admin_jump_link(terminal_in, src)] to shutdown entire ship.")

	icon_state = "device_blackout-off"

/obj/item/device/blackout/proc/check_to_use()
	return lastUse <= (world.time - cooldown)

/obj/item/device/blackout/examine(mob/user)
	. = ..()
	if (isobserver(user) || (user.mind && user.mind.special_role != null) || user.skill_check(SKILL_DEVICES, SKILL_EXPERIENCED) || user.skill_check(SKILL_ELECTRICAL, SKILL_EXPERIENCED))
		to_chat(user, "This device appears to be able to send a signal to overload the power grid. ")
		return
