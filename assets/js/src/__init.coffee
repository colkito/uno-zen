'use strict'

$ ->
  window.Uno = Uno =
    version: '2.0.0'

    search:
      container: -> $('#results')
      form: (action) -> $("#search-container")[action]()

    loadingBar: (action) -> $(".pace")[action]()

    context: ->
      # get the context from the first class name of body
      # https://github.com/TryGhost/Ghost/wiki/Context-aware-Filters-and-Helpers
      className = document.body.className.split(" ")[0].split("-")[0]
      if className is "" then 'error' else className

    is: (property, value) -> document.body.dataset[property] is value

    readTime: ->
      DateInDays = (selector, cb) ->
        $(selector).each ->
          postDate = $(this).html()
          postDateNow = new Date(Date.now())
          postDateInDays = Math.floor((postDateNow - new Date(postDate)) / 86400000)

          if postDateInDays is 0 then postDateInDays = 'today'
          else if postDateInDays is 1 then postDateInDays = "yesterday"
          else postDateInDays = "#{postDateInDays} days ago"

          $(this).html(postDateInDays)
          $(this).mouseover -> $(this).html(postDate)
          $(this).mouseout -> $(this).html(postDateInDays)
        cb?()

      DateInDays ".post.meta > time"

  ## Main
  el = document.body
  el.dataset.page ?= Uno.context()

  Uno.readTime()

  if Uno.is 'page', 'post'
    $('.main').readingTime readingTimeTarget: ".post.reading-time > span"

  if Uno.is 'device', 'desktop'
    FastClick.attach(el)

  $('#panic-button').click ->
    s = document.createElement('script')
    s.setAttribute('src','https://nthitz.github.io/turndownforwhatjs/tdfw.js')
    document.body.appendChild(s)
