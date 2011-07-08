### ...
###
namespace 'fix', (exports) ->
  
  ### If the browser doesn't support ``position: fixed`` (ahem, Mobile Safari)
    then we need to jump through hoops to get a fixed footer along with
    scrolling content.
    
    This implementation follows the solution choosen by jquery mobile, which
    is to keep the damn thing in place using ``position: absolute`` with
    a top=N changed every time the page scrolls / changes size.
  ###
  class FixedFooter extends Backbone.View
    
    showDelay: 120
    delayTimer: null
    scrollTriggered: null
    
    _startShowTimer: =>
      @_clearShowTimer()
      @delayTimer = window.setTimeout =>
          @delayTimer = undefined
          @show()
        , @showDelay
      
    
    _clearShowTimer: =>
      window.clearTimeout @delayTimer if @delayTimer
      @delayTimer = undefined
      
    
    
    _getOffsetTop: =>
      # use this and not .offset() to work around a mobile safari bugimplemented 
      top = 0
      node = @el.get(0)
      while node?
        top += node.offsetTop
        node = node.offsetParent
      return top
      
    
    _setTop: =>
      @el.css "top", $(window).scrollTop() + window.innerHeight - @el.outerHeight(true)
      
    
    
    show: =>
      @_clearShowTimer()
      @_setTop()
      @el.show()
      
    
    hide: =>
      @_clearShowTimer()
      @el.hide()
      
    
    update: =>
      @hide true if not @delayTimer
      @_startShowTimer()
      
    
    
    initialize: =>
      console.log @el
      # apply css styles required to fake a fixed footer with ``position: absolute``
      $(@el).addClass 'fixed'
      # listen for events that require an update
      $w = $ window
      $w.bind "orientationchange", @update
      $d = $ document
      $d.bind "silentscroll", @update
      # handle scroll start and scroll stop events
      target = if $d.scrollTop() is 0 then $w else $d
      target.bind "scrollstart", (event) =>
          @scrollTriggered = true
          @_clearShowTimer() 
          @hide()
      target.bind "scrollstop", ( event ) =>
          @scrollTriggered = false
          @_startShowTimer()
      # make sure the thing is in the right place
      @show()
      
    
    
  
  exports.FixedFooter = FixedFooter
  


