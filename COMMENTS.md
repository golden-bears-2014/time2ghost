* Bart:  Why is this  class called this?  Did you build an abstraction of the
  entire BART service?
* app/models/bart.rb needs to be looked at during a team review (possibly refac
  live)
* We do not commit our log/ directory
* Why are we re-including jquery in app/assets?  Doesn't rails come with
  jQuery?  Did you need a newer version?  If so, it should probably be in
  vendor/assets/javascripts
* Why does mailer directory exist?
* Rails conventions say do not captialize your model file name "trip.rb" not
  "Trip.rb"
* I really feel like there should be a lot of classes like *Calculator:
  distance calculator, next train calculator, total trip time calculator, etc
* I'm surprised Trip doesn't know how to make toast, it knows everything in the
  universe
* You have so many classes that *need* to be extracted, that should help with
  your paucity of tests.
