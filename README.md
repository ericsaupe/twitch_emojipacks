# Twitch to Slack

Converts Twitch Emoticons from a Twitch Channel into an Emojipacks compatible
YAML file. Then use the Emojipacks project to upload the export into your Slack
channel.

## How to Use
 * Clone repo locally
 * `cd twitch-to-slack`
 * `bundle install`
 * `ruby twitch_to_slack.rb CHANNEL_NAME`
 * Run Emojipacks using outputted file in `emojipacks` folder
