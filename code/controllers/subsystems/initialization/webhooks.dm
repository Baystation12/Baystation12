SUBSYSTEM_DEF(webhooks)
	name = "Webhooks"
	init_order = SS_INIT_EARLY
	flags = SS_NO_FIRE
	var/list/webhook_decls = list()

/datum/controller/subsystem/webhooks/Initialize()

	if(!fexists(HTTP_POST_DLL_LOCATION))
		to_world_log("Unable to locate HTTP POST lib at [HTTP_POST_DLL_LOCATION], webhooks will not function on this run.")
	else

		var/list/all_webhooks_by_id = list()
		var/list/all_webhooks = decls_repository.get_decls_of_subtype(/decl/webhook)
		for(var/wid in all_webhooks)
			var/decl/webhook/webhook = all_webhooks[wid]
			if(webhook.id)
				all_webhooks_by_id[webhook.id] = webhook

		var/webhook_config = return_file_text("config/webhooks.json")
		if(webhook_config)
			for(var/webhook_data in json_decode(webhook_config))
				var/wid = webhook_data["id"]
				var/wurl = webhook_data["url"]
				var/wmention = webhook_data["mentions"]
				to_world_log("Setting up webhook [wid].")
				if(wid && wurl && all_webhooks_by_id[wid])
					var/decl/webhook/webhook = all_webhooks_by_id[wid]
					webhook.url = wurl
					if(wmention)
						webhook.mentions = jointext(wmention, ", ")
					webhook_decls[wid] = webhook
					to_world_log("Webhook [wid] ready.")
				else
					to_world_log("Failed to set up webhook [wid].")

	. = ..()

/datum/controller/subsystem/webhooks/proc/send(var/wid, var/wdata)
	var/decl/webhook/webhook = webhook_decls[wid]
	if(webhook)
		if(webhook.send(wdata))
			to_world_log("Sent webhook [webhook.id].")
			log_debug("Webhook sent: [webhook.id].")
		else
			to_world_log("Failed to send webhook [webhook.id].")
			log_debug("Webhook failed to send: [webhook.id].")
