// Generated by CoffeeScript 1.3.3
(function() {

  App.TableEditableExample = Ember.Namespace.create();

  App.TableEditableExample.EditableTableCell = Ember.Table.TableCell.extend({
    classNames: 'editable-table-cell',
    templateName: 'editable-table-cell',
    isEditing: false,
    type: 'text',
    innerTextField: Ember.TextField.extend({
      valueBinding: 'parentView.cellContent',
      didInsertElement: function() {
        return this.$().focus();
      },
      blur: function() {
        return this.set('parentView.isEditing', false);
      }
    }),
    onRowContentDidChange: Ember.observer(function() {
      return this.set('isEditing', false);
    }, 'rowContent'),
    editLabel: function(event) {
      this.set('isEditing', true);
      return event.stopPropagation();
    }
  });

  App.TableEditableExample.TableController = Ember.Table.TableController.extend({
    hasHeader: true,
    hasFooter: false,
    numFixedColumns: 0,
    numRows: 100000,
    rowHeight: 30,
    columns: Ember.computed(function() {
      var columnNames, columns, dateColumn, entryColumn;
      columnNames = ['open', 'high', 'low', 'close', 'volume'];
      entryColumn = Ember.Table.ColumnDefinition.create({
        columnWidth: 100,
        headerCellName: 'Entry',
        tableCellViewClass: 'App.TableEditableExample.EditableTableCell',
        getCellContent: function(row) {
          return row['index'];
        }
      });
      dateColumn = Ember.Table.ColumnDefinition.create({
        columnWidth: 150,
        headerCellName: 'Date',
        tableCellViewClass: 'App.TableEditableExample.EditableTableCell',
        getCellContent: function(row) {
          return row['date'].toDateString();
        }
      });
      columns = columnNames.map(function(key, index) {
        var name;
        name = key.charAt(0).toUpperCase() + key.slice(1);
        return Ember.Table.ColumnDefinition.create({
          columnWidth: 100,
          headerCellName: name,
          tableCellViewClass: 'App.TableEditableExample.EditableTableCell',
          getCellContent: function(row) {
            return row[key].toFixed(2);
          }
        });
      });
      columns.unshift(dateColumn);
      columns.unshift(entryColumn);
      return columns;
    }).property(),
    content: Ember.computed(function() {
      var _i, _ref, _results;
      return (function() {
        _results = [];
        for (var _i = 0, _ref = this.get('numRows'); 0 <= _ref ? _i < _ref : _i > _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this).map(function(num, idx) {
        var date;
        date = new Date();
        date.setDate(date.getDate() + idx);
        return {
          index: idx,
          date: date,
          open: Math.random() * 100 - 50,
          high: Math.random() * 100 - 50,
          low: Math.random() * 100 - 50,
          close: Math.random() * 100 - 50,
          volume: Math.random() * 1000000
        };
      });
    }).property('numRows')
  });

}).call(this);