<%-- 
    Document   : gridEditor
    Created on : 8/07/2019, 06:09:04 PM
    Author     : sergio.tellez
--%>
<%@page import="org.semanticwb.portal.admin.resources.SWBAComposer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest, org.semanticwb.SWBUtils,
        org.semanticwb.SWBPlatform, org.semanticwb.model.SWBContext, org.semanticwb.model.User,
        java.util.Locale, org.semanticwb.model.WebPage, org.json.JSONObject, org.json.JSONArray"%>
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
    String suri = request.getParameter("suri");
    if (null == suri && null != request.getAttribute("suri")) {
        suri = (String) request.getAttribute("suri");
    }
    String actionUri = paramRequest.getActionUrl().setAction(SWBAComposer.ACTION_ADD_GRID).toString();
    String savedData = null;
    boolean renderSavedData = false;
    
    if (request.getAttribute("_elements") != null && !"".equals(request.getAttribute("_elements"))) {
        
        JSONObject savedObj = new JSONObject((String) request.getAttribute("_elements"));
        if (savedObj.has("elements")) {
            savedData = savedObj.getJSONArray("elements").toString();
            renderSavedData = true;
            
            
            
            
            System.out.println("JSON saved: " + savedData);
        } else {
            System.out.println("No se encontro -elements en: \n" + savedObj.toString());
        }
    }
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
            <form action="<%=actionUri%>" name="saveConf" method="POST">
              <button class="" id="save-grid" type="button" name="save" value="Save">
                Guardar
              </button>
              <input type="hidden" name="suri" value="<%=suri%>">
              <input type="hidden" name="jsongrid" value="">
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
              .gridstack(options);
          new function () {
            this.serializedData = [];
            this.grid = $('.grid-stack').data('gridstack');
            this.grid.addWidget = function(el, x, y, width, height, autoPosition, minWidth, maxWidth,
                  minHeight, maxHeight, id, resType, resId) {
                      
                  el = $(el);
                  if (typeof x !== 'undefined') { el.attr('data-gs-x', x); }
                  if (typeof y !== 'undefined') { el.attr('data-gs-y', y); }
                  if (typeof width !== 'undefined') { el.attr('data-gs-width', width); }
                  if (typeof height !== 'undefined') { el.attr('data-gs-height', height); }
                  if (typeof autoPosition !== 'undefined') { el.attr('data-gs-auto-position', autoPosition ? 'yes' : null); }
                  if (typeof minWidth !== 'undefined') { el.attr('data-gs-min-width', minWidth); }
                  if (typeof maxWidth !== 'undefined') { el.attr('data-gs-max-width', maxWidth); }
                  if (typeof minHeight !== 'undefined') { el.attr('data-gs-min-height', minHeight); }
                  if (typeof maxHeight !== 'undefined') { el.attr('data-gs-max-height', maxHeight); }
                  if (typeof id !== 'undefined') { el.attr('data-gs-id', id); }
                  if (typeof resId !== 'undefined') { el.attr('data-gs-resource-id', resId); }
                  this.container.append(el);
                  this._prepareElement(el, true);
                  if (typeof resType !== 'undefined') {
                      el.addClass("grid-stack-item-" + resType);
                      el[0].children[0].setAttribute("data-gs-resource-type", resType);
                  }
                  
                  let textNode = document.createTextNode(resType);
                  let elementNode = document.createElement("span");
                  el[0].childNodes[0].appendChild(elementNode);
                  el[0].childNodes[0].appendChild(textNode);
                  el[0].removeChild(el[0].childNodes[1]);
                  
                  this._triggerAddEvent();
                  this._updateContainerHeight();
                  this._triggerChangeEvent(true);
                  return el;
            };
              
            this.loadGrid = function () {
                this.grid.removeAll();
                this.serializedData = <%=(null != savedData ? savedData : "[]")%>;
                var items = GridStackUI.Utils.sort(this.serializedData);
                _.each(items, function (node) {
                        let element = this.grid.addWidget($('<div><div class="grid-stack-item-content" /><div/>'),
                            node.x, node.y, node.width, node.height, undefined, undefined,
                            undefined, undefined, undefined, undefined, node.resourceType,
                            node.resourceId);
                    }, this);
                    return false;
                }.bind(this);

            this.saveGrid = function() {
              this.serializedData = _.map($('.grid-stack > .grid-stack-item:visible'), function (el) {
                el = $(el);
                
                var node = el.data('_gridstack_node');
                return {
                  x: node.x,
                  y: node.y,
                  width: node.width,
                  height: node.height,
                  resourceType: el[0].firstElementChild.getAttribute("data-gs-resource-type"),
                  resourceId: null !== el[0].getAttribute("data-gs-resource-id")
                              ? el[0].getAttribute("data-gs-resource-id") : ""
                };
              }, this);
              document.forms["saveConf"].jsongrid.value = JSON.stringify(GridStackUI.Utils.sort(this.serializedData));
              if (document.forms["saveConf"].jsongrid.value !== "" &&
                      document.forms["saveConf"].suri.value !== "") {
                document.forms["saveConf"].submit();
              }
              return false;
            }.bind(this);

            $('#save-grid').click(this.saveGrid);
            $('#load-grid').click(this.loadGrid);
<%          
            if (renderSavedData) {
%>
            this.loadGrid();
<%          
            }
%>
          };

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
