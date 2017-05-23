# mruby-msd   [![Build Status](https://travis-ci.org/pepabo/mruby-msd.svg?branch=master)](https://travis-ci.org/pepabo/mruby-msd)
msd class
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'pyama86/mruby-msd'
end
```
## How to start development
### docker-compose
```bash
$ rake dev:docker
$ rake clean
$ rake test
```

### OSX
```
$ brew install mysql
$ brew install redis
$ brew services start mysql
$ brew services start redis
$ rake test
```

## License
under the MIT License:
- see LICENSE file
