/datum/admin_secret_item/random_event/trigger_CompanyProvocation
  name = "Trigger Company Provocation"
  buttonName = "Запустить Провокацию компанией-конкурентом"

  var/announceTitle = ""
  var/announceMessage = ""
  var/wasTriggered = FALSE

/datum/admin_secret_item/random_event/trigger_CompanyProvocation/execute(var/mob/user)
  . = ..()
  if(!.)
    return

  if (wasTriggered)
    log_and_message_admins("Company Provocation Event Error: ивент можно запустить только один раз!", user)
    return

  // count factions Participants
  var/list/factionsParticipants[0]
  var/notEmptyFractionsNum = 0 // without NanoTrasen
  for (var/faction in GLOB.using_map.faction_choices)
    factionsParticipants[faction] = 0

  for (var/mob/living/carbon/human/character in GLOB.living_mob_list_)
    if (length(character.personal_faction))
      for (var/faction in GLOB.using_map.faction_choices)
        if (cmptext(character.personal_faction, faction))
          if (!factionsParticipants[faction] && !cmptext(GLOB.using_map.faction_choices[1], faction)) // don't count NanoTrasen
            notEmptyFractionsNum++
          factionsParticipants[faction]++
          break

  if (!notEmptyFractionsNum)
    log_and_message_admins("Company Provocation Event Error: нет игроков других фракций!", user)
    return

  // choose enemy fraction
  var/enemyFaction = ""
  var/enemyFactionNumber = 2 // 1 - NanoTrasen
  var/randomNotEmptyFractionNumber = rand(1, notEmptyFractionsNum)

  do
    if (factionsParticipants[GLOB.using_map.faction_choices[enemyFactionNumber]])
      randomNotEmptyFractionNumber--
      if (!randomNotEmptyFractionNumber)
        enemyFaction = GLOB.using_map.faction_choices[enemyFactionNumber]
        break
    enemyFactionNumber++
  while (TRUE)

  announceTitle = "Провокация"
  announceMessage = "Внимание! Компанией [enemyFaction] была совершена провокация на одной из наших станций. NanoTrasen уже готовит ответные меры в отношении провокаторов. Необходимо проверить все связи сотрудников с данной корпорацией и принять необходимые меры для обеспечения безопасности корпоративного имущества! Желаем приятной смены."

  command_announcement.Announce(announceMessage, announceTitle)
  wasTriggered = TRUE
