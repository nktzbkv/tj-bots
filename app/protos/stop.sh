@STOP_COMMAND@

curl -s -w "\n" -X POST \
  --header 'X-Device-Token: @TJOURNAL_WEBHOOK_TOKEN@' \
  --form 'event=new_comment' \
  https://api.tjournal.ru/v1.8/webhooks/del

curl -s -w "\n" -X POST \
  --header 'X-Device-Token: @DTF_WEBHOOK_TOKEN@' \
  --form 'event=new_comment' \
  https://api.dtf.ru/v1.8/webhooks/del
