# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'action_controller' # version >= 2.3.0

require File.dirname(__FILE__) + '/../lib/dm_session_store'