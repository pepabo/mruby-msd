def rows_mock(val)
  rows = Mocks::Mock.new
  rows.stubs(:next).returns(val)
  rows.stubs(:close).returns(true)
  rows
end

def mysql_mock(rows)
  mysql = Mocks::Mock.new
  connection = Mocks::Mock.new
  connection.stubs(:execute).returns(rows)
  mysql.stubs(:new).returns(connection)
  mysql
end

def mock(val)
  rows = rows_mock(val)
  mysql_mock(rows)
end

def subject(query="SELECT flg FROM test WHERE host = ?")
  Msd::Store::MySQL.new(query)
end

assert("Msd::Store::MySQL.connect") do
  s = subject
  s.set_mysql_class(mock('1'))
  assert_true s.connect
  assert_true s.connect?
end

assert("Msd::Store::MySQL.fetch") do
  s = subject
  s.set_mysql_class(mock('0'))
  assert_equal("0", s.fetch("sample.jp"))

  s = subject
  s.set_mysql_class(mock(''))
  assert_equal("", s.fetch("sample.com"))
end

assert("Msd::Store::MySQL.hash") do
  s = subject('SELECT host, flg FROM test WHERE host = ?')
  s.hash_keys = %w(host flg)
  s.set_mysql_class(mock(['sample.jp', '0']))
  assert_equal({"host"=>"sample.jp", "flg"=>"0"}, s.fetch("sample.jp"))
end

assert("Msd::Store::MySQL.key_prefix") do
  s = subject
  s.key_prefix = 'sample.'
  s.set_mysql_class(mock('0'))
  assert_equal("0", s.fetch("jp"))
end
