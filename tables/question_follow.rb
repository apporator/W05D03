class QuestionFollow

    attr_accessor :id, :question_id, :user_id

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM question_follows")
        data.map {|element| Question.new(element)}
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def followers_for_question_id(q_id)
        data = PlayDBConnection.instance.execute(<<-SQL, q_id)     
            SELECT
            *
            FROM question_follows
            where user_id = ?
        SQL

        
    end
end