# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
require 'bubble-wrap'
require 'sugarcube'
require 'sugarcube-gestures'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Origami'
  app.identifier = "io.yannick.origami"
  app.codesign_certificate = 'iPhone Developer: Yannick Schutz'
  app.provisioning_profile = '/Users/yannick/Documents/ios/origami.mobileprovision'
  app.icons = %w[logo-57 logo-72 logo-114 logo-144]
  app.prerendered_icon = true
  app.interface_orientations = [:portrait]
  app.device_family = [:iphone]

  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'io.yannick.origami',
      'CFBundleURLSchemes' => ['origami'] }
  ]
  app.pods do
    pod 'ViewDeck'
  end
end
