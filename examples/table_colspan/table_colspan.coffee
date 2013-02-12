App.TableSimpleExample = Ember.Namespace.create()

App.TableSimpleExample.LazyDataSource = Ember.ArrayProxy.extend
  objectAt: (idx) ->
    row  = @get('content')[idx]
    return row if row
    date = new Date();
    date.setDate(date.getDate() + idx)
    row =
      index: idx
      date:  date
      open:  Math.random() * 100 - 50
      high:  Math.random() * 100 - 50
      low:   Math.random() * 100 - 50
      close: Math.random() * 100 - 50
      volume: Math.random() * 1000000
    @get('content')[idx] = row
    row

App.TableSimpleExample.HeaderTreeCell = Ember.Table.HeaderCell.extend
  templateName: 'table-header-colspan-cell'

App.TableSimpleExample.ColumnGroups = Ember.ArrayController.extend
  columns: null
  headerCellViewClass: 'App.TableSimpleExample.HeaderTreeCell'
  columnWidth: Ember.computed ->
    widths = (@get('columns').getEach('columnWidth') or [])
    widths.reduce ((sum, width) -> sum + width), 0
  .property 'columns.@each.columnWidth'

App.TableSimpleExample.TableController = Ember.Table.TableController.extend
  hasHeader: yes
  hasFooter: no
  numFixedColumns: 0
  numRows: 500000
  rowHeight: 30

  columnGroups: Ember.computed ->
    columns = @get('columns')
    stocks  = App.TableSimpleExample.ColumnGroups.create
      headerCellName: 'Stocks'
      columns: columns.slice(0, 2)
    bonds   = App.TableSimpleExample.ColumnGroups.create
      headerCellName: 'Bonds'
      columns: columns.slice(2)
    [stocks, bonds]
  .property 'columns'

  columns: Ember.computed ->
    columnNames = ['open', 'high', 'low', 'close', 'volume']
    dateColumn = Ember.Table.ColumnDefinition.create
      columnWidth: 150
      headerCellName: 'Date'
      getCellContent: (row) -> row['date'].toDateString();
    columns= columnNames.map (key, index) ->
      name = key.charAt(0).toUpperCase() + key.slice(1)
      Ember.Table.ColumnDefinition.create
        columnWidth: 100
        headerCellName: name
        getCellContent: (row) -> row[key].toFixed(2)
    columns.unshiftObject(dateColumn)
    columns
  .property()

  content: Ember.computed ->
    App.TableSimpleExample.LazyDataSource.create
      content: new Array(@get('numRows'))
  .property 'numRows'
