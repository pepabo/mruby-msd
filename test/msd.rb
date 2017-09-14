##
## Msd Test
##
assert("Msd.respond_to") do
  %i(
    setup
    fetch
  ).each do |m|
    assert_true Msd.respond_to? m
  end
end

assert("Msd#configure") do
  Msd.configure do |c|
    c.retry_count = 1
    c.retry_usleep = 2
    c.logger = 3
    c.stores = 4
  end

  assert_equal(1, Msd.config.retry_count)
  assert_equal(2, Msd.config.retry_usleep)
  assert_equal(3, Msd.config.logger)
  assert_equal(4, Msd.config.stores)
end

assert("Msd#setup") do
  lmc = Msd::Store::Lmc.new("test")
  Msd.configure do |c|
    c.stores = [lmc]
  end

  assert_nothing_raised { Msd.setup}
end

assert("Msd#fetch") do
  lmc = Msd::Store::Lmc.new("test")
  Msd.configure do |c|
    c.stores = [lmc]
  end
  lmc.cache("example", "value")

  assert_equal("value", Msd.fetch("example"))
end

assert("Msd#fetch_retry") do
  redis = Msd::Store::Redis.new
  lmc = Msd::Store::Lmc.new("test")

  Msd.configure do |c|
    c.stores = [lmc, redis]
    c.logger = nil
  end
  redis.cache("example.com", "1")
  assert_equal("1", Msd.fetch("example.com"))
  redis.purge("example.com")
  assert_equal("1", Msd.fetch("example.com"))
end
