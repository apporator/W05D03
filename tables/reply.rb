
class Reply

    attr_accessor :id, :question_id, :parent_reply, :user_id, :body

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM replies")
        data.map {|element| Reply.new(element)}
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply = options['parent_reply']
        @user_id = options['user_id']
        @body = options['body']
    end

    def author
        User.find_by_id(self.user_id)
    end

    def question
        Question.find_by_id(self.question_id)
    end

    def self.find_by_id(id)
        # debugger
        data = PlayDBConnection.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM replies
            WHERE id = ?
        SQL
        # debugger
        Reply.new(data.first) if result?(data)
    end

    def self.find_by_user_id(u_id)
        data = PlayDBConnection.instance.execute(<<-SQL, u_id)
            SELECT
            *
            FROM replies
            WHERE user_id = ?
        SQL
        # debugger
        data.map {|element| Reply.new(element)} if Reply.result?(data)
    end

    def self.find_by_question_id(question_id)
        # debugger
        data = PlayDBConnection.instance.execute(<<-SQL, question_id)
            SELECT
            *
            FROM replies
            WHERE question_id = ?
        SQL
        # debugger
        data.map {|element| Reply.new(element)} if Reply.result?(data)
    end

    def get_parent_reply
        Reply.find_by_id(self.parent_reply)
    end

    def child_replies
        # Reply.find_by_id(self.parent_reply) if parent_reply
        data = PlayDBConnection.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM
                replies
            WHERE
                parent_reply = ?
        SQL

        Reply.new(data.first) if Reply.result?(data)
    end

    def result?(data)
        if data.empty?
            puts "No entry found."
            return false
        else
            return true
        end
    end

    def self.result?(data)
        if data.empty?
            puts "No entry found."
            return false
        else
            return true
        end
    end

    def save
        return false if self.id

        data = PlayDBConnection.instance.execute(<<-SQL, self.question_id, self.parent_reply, self.user_id, self.body)
        INSERT INTO
            replies(question_id, parent_reply, user_id, body)
        VALUES
            (?,?,?,?)
        SQL

        return self
    end

    def update
        return false if self.id.nil?

        data = PlayDBConnection.instance.execute(<<-SQL, self.question_id, self.parent_reply, self.user_id, self.body, self.id)
            UPDATE
                replies
            SET
                question_id = ?, parent_reply = ?, user_id = ?, body = ?
            where id = ?
        SQL

        return self
    end
end