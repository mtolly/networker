rows = []
emptyRow = -> 0 for i in [0..31]

toDecimal = (n) ->
  octets = for i in [0, 8, 16, 24]
    sum = 0
    value = 1
    for j in [i + 7 .. i]
      sum += rows[n][j] * value
      value *= 2
    sum
  octets.join '.'

addRow = ->
  n = rows.length
  newRow =
    if rows.length is 0
      emptyRow()
    else
      rows[rows.length - 1][..]
  rows.push newRow
  htmlButtons = for bit, i in newRow
    "<td><button id=\"r#{n}b#{i}\" onclick=\"toggleBit(#{n}, #{i});\">#{bit}</button></td>"
  for i in [8, 16, 24]
    htmlButtons[i - 1] += '<td>|</td>'
  htmlContent = htmlButtons.join ''
  htmlContent += "<td id=\"r#{n}dec\">#{toDecimal(n)}</td>"
  htmlRow = '<tr>' + htmlContent + '</tr>'
  $('#bit-table').append htmlRow

updateBit = (n, i) ->
  $("\#r#{n}b#{i}").html rows[n][i]
  $("\#r#{n}dec").html toDecimal(n)

toggleBit = (n, i) ->
  rows[n][i] ^= 1
  updateBit n, i

$(document).ready ->
  addRow()

window.addRow = addRow
window.toggleBit = toggleBit
