class User
    # @@table_name = 'users'
    # include TableHelper

    attr_accessor :id, :fname, :lname, :table_name

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM users")
        data.map {|element| User.new(element)}
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        # debugger

        data = PlayDBConnection.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM users
            WHERE id = ?
        SQL

        User.new(data.first) if result?(data)
    end

    def self.find_by_name(fname, lname)
        data = PlayDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
            *
            FROM users
            WHERE fname = ?
            AND lname = ?
        SQL

        User.new(data.first) if result?(data)
    end

    def self.result?(data)
        if data.empty?
            puts "No entry found."
            return false
        else
            return true
        end
    end

    def authored_questions
        Question.find_by_author_id(self.id)
    end
end