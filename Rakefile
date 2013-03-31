# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
require 'bubble-wrap'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'heroku'
  app.device_family = [:iphone]

  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'io.yannick.heroku',
      'CFBundleURLSchemes' => ['heroku'] }
  ]
  app.pods do
    pod 'ViewDeck'
  end
end
