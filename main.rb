require_relative 'game'
require_relative 'player'

CIRCLE_MARK = "\u25CB".encode('utf-8')
BANNER = "

████████╗██╗ ██████╗    ████████╗ █████╗  ██████╗    ████████╗ ██████╗ ███████╗
╚══██╔══╝██║██╔════╝    ╚══██╔══╝██╔══██╗██╔════╝    ╚══██╔══╝██╔═══██╗██╔════╝
   ██║   ██║██║            ██║   ███████║██║            ██║   ██║   ██║█████╗  
   ██║   ██║██║            ██║   ██╔══██║██║            ██║   ██║   ██║██╔══╝  
   ██║   ██║╚██████╗       ██║   ██║  ██║╚██████╗       ██║   ╚██████╔╝███████╗
   ╚═╝   ╚═╝ ╚═════╝       ╚═╝   ╚═╝  ╚═╝ ╚═════╝       ╚═╝    ╚═════╝ ╚══════╝
                                                                               

"
NUMBERS = "0123456789"
puts BANNER
print ">> Type your name: "
player1_name = gets.chomp
player1_mark = ''
loop do
  print ">> Choose (1) '#{CIRCLE_MARK}' or (2) 'x': "
  player1_mark = 
    case gets.chomp
    when '1' then CIRCLE_MARK
    when '2' then 'x'
    else ''
    end
  break if player1_mark == 'x' || player1_mark == CIRCLE_MARK
  puts ">> Invalid option. Choose 1 or 2."
end
player1 = Player.new(name:player1_name, mark:player1_mark)
player2_mark = player1_mark == 'x' ? CIRCLE_MARK : 'x'
answer = ''
loop do
  print ">> Would you like to choose Player2's name? (y/n) "
  answer = gets.chomp.downcase
  break if answer == 'n' || answer == 'y'
  puts ">> Invalid option. Choose n or y."
end
if answer == 'n'
  player2 = Player.new(mark:player2_mark)
else
  print ">> Type Player2's name: "
  player2_name = gets.chomp
  player2 = Player.new(name:player2_name, mark:player2_mark)
end
game = Game.new([player1, player2])
loop do
  game.print_grid

  while game.count_available_positions > 0
    if game.current_player == game.players[0]
      row = 0
      column = 0
      loop do
        print ">> Enter the row number then the column number (eg, 00, 12, 01 etc.): "
        position_string = gets.chomp
        position = []
        position_string.each_char { |char| position << char.to_i if NUMBERS.include?(char) }
        row, column = position
        break if game.is_available?(row:row.to_i, column:column.to_i)
        puts ">> Invalid position. Try again."
      end
      game.set_mark(mark:game.current_player.mark, row:row.to_i, column:column.to_i)
    else
      game.random_play
    end
    system "clear"
    puts BANNER
    game.print_grid
    if game.count_winning_sequences > 0
      puts ">> #{game.current_player.name} has won!!!"
      break
    else
      game.current_player, game.next_player = game.next_player, game.current_player
    end
  end
  puts ">> Draw..." if game.count_available_positions == 0
  puts
  new_match = ''
  loop do
    print '>> Would you like to play again? (y/n) '
    new_match = gets.chomp.downcase
    break if new_match == 'y' || new_match == 'n'
    puts '>> Invalid option. Type y ou n.'
  end
  break if new_match == 'n'
  game.reset_grid
  system "clear"
  puts BANNER
end




  