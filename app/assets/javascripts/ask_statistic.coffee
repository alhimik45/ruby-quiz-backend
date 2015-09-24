$ ->
  $.get 'ask_statistic/stats', (stats) ->
    if stats.length != 0
      Morris.Bar
        element: 'chartdiv'
        data: stats
        xkey: 'id'
        hideHover: 'auto'
#        hoverCallback: (index)->
#          alert index
        ykeys: ['right', 'wrong']
        labels: ['Правильных ответов', 'Неправильных ответов']
    else
      $('#chartdiv').text 'Статистики нет'

