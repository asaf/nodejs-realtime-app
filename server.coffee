http = require 'http'
ss = require 'socketstream'

#single-page for desktop
ss.client.define 'main', {
    view: 'desktop.html', 
    css: ['libs/bootstrap-responsive.css', 'libs/bootstrap.css', 'chat.styl'],
    code: ['libs/jquery-1.10.2.js', 'libs/bootstrap.js', 'libs/handlesbar.js', 'libs/ember-1.0.0-rc.6.js', 'libs/moment.js', 'app'],
    tmpl: 'chat'
}

# Serve desktop client on root URL
ss.http.route '/', (req, res) ->
    res.serveClient 'main'

ss.client.formatters.add require 'ss-coffee'
ss.client.formatters.add require 'ss-stylus'
#ss.client.templateEngine.use require('ss-hogan'), '/hgn'
ss.client.templateEngine.use 'ember', '/chat'
#ss.client.templateEngine.use require('ss-handlebars'), '/hds'
#ss.client.templateEngine.use require 'ss-handlebars'

#Minimize and pack assets if you type: SS_ENV=production node app.js
if ss.env is 'production' then ss.client.packAssets()

server = http.Server ss.http.middleware
server.listen 3000
ss.start server

console.log 'Server running at http://127.0.0.1:3000/'