rows = []

emptyRow = ->
  bits: for i in [0..31]
    color: 'black'
    value: 0
  label: ''

cloneRow = (row) ->
  bits:
    $.extend({}, bit) for bit in row.bits
  label: ''

getBit = (n, i) ->
  rows[n].bits[i]

toDecimal = (n) ->
  octets = for i in [0, 8, 16, 24]
    sum = 0
    value = 1
    for j in [i + 7 .. i]
      sum += getBit(n, j).value * value
      value *= 2
    sum
  octets.join '.'

attachRow = (row) ->
  n = rows.length
  rows.push row
  tds = []
  tds.push "<td><input id=\"r#{n}label\" type=\"text\" value=\"#{row.label}\" size=\"5\" /></td>"
  tds.push "<td>&nbsp;</td>"
  for bit, i in row.bits
    if i in [8, 16, 24]
      tds.push '<td>&ndash;</td>'
    tds.push "<td><button id=\"r#{n}b#{i}\" onclick=\"clickBit(#{n}, #{i});\" class=\"#{bit.color}\">#{bit.value}</button></td>"
  tds.push "<td>&nbsp;</td>"
  tds.push "<td id=\"r#{n}dec\">#{toDecimal(n)}</td>"
  tr = '<tr>' + tds.join('') + '</tr>'
  $('#bit-table').append tr
  $("\#r#{n}label").change ->
    editedText(n)

addRow = ->
  lastRow = rows[rows.length - 1] ? emptyRow()
  attachRow cloneRow(lastRow)
  save()

removeRow = ->
  return if rows.length <= 0
  rows.pop()
  $('#bit-table tr').last().remove()
  save()

editedText = (n) ->
  rows[n].label = $("\#r#{n}label").val()
  save()

updateBit = (n, i) ->
  button = $("\#r#{n}b#{i}")
  button.html getBit(n, i).value
  $("\#r#{n}dec").html toDecimal(n)
  button.removeClass()
  button.addClass getBit(n, i).color

currentTool = 'flip'
setTool = (tool) -> currentTool = tool

clickBit = (n, i) ->
  switch currentTool
    when 'flip'
      getBit(n, i).value ^= 1
    else
      getBit(n, i).color = currentTool
  updateBit n, i
  save()

save = ->
  localStorage.setItem 'networker', JSON.stringify(rows)

load = ->
  res = localStorage.getItem 'networker'
  if res?
    attachRow row for row in JSON.parse res
    true
  else
    false

$(document).ready ->
  load() or addRow()

window.addRow = addRow
window.removeRow = removeRow
window.clickBit = clickBit
window.setTool = setTool
