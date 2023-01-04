SUBSYSTEM_DEF(webhooks)
	name = "Webhooks"
	init_order = SS_INIT_EARLY
	flags = SS_NO_FIRE

	/// If not truthy, the HTTP library was not found and webhooks are unavailable.
	var/static/http_available

	/// A cache of (path = Instance) webhook singletons.
	var/static/list/singleton/webhook/enabled_webhooks = list()


/datum/controller/subsystem/webhooks/Initialize(start_uptime)
	LoadConfiguration()


/datum/controller/subsystem/webhooks/proc/LoadConfiguration()
	http_available = fexists(HTTP_POST_DLL_LOCATION)
	if (!http_available)
		log_debug({"HTTP POST library "[HTTP_POST_DLL_LOCATION]" unavailable, webhooks disabled."})
		return
	var/list/webhooks_config = trim(file2text("config/webhooks.json"))
	if (!webhooks_config)
		return
	if (webhooks_config[1] != "{" || webhooks_config[length(webhooks_config)] != "}")
		log_debug("Invalid JSON in webhooks.json; unable to load any webhooks.")
		return
	try
		webhooks_config = json_decode(webhooks_config)
	catch
		log_debug("Invalid JSON in webhooks.json; unable to load any webhooks.")
		return
	enabled_webhooks.Cut()
	var/list/webhooks_by_key = list()
	var/list/webhooks_by_path = Singletons.GetSubtypeMap(/singleton/webhook)
	for (var/path in webhooks_by_path)
		var/singleton/webhook/webhook = webhooks_by_path[path]
		webhooks_by_key[webhook.config_key] = webhook
	for (var/config_key in webhooks_config)
		var/singleton/webhook/webhook = webhooks_by_key[config_key]
		if (!webhook)
			log_debug({"Invalid webhook config key "[config_key]" in webhooks.json"})
			continue
		if (!webhook.Configure(webhooks_config[config_key]))
			continue
		enabled_webhooks[webhook.type] = webhook
		webhook.available = TRUE


/datum/controller/subsystem/webhooks/proc/Send(path, list/payload)
	if (!length(enabled_webhooks))
		return // HTTP is not available or the webhooks config is bad.
	if (!ispath(path, /singleton/webhook))
		log_debug({"Invalid webhook "[path]" called."})
		return
	var/singleton/webhook/webhook = enabled_webhooks[path]
	if (!webhook)
		log_debug({"Invalid webhook "[path]" called."})
		return
	if (!webhook.Send(payload))
		log_debug({"Webhook "[path]" failed to send."})


/client/proc/reload_webhooks()
	set name = "Reload Webhooks"
	set category = "Debug"
	if (!check_rights(R_DEBUG))
		return
	if (!SSwebhooks.initialized)
		to_chat(usr, SPAN_WARNING("SSwebhooks is not Initialized."))
		return
	log_and_message_admins("has reloaded webhooks.")
	SSwebhooks.LoadConfiguration()
