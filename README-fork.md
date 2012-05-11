# From Cucumber to Turnip in 5 minutes

_This is the README for the fork. You can still read the original README in this repo: README-forked.rb._

## Why turning to Turnip?

* Instead of having RSpec **and** Cucumber, just have RSpec. Guessing the good part?
* Turnip step definitions are more easy to read.
 
**Here are some references on this subject:**

* [Turnip's author introductory post](http://elabs.se/blog/30-solving-cucumber-s-problems).
* [Thoughbot's review](http://robots.thoughtbot.com/post/21494223079/turnip-a-tasty-cucumber-alternative)

## What does the fork?

**It allows you to continue using Regexp in your step definitions as you did with Cucumber.**

## Why is this nice?

* **Turning from Cucumber to Turnip is now a matter of minutes!**
* You can **continue using Cucumber** in parallel for some specific requirements if you feel so, **and share** (almost *) **your Cucumber step-definitions with Turnip** (the contrary isn't possible however).
* You may feel less worried by the fact that **Turnip now supports Regexp step definitions**!

_* Sadly, Cucumber uses `Given/When/Then` for a step definition, while Turnip only uses `step` (what I find more logical in the context of a step definition). So you will have to do simple search and replace to move your step definitions from Cucumber to Turnip (and back if you need to)._


## The point of the forker

I understand the points of Turnip not using Regexp:

* easier to read,
* faster to write.

However with hundreds of step definitions, **I don't want to spend hours converting them for Turnip just to check if this works** as a replacement of Cucumber for my project.

## Changes in the fork

* Changed StepDefinition to support Regexp.
* Added some specs to ensure this is working correctly with Regexps too.
* As of Turnip 0.3.1, changed the way of joining steps to show a more Cucumber-like list of steps (using new lines and spaces instead of ' -> ')

## Installation

### Installing the gem from the fork

Add this to your Gemfile to use this fork of Turnip:

    gem 'turnip', :git => "https://github.com/rchampourlier/turnip.git"
    
Run `bundle install` and **follow original Turnip's README for Turnip's installation**.

You should be able to keep using Cucumber while using Turnip if you need so until your trusting Turnip enough to remove Cucumber.

### Copy your features

Copy your Cucumber's features to your Turnip's acceptance  directory (e.g. `spec/acceptance`).

### Copy and change (a little) your step definitions

Copy your step definitions to your `spec` directory, for example in `spec/acceptance/step_definitions`.

Turnip's doesn't support `Given/When/Then` used by Cucumber in step definitions, so you will need a simple search and replace to rename them all to `step`. (Converting them back to Cucumber will require the reverse search and replace, using any of `Given/When/Then` since it is not interpreted by Cucumber in step definitions - which makes Turnip more logical when using only `step`).

### Load some Cucumber helpers in RSpec

If you're using Cucumber, you may rely on the `web_steps.rb` step definitions which itself relies on two helpers. They were designed to be loaded in Cucumber, so they need some minor changes to work in RSpec/Turnip.

If you see some `World(<the name of a module>)` in your Cucumber's step definitions, track the module down, extract it to a file you move to your `spec` directory (e.g. `spec/support/helpers`) and add these lines to your `spec_helper.rb` to load them in your RSpec examples:

```
# Turnip cucumber retro-compatibility helpers

RSpec.configure do |config|
  Dir[File.join(File.expand_path("../integration/support/helpers", __FILE__), '*.rb')].each do |file|
    require file
  end
  
  config.include(TheNameOfAModule)
  
  # You may want to add those if you're using
  # Cucumber's web_steps and email_spec
  # config.include(EmailHelpers)
  # config.include(HtmlSelectorsHelpers)
  # config.include(WithinHelpers)
end
```

_This example will include helpers for email_spec and the original helpers needed by Cucumber's `web_steps.rb`. The extracted helpers are available in this repo's `helpers` directory._

You may copy your Cucumber's `path.rb` file in the parent directory of your step definitions.

## Benchmarks

Improvements on a totally arbitrary test suite:

* Cucumber, standalone: total 93s (Cucumber indicates 33s, so I suppose about 1min to load the environment).
* Turnip, RSpec running on Spork: total 45s

The difference is essentially the loading time of the environment. If you're not using Spork, you will still see an improvement when running both unit and integration tests, since they will all run in the same environment (RSpec), which gets loaded once (while RSpec + Cucumber is 2).