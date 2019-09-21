#' def create_time_series(dff, column, title):
#'   return {
#'     'data': [go.Scatter(
#'       x=dff['year'],
#'       y=dff[column],
#'       mode='lines+markers',
#'     )],
#'     'layout': {
#'       'height': 225,
#'       'margin': {'l': 50, 'b': 30, 'r': 10, 't': 10},
#'       'annotations': [{
#'         'x': 0, 'y': 0.85, 'xanchor': 'left', 'yanchor': 'bottom',
#'         'xref': 'paper', 'yref': 'paper', 'showarrow': False,
#'         'align': 'left', 'bgcolor': 'rgba(255, 255, 255, 0.5)',
#'         'text': title
#'       }],
#'       'yaxis': {'type': 'linear', 'title': column},
#'       'xaxis': {'showgrid': False}
#'     }
#'   }
#' 
#' 
#' @app.callback(
#'   dash.dependencies.Output('x-time-series', 'figure'),
#'   [dash.dependencies.Input('crossfilter-indicator-scatter', 'hoverData')])
#' def update_y_timeseries(hoverData):
#'   country_name = hoverData['points'][0]['customdata']
#' dff = df[df['country'] == country_name]
#' title = '<b>{}</b>'.format(country_name)
#' return create_time_series(dff, y_data, title)
#' 
#' 
#' @app.callback(
#'   dash.dependencies.Output('y-time-series', 'figure'),
#'   [dash.dependencies.Input('crossfilter-indicator-scatter', 'hoverData')])
#' def update_x_timeseries(hoverData):
#'   country_name = hoverData['points'][0]['customdata']
#' dff = df[df['country'] == country_name]
#' title = '<b>{}</b>'.format(country_name)
#' return create_time_series(dff, x_data, title)