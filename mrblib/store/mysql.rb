module Msd
  class Store
    class MySQL
      include HashKeys
      include Prefixer
      def initialize(query, server = nil, user = nil, password = nil, database = nil)
        @query = query
        @server = ENV['MYSQL_HOST'] || server
        @user = ENV['MYSQL_USER'] || user
        @password = ENV['MYSQL_PASSWORD'] || password
        @database = ENV['MYSQL_DATABASE'] || database
        @mysql = ::MySQL::Database
      end

      def set_mysql_class(mysql)
        @mysql = mysql
        disconnect
        connect
      end

      def connect
        @_c ||= @mysql.new(@server, @user, @password, @database)
      end

      def connect?
        @_c
      end

      def disconnect
        @_c = nil
      end

      def fetch(key)
        key = set_prefix(key)
        connect unless connect?
        rows = @_c.execute(@query, key)
        cols = rows.next
        rows.close
        if cols
          if has_keys?
            r = {}
            hash_keys.each_with_index do |h,index|
              r[h] = cols[index].to_s
            end
            r
          else
            cols[0].to_s
          end
        end
      end

      def cache(key, val)
        true
      end

      def purge(key)
        true
      end

      def before_connect_retry
        @_c.close
      end

      def before_fetch_retry
        @_c.close
        @_c.connect
      end

      def before_purge_retry;end
    end
  end
end
