# Oh BOSH, Will It Fit?

Find out early if your target deployment will fit into the quota/available limits of your target OpenStack tenancy.

If the deployment fits, then you'll see something like:

![fits](https://www.evernote.com/shard/s3/sh/ce1c2d81-0070-4702-aa84-c426b777429d/0dd99134d3abab7dabd9d4e6cba23349/deep/0/drnic@drnic----gems-ohboshwillitfit---zsh---204-51.png)

If the deployment won't fit, then you'll see:

![wont-fit](https://www.evernote.com/shard/s3/sh/c72b4de3-5955-4c82-9248-d50a46bab36c/0ee172f27ee41311101b029bfa34e04e/deep/0/drnic@drnic----gems-ohboshwillitfit---zsh---204-51.png)

If the deployment has an invalid flavor/instance type:

![bad-flavor](https://www.evernote.com/shard/s3/sh/6d4a3c49-c841-455e-ab4b-039baae6dbd3/c904e89a317e870dea78a84bbaa6e6ae/deep/0/drnic@drnic----gems-ohboshwillitfit---zsh---204-51.png)

## Installation

This BOSH CLI plugin is distributed as a RubyGem:

```
gem install ohboshwillitfit
```

## Usage

Currently, you must have your target OpenStack's credentials stored in a `~/.fog` file and reference the key within that file:

```
bosh will it fit --fog-key default
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/ohboshwillitfit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
