/singleton/webhook
	var/id
	var/list/urls
	var/mentions

/singleton/webhook/proc/get_message(list/data)
	. = list()

/singleton/webhook/proc/http_post(target_url, payload)
	if (!target_url)
		return -1

	var/result = call_ext(HTTP_POST_DLL_LOCATION, "send_post_request")(target_url, payload, json_encode(list("Content-Type" = "application/json")))

	result = json_decode(result)
	if (result["error_code"])
		log_debug("byhttp error: [result["error"]] ([result["error_code"]])")
		return result["error_code"]

	return list(
		"status_code" = result["status_code"],
		"body" = result["body"]
	)

/singleton/webhook/proc/send(list/data)
	var/message = get_message(data)
	if(message)
		if(mentions)
			if(message["content"])
				message["content"] = "[mentions]: [message["content"]]"
			else
				message["content"] = "[mentions]"
		message = json_encode(message)
		. = TRUE
		for(var/target_url in urls)
			var/list/httpresponse = http_post(target_url, message)
			if(!islist(httpresponse))
				. = FALSE
				continue
			switch(httpresponse["status_code"])
				if (200 to 299)
					continue
				if (400 to 599)
					log_debug("Webhooks: HTTP error code while sending to '[target_url]': [httpresponse["status_code"]]. Data: [httpresponse["body"]].")
				else
					log_debug("Webhooks: unknown HTTP code while sending to '[target_url]': [httpresponse["status_code"]]. Data: [httpresponse["body"]].")
			. = FALSE
