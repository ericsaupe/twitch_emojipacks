# Twitch Emojipacks

Converts Twitch Emoticons from a Twitch Channel into an [Emojipacks](https://github.com/lambtron/emojipacks) compatible
YAML file. Then use the [Emojipacks](https://github.com/lambtron/emojipacks#usage)
project to upload the export into your Slack channel.

## How to Use
 * Clone repo locally
 * `cd twitch_emojipacks`
 * `bundle install`
 * `ruby twitch_emojipacks.rb CHANNEL_NAME`
 * Run [Emojipacks](https://github.com/lambtron/emojipacks#usage) using outputted file in `emojipacks` folder
