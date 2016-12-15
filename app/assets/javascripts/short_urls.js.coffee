# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#shorturl').dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    bStateSave: true
    columnDefs: [{ orderable: false, targets: -1 }]
    sAjaxSource: $('#shorturl').data('source')

