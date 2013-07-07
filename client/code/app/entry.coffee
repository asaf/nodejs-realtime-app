#This file automatically gets called first by SocketStream and must always exist

#Make 'ss' available to all modules and the browser console
window.ss = require 'socketstream'

ss.server.on 'disconnect', () ->
    console.log 'connection-down!'

ss.server.on 'ready', () ->
    console.log 'Ready!'
    require '/app'