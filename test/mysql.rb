def make_rows_mock(val)
  rows = Mocks::Mock.new
  rows.stubs(:next).returns(val)
  rows.stubs(:close).returns(true)
  rows
end

def make_conn_mock(query, key, rows)
  conn = Mocks::Mock.new
  conn.stubs(:execute).with(query, key).returns(rows)
  conn
end

def make_mysql_mock(conn)
  mysql = Mocks::Mock.new
  mysql.stubs(:close).returns(true)
  mysql.stubs(:connect?).returns(true)
  mysql.stubs(:new).with('localhost', 'root', '', 'database').returns(conn)
  mysql
end

def make_basic_mock(key, val)
  rows = make_rows_mock(val)
  conn = make_conn_mock('SELECT flg FROM test WHERE host = ?', key, rows)
  make_mysql_mock(conn)
end

def make_hash_mock(key, val)
  rows = make_rows_mock(val)
  conn = make_conn_mock('SELECT host, flg FROM test WHERE host = ?', key, rows)
  make_mysql_mock(conn)
end

def subject(query="SELECT flg FROM test WHERE host = ?")
  Msd::Store::MySQL.new(query)
end

assert("Msd::Store::MySQL.connect") do
  s = subject
  s.set_mysql_class(make_basic_mock('sample.jp', '1'))
  s.disconnect
  assert_true s.connect
end

assert("Msd::Store::MySQL.connect?") do
  s = subject
  s.set_mysql_class(make_basic_mock('sample.jp', '1'))
  s.disconnect
  s.connect
  assert_true s.connect?
end

assert("Msd::Store::MySQL.fetch OK") do
  s = subject
  s.set_mysql_class(make_basic_mock('sample.jp', '0'))
  assert_equal(s.fetch("sample.jp"), "0")
end

assert("Msd::Store::MySQL.fetch NOT OK") do
  s = subject
  s.set_mysql_class(make_basic_mock('sample.com', ''))
  assert_equal(s.fetch("sample.com"), "")
end

assert("Msd::Store::MySQL.hash OK") do
  s = subject('SELECT host, flg FROM test WHERE host = ?')
  s.hash_keys = %w(host flg)
  s.set_mysql_class(make_hash_mock('sample.jp', ['sample.jp', '0']))
  assert_equal(s.fetch("sample.jp"), {"host"=>"sample.jp", "flg"=>"0"})
end

assert("Msd::Store::MySQL.key_prefix") do
  s = subject
  s.key_prefix = 'sample.'
  s.set_mysql_class(make_basic_mock('sample.jp', '0'))
  assert_equal(s.fetch("jp"), "0")
end
