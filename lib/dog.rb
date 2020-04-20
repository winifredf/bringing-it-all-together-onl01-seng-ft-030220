class Dog
  
  attr_accessor :name, :breed
  attr_reader :id
  
    def initialize(id: nil, name:, breed:)
      @id = id
      @name = name
      @breed = breed
    end
    
    def self.create_table
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
        name TEXT,
        breed TEXT
        )
      SQL
      
      DB[:conn].execute(sql)
    end
    
    def self.drop_table
      sql = <<-SQL
        DROP TABLE IF EXISTS dogs
      SQL
      
      DB[:conn].execute(sql)
    end
    
    def save
      if self.id
        self.update
      else
      sql = <<-SQL
        INSERT INTO dogs(name, breed)
        VALUES (?, ?)
      SQL
      
      DB[:conn].execute(sql, self.name, self.breed)
      
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end
    
    def self.create(hash_of_attributes)
      dog =self.new(hash_of_attributes)
      dog.save
      dog
    end
    
    def self.new_from_db(row)
      hash_of_attributes = {
        :id => row[0],
        :name => row[1],
        :breed => row [2]
      }
      self.new(hash_of_attributes)
    end
    
    def self.find_by_id(id)
      sql = <<-SQL
        SELECT * FROM dogs WHERE id = ?
      SQL
      DB[:conn].execute(sql, id).map do |row|
        self.new_from_db(row)
      end.first
    end
    
    def self.find_or_create_by
      if !dog.empty?
        dog_data = dog[0]
        dog = new_from_db(dog_data)
      else
        dog = self.create({name:, breed: breed})
      end
      dog
    end
  end
        
