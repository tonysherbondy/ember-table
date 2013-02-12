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
  classNames: 'colspan-cell'
  didInsertElement: ->

App.TableSimpleExample.HeaderCell = Ember.Table.HeaderCell.extend
  heightBinding: null
  height: 30

App.TableSimpleExample.ColumnGroups = Ember.ArrayController.extend
  columns: null
  headerCellViewClass: 'App.TableSimpleExample.HeaderTreeCell'
  columnWidth: Ember.computed ->
    widths = (@get('columns').getEach('columnWidth') or [])
    widths.reduce ((sum, width) -> sum + width), 1
  .property 'columns.@each.columnWidth'

App.TableSimpleExample.TableController = Ember.Table.TableController.extend
  hasHeader: yes
  hasFooter: no
  numFixedColumns: 0
  numRows: 500000
  rowHeight: 30
  headerHeight: 60

  columnGroups: Ember.computed ->
    columns = @get('columns')
    stocks  = App.TableSimpleExample.ColumnGroups.create
      headerCellName: 'Stocks'
      headerCellViewClass: 'App.TableSimpleExample.HeaderTreeCell'
      columns: columns.slice(0, 3)
    bonds   = App.TableSimpleExample.ColumnGroups.create
      headerCellName: 'Bonds'
      headerCellViewClass: 'App.TableSimpleExample.HeaderTreeCell'
      columns: columns.slice(3)
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
        columnWidth: 150
        headerCellName: name
        getCellContent: (row) -> row[key].toFixed(2)
    columns.unshiftObject(dateColumn)
    columns
  .property()

  content: Ember.computed ->
    App.TableSimpleExample.LazyDataSource.create
      content: new Array(@get('numRows'))
  .property 'numRows'
