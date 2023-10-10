require_relative 'point'
require_relative 'raisin'
require_relative 'piece'

class CakeSolver

  def initialize
    @raisins = Array.new
  end

  def solve
    #Different variantes of cakes
    cake_pattern = ".o.o....\n........\n....o...\n........\n.....o..\n........"
    #cake_pattern = "....\n.o..\n..o.\n....\n"
    #cake_pattern = ".o......\n......o.\n....o...\n..o.....\n"
    #cake_pattern = ".o......\n....o...\n........\n..o.o...\n"
    #cake_pattern = ".o......\n....o...\n......o.\n..o.....\n........\n........\n"


    splited_cake = cake_pattern.split("\n")
    width = splited_cake.length
    length = splited_cake[0].length

    (0...width).each { |i|
      string = splited_cake[i]
      (0...string.length).each { |j|
        if string[j] == 'о' || string[j] == 'o'
          raisin = Raisin.new(j, i)
          @raisins << raisin
        end
      }
    }

    raisins_count = validate_raisins_count

    pieces = generate_pieces(length, width, length * width / raisins_count)
    solutions = find_solutions(pieces, raisins_count)
    solutions_count = solutions.size

    solutions.each_with_index do |solution, solution_index|
      solution.each_with_index do |piece, piece_index|
        x_range = piece.x...piece.width + piece.x
        y_range = piece.y...piece.height + piece.y
        @raisins.each do |raisin|
          if (x_range.include?(raisin.x) && y_range.include?(raisin.y))
            piece.locate_raisin(raisin)
          end
        end
      end
    end


    puts "\n\nSolution's quantity: #{solutions_count}"

    array = Array.new(solutions_count) { Array.new(solutions[0].size, 0) }
    solutions.each_with_index do |solution, solution_index|
      solution.each_with_index do |piece, piece_index|
        array[solution_index][piece_index] = piece.width
      end
    end


    solutions[0].size.times do |piece_index|
      max = 0
      counter = 0
      solutions_count.times do |solution_index|
        if array[solution_index][piece_index] > max
          max = array[solution_index][piece_index]
          counter += 1
        elsif array[solution_index][piece_index] == max
          counter += 1
        end
      end


      solutions_count.times do |solution_index|
        if array[solution_index][piece_index] < max
          array[solution_index].fill(0)
        end
      end
    end
    


    finalSolutionIndex = -1
    solutions[0].size.times do |piece_index|
      solutions_count.times do |solution_index|
        if array[solution_index][piece_index] != 0
          finalSolutionIndex = solution_index
        end
      end
    end

   
    if finalSolutionIndex != -1
      puts "\n\nInitial cake:"
      print_cake(solutions[finalSolutionIndex], length, width)
      puts("\n\n")
      puts "Pieces:"
      print_pieces(solutions[finalSolutionIndex], length, width)
    else
      puts "Equal solutions"
    end

  end


  def validate_raisins_count
    raisins_count = @raisins.size
    raise ArgumentError.new("The amount of raisins must be > 1") if raisins_count <= 1
    raise ArgumentError.new("The amount of raisins must be < 10") if raisins_count >= 10
    return raisins_count
  end

  
  def has_single_raisin(piece1, piece2)
    first_piece = false
    second_piece = false

    amount_in_first_piece = 0
    amount_in_second_piece = 0

    @raisins.each do |raisin|
      raisin_point = Point.new(raisin.x, raisin.y)
      if piece1.contains(raisin_point) && piece2.contains(raisin_point)
        return false
      end
      if piece1.contains(raisin_point)
        amount_in_first_piece += 1
        if amount_in_first_piece == 1
          first_piece = true
        else
          return false
        end
      end
      if piece2.contains(raisin_point)
        amount_in_second_piece += 1
        if amount_in_second_piece == 1
          second_piece = true
        else
          return false
        end
      end
    end
    first_piece && second_piece
  end


  def pieces_overlap(first_piece, second_piece)
    !first_piece.intersects(second_piece) && has_single_raisin(first_piece, second_piece)
  end


  def pieces_overlap_in_collection(pieces)
    (0...pieces.size).each { |i|
      (i + 1...pieces.size).each { |j|
        if pieces_overlap(pieces[i], pieces[j])
          next
        else
          return false
        end
      }
    }
    true
  end


  def generate_pieces(length, width, area)
    result = []
    (0...length).each do |x1|
      (0...width).each do |y1|
        (x1...length).each do |x2|
          (y1...width).each do |y2|
            piece = Piece.new(x1, y1, (x2 - x1 + 1), (y2 - y1 + 1))
            if piece.height * piece.width == area
              result << piece
            end
          end
        end
      end
    end
    result
  end


  def find_solutions(all_available_pieces, raisinsAmount)
    solutions = []
    find_all_solutions(all_available_pieces, solutions, [], raisinsAmount, 0)
    solutions
  end


  def find_all_solutions(all_available_pieces, solutions, current_solution, raisinsAmount, start_index)
    if current_solution.size == raisinsAmount
      if pieces_overlap_in_collection(current_solution)
        solutions.append(current_solution.clone)
      end
      return
    end

    (start_index...all_available_pieces.size).each { |i|
      current_solution.append(all_available_pieces[i])
      find_all_solutions(all_available_pieces, solutions, current_solution, raisinsAmount, i + 1)
      current_solution.pop
    }
  end


  def print_cake(pieces, length, width)
    (0...width).each do |j|
      (0...length).each do |i|
        found = false
        pieces.each_with_index do |piece, k|
          if piece.contains(Point.new(i, j))
              if piece.raisin.x == i && piece.raisin.y == j
                print "o "
              else
                print ". "
              end
            found = true
            break
          end
        end
        print " " unless found
      end
      puts
    end
  end


  def print_pieces(pieces, length, width)
    total_area = 0

    pieces.each_with_index do |piece, k|
      area = piece.width * piece.height
      total_area += area

      puts "------------------------"
      puts "#{k + 1}) Piece:"
      (0...width).each do |j|
        row_output = ""
        (0...length).each do |i|
          if piece.contains(Point.new(i, j))
            row_output += piece.contains_raisin?(Point.new(i, j)) ? "★ " : "."
          else
            row_output += ". "
          end
        end
        puts row_output.strip
      end

      puts "\nS = #{area}.0"
    end

    puts "------------------------"
    puts "Total Area = #{total_area}.0\n\n"
  end

end


CakeSolver.new.solve