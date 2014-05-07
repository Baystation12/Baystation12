datum/directive/tau_ceti_needs_women
  var/list/command_targets = list()
  var/list/alien_targets = list()

  proc/get_target_gender()
    if(!mode.head_loyalist) return FEMALE
    return mode.head_loyalist.current.gender == FEMALE ? MALE : FEMALE

  proc/get_crew_of_target_gender()
    var/list/targets[0]
    for(var/mob/living/carbon/human/H in player_list)
      if(H.species.name != "Machine" && H.gender == get_target_gender())
        targets.Add(H)
    return targets

  proc/get_target_heads()
    var/list/heads[0]
    for(var/mob/living/carbon/human/H in get_crew_of_target_gender())
      if(command_positions.Find(H.mind.assigned_role))
        heads.Add(H)
    return heads

  proc/get_target_aliens()
    var/list/aliens[0]
    for(var/mob/living/carbon/human/H in get_crew_of_target_gender())
      if (H.species.name == "Tajaran" || H.species.name == "Unathi" || H.species.name == "Skrell")
        aliens.Add(H)
    return aliens

  proc/count_heads_reassigned()
    var/heads_reassigned = 0
    for(var/obj/item/weapon/card/id in command_targets)
      if (command_targets[id])
        heads_reassigned++

    return heads_reassigned

datum/directive/tau_ceti_needs_women/get_description()
  return {"
    <p>
      Recent evidence suggests [get_target_gender()] aptitudes may be effected by radiation from Tau Ceti.
      Effects were measured under laboratory and station conditions. Humans remain more trusted than Xeno. Further information is classified.
    </p>
  "}

datum/directive/tau_ceti_needs_women/initialize()
  for(var/mob/living/carbon/human/H in get_target_heads())
    command_targets[H.wear_id] = 0

  for(var/mob/living/carbon/human/H in get_target_aliens())
    alien_targets.Add(H.wear_id)

  special_orders = list(
    "Remove [get_target_gender()] personnel from Command positions.",
    "Terminate employment of all [get_target_gender()] Skrell, Tajara, and Unathi.")

datum/directive/tau_ceti_needs_women/meets_prerequisites()
  var/list/targets = get_crew_of_target_gender()
  return targets.len >= 3

datum/directive/tau_ceti_needs_women/directives_complete()
  return command_targets.len == count_heads_reassigned() && alien_targets.len == 0

/hook/reassign_employee/proc/command_reassignments(obj/item/weapon/card/id/id_card)
  var/datum/directive/tau_ceti_needs_women/D = get_directive("tau_ceti_needs_women")
  if(!D) return 1

  if(D.command_targets && D.command_targets.Find(id_card))
    D.command_targets[id_card] = command_positions.Find(id_card.assignment) ? 0 : 1

  return 1

/hook/terminate_employee/proc/gender_target_termination_directive(obj/item/weapon/card/id)
  var/datum/directive/tau_ceti_needs_women/D = get_directive("tau_ceti_needs_women")
  if (!D) return 1

  if(D.alien_targets && D.alien_targets.Find(id))
    D.alien_targets.Remove(id)

  if(D.command_targets && D.command_targets.Find(id))
    D.command_targets[id] = 1

  return 1
