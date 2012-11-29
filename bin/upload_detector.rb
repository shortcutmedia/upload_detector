#!/usr/bin/env ruby

#load environment
env = ENV['UPLOAD_DETECTOR_ENV'] || 'development'
require "rubygems"
require "bundler"
Bundler.setup(:default, env)

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'upload_detector'

opts   = CommandlineOptions.new
config = AppConfig.new filename: 'upload_detector.yml', env: env, initial_data: opts.opts



input_file = File.open File.expand_path(config.input_file, UploadDetector.root)
detector = Detector.new input_file: input_file

#detector.add_listener AnnotationListener.new if opts[:annotate]
#detector.add_listener UploadListener.new unless opts[:annotate] || opts[:debug]
detector.add_listener DebugUploadListener.new if opts[:debug]
detector.add_listener ImportTrigger.new

if config.log
  #log_level = opts[:debug] ? Log4r::DEBUG : Log4r::INFO
  log_path = File.expand_path(config.log_file, UploadDetector.root)
  logger = Logger.new(:filename => log_path)
  detector.add_listener logger
end

forever = opts[:deamonized]
UploadDetector.new( :detector => detector, :logger => nil ).run(forever)
