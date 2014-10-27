// Generated by CoffeeScript 1.8.0
(function() {
  var addRow, attachRow, clickBit, currentTool, emptyRow, load, removeRow, rows, save, setTool, toDecimal, updateBit;

  rows = [];

  emptyRow = function() {
    var i, _i, _results;
    _results = [];
    for (i = _i = 0; _i <= 31; i = ++_i) {
      _results.push({
        color: 'black',
        value: 0
      });
    }
    return _results;
  };

  toDecimal = function(n) {
    var i, j, octets, sum, value;
    octets = (function() {
      var _i, _j, _len, _ref, _ref1, _results;
      _ref = [0, 8, 16, 24];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        sum = 0;
        value = 1;
        for (j = _j = _ref1 = i + 7; _ref1 <= i ? _j <= i : _j >= i; j = _ref1 <= i ? ++_j : --_j) {
          sum += rows[n][j].value * value;
          value *= 2;
        }
        _results.push(sum);
      }
      return _results;
    })();
    return octets.join('.');
  };

  attachRow = function(row) {
    var bit, htmlButtons, htmlContent, htmlRow, i, n, _i, _len, _ref;
    n = rows.length;
    rows.push(row);
    htmlButtons = (function() {
      var _i, _len, _results;
      _results = [];
      for (i = _i = 0, _len = row.length; _i < _len; i = ++_i) {
        bit = row[i];
        _results.push("<td><button id=\"r" + n + "b" + i + "\" onclick=\"clickBit(" + n + ", " + i + ");\" class=\"" + bit.color + "\">" + bit.value + "</button></td>");
      }
      return _results;
    })();
    _ref = [8, 16, 24];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      htmlButtons[i - 1] += '<td>&mdash;</td>';
    }
    htmlContent = htmlButtons.join('');
    htmlContent += "<td>&nbsp;</td>";
    htmlContent += "<td id=\"r" + n + "dec\">" + (toDecimal(n)) + "</td>";
    htmlRow = '<tr>' + htmlContent + '</tr>';
    return $('#bit-table').append(htmlRow);
  };

  addRow = function() {
    var newRow, x;
    newRow = (function() {
      var _i, _len, _ref, _results;
      if (rows.length === 0) {
        return emptyRow();
      } else {
        _ref = rows[rows.length - 1];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          x = _ref[_i];
          _results.push(jQuery.extend({}, x));
        }
        return _results;
      }
    })();
    attachRow(newRow);
    return save();
  };

  removeRow = function() {
    if (rows.length <= 0) {
      return;
    }
    rows.pop();
    $('#bit-table tr').last().remove();
    return save();
  };

  updateBit = function(n, i) {
    var button;
    button = $("\#r" + n + "b" + i);
    button.html(rows[n][i].value);
    $("\#r" + n + "dec").html(toDecimal(n));
    button.removeClass();
    return button.addClass(rows[n][i].color);
  };

  currentTool = 'flip';

  setTool = function(tool) {
    return currentTool = tool;
  };

  clickBit = function(n, i) {
    switch (currentTool) {
      case 'flip':
        rows[n][i].value ^= 1;
        break;
      default:
        rows[n][i].color = currentTool;
    }
    updateBit(n, i);
    return save();
  };

  save = function() {
    return createCookie('networker', JSON.stringify(rows));
  };

  load = function() {
    var res, row, _i, _len, _ref;
    res = readCookie('networker');
    if (res != null) {
      _ref = JSON.parse(res);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        row = _ref[_i];
        attachRow(row);
      }
      return true;
    } else {
      return false;
    }
  };

  $(document).ready(function() {
    return load() || addRow();
  });

  window.addRow = addRow;

  window.removeRow = removeRow;

  window.clickBit = clickBit;

  window.setTool = setTool;

}).call(this);
