# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points

def score_mobil1(dice)
  sum_Score = 0
  dices = dice.sort
  dices.uniq.each do |y|
    if dices.count(y) >= 3
      y == 1 ? sum_Score = 1000 : sum_Score = y * 100
      dices[dices.find_index {|x| x==y}, 3] = []
      break
    end
  end
  sum_Score + dice.count(1)*100 + dice.count(5)*50
end

def score_mobil2(dice)
  sum_Score = 0
  dices = dice.sort
  dices.uniq.each do |uniq_dice|
    Points.keys.sort.reverse.each do |bonus_combo|
      count = dices.count(uniq_dice) / bonus_combo
      if count > 0
        sum_Score+=Points[bonus_combo].fetch(uniq_dice, 0) * count
        dices[dices.find_index {|x| x==uniq_dice}, bonus_combo] = []
      end
    end
  end
  return sum_Score
end

  Points = {
    3 => {
      1 => 1000,
      2 => 200,
      3 => 300,
      4 => 400,
      5 => 500,
      6 => 600
    },
    1 => {
      1 => 100,
      5 => 50
    }
  }

def score_alex1(dices)
  (1..6).reduce(0) do |sum, dice|
    triples, singles = dices.count(dice).divmod(3)
    sum + triples * Points[3].fetch(dice, 0) +
           singles * Points[1].fetch(dice, 0)
  end
end

def score_alex2(dices)
 	faces = (1..6).to_a
	sets = Points.keys.sort.reverse
	faces.reduce(0) do |acc, face|
    	left = dices.count(face)
    	point = sets.reduce(0) do |acc, set|
    		count, left = left.divmod(set) 
      		point = count * Points[set].fetch(face, 0)
      		acc + point
    	end
    acc + point
	end
end

def time_sandwich
time1 = Time.now
6.times do |a|
  6.times do |b|
    6.times do |c|
      6.times do |d|
        6.times do |e|
          score = [a+1, b+1, c+1, d+1, e+1]
          yield(score)
        end
      end
    end
  end
end
time2 = Time.now
puts time2 - time1
end

time_sandwich {}
time_sandwich {|score| score_mobil1(score)}
time_sandwich {|score| score_mobil2(score)}
time_sandwich {|score| score_alex1(score)}
time_sandwich {|score| score_alex2(score)}