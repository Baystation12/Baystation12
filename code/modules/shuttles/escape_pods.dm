var/list/escape_pods = list()
var/list/escape_pods_by_name = list()

#define evac_chair(varName) var/obj/structure/bed/chair/shuttle/##varName	// inf
#define ISEVAC_STARSHIP_FAST_CONTROLER istype(evacuation_controller, /datum/evacuation_controller/starship/fast)	// inf

/datum/shuttle/autodock/ferry/escape_pod
	var/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/arming_controller
	category = /datum/shuttle/autodock/ferry/escape_pod
	move_time = 100
	var/need_people	= 0// inf

/datum/shuttle/autodock/ferry/escape_pod/New()
	if(name in escape_pods_by_name)
		CRASH("An escape pod with the name '[name]' has already been defined.")
	move_time = evacuation_controller.evac_transit_delay + rand(-30, 60)
	escape_pods_by_name[name] = src
	escape_pods += src
	move_time = round(evacuation_controller.evac_transit_delay/10)

	..()

	//find the arming controller (berth)
	var/arming_controller_tag = arming_controller
	arming_controller = SSshuttle.docking_registry[arming_controller_tag]
	if(!istype(arming_controller))
		CRASH("Could not find arming controller for escape pod \"[name]\", tag was '[arming_controller_tag]'.")

	//find the pod's own controller
	var/datum/computer/file/embedded_program/docking/simple/prog = SSshuttle.docking_registry[dock_target]
	var/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/controller_master = prog.master
	if(!istype(controller_master))
		CRASH("Escape pod \"[name]\" could not find it's controller master!")

	controller_master.pod = src
// [INF]
	evac_chair(temp)
	for(temp in shuttle_area[1])
		++need_people

/datum/shuttle/autodock/ferry/escape_pod/force_launch(user)
	. = ..()
	shuttle_docking_controller.finish_undocking()
	var/datum/computer/file/embedded_program/docking/simple/prog = shuttle_docking_controller
	prog.close_door()

/datum/shuttle/autodock/ferry/escape_pod/proc/toggle_bds(var/CLOSE = FALSE)
	for(var/obj/machinery/door/blast/regular/escape_pod/ES in world)
		if(ES.id_tag == shuttle_docking_controller.id_tag)
			if(CLOSE)
				INVOKE_ASYNC(ES, /obj/machinery/door/blast/proc/force_close)
			else
				INVOKE_ASYNC(ES, /obj/machinery/door/blast/proc/force_open)

/datum/shuttle/autodock/ferry/escape_pod/proc/set_self_unarm()
	if(arming_controller.armed)
		if(evacuation_controller.is_idle() || evacuation_controller.is_on_cooldown())
			var/check = TRUE
			for(var/mob/living/user in shuttle_area[1])
				if(isliving(user))
					check = FALSE
					break
			if(check)
				arming_controller.unarm()
				return
		GLOB.exited_event.register(shuttle_area[1], arming_controller, /datum/computer/file/embedded_program/docking/simple/escape_pod_berth/proc/check_unarm)

/datum/shuttle/autodock/ferry/escape_pod/proc/check_load()
	var/list/counted = list()
	var/i = 0
	evac_chair(temp)
	for(temp in shuttle_area[1])
		if(temp.buckled_mob)
			counted += temp.buckled_mob
			if(counted.len >= need_people)
				return TRUE
		i++
	if(i < need_people)	// someone broke a chair
		for(var/mob/living/M in shuttle_area[1])
			if(M in counted)
				continue
			counted += M
			if(counted.len >= need_people)
				return TRUE
	return FALSE
// [/INF]

/datum/shuttle/autodock/ferry/escape_pod/can_launch()
// [INF]
	if(!ISEVAC_STARSHIP_FAST_CONTROLER && !evacuation_controller.has_evacuated())
		return 0
	if(ISEVAC_STARSHIP_FAST_CONTROLER)
		if(isnull(evacuation_controller.evac_no_return))
			return 0
		if(!check_load() && (world.time < evacuation_controller.evac_no_return))
			return 0
// [/INF]
	if(arming_controller && !arming_controller.armed)	//must be armed
		return 0
	if(location)
		return 0	//it's a one-way trip.
	return ..()

/datum/shuttle/autodock/ferry/escape_pod/can_force()
	if (arming_controller && arming_controller.master.emagged)	// inf
		return (next_location && next_location.is_valid(src) && !current_location.cannot_depart(src) && moving_status == SHUTTLE_IDLE && !location && arming_controller && arming_controller.armed)	// inf
	if (arming_controller.eject_time && world.time < arming_controller.eject_time + 50)
		return 0	//dont allow force launching until 5 seconds after the arming controller has reached it's countdown
	return ..()

/datum/shuttle/autodock/ferry/escape_pod/can_cancel()
	return 0


//This controller goes on the escape pod itself
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	name = "escape pod controller"
	program = /datum/computer/file/embedded_program/docking/simple/escape_pod
	var/datum/shuttle/autodock/ferry/escape_pod/pod
	var/tag_pump
	frequency = EXTERNAL_AIR_FREQ	 //INF

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/computer/file/embedded_program/docking/simple/docking_program = program

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"door_state" = 	docking_program.memory["door_status"]["state"],
		"door_lock" = 	docking_program.memory["door_status"]["lock"],
		"can_force" = pod.can_force() || pod.can_launch(),	// inf, was "can_force" = pod.can_force() || (evacuation_controller.has_evacuated() && pod.can_launch()),	//allow players to manually launch ahead of time if the shuttle leaves
		"is_armed" = pod.arming_controller.armed,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/OnTopic(user, href_list)
/* [BAY]	thx for broken shit
	if(href_list["manual_arm"])
		pod.arming_controller.arm()
		return TOPIC_REFRESH

	if(href_list["force_launch"])
		if (pod.can_force())
			pod.force_launch(src)
		else if (evacuation_controller.has_evacuated() && pod.can_launch())	//allow players to manually launch ahead of time if the shuttle leaves
			pod.launch(src)
		return TOPIC_REFRESH
[/BAY]*/
// [INF]
	if(href_list["command"])
		var/command = href_list["command"]
		if(command == "manual_arm")
			pod.arming_controller.arm()
			return TOPIC_REFRESH

		if(command == "force_launch")
			if (pod.can_launch())
				pod.toggle_bds()
				pod.launch(src)
			else if (pod.can_force())
				pod.toggle_bds()
				GLOB.global_announcer.autosay("Несанкционированный запуск капсулы <b>[pod]</b>! Возможна разгерметизация!", "Эвакуационный Контроллер",, z)
				pod.force_launch(src)
			return TOPIC_REFRESH
// [/INF]

//This controller is for the escape pod berth (station side)
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth
	name = "escape pod berth controller"
	program = /datum/computer/file/embedded_program/docking/simple/escape_pod_berth
	frequency = EXTERNAL_AIR_FREQ	 //INF

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/computer/file/embedded_program/docking/simple/docking_program = program

	var/armed = null
	if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod_berth))
		var/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/P = docking_program
		armed = P.armed

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"armed" = armed,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_berth_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// [INF]
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/attackby(var/obj/item/T, var/mob/living/carbon/human/user)
	if(emagged && isMultitool(T) && user.skill_check(SKILL_ELECTRICAL, SKILL_ADEPT))
		to_chat(user, "<span class='notice'>Ты начал сбрасывать настройки [src], чтобы починить его.</span>")
		if(do_after(user, 100, src))
			emagged = FALSE
			state("Сброс до заводских настроек завершен!")
			sleep(5)
			state("Поиск центрального контроллера...")
			sleep(10)
			state("Найдено!")
			sleep(10)
			state("Первичная настройка капсулы...")
			sleep(20)
			state("Успешно!")
			if (istype(program, /datum/computer/file/embedded_program/docking/simple/escape_pod_berth))
				var/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/P = program
				for(var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods)
					if(pod.arming_controller == P)
						pod.toggle_bds(TRUE)
						break
				if (P.armed)
					P.unarm()
			return
	. = ..()
// [/INF]

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		to_chat(user, "<span class='notice'>You emag the [src], arming the escape pod!</span>")
		emagged = TRUE
		// [INF]
		GLOB.global_announcer.autosay("<b>Несанкционированный доступ</b> к контроллеру эвакуации. Потеряно управление от <b><i>[src]</i></b>. Службе безопасности рекомендуется проследовать к этой капсуле. Местоположение капсулы: [get_area(src)]", "Автоматическая Система Безопасности", "Security", z)
		state("Ошибка центрального контроллера!")
		sleep(5)
		state("Обнаружена аварийная ситуация!")
		sleep(3)
		state("Взведение капсулы...")
		sleep(10)
		state("Ошибка стыковочных зажимов!")
		sleep(5)
		state("Отключение зажимов...")
		sleep(20)
		state("Примерное время подготовки: 5 минут.")
		// [/INF]
		if (istype(program, /datum/computer/file/embedded_program/docking/simple/escape_pod_berth))
			var/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/P = program
			if (!P.armed)
				addtimer(CALLBACK(P, /datum/computer/file/embedded_program/docking/simple/escape_pod_berth/proc/arm), 5 MINUTES)	// inf was P.arm()
		return 1

//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple/escape_pod_berth
	var/armed = 0
	var/eject_delay = 10	//give latecomers some time to get out of the way if they don't make it onto the pod
	var/eject_time = null
	var/closing = 0


/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/proc/arm()
	if(!armed)
		armed = 1
		open_door()

/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/proc/unarm()
	if(armed)
		armed = 0
		close_door()

// [INF]
/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/proc/check_unarm(var/area/area, var/mob/living/user)
	if(armed && isliving(user))
		if(evacuation_controller.is_idle() || evacuation_controller.is_on_cooldown())
			var/check = TRUE
			for(user in area)
				if(isliving(user))
					check = FALSE
					break
			if(check)
				unarm()
	else if(!armed)
		GLOB.exited_event.unregister(area, src, /datum/computer/file/embedded_program/docking/simple/escape_pod_berth/proc/check_unarm)
// [/INF]

/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/receive_user_command(command)
	if (!armed)
		return TRUE // Eat all commands.
	return ..(command)
/* [BAY]
/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/process()
	..()
	if (eject_time && world.time >= eject_time && !closing)
		close_door()
		closing = 1
[BAY] */
/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/prepare_for_docking()
	return

/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/ready_for_docking()
	return 1

/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/finish_docking()
	return		//don't do anything - the doors only open when the pod is armed.

/datum/computer/file/embedded_program/docking/simple/escape_pod_berth/prepare_for_undocking()
	eject_time = world.time + eject_delay*10
	..()	// inf

// The program for the escape pod controller.
/datum/computer/file/embedded_program/docking/simple/escape_pod
	var/tag_pump
// [INF]
	var/undock_begin

// No answer recieved from vessel controller? Evacing in any case
/datum/computer/file/embedded_program/docking/simple/escape_pod/ready_for_undocking()
	. = ..()
	if(!undock_begin)
		undock_begin = world.time
	if (. && (world.time > undock_begin + 10 SECONDS))
		finish_undocking()
		reset()
// [/INF]

/datum/computer/file/embedded_program/docking/simple/escape_pod/New(var/obj/machinery/embedded_controller/M)
	..(M)
	if (istype(M, /obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod))
		var/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/controller = M
		tag_pump = controller.tag_pump ? controller.tag_pump : "[id_tag]_pump"

/datum/computer/file/embedded_program/docking/simple/escape_pod/finish_undocking()
	. = ..()
	undock_begin = null	// inf
	// Send a signal to the vent pumps to repressurize the pod.
	var/datum/signal/signal = new
	signal.data = list(
		"tag" = tag_pump,
		"sigtype" = "command",
		"set_power" = 1,	// inf, was	"power" = 1,
		"set_direction" = "release",	// inf, was	"direction" = 1,
		"status" = TRUE,	// inf,
		"set_external_pressure" = ONE_ATMOSPHERE
	)
	post_signal(signal)

#undef evac_chair
#undef ISEVAC_STARSHIP_FAST_CONTROLER
