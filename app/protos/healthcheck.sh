 # check app is alive and register webhook
(curl -s -w "\n" http://@HTTPD_BIND@/) \
&& \
(curl -s -w "\n" -X POST \
  --header 'X-Device-Token: @TJOURNAL_WEBHOOK_TOKEN@' \
  --form 'url=http://@HTTPD_HOST@/new-comment/@TJOURNAL_WEBHOOK_TAG@' \
  --form 'event=new_comment' \
  https://api.tjournal.ru/v1.8/webhooks/add || true) \
&& \
(curl -s -w "\n" -X POST \
  --header 'X-Device-Token: @DTF_WEBHOOK_TOKEN@' \
  --form 'url=http://@HTTPD_HOST@/new-comment/@DTF_WEBHOOK_TAG@' \
  --form 'event=new_comment' \
  https://api.dtf.ru/v1.8/webhooks/add || true)
