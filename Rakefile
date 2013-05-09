# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'#/template/ios'
require 'bundler'
require 'bubble-wrap'
require 'bubble-wrap/reactor'
require 'sugarcube'
require 'sugarcube-gestures'
require 'motion-testflight'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Origami'
  app.identifier = "io.yannick.origami"
  app.version = "0.4"
  app.short_version = "0.4"
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
    pod 'MBAlertView'
    pod 'NewRelicAgent'
  end

  app.vendor_project(
    'vendor/Pods/NewRelicAgent/NewRelic_iOS_Agent_1.328/NewRelicAgent.framework',
    :static,
    :products => ['NewRelicAgent'],
    :headers_dir => 'Headers'
  )

  app.vendor_project(
    'vendor/Crashlytics.framework',
    :static,
    :products => ['Crashlytics'],
    :headers_dir => 'Headers'
  )

  app.testflight do
    app.testflight.sdk = 'vendor/TestFlightSDK'
    app.testflight.api_token = '3a009a08d4a8d14db482e312c6794eb3_NjI5MzA3MjAxMi0wOS0xNSAwODoyMToxNy4xMDg2MzA'
    app.testflight.team_token = 'f8733c3f121e1d69be2f617439f69890_MjIxMjU4MjAxMy0wNS0wOCAyMDowOToxNi40Mjk1MjQ'
    app.testflight.notify = true # default is false
  end

end
