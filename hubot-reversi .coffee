# Description
#  Reversi script
#
# Dependencies:
#  None
#
# Configuration:
#  None
#
# Commands:
#  hubot game start - オセロゲーム開始する
#
# Notes:
#
#
# Author:
#  minegishi@wpuzzle.com

module.exports = (robot) ->
  robot.hear /(鮪|マグロ|ﾏｸﾞﾛ|まぐろ|tuna|Tuna|TUNA)/i, (msg) ->
    msg.send "あるよっ:sushi:"


  robot.hear /navico game start/i, (msg) ->
    bordArray = [
      ["□", "□", "□", "□", "□", "□", "□", "□"],
      ["□", "□", "□", "□", "□", "□", "□", "□"],
      ["□", "□", "□", "□", "□", "□", "□", "□"],
      ["□", "□", "□", "○", "●", "□", "□", "□"],
      ["□", "□", "□", "●", "○", "□", "□", "□"],
      ["□", "□", "□", "□", "□", "□", "□", "□"],
      ["□", "□", "□", "□", "□", "□", "□", "□"],
      ["□", "□", "□", "□", "□", "□", "□", "□"]
    ]

    turn = "black"

    # brainを初期化
    robot.brain.set("ba", bordArray)
    robot.brain.set("turn", turn)

    msg.send outputBord(bordArray)
    msg.send outputTurn(turn) + "からスタートです。"


  robot.hear /navico set(\s[ABCDEFGH]{1}[12345678]{1})/i, (msg) ->
    bordArray = robot.brain.get("ba")
    turn = robot.brain.get("turn")

    point = msg.match[1]
    x = parseInt(point[2], 10) - 1
    y = parseInt(point[1], 16) - 10

    list = []
    bordArray = updateBord(bordArray, list, x, y, turn)
    turn = changeTurn(turn)

    robot.brain.set("ba", bordArray)
    robot.brain.set("turn", turn)

    msg.send outputBord(bordArray)
    msg.send "次は、" + outputTurn(turn) + "のターンです。"


outputBord = (ba) ->
  retmsg = "....A.B..C.D..E..F..G.H\n" +
      "１#{ba[0][0]}#{ba[0][1]}#{ba[0][2]}#{ba[0][3]}#{ba[0][4]}#{ba[0][5]}#{ba[0][6]}#{ba[0][7]}\n" +
      "２#{ba[1][0]}#{ba[1][1]}#{ba[1][2]}#{ba[1][3]}#{ba[1][4]}#{ba[1][5]}#{ba[1][6]}#{ba[1][7]}\n" +
      "３#{ba[2][0]}#{ba[2][1]}#{ba[2][2]}#{ba[2][3]}#{ba[2][4]}#{ba[2][5]}#{ba[2][6]}#{ba[2][7]}\n" +
      "４#{ba[3][0]}#{ba[3][1]}#{ba[3][2]}#{ba[3][3]}#{ba[3][4]}#{ba[3][5]}#{ba[3][6]}#{ba[3][7]}\n" +
      "５#{ba[4][0]}#{ba[4][1]}#{ba[4][2]}#{ba[4][3]}#{ba[4][4]}#{ba[4][5]}#{ba[4][6]}#{ba[4][7]}\n" +
      "６#{ba[5][0]}#{ba[5][1]}#{ba[5][2]}#{ba[5][3]}#{ba[5][4]}#{ba[5][5]}#{ba[5][6]}#{ba[5][7]}\n" +
      "７#{ba[6][0]}#{ba[6][1]}#{ba[6][2]}#{ba[6][3]}#{ba[6][4]}#{ba[6][5]}#{ba[6][6]}#{ba[6][7]}\n" +
      "８#{ba[7][0]}#{ba[7][1]}#{ba[7][2]}#{ba[7][3]}#{ba[7][4]}#{ba[7][5]}#{ba[7][6]}#{ba[7][7]}\n"


outputTurn = (turn) ->
  if turn == "black" then "黒" else "白"


updateBord = (ba, lists, x, y, turn) ->
  stone = if turn == "black" then "●" else "○"

  ba[x][y] = stone

  for list in lists
    ba[list[1]][list[0]] = stone

  return ba


changeTurn = (turn) ->
  if turn == "black" then "white" else "black"
