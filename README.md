# Tea Subscription Service - Project README
# By Allan Evans

## Setup
- Ruby 3.2.2
- Rails 7.0.7.2
- [Faraday](https://github.com/lostisland/faraday) A gem to interact with APIs
- [SimpleCov](https://github.com/simplecov-ruby/simplecov) A gem for code coverage tracking
- [ShouldaMatchers](https://github.com/thoughtbot/shoulda-matchers) A gem for testing assertions

## Installation Instructions
 - Fork Repository
 - `git clone <repo_name>`
 - `cd <repo_name>`
 - `bundle install`   
 - `rails db:{drop,create,migrate}`
 - No webmock yet, no calls to outside api.

## Project Description
Intermission work post Mod 3, creates backend to create users, subscriptions, and teas.  Extension includes usage of a external api.


## End points
- Customer creation post `/api/v1/customer`requires first_name, last_name, email, and address in the body
- Subscription creation post `/api/v1/customers` requires title, price, status, frequency, and the user id in the body
- Subscription deletion destroy `/api/v1/customers/:customer_id/subscriptions/:sub_id`
- Find customers subscriptions get `/api/v1/customers/customer_id/subscriptions`
- Create tea post `/api/v1/teas` requires tilte, description, temperature, brew_time
- Add tea to subscription  patch `/api/v1/subscription_teas` requires subscription_id and tea_id in the body
