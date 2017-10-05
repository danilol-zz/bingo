class Bingo
  attr_accessor :users, :anounced_numbers

  def initialize
    print "Quantos vao jogar? "
    players = gets.chomp.to_i
    users = []
    players.times do |i|
      print "Qual o nome do jogador #{i+1}? "
      user = User.new(gets.chomp)
      users << user
      puts "Bem vindo #{user.name}"
      puts "Sua cartela: #{user.table.print}"
    end

    #user = User.new("danilo")
    #users << user
    @users = users
    @anounced_numbers = []
  end

  def winner
    u = users.select {|u| u.bingo? }.first
  end

  def run
    result = []

    while not users.any? {|u| u.bingo? }
      begin
        number = rand(1..75).to_s
      end while (anounced_numbers.include?(number))

      anounced_numbers << number

      users.each do |user|
        user.table.matrix.each do |column|
          if column.include?(number)
            user.result[column.first] << number
          end
        end
      end
    end

    puts "Winner! #{winner.name}"
    puts "Result! #{winner.result}"
    puts "Numbers! #{anounced_numbers}"
  end

  class Table
    attr_accessor :matrix

    def initialize
      @matrix = generate_table
    end

    def print
      result = []
      (@matrix.size + 1).times do |i|
        result << @matrix.map {|t| t[i].rjust(5) }.join("|")
      end

      puts result
    end

    private

    def generate_table
      table = []
      table << generate_columns("B", B_COLUMN)
      table << generate_columns("I", I_COLUMN)
      table << generate_columns("N", N_COLUMN)
      table << generate_columns("G", G_COLUMN)
      table << generate_columns("O", O_COLUMN)
    end

    def generate_columns(letter, range)
      column = []
      begin
        x = rand(range)
        column << x unless column.include?(x)
      end while column.size < 5

      [letter] + column.sort.map(&:to_s)
    end

    B_COLUMN =  1..15
    I_COLUMN = 16..30
    N_COLUMN = 31..45
    G_COLUMN = 46..60
    O_COLUMN = 61..75
  end

  class User
    attr_accessor :name, :table, :result

    def initialize(name)
      @name = name
      @table = Table.new
      @result = {"B" => [], "I" => [], "N" => [], "G" => [], "O" => []}
    end

    def bingo?
      result.keys.each do |letter|
        return true if five?(letter)
      end

      false
    end

    def five?(letter)
      result[letter].size == 5
    end
  end
end

bingo = Bingo.new
bingo.run
