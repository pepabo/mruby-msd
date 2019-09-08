##
## Msc Test
##
assert("Msd::Store::Lmc.respond_to") do
  lmc = Msd::Store::Lmc.new("test")
  %i(
    connect
    connect?
    drop
    fetch
    cache
  ).each do |m|
    assert_true lmc.respond_to? m
  end
end

assert("Msd::Store::Lmc.connect") do
  lmc = Msd::Store::Lmc.new("test")
  assert_not_nil lmc.connect
end

assert("Msd::Store::Lmc.connect?") do
  lmc = Msd::Store::Lmc.new("test")
  assert_false lmc.connect?
  lmc.connect
  assert_not_nil lmc.connect?
end

assert("Msd::Store::Lmc.drop") do
  lmc = Msd::Store::Lmc.new("test")
  lmc.connect
  assert_not_nil lmc.connect?
  lmc.drop
  assert_false lmc.connect?
end

assert("Msd::Store::Lmc.cache") do
  lmc = Msd::Store::Lmc.new("test")
  lmc.cache("example", "value")
  assert_equal("value", lmc.fetch("example"))

  lmc.hash_keys = %w(key)
  lmc.cache("hash", { "key" => "value"})
  assert_equal({ "key" => "value"}, lmc.fetch("hash"))
end

assert("Msd::Store::Lmc.key_prefix") do
  lmc = Msd::Store::Lmc.new("test")
  lmc.key_prefix = "prefix_"
  lmc.cache("example", "value")
  assert_equal("value", lmc.fetch("example"))

  pure_lmc = Msd::Store::Lmc.new("test")
  assert_equal("value", pure_lmc.fetch("prefix_example"))
end

