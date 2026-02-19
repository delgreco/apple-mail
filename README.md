# apple-mail
Fetch email from Apple Mail and store it in plain text as JSON.

Specifically, only Sent messages are fetched by this script.

## run manually in verbose mode

    osascript get.scpt -v

## keep it fresh hourly

    0 * * * * cd $HOME/apple-mail; osascript get.scpt >> getmail.log
    0 4-18 * * * cd $HOME/apple-mail; ./run_getmail.sh >> out.log

## result

Mail will be stored in a local mail/ folder, in the following format:

    YYYYMMDD_HHMMSS_[message_id].json

Therefore:

    $ ls mail
    20260112_153818_1041.json  20260116_085923_1013.json  [etc...]



