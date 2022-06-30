class LinebotsController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
          
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
          
        end
      
      when Line::Bot::Event::Follow #友達登録イベント
        userId = event['source']['userId'] 
        linkToken = createtoken(client, userId)
        
        client.reply_message(event['replyToken'], hello(linkToken))
        # User.find_or_create_by(uid: userId)
        
      when Line::Bot::Event::Postback #ポストバックイベント
        if event['postback']['data'] === 'authenticate'
          userId = event['source']['userId'] 
          linkToken = createtoken(client, userId)
        
          client.reply_message(event['replyToken'], lineAuthenticate(linkToken))
          # User.find_or_create_by(uid: userId)
        end

      when Line::Bot::Event::AccountLink #アカウント連携イベント
        nonce = event['link']['nonce']
        user = User.find_by(linenonce: nonce);
        userId = event['source']['userId']
        user.update(lineuid: userId)
        client.link_user_rich_menu(userId, ENV.fetch("LINE_RICH_MENU_ID", nil))
        message = {
          type: 'text',
          text: "認証が完了しました！通知設定はあるふネットより変更が可能です。"
        }
        client.push_message(user.lineuid, message)
      end
    }

    head :ok
  end
  
  
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = ENV.fetch("LINE_CHANNEL_ID", nil)
      config.channel_secret = ENV.fetch("LINE_CHANNEL_SECRET", nil)
      config.channel_token = ENV.fetch("LINE_CHANNEL_TOKEN", nil)
    }
  end
  
  def createtoken(client, userId)
    token_json = client.create_link_token(userId).body
    token_hash = JSON.parse(token_json)
    token_hash["linkToken"]
  end
  
  def hello(linkToken)
    host_name = ENV.fetch("HOST", nil)
    {
      type: "template",
      altText: "友達追加ありがとうございます。認証すると通知を受け取れるようになります",
      template: {
        type: 'buttons',
        text: "友達追加ありがとうございます。以下の「認証する」から あるふネット で認証すると通知を受け取れるようになります。認証はこの通知を受け取ってから10分以内に行ってください。",
        actions: [
          {
            type: "uri",
            label: "認証する",
            uri: "https://#{host_name}/line?linkToken=#{linkToken}"
          }
        ]
      }
    }
  end

  def lineAuthenticate(linkToken)
    host_name = ENV.fetch("HOST", nil)
    {
      type: "template",
      altText: "認証すると通知を受け取れるようになります",
      template: {
        type: 'buttons',
        text: "以下の「認証する」から あるふネット で認証すると通知を受け取れるようになります。認証はこの通知を受け取ってから10分以内に行ってください。",
        actions: [
          {
            type: "uri",
            label: "認証する",
            uri: "https://#{host_name}/line?linkToken=#{linkToken}"
          }
        ]
      }
    }
  end

end
