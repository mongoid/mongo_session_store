# Releasing

Release from a clean local checkout of the upstream repository, not a fork. You need push access, RubyGems ownership with MFA, and an authenticated GitHub CLI.

## Prepare

1. Run `git switch main`, `git pull --ff-only`, and confirm that `origin` points to `mongoid/mongo_session_store`.
2. Choose the next semantic version, update `lib/mongo_session_store/version.rb`, and replace the unreleased changelog heading with the version and release date. Remove the contribution placeholder.
3. With MongoDB running, install dependencies and run `bundle exec rake test` using each supported adapter's `BUNDLE_GEMFILE`, for example `gemfiles/rails-6.0-mongo.gemfile` and `gemfiles/rails-6.0-mongoid.gemfile`. Run `bundle exec rubocop` with the default Gemfile.
4. Commit the preparation, push `main`, and wait for the complete GitHub Actions matrix to pass for that commit.

## Publish

Do not use the legacy `rake release` task: it assumes `master` and performs interactive edits. Build and publish the prepared version explicitly:

```sh
version=3.2.2 # Replace with the version being released.
gem build mongo_session_store.gemspec
git tag "v$version"
git push origin "v$version"
gem push "mongo_session_store-$version.gem"
```

Enter a fresh RubyGems MFA code when prompted. Create a GitHub release from the same tag, using the matching changelog section as the release notes:

```sh
gh release create "v$version" --repo mongoid/mongo_session_store \
  --verify-tag --title "$version" --notes-file /path/to/release-notes.md --latest
```

Verify the exact version at `https://rubygems.org/gems/mongo_session_store/versions/VERSION` and inspect `gh release view "v$version" --repo mongoid/mongo_session_store` to confirm a published, non-draft release.

If publication is interrupted, check the remote tag, RubyGems version, and GitHub release first. Resume only the missing step; never move a published tag or rebuild an already published version. If the gem push needs a new code, retry that command with `--otp CODE`.

## Next development version

Increment the patch version in `lib/mongo_session_store/version.rb`, add a new `## (unreleased)` section with a contribution placeholder, and commit and push the changes to `main`. Remove the local built gem after successful publication.
