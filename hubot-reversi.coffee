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

    robot.brain.set("ba", bordArray)
    robot.brain.set("turn", turn)

    msg.send outputBord(bordArray)
    msg.send outputTurn(turn) + "からスタートです。"


  robot.hear /navico set(\s[ABCDEFGH]{1}[12345678]{1})/i, (msg) ->
    bordArray = robot.brain.get("ba")
    turn = robot.brain.get("turn")

    point = msg.match[1]
    x = parseInt(point[2], 10) - 1
    y = point[1].charCodeAt(0) - 65

    if !checkPosition(bordArray, x, y)
      msg.send "置けません。A"
      return

    list = []
    list = checkUe(bordArray, list, x, y, turn)
    list = checkShita(bordArray, list, x, y, turn)
    list = checkMigi(bordArray, list, x, y, turn)
    list = checkHidari(bordArray, list, x, y, turn)
    list = checkMigiUe(bordArray, list, x, y, turn)
    list = checkMigiShita(bordArray, list, x, y, turn)
    list = checkHidariUe(bordArray, list, x, y, turn)
    list = checkHidariShita(bordArray, list, x, y, turn)

    if list.length == 0
      msg.send "置けません。B"
      return

    bordArray = updateBord(bordArray, list, x, y, turn)
    turn = changeTurn(turn)

    robot.brain.set("ba", bordArray)
    robot.brain.set("turn", turn)

    if checkGameEnd(bordArray)
      msg.send outputBord(bordArray)
      msg.send outputEnding(bordArray)
      return

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


outputEnding = (ba) ->
  retmsg = "ゲームが終了しました。お疲れ様でした。"


updateBord = (ba, lists, x, y, turn) ->
  stone = if turn == "black" then "●" else "○"

  ba[x][y] = stone

  for list in lists
    ba[list[1]][list[0]] = stone

  return ba


changeTurn = (turn) ->
  if turn == "black" then "white" else "black"


checkPosition = (ba, x, y) ->
  isEmpty = if ba[x][y] == "□" then true else false


checkGameEnd = (ba) ->
  isEnd = true
  for x in [0..7]
    for y in [0..7]
      if ba[x][y] == "□"
        isEnd = false
        break


checkShita = (ba, list, x, y, turn) ->
  hitStoneList = []
  count = 0
  hit = false
  myStone = if turn == "black" then "●" else "○"
  searchStone = if turn == "black" then "○" else "●"

  if x < 7
    for i in [(x + 1)...7]
      if ba[i][y] == "□"
        break

      if ba[i][y] == myStone && count == 0
        break

      if ba[i][y] == searchStone
        count += 1
        hitStoneList.push("" + y + i)

      if ba[i][y] == myStone && count > 0
        hit = true
        break

    if hit == true
      list = list.concat hitStoneList

  return list


checkMigi = (ba, list, x, y, turn) ->
  hitStoneList = []
  count = 0
  hit = false
  myStone = if turn == "black" then "●" else "○"
  searchStone = if turn == "black" then "○" else "●"

  if y < 7
    for i in [(y + 1)...7]
      if ba[x][i] == "□"
        break

      if ba[x][i] == myStone && count == 0
        break

      if ba[x][i] == searchStone
        count += 1
        hitStoneList.push("" + i + x)

      if ba[x][i] == myStone && count > 0
        hit = true
        break

    if hit == true
      list = list.concat hitStoneList

  return list


checkUe = (ba, list, x, y, turn) ->
  hitStoneList = []
  count = 0
  hit = false
  myStone = if turn == "black" then "●" else "○"
  searchStone = if turn == "black" then "○" else "●"

  if x > 0
    for i in [(x - 1)...0]
      if ba[i][y] == "□"
        break

      if ba[i][y] == myStone && count == 0
        break

      if ba[i][y] == myStone && count > 0
        hit = true
        break

      if ba[i][y] == searchStone
        count += 1
        hitStoneList.push("" + y + i)

    if hit == true
      list = list.concat hitStoneList

  return list


checkHidari = (ba, list, x, y, turn) ->
  hitStoneList = []
  count = 0
  hit = false
  myStone = if turn == "black" then "●" else "○"
  searchStone = if turn == "black" then "○" else "●"

  if y > 0
    for i in [(y - 1)...0]
      if ba[x][i] == "□"
        break

      if ba[x][i] == myStone && count == 0
        break

      if ba[x][i] == myStone && count > 0
        hit = true
        break

      if ba[x][i] == searchStone
        count += 1
        hitStoneList.push("" + i + x)

    if hit == true
      list = list.concat hitStoneList

  return list


checkHidariUe = (ba, list, x, y, turn) ->
  hitStoneList = []
  count = 0
  hit = false
  myStone = if turn == "black" then "●" else "○"
  searchStone = if turn == "black" then "○" else "●"

  if x > 0
    for i in [(x - 1)...0]
      if ba[i][(y - (x - i))] == "□"
        break

      if ba[i][(y - (x - i))] == myStone && count == 0
        break

      if ba[i][(y - (x - i))] == myStone && count > 0
        hit = true
        break

      if ba[i][(y - (x - i))] == searchStone
        count += 1
        hitStoneList.push("" + (y - (x - i)) + i)

    if hit == true
      list = list.concat hitStoneList

  return list


checkHidariShita = (ba, list, x, y, turn) ->
  hitStoneList = []
  count = 0
  hit = false
  myStone = if turn == "black" then "●" else "○"
  searchStone = if turn == "black" then "○" else "●"

  if x > 7
    for i in [(x + 1)...7]
      if ba[i][(y - (i - x))] == "□"
        break

      if ba[i][(y - (i - x))] == myStone && count == 0
        break

      if ba[i][(y - (i - x))] == myStone && count > 0
        hit = true
        break

      if ba[i][(y - (i - x))] == searchStone
        count += 1
        hitStoneList.push("" + (y - (i - x)) + i)

    if hit == true
      list = list.concat hitStoneList

  return list


checkMigiUe = (ba, list, x, y, turn) ->
  hitStoneList = []
  count = 0
  hit = false
  myStone = if turn == "black" then "●" else "○"
  searchStone = if turn == "black" then "○" else "●"

  if x > 0
    for i in [(x - 1)...0]
      if ba[i][(y + (x - i))] == "□"
        break

      if ba[i][(y + (x - i))] == myStone && count == 0
        break

      if ba[i][(y + (x - i))] == myStone && count > 0
        hit = true
        break

      if ba[i][(y + (x - i))] == searchStone
        count += 1
        hitStoneList.push("" + (y + (x - i)) + i)

    if hit == true
      list = list.concat hitStoneList

  return list


checkMigiShita = (ba, list, x, y, turn) ->
  hitStoneList = []
  count = 0
  hit = false
  myStone = if turn == "black" then "●" else "○"
  searchStone = if turn == "black" then "○" else "●"

  if x > 7
    for i in [(x + 1)...7]
      if ba[i][(y + (i - x))] == "□"
        break

      if ba[i][(y + (i - x))] == myStone && count == 0
        break

      if ba[i][(y + (i - x))] == myStone && count > 0
        hit = true
        break

      if ba[i][(y + (i - x))] == searchStone
        count += 1
        hitStoneList.push("" + (y + (i - x)) + i)

    if hit == true
      list = list.concat hitStoneList

  return list
