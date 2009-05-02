# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/dm_session_store'