require 'httparty'
require 'pry'
require 'yaml'

class TwitchToSlack
  include HTTParty

  def initialize(twitch_channel)
    @twitch_channel = twitch_channel
  end

  def save_twitch_emoticons_to_emojipacks_yaml
    twitch_emotes = get_twitch_emoticons
    yaml_content = to_emojipacks_yaml(twitch_emotes)
    # Store to Emojipacks compatible YAML
    File.open("emojipacks/#{@twitch_channel}.yaml", 'w') {|f| f.write yaml_content }
  end

  ##
  # Fetches twitch emoticons from channel_name
  #
  def get_twitch_emoticons
    # Get Emoticons for Channel
    headers = {
      'Accept' => 'application/vnd.twitchtv.v3+json',
      'Client-ID' => 'efq3aoz1vvrtac1wz0ojszl54p6uuw'
    }
    http_response = self.class.get(
      "https://api.twitch.tv/kraken/chat/#{@twitch_channel}/emoticons",
      headers: headers
    )
    response = JSON.parse(http_response.body, symbolize_names: true)
    emoticons = response[:emoticons]
    emoticons = emoticons.select do |e|
      e[:state] == 'active' && e[:subscriber_only]
    end
    emoticons
  end

  ##
  # Imports emotes into Slack group
  #
  def import_slack_emotes
    raise NotImplementedError
  end

  private

  ##
  # Cleans the raw emoticon response from Twitch into a useful hash for Emojipacks
  #
  def to_emojipacks_yaml(raw_emoticon_response)
    result_hash = {
      'title' => @twitch_channel,
      'emojis' => []
    }
    raw_emoticon_response.each do |e|
      result_hash['emojis'] << { 'name' => e[:regex].downcase, 'src' => e[:url] }
    end
    result_hash.to_yaml
  end
end

if ARGV[0].nil?
  puts "Missing Twitch Channel argument"
else

  connector = TwitchToSlack.new(ARGV[0])
  puts "Getting subscriber only emotes for #{ARGV[0]}"
  connector.save_twitch_emoticons_to_emojipacks_yaml
  puts "Emojipack saved to: emojipacks/#{ARGV[0]}.yaml"
end
