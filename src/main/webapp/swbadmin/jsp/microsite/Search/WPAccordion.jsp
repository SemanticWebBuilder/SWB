<%@page import="java.net.URLEncoder, org.semanticwb.platform.SemanticObject, org.semanticwb.platform.SemanticClass, org.semanticwb.platform.SemanticProperty, java.text.SimpleDateFormat, org.semanticwb.portal.resources.sem.BookmarkEntry, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%
    String lang = "es";
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    Iterator<WebPage> childs = paramRequest.getWebPage().listChilds(lang, true, false, false, true, true);

    if (paramRequest.getUser() != null) {
        lang = paramRequest.getUser().getLanguage();
    }

    boolean showChilds = Boolean.valueOf(paramRequest.getArgument("showchilds", "true"));
    %>
    <script type="text/javascript">
    function setSearchClass(what) {
        document.getElementById("what").value = what;
        var catLabel = "Todas";
        if (what == "Clasified") catLabel = "Clasificados";
        if (what == "") catLabel = "Todas";
        if (what == "Member") catLabel = "Personas";
        if (what == "Organization") catLabel = "Organizaciones";
        if (what == "MicroSite") catLabel = "Comunidades";
        document.getElementById("catLabel").innerHTML = catLabel;
    }

    function setSearchCategory(what) {
        document.getElementById("scategory").value = what;
        if (what == "Sitios_de_Interes") catLabel = "Lugares";
        if (what == "Servicios") catLabel = "Servicios";
        document.getElementById("catLabel").innerHTML = catLabel;
    }
</script>

<div class="twoColContent">
<div id="busquedaAvanzada">
      	<div class="buscador" id="busquedaPalabraClave">
            <form id="busquedaKeyWords" method="get" action="<%=paramRequest.getWebPage().getWebSite().getWebPage("Busqueda").getUrl()%>" >
          	    <div>
                <label for="buscadorKeywords">Busca por palabra clave</label>
                <input type="text" name="q" id="buscadorKeywords" value="B&uacute;squeda por palabra clave" />
                <label for="buscarKeywords">Buscar</label>
                <input type="submit" id="buscarKeywords" value="Buscar" />
                <input type="hidden" name="what" id="what" value="All"/>
                <input type="hidden" name="scategory" id="scategory" value=""/>
              </div>
            </form>
          </div>
          <ul id="MenuBar3" class="MenuBarHorizontal">
	  <li class="selectTitle"><p id="catLabel">Categor&iacute;a</p>
              <ul>                  
	      <li><a onclick="setSearchClass('');">Todas</a></li>
	      <li><a onclick="setSearchCategory('Sitios_de_Interes');">Lugares</a></li>
              <li><a onclick="setSearchClass('Member');">Personas</a></li>
              <li><a onclick="setSearchCategory('Servicios');" >Servicios</a></li>
              <li><a onclick="setSearchClass('Organization');">Organizaciones</a></li>
              <li><a onclick="setSearchClass('Clasified');">Clasificados</a></li>
              <li><a onclick="setSearchClass('MicroSite');">Comunidades</a></li>
              </ul>
	  </li>
	</ul>
        </div>
</div>
<script type="text/javascript">
    var MenuBar3 = new Spry.Widget.MenuBar("MenuBar3");
</script>
<br/>
    <div id="Accordion1" class="Accordion">
    <%
    if (showChilds) {
        while(childs.hasNext()) {
            WebPage p = childs.next();
            %>
                <div class="AccordionPanel">
                    <div class="AccordionPanelTab AccordionPanelClosed"><%=p.getTitle()%></div>
                    <div class="AccordionPanelContent">
                        <ul class="itemsCategoria">
                        <%
                            Iterator<WebPage> c = p.listChilds(lang, true, false, false, true, true);
                            while(c.hasNext()) {
                                WebPage wp = c.next();
                                %>
                                <li>
                                    <a href="<%=wp.getUrl()%>"><%=wp.getTitle()%></a>
                                </li>
                                <%
                            }
                        %>
                        </ul>
                    </div>
                </div>                
            <%
        }
    } else {
        while(childs.hasNext()) {
            WebPage p = childs.next();
            %>
                <div class="AccordionPanel AccordionPanelOpen">
                    <div class="AccordionPanelTab AccordionPanelClosed">
                        <a style="color:#D9D9B5; text-decoration:none" href="<%=p.getUrl()%>"><%=p.getTitle()%></a>
                    </div>
                </div>
            <%
        }
    }
%>
    </div>
<%
    if (showChilds) {
        %>
        <script type="text/javascript">
            var Accordion1 = new Spry.Widget.Accordion("Accordion1");
        </script>
    <%
    }
%>