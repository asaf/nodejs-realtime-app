window.Chat = Chat = Ember.Application.create()

Chat.Router.map () ->
    this.resource 'about'
    this.resource 'login'  
    this.resource 'chat'

Chat.IndexRoute = Ember.Route.extend
    redirect: () ->
        @transitionTo('login')

Chat.ChatRoute = Ember.Route.extend
    enter: (router) ->
        controller = @controllerFor 'login'
        if not controller.get('fullName')
            @transitionTo 'login'

Chat.ApplicationController = Ember.Controller.extend
  appName: "ChitChat",
  version: 0.1

Chat.LoginController = Ember.Controller.extend
    login: () ->
        @transitionToRoute 'chat'

Chat.ChatController = Ember.ArrayController.extend
  needs: 'login'
  sending: false
  content: Ember.A()
  init: () ->
      @_super()

  sendCurrent: () ->
      that    = this
      msgText = @get('text')
      message = Chat.Message.create
          msg: msgText
          who: @get('controllers.login').fullName

      that.set('text', '')
      that.set('sending', true)
      message.send () ->
          that.set('sending', false)

Chat.Message = Ember.Object.extend
    who: null
    msg: null
    cb: null

    init: () ->
        @_super()
        @set('createdAt', new Date())
    send: (cb) ->
        cb = cb or $.noop
        @cb = cb
        #simulate a longer delay
        #Ember.run.later(this, @run, 1000)
        @run()
    run: () ->
        ss.rpc 'app.sendMsg', @get('who'), @get('msg'), @cb

Chat.MainView = Ember.View.extend
    tagName:      'form',
    templateName: 'chat-chatview',
    submit: () ->
        @get('controller').sendCurrent()
        false

Chat.MessageView = Ember.View.extend
  tagName: 'p'
  
  init: () ->
    @_super()
    #message is accessible due to the messageBinding="this" in view.
    d = @get('message.createdAt');
    @set('message.time', d.getHours() + ':' + @pad2(d.getMinutes()) + ':' + @pad2(d.getSeconds()))

  didInsertElement: () ->
    $(@get('element')).slideDown();

  pad2: (number) ->
    return (number < 10 ? '0' : '') + number;

Chat.MessageInput = Ember.TextField.extend
  sendingBinding: 'controller.sending',

  placeholder: ( ->
      if @get('sending') then 'Sending...' else 'Your message'
  )
  .property('sending')

#Listen out for newMessage events coming from the server
ss.event.on 'incommingMessage', (msgObject) ->
  message = Chat.Message.create 
      msg: msgObject.msg
      who: msgObject.who
  chat = Chat.__container__.lookup('controller:Chat')
  
  chat.pushObject message
      