require 'httparty'
require 'pry'

class TwitchToSlack
  include HTTParty

  def initialize(twitch_channel, slack_group)
    @twitch_channel = twitch_channel
    @slack_group = slack_group
  end

  ##
  # Fetches twitch emoticons from channel_name
  #
  def get_twitch_emoticons
    # Get Emoticon Set ID
    # TODO: Figure out how to get this number from the API
    emoticon_set = 17937 # MoonMoon_OW Emoticon Set
    # Get Emoticons for Channel
    headers = {
      'Accept' => 'application/vnd.twitchtv.v5+json',
      'Client-ID' => 'efq3aoz1vvrtac1wz0ojszl54p6uuw'
    }

    http_response = self.class.get(
      'https://api.twitch.tv/kraken/chat/emoticons',
      headers: headers
    )
    response = JSON.parse(http_response.body, symbolize_names: true)
    emoticons = response[:emoticons]
    emoticons = emoticons.select do |e|
      e[:images].select do |i|
        i[:emoticon_set] == emoticon_set
      end.count > 0
    end
    clean_selected_emoticons(emoticons)
  end

  ##
  # Imports emotes into Slack group
  #
  def import_slack_emotes
    raise NotImplementedError
  end

  private

  ##
  # Gets the Twitch user_id for the @twitch_channel
  #
  def get_twitch_user_id
    headers = {
      'Accept' => 'application/vnd.twitchtv.v5+json',
      'Client-ID' => 'efq3aoz1vvrtac1wz0ojszl54p6uuw'
    }
    query = {
      login: @twitch_channel
    }

    http_response = self.class.get(
      'https://api.twitch.tv/kraken/users',
      query: query,
      headers: headers
    )
    response = JSON.parse(http_response.body, symbolize_names: true)
    response[:users].first[:_id]
  end

  ##
  # Cleans the raw emoticon response from Twitch into a useful hash
  #
  def clean_selected_emoticons(raw_emoticon_response)
    cleaned_emoticons = {}
    raw_emoticon_response.each do |e|
      cleaned_emoticons[e[:regex]] = e[:images].first[:url]
    end
    cleaned_emoticons
  end
end

connector = TwitchToSlack.new('moonmoon_ow', 'triggeredbytime')
twitch_emotes = connector.get_twitch_emoticons
