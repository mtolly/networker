rows = []
emptyRow = -> for i in [0..31]
  color: 'black'
  value: 0

toDecimal = (n) ->
  octets = for i in [0, 8, 16, 24]
    sum = 0
    value = 1
    for j in [i + 7 .. i]
      sum += rows[n][j].value * value
      value *= 2
    sum
  octets.join '.'

addRow = ->
  n = rows.length
  newRow =
    if rows.length is 0
      emptyRow()
    else
      jQuery.extend({}, x) for x in rows[rows.length - 1]
  rows.push newRow
  htmlButtons = for bit, i in newRow
    "<td><button id=\"r#{n}b#{i}\" onclick=\"clickBit(#{n}, #{i});\" class=\"#{bit.color}\">#{bit.value}</button></td>"
  for i in [8, 16, 24]
    htmlButtons[i - 1] += '<td>&mdash;</td>'
  htmlContent = htmlButtons.join ''
  htmlContent += "<td>&nbsp;</td>"
  htmlContent += "<td id=\"r#{n}dec\">#{toDecimal(n)}</td>"
  htmlRow = '<tr>' + htmlContent + '</tr>'
  $('#bit-table').append htmlRow

removeRow = ->
  return if rows.length <= 0
  rows.pop()
  $('#bit-table tr').last().remove()

updateBit = (n, i) ->
  button = $("\#r#{n}b#{i}")
  button.html rows[n][i].value
  $("\#r#{n}dec").html toDecimal(n)
  button.removeClass()
  button.addClass rows[n][i].color

currentTool = 'flip'
setTool = (tool) -> currentTool = tool

clickBit = (n, i) ->
  switch currentTool
    when 'flip'
      rows[n][i].value ^= 1
    else
      rows[n][i].color = currentTool
  updateBit n, i

$(document).ready ->
  addRow()

window.addRow = addRow
window.removeRow = removeRow
window.clickBit = clickBit
window.setTool = setTool
