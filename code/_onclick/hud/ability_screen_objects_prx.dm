//Changeling Abilities
/obj/screen/ability/changeling
	icon = 'proxima/icons/obj/action_buttons/changeling_new.dmi'
	icon_state = "ling_spell_base"
	background_base_state = "ling"
	var/sting_datum

/obj/screen/ability/changeling/activate()
	to_chat(ability_master.my_mob, SPAN_LING("Мы подготовили жало. <i>Используйте alt+клик или СКМ на цели для укола.</i>"))
	var/datum/changeling/C = ability_master.my_mob.mind.changeling
	C.chosen_sting = new sting_datum

	ability_master.my_mob.ling_sting.name = name
	ability_master.my_mob.ling_sting.icon_state = ability_icon_state
	ability_master.my_mob.ling_sting.invisibility = 0

/obj/screen/movable/ability_master/proc/add_ling_ability(var/name_given, var/sting_datum, var/ability_icon_given)
	if(!sting_datum)
		message_admins("ERROR: add_ling_ability() was not given a sting_id in its arguments.")
	if(get_ability_by_proc_ref(sting_datum))
		return // Duplicate
	var/obj/screen/ability/changeling/A = new /obj/screen/ability/changeling()
	A.ability_master = src
	A.sting_datum = sting_datum
	A.ability_icon_state = ability_icon_given
	A.SetName(name_given)
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen
