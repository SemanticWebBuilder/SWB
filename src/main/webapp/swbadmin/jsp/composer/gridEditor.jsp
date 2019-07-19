<%-- 
    Document   : gridEditor
    Created on : 8/07/2019, 06:09:04 PM
    Author     : sergio.tellez
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest, org.semanticwb.SWBUtils,
        org.semanticwb.SWBPlatform, org.semanticwb.model.SWBContext, org.semanticwb.model.User,
        java.util.Locale"%>
<%
    User user = SWBContext.getAdminUser();
	SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
	System.out.println("PAGE: " + request.getParameter("suri"));
    String webPath = SWBPlatform.getContextPath();
    if (null == user) {
        response.sendError(403);
        return;
    }
    String lang = user.getLanguage();
%>
<%!
    public String getLocaleString(String key, String lang) {
        return SWBUtils.TEXT.getLocaleString("locale_swb_admin", key, new Locale(lang));
    }
%>
      <link rel="stylesheet" href="<%=webPath%>/swbadmin/js/gridstack1.0.0/gridstack.css"/>
      <link rel="stylesheet" href="<%=webPath%>/swbadmin/js/gridstack1.0.0/gridstack-extra.css"/>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/3.5.0/lodash.min.js"></script>
      <script src='<%=webPath%>/swbadmin/js/gridstack1.0.0/gridstack.js'></script>
      <script src='<%=webPath%>/swbadmin/js/gridstack1.0.0/gridstack.jQueryUI.js'></script>

      <div class="row templetebuilder">
        <div class="col-xs-2 col-md-2 tools">
          <div class="guardar">
            <form>
              <button class="" id="save-grid" type="button" name="save" value="Save">
                Guardar
              </button>
            </form>
          </div>
          <div class="sidebar">
              <div class="grid-stack-item grid-stack-item-menu">
                  <div class="grid-stack-item-content" data-gs-resource-type="menu">
                      <span></span>Menu
                  </div>
              </div>
              <div class="grid-stack-item grid-stack-item-htmlContent">
                  <div class="grid-stack-item-content" data-gs-resource-type="htmlContent">
                      <span></span>Html Content
                  </div>
              </div>
              <div class="grid-stack-item grid-stack-item-staticText">
                  <div class="grid-stack-item-content" data-gs-resource-type="staticText">
                      <span></span>StaticText
                  </div>
              </div>
          </div>
          <div class="trash dropx">
            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
          </div>
        </div>
        <div class="col-xs-10 col-md-10 bigArea">
          <div class="grid-stack grid-stack-12" id="workGrid">
          </div>
        </div>
      </div>

  <script type="text/javascript">
      $(function () {
          var options = {
              width: 12,
              float: false,
              removable: '.trash',
              removeTimeout: 500,
              acceptWidgets: '.grid-stack-item'
          };
          var workGrid = $('#workGrid')
              .gridstack(options)
              .addWidget = function(el, x, y, width, height, autoPosition, minWidth, maxWidth,
                  minHeight, maxHeight, id, resType, resId) {
                  el = $(el);
                  if (typeof x != 'undefined') { el.attr('data-gs-x', x); }
                  if (typeof y != 'undefined') { el.attr('data-gs-y', y); }
                  if (typeof width != 'undefined') { el.attr('data-gs-width', width); }
                  if (typeof height != 'undefined') { el.attr('data-gs-height', height); }
                  if (typeof autoPosition != 'undefined') { el.attr('data-gs-auto-position', autoPosition ? 'yes' : null); }
                  if (typeof minWidth != 'undefined') { el.attr('data-gs-min-width', minWidth); }
                  if (typeof maxWidth != 'undefined') { el.attr('data-gs-max-width', maxWidth); }
                  if (typeof minHeight != 'undefined') { el.attr('data-gs-min-height', minHeight); }
                  if (typeof maxHeight != 'undefined') { el.attr('data-gs-max-height', maxHeight); }
                  if (typeof id != 'undefined') { el.attr('data-gs-id', id); }
                  if (typeof resType != 'undefined') { el.attr('data-gs-resourceType', resType); }
                  if (typeof resId != 'undefined') { el.attr('data-gs-resourceId', resId); }
                  this.container.append(el);
                  this._prepareElement(el, true);
                  this._triggerAddEvent();
                  this._updateContainerHeight();
                  this._triggerChangeEvent(true);

                  console.log("Widget added: " + resId);
                  return el;
              };
          new function () {
            this.serializedData = [];
            this.saveGrid = function() {
              this.serializedData = _.map($('.grid-stack > .grid-stack-item:visible'), function (el) {
                el = $(el);
                var node = el.data('_gridstack_node');
                return {
                  x: node.x,
                  y: node.y,
                  width: node.width,
                  height: node.height,
                  resourceType: el[0].firstElementChild.innerText,
                  resourceId: el[0].id
                };
              }, this);
              alert(JSON.stringify(this.serializedData));
              console.log(JSON.stringify(this.serializedData, null, 4));
              return false;
            }.bind(this);

            this.loadGrid = function () {
                this.grid.removeAll();
                this.serializedData = [
                  {
                      "x": 0,
                      "y": 0,
                      "width": 2,
                      "height": 4,
                      "resourceType": "Menu",
                      "resourceId": "01menu_01"
                  },
                  {
                      "x": 2,
                      "y": 0,
                      "width": 5,
                      "height": 1,
                      "resourceType": "HtmlContent",
                      "resourceId": "02htmlcontent_01"
                  },
                  {
                      "x": 2,
                      "y": 1,
                      "width": 8,
                      "height": 1,
                      "resourceType": "HtmlContent",
                      "resourceId": "03htmlcontent_02"
                  },
                  {
                      "x": 2,
                      "y": 2,
                      "width": 2,
                      "height": 1,
                      "resourceType": "StaticText",
                      "resourceId": "04statictext_01"
                  },
                  {
                      "x": 5,
                      "y": 2,
                      "width": 2,
                      "height": 1,
                      "resourceType": "StaticText",
                      "resourceId": "05statictext_02"
                  },
                  {
                      "x": 8,
                      "y": 2,
                      "width": 2,
                      "height": 1,
                      "resourceType": "StaticText",
                      "resourceId": ""
                  }
                ];
                var items = GridStackUI.Utils.sort(this.serializedData);
                _.each(items, function (node) {
                        this.grid.addWidget($('<div><div class="grid-stack-item-content" /><div/>'),
                            node.x, node.y, node.width, node.height, undefined, undefined, undefined, undefined, undefined, undefined, node.resourceType, node.resourceId);
                    }, this);
                    return false;
                }.bind(this);

            $('#save-grid').click(this.saveGrid);
            $('#load-grid').click(this.loadGrid);
          }

          $('.sidebar .grid-stack-item').draggable({
              revert: 'invalid',
              handle: '.grid-stack-item-content',
              scroll: false,
              appendTo: '#workGrid',
              helper: 'clone',
              opacity: 0.35
          });

      });
  </script>
