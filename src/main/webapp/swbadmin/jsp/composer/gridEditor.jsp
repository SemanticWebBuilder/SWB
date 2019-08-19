<%-- 
    Document   : gridEditor
    Created on : 8/07/2019, 06:09:04 PM
    Author     : sergio.tellez
--%>
<%@page import="org.semanticwb.portal.admin.resources.SWBAComposer"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest, org.semanticwb.SWBUtils,
        org.semanticwb.SWBPlatform, org.semanticwb.model.SWBContext, org.semanticwb.model.User,
        java.util.Locale, org.semanticwb.model.WebPage, org.json.JSONObject, org.json.JSONArray"%>
<%
    User user = SWBContext.getAdminUser();
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
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
    String actionUri = paramRequest.getActionUrl()
                        .setAction(SWBAComposer.ACTION_ADD_GRID)
                        .toString();
    String savedData = null;
    boolean renderSavedData = false;
    String webSiteId = null;
    
    if (request.getAttribute("_elements") != null && !"".equals(request.getAttribute("_elements"))) {
        JSONObject savedObj = new JSONObject((String) request.getAttribute("_elements"));
        if (savedObj.has("elements")) {
            savedData = savedObj.getJSONArray("elements").toString();
            renderSavedData = true;
        }
        webSiteId = (String) request.getAttribute("webSiteId");
    }
    String resAdminRenderedUrl = paramRequest.getRenderUrl()
                                .setMode(SWBAComposer.MODE_RES_ADM_CALL)
                                .setParameter("resId", "resIdValue")
                                .setParameter("webSiteId", webSiteId)
                                .toString();
    String lbl_bttn_save = paramRequest.getLocaleString("lbl_bttn_save");  //Guardar
    String mnu_opt_admin = paramRequest.getLocaleString("mnu_opt_admin");  // Administrar recurso
    String mnu_opt_display = paramRequest.getLocaleString("mnu_opt_display");  //Opciones de despliegue 
    String hdng_modal_admin = paramRequest.getLocaleString("hdng_modal_admin");  //Administraci&oacute;n del recurso
    String hdng_modal_display = paramRequest.getLocaleString("hdng_modal_display");  //Opciones de despliegue para la celda 
    String lbl_title = paramRequest.getLocaleString("lbl_title"); //T&iacute;tulo del recurso
    String lbl_cssClass = paramRequest.getLocaleString("lbl_cssClass");  //Nombre de clase de estilos
    String lbl_modal_subTitle = paramRequest.getLocaleString("lbl_modal_subTitle");  //Columnas utilizadas por la celda en las diferentes resoluciones
    String lbl_xtraSmall = paramRequest.getLocaleString("lbl_xtraSmall");  //Extra chica
    String lbl_small = paramRequest.getLocaleString("lbl_small");  //Chica
    String lbl_large = paramRequest.getLocaleString("lbl_large");  //Grande
    String lbl_xtraLarge = paramRequest.getLocaleString("lbl_xtraLarge");  //Extra grande :solo para Bootstrap 4
    String error_notHtmlcontent = paramRequest.getLocaleString("error_notHtmlcontent");  //El recurso no es un contenido de HTML!
    String msg_dataSaved = paramRequest.getLocaleString("msg_dataSaved");  //Información guardada!
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
              <button id="save-grid" type="button" name="save">
                <%=lbl_bttn_save%>
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
          <div class="trash">
            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
          </div>
        </div>
        <div class="col-xs-10 col-md-10 bigArea">
          <div class="grid-stack grid-stack-12" id="workGrid">
          </div>
        </div>
      </div>
      
      <ul class="ctxtmenu">
        <li class="ctxtmenu-item" id="resAdm"><%=mnu_opt_admin%></li>
        <li class="ctxtmenu-item" id="dispOptns"><%=mnu_opt_display%></li>
      </ul>
      <div class="modalW" id="modalAdm">
        <div class="modalW-dialog">
          <div class="modalW-header">
            <span class="close-btn" id="closeW">&times;</span>
            <h4><%=hdng_modal_admin%></h4>
          </div>
          <div class="modalW-content" id="admModalBody">
	  </div>
        </div>
      </div>
      <div class="modalW" id="modalDisplay">
        <div class="modalDisp-dialog">
          <div class="modalW-header">
            <span class="close-btn" id="closeDisp">&times;</span>
            <h4><%=hdng_modal_display%></h4>
          </div>
          <div class="modalDisp-content" id="dispModalBody">
            <form name="cellData" id="cellData">
              <div>
                  <label><%=lbl_title%></label>
                  <input type="text" name="title" value="" placeholder="" maxlength="25" required>
              </div>
              <div>
                  <label><%=lbl_cssClass%></label>
                  <input type="text" name="className2Use" value="">
              </div>
              <div class="modal-text">
                <span><%=lbl_modal_subTitle%></span>
              </div>
              <div>
                  <label><%=lbl_xtraSmall%><span>col-xs-</span></label>
                  <input type="number" name="col-xs" value="" min="1" max="12">
              </div>
              <div>
                  <label><%=lbl_small%><span>col-sm-</span></label>
                  <input type="number" name="col-sm" value="" min="1" max="12">
              </div>
              <div>
                  <label><%=lbl_large%><span>col-lg-</span></label>
                  <input type="number" name="col-lg" value="" min="1" max="12">
              </div>
              <%--div>
                  <label><%=lbl_xtraLarge%><span>col-xl-</span></label>
                  <input type="number" name="col-xl" value="" min="1" max="12">
              </div--%>
              <div>
                  <button type="button" onclick="persistCols(this.form);"><%=lbl_bttn_save%></button>
              </div>
            </form>
	  </div>
        </div>
      </div>
      
  <script type="text/javascript">
      let modal = document.querySelector("#modalAdm");
      let modalDisp = document.querySelector("#modalDisplay");
      let ctxtmenu = document.querySelector('.ctxtmenu');
      let closeBtn = document.querySelector("#closeW");
      let closeDisp = document.querySelector("#closeDisp");
      let lastClicked = null;

      $(document).ready(function() {
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
//            this.grid.addWidget = function(el, x, y, width, height, autoPosition, minWidth, maxWidth,
//                  minHeight, maxHeight, id, resType, resId) {

            this.grid.addWidget = function(el, nodeObj) {
                  el = $(el);
                  if (typeof nodeObj.x !== 'undefined') { el.attr('data-gs-x', nodeObj.x); }
                  if (typeof nodeObj.y !== 'undefined') { el.attr('data-gs-y', nodeObj.y); }
                  if (typeof nodeObj.width !== 'undefined') { el.attr('data-gs-width', nodeObj.width); }
                  if (typeof nodeObj.height !== 'undefined') { el.attr('data-gs-height', nodeObj.height); }
                  if (typeof nodeObj.autoPosition !== 'undefined') { el.attr('data-gs-auto-position', nodeObj.autoPosition ? 'yes' : null); }
                  if (typeof nodeObj.minWidth !== 'undefined') { el.attr('data-gs-min-width', nodeObj.minWidth); }
                  if (typeof nodeObj.maxWidth !== 'undefined') { el.attr('data-gs-max-width', nodeObj.maxWidth); }
                  if (typeof nodeObj.minHeight !== 'undefined') { el.attr('data-gs-min-height', nodeObj.minHeight); }
                  if (typeof nodeObj.maxHeight !== 'undefined') { el.attr('data-gs-max-height', nodeObj.maxHeight); }
                  if (typeof nodeObj.id !== 'undefined') { el.attr('data-gs-id', nodeObj.id); }
                  if (typeof nodeObj.resourceId !== 'undefined') { el.attr('data-gs-resource-id', nodeObj.resourceId); }
                  if (typeof nodeObj.classname !== 'undefined') { el.attr('data-gs-class-name', nodeObj.classname); }
                  if (typeof nodeObj.colXs !== 'undefined') { el.attr('data-gs-col-xs', nodeObj.colXs); }
                  if (typeof nodeObj.colSm !== 'undefined') { el.attr('data-gs-col-sm', nodeObj.colSm); }
                  if (typeof nodeObj.colLg !== 'undefined') { el.attr('data-gs-col-lg', nodeObj.colLg); }
                  //solo para Bootstrap 4:
                  //if (typeof nodeObj.colXl !== 'undefined') { el.attr('data-gs-col-xl', nodeObj.colXl); }
                  this.container.append(el);
                  this._prepareElement(el, true);
                  if (typeof nodeObj.resourceType !== 'undefined') {
                      el.addClass("grid-stack-item-" + nodeObj.resourceType);
                      el[0].children[0].setAttribute("data-gs-resource-type", nodeObj.resourceType);
                  }
                  
                  let textNode = document.createTextNode(null != nodeObj.title ? nodeObj.title : nodeObj.resourceType);
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
//                        let element = this.grid.addWidget($('<div><div class="grid-stack-item-content" /><div/>'),
//                            node.x, node.y, node.width, node.height, undefined, undefined,
//                            undefined, undefined, undefined, undefined, node.resourceType,
//                            node.resourceId);
                        let element = this.grid.addWidget(
                                $('<div><div class="grid-stack-item-content" /><div/>'), node);
                    }, this);
                    return false;
                }.bind(this);

            this.saveGrid = function() {
              this.serializedData = _.map($('.grid-stack > .grid-stack-item:visible'), function (el) {
                el = $(el);
                
                if (el.data('_gridstack_node') === undefined) {
                    this.recoverNode(el);
                }
                
                var node = el.data('_gridstack_node');
                return {
                  x: node.x,
                  y: node.y,
                  width: node.width,
                  height: node.height,
                  resourceType: el[0].firstElementChild.getAttribute("data-gs-resource-type"),
                  resourceId: null !== el[0].getAttribute("data-gs-resource-id")
                              ? el[0].getAttribute("data-gs-resource-id") : "",
                  title: null !== el[0].firstElementChild.childNodes[1].nodeValue
                              ? el[0].firstElementChild.childNodes[1].nodeValue : "",
                  classname: null !== el[0].getAttribute("data-gs-class-name")
                              ? el[0].getAttribute("data-gs-class-name") : "",
                  colXs: null !== el[0].getAttribute("data-gs-col-xs")
                              ? el[0].getAttribute("data-gs-col-xs") : "",
                  colSm: null !== el[0].getAttribute("data-gs-col-sm")
                              ? el[0].getAttribute("data-gs-col-sm") : "",
                  colLg: null !== el[0].getAttribute("data-gs-col-lg")
                              ? el[0].getAttribute("data-gs-col-lg") : ""
//solo para Bootstrap 4:
//                  colXl: null !== el[0].getAttribute("data-gs-col-xl")
//                              ? el[0].getAttribute("data-gs-col-xl") : ""
                };
              }, this);
              document.forms["saveConf"].jsongrid.value = JSON.stringify(GridStackUI.Utils.sort(this.serializedData));
//              console.log(JSON.stringify(GridStackUI.Utils.sort(this.serializedData), 4));
              if (document.forms["saveConf"].jsongrid.value !== "" &&
                      document.forms["saveConf"].suri.value !== "") {
                document.forms["saveConf"].submit();
              }
              return false;
            }.bind(this);

            this.recoverNode = function(el) {
                let theNode = GridStackUI.Engine.prototype._prepareNode({
                    x: el[0].getAttribute("data-gs-x"),
                    y: el[0].getAttribute("data-gs-y"),
                    width: el[0].getAttribute("data-gs-width"),
                    height: el[0].getAttribute("data-gs-height")
                });
                
                el.data('_gridstack_node', theNode);
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
            closeBtn.onclick = function() {
              modal.style.display = "none";
            }
            
            this.hidemenu = function(ev) {
              ctxtmenu.classList.add('off');
              ctxtmenu.style.top = '-200%';
              ctxtmenu.style.left = '-200%';
            }.bind(this);
            
            this.showmenu = function(ev) {
              //stop real right click menu
              ev.preventDefault();
              //show custom menu, instead
              let leftCrnr = $(ev.view.document.body).width() - ev.clientX < 150 ? ev.clientX - 100 : ev.clientX - 20;
              ctxtmenu.style.top = (ev.clientY - 20) + 'px';
              ctxtmenu.style.left = leftCrnr + 'px';
              ctxtmenu.classList.remove('off');
              
              if ($(ev.target).hasClass('ui-draggable-handle')) {
                  lastClicked = ev.target.parentElement;
              } else if ($(ev.target).is('.grid-stack-item-content.ui-draggable-handle span')) {
                  lastClicked = ev.target.parentElement.parentElement;
              }
            }.bind(this);
            
            this.openAdmin = function(ev) {
                let urlToOpen = '<%=resAdminRenderedUrl%>';
//                    console.log(lastClicked);
                let domElement = lastClicked.getAttribute("data-gs-resource-id") !== null ? lastClicked : $(lastClicked);
                if (domElement !== undefined) {
                    let resType = domElement.firstElementChild.getAttribute("data-gs-resource-type");
                    urlToOpen = urlToOpen.replace("resIdValue",
                            domElement.getAttribute("data-gs-resource-id"));

                    if ("htmlContent" === resType) {
                        $("#admModalBody").load(urlToOpen.substring(0, urlToOpen.indexOf("?")),
                                    urlToOpen.substring(urlToOpen.indexOf("?") + 1, urlToOpen.length) +
                                            "&resType=htmlContent");
                    } else {
                        $("#admModalBody").load(urlToOpen.substring(0, urlToOpen.indexOf("?")),
                                    urlToOpen.substring(urlToOpen.indexOf("?") + 1, urlToOpen.length));
                    }
                    modal.style.display = "block";
                } else {
                    this.hidemenu();
                }
            }.bind(this);
            
            this.openAdminHtmlEditor = function(ev) {
                let domElement = lastClicked.getAttribute("data-gs-resource-id") !== null ? lastClicked : $(lastClicked);
                let resType = domElement.firstElementChild.getAttribute("data-gs-resource-type");
                if (domElement !== undefined) {
                    if ("htmlContent" === resType) {
                        let urlToOpen = '<%=resAdminRenderedUrl%>';
                        urlToOpen = urlToOpen.replace("resIdValue",
                                domElement.getAttribute("data-gs-resource-id"));
                        $("#admModalBody").load(urlToOpen.substring(0, urlToOpen.indexOf("?")),
                                    urlToOpen.substring(urlToOpen.indexOf("?") + 1, urlToOpen.length) +
                                            "&resType=htmlContent");
                        modal.style.display = "block";
                    } else {
                        alert("<%=error_notHtmlcontent%>");
                    }
                } else {
                    this.hidemenu();
                }
            }.bind(this);
            
            this.addMenuListeners = function() {
              $('#resAdm').click(this.openAdmin);
              $('#dispOptns').click(openDispOptnsModal);
//              $('#resAdmTest').click(this.openAdminHtmlEditor);
            }.bind(this);
            
            this.hidemenu();
            
            //adding right click to the menu
            $('#workGrid > .grid-stack-item:visible').contextmenu(this.showmenu);
            //add listener for leaving the menu
            $('.ctxtmenu').mouseleave(this.hidemenu);
            this.addMenuListeners();
            
          };

          $('.sidebar .grid-stack-item').draggable({
              revert: 'invalid',
              handle: '.grid-stack-item-content',
              scroll: false,
              appendTo: '#workGrid',
              helper: 'clone',
              opacity: 0.35
          });
          $('.trash').on('dragenter', function() {
            $('.trash').addClass('drop');
          });
          $('.trash').on('dragend', function() {
              $('.trash').removeClass('drop');
          });

      });
      
      closeDisp.onclick = function() {
        modalDisp.style.display = "none";
      };
      
      
      function openDispOptnsModal() {
        modalDisp.style.display = "block";
        let el = $(lastClicked);
        if (el !== undefined) {
            let formEle = document.querySelector('#cellData');
            formEle.title.value = lastClicked.firstElementChild.childNodes[1].nodeValue;
            formEle.className2Use.value = el.attr('data-gs-class-name') !== undefined ? el.attr('data-gs-class-name') : "";
            formEle.elements['col-xs'].value = el.attr('data-gs-col-xs') !== undefined ? el.attr('data-gs-col-xs') : "";
            formEle.elements['col-sm'].value = el.attr('data-gs-col-sm') !== undefined ? el.attr('data-gs-col-sm') : "";
            formEle.elements['col-lg'].value = el.attr('data-gs-col-lg') !== undefined ? el.attr('data-gs-col-lg') : "";
            //solo para Bootstrap 4:
            //formEle.elements['col-xl'].value = el.attr('data-gs-col-xl') !== undefined ? el.attr('data-gs-col-xl') : "";
        }
      }
      function persistCols(form) {
          let el = $(lastClicked);
          if (form.title.value !== "") {
              lastClicked.firstElementChild.childNodes[1].nodeValue = form.title.value;
          }
          el.attr('data-gs-class-name', form.className2Use.value);
          
          if (form.elements['col-xs'].value !== "") {
              el.attr('data-gs-col-xs', form.elements['col-xs'].value);
          }
          if (form.elements['col-sm'].value !== "") {
              el.attr('data-gs-col-sm', form.elements['col-sm'].value);
          }
          if (form.elements['col-lg'].value !== "") {
              el.attr('data-gs-col-lg', form.elements['col-lg'].value);
          }
//solo para Bootstrap 4:
//          if (form.elements['col-xl'].value !== "") {
//              el.attr('data-gs-col-xl', form.elements['col-xl'].value);
//          }
          alert("<%=msg_dataSaved%>");
      }
      window.onclick = function(e){
        if (e.target === modal) {
          modal.style.display = "none";
        } else if (e.target === modalDisp) {
            modalDisp.style.display = "none";
        }
      };
  </script>
