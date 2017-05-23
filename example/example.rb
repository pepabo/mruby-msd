#
# single value
#
mysql = Msd::Store::MySQL.new('SELECT flg FROM test WHERE host = ?', 'localhost', 'root', '', 'msdtest')
redis = Msd::Store::Redis.new
lmc = Msd::Store::Lmc.new("test")

Msd.configure do |c|
  c.logger = nil
  c.stores = [lmc, redis, mysql]
end

puts Msd.fetch('example.com')
puts Msd.fetch('notfound.jp')

# clean
Msd.purge("example.com")
Msd.purge("notfound.jp")

#
# multi value
#
mysql = Msd::Store::MySQL.new('SELECT host, flg FROM test WHERE host = ?', 'localhost', 'root', '', 'msdtest')
redis = Msd::Store::Redis.new
lmc = Msd::Store::Lmc.new("test")

Msd.configure do |c|
  c.logger = nil
  c.stores = [lmc, redis, mysql]
  c.hash_keys = %w(host flag)
end

puts Msd.fetch('example.com')
puts Msd.fetch('notfound.com')

# clean
Msd.purge("example.com")
Msd.purge("notfound.jp")
