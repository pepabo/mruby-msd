assert("Msd::Store::Redis.respond_to") do
  redis = Msd::Store::Redis.new
  %i(
    connect
    connect?
    close
    fetch
    cache
  ).each do |m|
    assert_true redis.respond_to? m
  end
end

assert("Msd::Store::Redis.connect") do
  redis = Msd::Store::Redis.new
  assert_true redis.connect
end

assert("Msd::Store::Redis.connect?") do
  redis = Msd::Store::Redis.new
  assert_false redis.connect?
  redis.connect
  assert_true redis.connect?
end

assert("Msd::Store::Redis.close") do
  redis = Msd::Store::Redis.new
  redis.set_mock
  redis.connect
  assert_true redis.connect?
  redis.close
  assert_false redis.connect?
end

assert("Msd::Store::Redis.cache") do
  redis = Msd::Store::Redis.new
  redis.cache("example", "value")
  assert_equal("value", redis.fetch("example"))

  redis.hash_keys = %w(key)
  redis.cache("hash", { "key" => "value"})
  assert_equal("value", redis.fetch("hash")["key"])
end

assert("Msd::Store::Redis.key_prefix") do
  redis = Msd::Store::Redis.new
  redis.key_prefix = "prefix_"
  redis.cache("example", "value")
  assert_equal("value", redis.fetch("example"))

  pure_redis = Msd::Store::Redis.new
  assert_equal("value", pure_redis.fetch("prefix_example"))
end
