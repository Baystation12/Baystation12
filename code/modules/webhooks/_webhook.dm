/decl/webhook
	var/id
	var/url
	var/mentions

/decl/webhook/proc/get_message(var/list/data)
	. = list()

/decl/webhook/proc/http_post(var/payload)
	if (!url)
		return -1

	var/result = call(HTTP_POST_DLL_LOCATION, "send_post_request")(url, payload, json_encode(list("Content-Type" = "application/json")))

	result = json_decode(result)
	if (result["error_code"])
		log_debug("byhttp error: [result["error"]] ([result["error_code"]])")
		return result["error_code"]

	return list(
		"status_code" = result["status_code"],
		"body" = result["body"]
	)

/decl/webhook/proc/send(var/list/data)
	var/message = get_message(data)
	if(message)
		if(mentions)
			if(message["content"])
				message["content"] = "[mentions]: [message["content"]]"
			else
				message["content"] = "[mentions]"

		var/list/httpresponse = http_post(json_encode(message))
		if(!islist(httpresponse))
			return FALSE

		switch(httpresponse["status_code"])
			if (200 to 299)
				return TRUE
			if (400 to 599)
				log_debug("Webhooks: HTTP error code while sending: [httpresponse["status_code"]]. Data: [httpresponse["body"]].")
				return FALSE
			else
				log_debug("Webhooks: unknown HTTP code while sending: [httpresponse["status_code"]]. Data: [httpresponse["body"]].")
				return FALSE
	return FALSE
