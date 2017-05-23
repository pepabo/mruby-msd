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

  assert_equal(Msd.config.retry_count, 1)
  assert_equal(Msd.config.retry_usleep, 2)
  assert_equal(Msd.config.logger, 3)
  assert_equal(Msd.config.stores, 4)
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

  assert_equal(Msd.fetch("example"), "value")
end
