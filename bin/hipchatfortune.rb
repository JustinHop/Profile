#!/usr/bin/env ruby
# encoding: utf-8

require 'dbus'

class HipChatFortune

    def initialize
        loop = DBus::Main.new
        bus = DBus::SessionBus.instance
        loop << bus

        num = rand(4)

        if num == 2
            zippy = IO.popen('fortune -l zippy')
        else
            zippy = IO.popen('fortune zippy')
        end
        @fortune = zippy.readlines
        zippy.close
        p @fortune.join("")

        hipchatService = bus.service("com.hipchat.Script1")
        @hipchat = hipchatService.object("/com/hipchat/Script1")

        @hipchat.introspect
        @hipchat.default_iface = "com.hipchat.Script1"
        @hipchat["com.hipchat.Script1"].SetStatus(@fortune.join(""))

    end

end

HipChatFortune.new
