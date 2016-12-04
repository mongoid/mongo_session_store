# Changelog

## 3.0.0 (unreleased)

- Drop Ruby 1.8 support.
- Drop explicit MongoMapper support.
- Drop MongoDB version 2 support.
- Support MongoDB version 3.
- Update Mongo Ruby driver support for more recent versions.
- Update Mongoid support for more recent versions.
- Add Mongo Ruby driver session store support.
- Add Rails 4 support.
- Remove explicit Rails 3 support.
- Move session data packing and unpacking to session models. This allows
  queried documents to unpack session data themselves.
- Test more internal code.
- Allow for easier custom classes and expanded behavior of Mongoid and Mongo
  session stores.

## 2.0.0

- Fix MongoMapper indexes
- Add Rails 3 support for Mongoid.
- Add Rails 3 support for MongoMapper.
- Support MongoMapper 0.7.5.
- Fix issue where ActionPack expects `set_session` to return the (new)
  session_id when session is created successfully.

## 1.1.2

- Generate a new session document if the current session document doesn't
  exist.

## 1.1.1

- Fix `updated_at` index for MongoMapper session documents.

## 1.1.0

- Add Mongoid support.

## 1.0.1

- Add gemspec and specify actionpack dependency.

## 1.0.0

Initial version of the gem.

- MongoMapper session store support.
