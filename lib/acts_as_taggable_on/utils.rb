module ActsAsTaggableOn
  module Utils
    def self.included(base)

      base.send :include, ActsAsTaggableOn::Utils::OverallMethods
      base.extend ActsAsTaggableOn::Utils::OverallMethods
    end

    module OverallMethods
      def using_postgresql?
        ::ActiveRecord::Base.connection && ::ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      end

      def using_sqlite?
        ::ActiveRecord::Base.connection && ::ActiveRecord::Base.connection.adapter_name == 'SQLite'
      end

      def sha_prefix(string)
        Digest::SHA1.hexdigest(string + Time.now.to_s)[0..6]
      end
      
      private
      def like_operator
        # I changed this because I want to be able to create duplicate tags
        # with different capitalizations. LIKE in POSTGRES is already case-sensitive,
        # while for mysql I had to add the 'binary' keyword.
        using_postgresql? ? 'LIKE' : 'LIKE binary'
      end

      # escape _ and % characters in strings, since these are wildcards in SQL.
       def escape_like(str)
         str.gsub(/[!%_]/){ |x| '!' + x }
       end
    end

  end
end
