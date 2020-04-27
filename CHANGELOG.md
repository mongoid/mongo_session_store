# Changelog

## (unreleased)

* [#45](https://github.com/mongoid/mongo_session_store/pull/45): Add Rails 6.0 to test setup - [@tombruijn](https://github.com/tombruijn).
* [#46](https://github.com/mongoid/mongo_session_store/pull/46): Fix Rack::Session::Cookie middleware bug - [@streetlogics](https://github.com/streetlogics) & [@tombruijn](https://github.com/tombruijn).
* Your contribution here.

## 3.2.0

* [#32](https://github.com/mongoid/mongo_session_store/pull/32): Add Rails 5.1 support - [@tombruijn](https://github.com/tombruijn).
* [#36](https://github.com/mongoid/mongo_session_store/pull/36): Add gem specific main error class - [@tombruijn](https://github.com/tombruijn).
* [#38](https://github.com/mongoid/mongo_session_store/pull/38): Support rails 5.2 - [@tombruijn](https://github.com/tombruijn).
* [#41](https://github.com/mongoid/mongo_session_store/pull/41): Add Ruby 2.5 and 2.6 support - [@tombruijn](https://github.com/tombruijn).

## 3.1.0

* [#31](https://github.com/mongoid/mongo_session_store/pull/31): Add Rails 5.0 support - [@tombruijn](https://github.com/tombruijn).

## 3.0.0

* Drop Ruby 1.8, 1.9 and 2.0 support - [@tombruijn](https://github.com/tombruijn).
* Drop explicit MongoMapper support - [@tombruijn](https://github.com/tombruijn).
* Drop MongoDB version 2 support - [@brianhempel](https://github.com/brianhempel).
* Support MongoDB version 3 - [@brianhempel](https://github.com/brianhempel).
* Update Mongo Ruby driver support for more recent versions - [@brianhempel](https://github.com/brianhempel), [@tombruijn](https://github.com/tombruijn).
* Update Mongoid support for more recent versions - [@brianhempel](https://github.com/brianhempel), [@tombruijn](https://github.com/tombruijn).
* Add Mongo Ruby driver session store support - [@brianhempel](https://github.com/brianhempel).
* Add Rails 4 support - [@brianhempel](https://github.com/brianhempel).
* Remove explicit Rails 3 support - [@tombruijn](https://github.com/tombruijn).
* Move session data packing and unpacking to session models. This allows queried documents to unpack session data themselves - [@tombruijn](https://github.com/tombruijn).
* Test more internal code - [@tombruijn](https://github.com/tombruijn).
* Allow for easier custom classes and expanded behavior of Mongoid and Mongo session stores - [@tombruijn](https://github.com/tombruijn).
* [#24](https://github.com/mongoid/mongo_session_store/pull/24): Add Danger, PR linter - [@tombruijn](https://github.com/tombruijn), [@dblock](https://github.com/dblock).
* [#27](https://github.com/mongoid/mongo_session_store/pull/27): Run tests against Ruby 2.3.1 and MongoDB 3.2 only - [@dblock](https://github.com/dblock).
* [#28](https://github.com/mongoid/mongo_session_store/pull/28): Support Ruby 2.4 - [@tombruijn](https://github.com/tombruijn).
* [#29](https://github.com/mongoid/mongo_session_store/pull/29): Use rails default session id generation - [@tombruijn](https://github.com/tombruijn).

## 2.0.0

* Fix MongoMapper indexes - [@nmerouze](https://github.com/nmerouze).
* Add Rails 3 support for Mongoid - [@nmerouze](https://github.com/nmerouze).
* Add Rails 3 support for MongoMapper - [@nmerouze](https://github.com/nmerouze).
* Support MongoMapper 0.7.5 - [@hsbt](https://github.com/hsbt).
* Fix issue where ActionPack expects `set_session` to return the (new) session_id when session is created successfully - [@memuller](https://github.com/memuller).

## 1.1.2

* Generate a new session document if the current session document doesn't exist - [@shingara](https://github.com/shingara).

## 1.1.1

* Fix `updated_at` index for MongoMapper session documents - [@nmerouze](https://github.com/nmerouze).

## 1.1.0

* Add Mongoid support - [@nmerouze](https://github.com/nmerouze).

## 1.0.1

* Add gemspec and specify actionpack dependency - [@nmerouze](https://github.com/nmerouze).

## 1.0.0

* Initial version of the gem - [@tpitale](https://github.com/tpitale), [@compressed](https://github.com/compressed).
* MongoMapper session store support - [@tpitale](https://github.com/tpitale), [@compressed](https://github.com/compressed).
