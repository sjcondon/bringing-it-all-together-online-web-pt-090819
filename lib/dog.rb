class Dog
  
  def self.create_table
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (id INTEGAR PRIMARY KEY,
        name TEXT,
        album TEXT)
      SQL
      DB[:conn].execute(sql)
    end
  
    def self.drop_table
      DB[:conn].execute("DROP TABLE IF EXISTS dogs")
    end
    
    def self.new_from_db(row)
      self.new(id: row[0], name: row[1], breed: row[2])
    end
    
    def self.find_by_name(name)
      sql = "SELECT * FROM dogs WHERE name = ?"
      DB[:conn].execute(sql,name).map {|row| new_from_db(row)}.first
    end
    
    def self.find_by_id(id)
      sql = "SELECT * FROM dogs WHERE id = ?"
      DB[:conn].execute(sql,name).map {|row| new_from_db(row)}
    end
    
    def self.find_or_create_by(name:, breed:)
      sql = <<-SQL
                SELECT * FROM dogs WHERE name = ? AND breed = ?;
            SQL
    end
    
    def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
    end
    

  
  attr_accessor :id, :name, :breed
  
    def initialize (id: nil, name:, breed:)
      @id = id
      @name = name
      @breed = breed
    end
  
    
  
    def save
        if self.id.nil?
            self.insert
        else
            self.update
        end
        self
    end

    def update
        sql = <<-SQL
                UPDATE dogs SET name = ?, breed = ? WHERE id = ?;
            SQL
        DB[:conn].execute(sql, self.name, self.breed, self.id)
    end

    def insert
        sql = <<-SQL 
                INSERT INTO dogs(name, breed) VALUES (?, ?);
            SQL
        DB[:conn].execute(sql, self.name, self.breed)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;")[0][0]
    end
end