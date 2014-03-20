# Oh BOSH, Will It Fit?

Find out early if your target deployment will fit into the quota/available limits of your target OpenStack tenancy.

If the deployment fits, then you'll see something like:

![fits](https://www.evernote.com/shard/s3/sh/ce1c2d81-0070-4702-aa84-c426b777429d/0dd99134d3abab7dabd9d4e6cba23349/deep/0/drnic@drnic----gems-ohboshwillitfit---zsh---204-51.png)

If the deployment has an invalid flavor/instance type:

![bad-flavor](https://www.evernote.com/shard/s3/sh/6d4a3c49-c841-455e-ab4b-039baae6dbd3/c904e89a317e870dea78a84bbaa6e6ae/deep/0/drnic@drnic----gems-ohboshwillitfit---zsh---204-51.png)

## Installation

Add this line to your application's Gemfile:

    gem 'ohboshwillitfit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ohboshwillitfit

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/ohboshwillitfit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
